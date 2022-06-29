Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B901B55FA70
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiF2IZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 04:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiF2IZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 04:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9D93BFA0;
        Wed, 29 Jun 2022 01:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 480A161D69;
        Wed, 29 Jun 2022 08:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45557C34114;
        Wed, 29 Jun 2022 08:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656491123;
        bh=/fEG8o56X8CR58XzBeCiViZTlPIDG3OwyZ/UgWpIrp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reDPLsOiXwvihxd/6ECgf2vvHyj/Nwb1s+ziqvznumgQi/VuGApy87VcgXSm6Do2C
         04vvU3b7Uj+PDspM0Xp8mnDSroRyA6VF9Ml5PJqFvB0Z0Zs95x+IXtqOnSL63qkHtx
         5o89CGLH2HZWj/NZcg5zYmVZUTTcu+QY3ab6mTpo=
Date:   Wed, 29 Jun 2022 10:25:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: linux-5.10.127 modpost warning
Message-ID: <YrwMbylQNI7XqJte@kroah.com>
References: <B9ViOjUL7reNao5fkvKkt4S91RPpLSuY6lGtyNIFW4WCgET8Z5Y_9-Y7O1GuZJ9FJFk7QouCfASA1ogdd-xaSVQNtR9RN2r2kFD7zu9vbMw=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B9ViOjUL7reNao5fkvKkt4S91RPpLSuY6lGtyNIFW4WCgET8Z5Y_9-Y7O1GuZJ9FJFk7QouCfASA1ogdd-xaSVQNtR9RN2r2kFD7zu9vbMw=@protonmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 08:18:04AM +0000, Jari Ruusu wrote:
> This shows up when building linux-5.10.127
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
> WARNING: modpost: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit to the function .init.text:drm_fb_helper_modinit()
> The symbol drm_fb_helper_modinit is exported and annotated __init
> Fix this by removing the __init annotation of drm_fb_helper_modinit or drop the export.

Known issue, see the stable list, I'll be fixing this up for the next
release, thanks.

greg k-h
