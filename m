Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE3B4BB2A9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 07:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiBRGmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 01:42:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiBRGmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 01:42:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD857B3B;
        Thu, 17 Feb 2022 22:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1CE61EB3;
        Fri, 18 Feb 2022 06:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EA1C340E9;
        Fri, 18 Feb 2022 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645166533;
        bh=HjMR23aoxKQWFwKcEqaYH5QVua1wOqAfuXyH1CKbZzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MW6EycTUDLx3IFunE3hebSFuuTaWWEimw6dLZnfr6JEmtAnu7nxVxUXEid+tgJtYv
         Vz4bBVvBRbZaE2CZbJHvobefOmDMOinPQVXkOGYVuIrZY/ykRYTFh2yKINs4f1jHLP
         GZz3bBpOGOquaHzB4/J94Sbv9uLGCnWArZrmFB2M=
Date:   Fri, 18 Feb 2022 07:42:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.4.302
Message-ID: <Yg8/vxWzcc/etxp+@kroah.com>
References: <1643877137240249@kroah.com>
 <20220217205550.GA21004@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217205550.GA21004@duo.ucw.cz>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 09:55:50PM +0100, Pavel Machek wrote:
> Hi!
> 
> > I'm announcing the release of the 4.4.302 kernel.
> > 
> > This kernel branch is now END-OF-LIFE.  It will not be getting any more
> > updates from the kernel stable team, and will most likely quickly become
> > insecure and out-of-date.  Do not use it anymore unless you really know
> > what you are doing.
> > 
> > Note, the CIP project at https://www.cip-project.org/ is considering to
> > maintain the 4.4 branch in a limited capability going forward.  If you
> > really need to use this kernel version, please contact them.
> 
> Yes, please; feel free to contact us.
> 
> Greg, we'll likely keep maintaining "stable 4.4.X" separately from
> "stable + changes for cip hardware, aka 4.4.X-cipY". Would it be okay
> if we simply kept tagging those kernels as 4.4.303 / 4.4.304 / ...?

No, please do not.  Just call them 4.4.302-cipY as there is no need to
even attempt to keep 4.4 alive for non-cip platforms at all anymore.  If
you were to keep incrementing the number, that will cause confusion and
people would think that it would be a general-purpose release like was
previously done, when that is going to be impossible for you all to keep
alive.

> CIP project is committed to maintain 4.4.x kernel till January of 2027
> [1]. We are maintaining -cip branch [2], that is stable kernel with about
> 1000 of patches to support our reference hardware [3] and -cip-rt
> branch, with is merge of -rt and -cip trees.

Hah, good luck!

> If you for some reason need 4.4.x with bug and security fixes, and are
> running similar hardware to our reference hardware (x86-64 and armv7),
> -cip tree may be good base for that work. Testing of the -cip tree is
> welcome, as is joining the CIP project.

I agree, people should join the CIP project and work with you all if
they really want to keep using 4.4

thanks,

greg k-h
