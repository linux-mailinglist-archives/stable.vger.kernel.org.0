Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FAB6B6535
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjCLLG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 07:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCLLGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 07:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E54DBE1
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 04:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9297660EC6
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 11:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5876C433EF;
        Sun, 12 Mar 2023 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678619205;
        bh=9gaAOjrDsyEVINQE8dB8WNVqCQL9lslp1CPyHZJSHKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XnjFb0K2WJGOBI5aoQq6duo8gGVXzZJ+Ig40YNy4S+sLzT/i8jUL9Sc39DjhuLK4k
         oimHmmSDOSIUulQPlSRsA+Mzz/ORp+uqpo/I3Trtnz4Rh108G39VIOHFSANs2EkVTo
         Vrm3yHPWqY7l3nTf8rhYbKcXCwWUAVTc3EL9JPG8=
Date:   Sun, 12 Mar 2023 12:06:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Message-ID: <ZA2yQly16i+avitV@kroah.com>
References: <33adb1b9-37c3-76ac-687f-97383f2101ec@gmail.com>
 <ZA12dnmhzqnAR1Uf@kroah.com>
 <056d7e9e-a1ea-379a-8ff6-23848a4031aa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056d7e9e-a1ea-379a-8ff6-23848a4031aa@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 11:18:31AM +0200, Bitterblue Smith wrote:
> On 12/03/2023 08:51, Greg KH wrote:
> > On Sun, Mar 12, 2023 at 12:12:12AM +0200, Bitterblue Smith wrote:
> >> From: Jun ASAKA <JunASAKA@zzy040330.moe>
> >>
> >> [ Upstream commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 ]
> >>
> >> Fixing transmission failure which results in
> >> "authentication with ... timed out". This can be
> >> fixed by disable the REG_TXPAUSE.
> >>
> >> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> >> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> >> ---
> >> Hi, this is my first time here. I'm not sure if I did everything
> >> correctly.
> >>
> >> This patch should go to all the stable kernels. Without it the
> >> USB wifi adapters with RTL8192EU chip are unusable more often
> >> than not. They can't connect to any network.
> >>
> >> There's a small problem: the last line of context in this patch
> >> is only found in 6.2. The older kernels have something else
> >> there. Will it still work or should I send one more version
> >> of the patch?
> > 
> > This commit is already in the following released kernels, have you tried
> > them?
> > 
> > 4.14.308 4.19.276 5.4.235 5.10.173 5.15.99 6.1.16 6.2.3 6.3-rc1
> 
> I see it now. It wasn't there when I wrote the email (a day or two
> before sending it). Sorry about the noise.

No noise at all, I'd much rather have duplicate requests like this than
not have requests.

thanks,

greg k-h
