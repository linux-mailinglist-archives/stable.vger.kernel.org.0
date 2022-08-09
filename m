Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5461958D5C9
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 10:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241323AbiHIIy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 04:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241381AbiHIIyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 04:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5CE22507
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 01:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8569860BEA
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 08:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5B2C433D6;
        Tue,  9 Aug 2022 08:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660035288;
        bh=+4LGtFDYpqy9u2HqZXMo09wbfWfuHFXo3Hcx5m5dFl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mi76CvbX6/UTvUvDIq1JHpS7dE4ArXRCMfdpDWJHzhBNdyyK56v7nr9bAbsaIayZl
         zAU9nOsZ2dKNU7GlbDHnFT+4MDiq5iu8LbCwIgb2xXms+jJ0mXhdk6FLH6f3AiwoR1
         kVteWgBugJRAEZZ6dQZy29DrdEnGAMq8At5zR3+E=
Date:   Tue, 9 Aug 2022 10:54:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Koen Vandeputte <koen.vandeputte@citymesh.com>
Cc:     stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH] bus: mhi: pci_generic: Introduce Sierra EM919X support
Message-ID: <YvIg1h4sfJIEMp6K@kroah.com>
References: <20220809084058.323170-1-koen.vandeputte@ncentric.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809084058.323170-1-koen.vandeputte@ncentric.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 10:40:58AM +0200, Koen Vandeputte wrote:
> From: Thomas Perrot <thomas.perrot@bootlin.com>
> 
> Add support for EM919X modems, this modem series is based on SDX55
> qcom chip.
> 
> It is mandatory to use the same ring for control+data and diag events.
> 
> Link: https://lore.kernel.org/r/20211123081541.648426-1-thomas.perrot@bootlin.com
> Tested-by: Aleksander Morgado <aleksander@aleksander.es>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Link: https://lore.kernel.org/r/20211216081227.237749-11-manivannan.sadhasivam@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Backported/refreshed version for 5.15 LTS based on 5.15.59
> This LTS contains all required bits and other modems have been backported already.
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
