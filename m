Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF535673FF
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiGEQPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiGEQPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3136C1D301;
        Tue,  5 Jul 2022 09:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9B2261BC4;
        Tue,  5 Jul 2022 16:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAE3C341C7;
        Tue,  5 Jul 2022 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657037717;
        bh=5NSoXSFTGA6pt3n/mTC17vetr4Mb7Wjn9Z9eyTc5eKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J28XyqrTcaiqarKRecxGKM9FRNjhhEY+PtHGGmPUQ5lnOi7NEfazyjJKiZzZUij12
         sFD40t+8O9XjMjnm6afIr0hg7TmuD0QNMXXJJwqW3/Q8KANBFnTfLc3RJPBViLSKkz
         EGJxPnx0jYNGNIvlk3ZjYJQMiKNkjyguum29YKL4=
Date:   Tue, 5 Jul 2022 18:15:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.9 16/29] net: dsa: bcm_sf2: force pause link settings
Message-ID: <YsRjki2CX4K6rEsA@kroah.com>
References: <20220705115605.742248854@linuxfoundation.org>
 <20220705115606.227964792@linuxfoundation.org>
 <5874e274-13e9-a2bf-9cca-670709fc62f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5874e274-13e9-a2bf-9cca-670709fc62f6@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 08:34:35AM -0700, Florian Fainelli wrote:
> 
> 
> On 7/5/2022 4:57 AM, Greg Kroah-Hartman wrote:
> > From: Doug Berger <opendmb@gmail.com>
> > 
> > commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream.
> > 
> > The pause settings reported by the PHY should also be applied to the GMII port
> > status override otherwise the switch will not generate pause frames towards the
> > link partner despite the advertisement saying otherwise.
> > 
> > Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> > Signed-off-by: Doug Berger <opendmb@gmail.com>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Greg, please remove this patch and the ones in 4.14 as well as the fix is
> not quite appropriate, sorry about that.

Now dropped, thanks.

greg k-h
