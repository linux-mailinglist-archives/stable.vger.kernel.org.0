Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D733E6E09DA
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDMJOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 05:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDMJO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 05:14:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5706949FE;
        Thu, 13 Apr 2023 02:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF7063CB7;
        Thu, 13 Apr 2023 09:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFB4C433D2;
        Thu, 13 Apr 2023 09:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681377264;
        bh=8tyk2Atpz6EI+qYX1ci4DB8qd3FP8XeT5stqpmeZZ7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MjPLDXm+zgmXZR1V9HtjWpwLoGJLSdpI4TKRVrzRHPNn+Y5K1k+LoXWs4VirrCLpl
         4UXQ2ceVl9OosOJhXAzxMkEkvDB0soS3KtTKpKlkNpetOEbdoFaGq/N++P+s5YZFQ2
         eNYPZFbV2L4D195qAJ3FbSO5ZUBwRfsDm6kU09Ys=
Date:   Thu, 13 Apr 2023 11:14:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "secu100@gmx.net" <secu100@gmx.net>
Cc:     stable@vger.kernel.org, kernel@vger.kernel.org,
        patches@lists.linux.dev
Subject: Re: [PATCH 6.1.23] ALSA: hda/realtek: Add quirk for HP ENVY Laptop
 17-cr0xxx
Message-ID: <2023041312-marigold-fastball-8b4a@gregkh>
References: <25ce0797-1d40-6e2b-0895-c4ca85aad2e6@gmx.net>
 <30f48ec1-df68-68e2-f81f-538e5526599e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f48ec1-df68-68e2-f81f-538e5526599e@gmx.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 10:32:20AM +0200, secu100@gmx.net wrote:
> The patch of the file patch_realtek.c fixes the speaker output on the HP
> ENVY Laptop 17-cr0xxx. The LEDs for muting the microphone and speakers
> still do not work. Likewise, the hotkey for microphone muting is without
> function.
> 
> This laptop model uses actually the Realtek ALC245 codec alongside with
> Cirrus Logic amplifiers. In the bios there seems to be no _DSD property
> specified in the ACPI tables of the CSC3551 section. Therefore, the file
> cs35l41_hda.c must also be patched.
> 
> Even if a patch of the file cs35l41_hda.c is excluded, it would make
> sense to make the adjustment in the file patch_realtek.c. then the sound
> output would work in case of a bios update on the part of the manufacturer.
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
