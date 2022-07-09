Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF856C95A
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiGIMQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIMQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 08:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D49E2A71E
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 05:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5EBB817D3
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 12:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0263DC3411C;
        Sat,  9 Jul 2022 12:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657368973;
        bh=rMjBF98f/tTkE6EmyrnMBwWnkPZpny9CbBqepIotJAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxIvn24b12EZQ1v7BMdcyCzydJH+FDCfMgQKhunioxPK6qr+s8NTIA9rRiMP84yv0
         WD8qV9FEhA2zpLoYAIDfdJcNX/4UwQJgi9xRh6zeJHVlonUOMM8+g5UU72u+h2dCY0
         WM8whtZgEktNpFwc+QDEodOYfT/8ZxP+wJ49Lv5k=
Date:   Sat, 9 Jul 2022 14:16:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Message-ID: <YslxiluWV9YnPPAY@kroah.com>
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 09, 2022 at 02:07:17PM +0200, Alexander Grund wrote:
> The following changes since commit 445514206988935e5ef0e80588d7481aa3cd3b7b:
> 
>   Linux 4.9.322 (2022-07-07 17:30:12 +0200)
> 
> are available in the Git repository at:
> 
>   https://github.com/Flamefire/android_kernel_sony_msm8998.git lsm_hooks_backport_4.9

I can not take a git pull for stable patches, as my bot says:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Please just send them to us in patch form like all other stable
submissions.

> for you to fetch changes up to 911aa0e49633be52c7a2de8c99de87b6bf3a7604:
> 
>   LSM: Initialize security_hook_heads upon registration. (2022-07-09 12:51:42 +0200)
> 
> All commits are cherry-picks/backports from mainline.
> The intend was to apply the last commit ("LSM: Initialize security_hook_heads upon registration.") with as few changes as possible.

Why?

> This revealed added/removed/changed hooks and related changes which seem valuable to have in 4.9 and via the CIP in 4.4 SLTS.

What is "CIP"?

> For additional Context: I initially backported those directly to CIPs v4.4-st14 and tested those on an ARM64 Android device from SONY. [1]

I have no context or understand this, sorry :(

thanks,

greg k-h
