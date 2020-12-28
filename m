Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32672E35EB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgL1K3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgL1K3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:29:46 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D74AC061794
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 02:29:06 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 2so9062176ilg.9
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 02:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2MCCk2cZZ07+LvmxVtnF1uyVJbCrtDXHKUmlAuDrBo=;
        b=ZHvwJhTIuM8BYGefobbbI0qCrUoKsdCly4UhbMGvy6ogmOZM2PUlw4GrtOJoE1eZJG
         g/2HA9Fct9wjq4AnafFa83CjR4cFS/oQ0kxulCoK7IyqfftdA3CCBChxvG7ySb8MkVTm
         /iqOhkLLp7n7XK4avGhvk5iwHTv/fRkoYYV9hxELqYmuAYepRpbZrI2IbfophObr/4g4
         Vu8mvEEQuArSOEUWO05ooPYRTR4CgtZIg+VwRtdNShPNT5Ts0/HqtlpDpUgk8SIbWF6I
         05UFRPlyQld5DUAqXYDDUzRbV+UtUJrsmPAjgP0g1VkdbSK4wURXwfYRt+luWqIbcXyj
         qPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2MCCk2cZZ07+LvmxVtnF1uyVJbCrtDXHKUmlAuDrBo=;
        b=Rp6BcH7PTg7vJP5uD4wIt7FRDtpssSTe4tlBEZ6WunjbTWHCxfDWr27vpmmmSa12OO
         ZSZ8wJpQ2PuaOmmoN4ealXvRvXT5ZFePg09ycy2fbftWm3UneYXYvEf4NUKE6iTGbWpD
         yh5imucwqGk2qiQNK0iz1d2uIvOyWDU4Pmdcvo9FAV4DlXaKGbI4K6YtQXBwtjAW/jbC
         w1cW4vdcXE1AcG5xkur1S29uJBT5c1M2tMjkefuqCtnXc6TCn8ft7EUr6+dAyB7uYipO
         1wr4RkbglTf8ckRB/7bDomXkdq7368vqCD5OanbahQJPbVD16Sj1lQImGiRO39DeMpvq
         aYng==
X-Gm-Message-State: AOAM531FbTwicBEQmHle9k/vzMW949XVctj/2C04NI6uX6Z4Qt1DFW4m
        2VzEMrIl4NFXDSbaU+h7Di79ndkLK/aO4k8hhfA=
X-Google-Smtp-Source: ABdhPJw6t/hc4IDDeP4q20/zV41g1Q6xI9UTO93g9pf6UCMo3QEqecawndzvrm4Ve92SvvojzRpLMlo9gOIX7tUEZtE=
X-Received: by 2002:a05:6e02:1a8e:: with SMTP id k14mr44089291ilv.275.1609151345990;
 Mon, 28 Dec 2020 02:29:05 -0800 (PST)
MIME-Version: 1.0
References: <16091476769227@kroah.com>
In-Reply-To: <16091476769227@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 28 Dec 2020 12:28:55 +0200
Message-ID: <CAOQ4uxg8bqKOVmn53XPtxRLxCZn3peUe_-7EE45-oFAjdLQQ9A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: make ioctl() safe" failed to apply to
 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 11:26 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 89bdfaf93d9157499c3a0d61f489df66f2dead7f Mon Sep 17 00:00:00 2001
> From: Miklos Szeredi <mszeredi@redhat.com>
> Date: Mon, 14 Dec 2020 15:26:14 +0100
> Subject: [PATCH] ovl: make ioctl() safe
>
> ovl_ioctl_set_flags() does a capability check using flags, but then the
> real ioctl double-fetches flags and uses potentially different value.
>
> The "Check the capability before cred override" comment misleading: user
> can skip this check by presenting benign flags first and then overwriting
> them to non-benign flags.
>
> Just remove the cred override for now,
> hoping this doesn't cause a regression.

Above is a sentence you don't want to see in stable patches.
At least it should indicate that a longer period is needed before backporting.

> The proper solution is to create a new setxflags i_op (patches are in the
works).

I looked into this and I am not sure it is worth backporting this temporary fix.
One observation is that the theoretic security flaw is arguably very hard to
exploit in practice.

The solution can be described as the lesser evil, but it is far from
perfect as it regresses some other functional test cases.

If anyone would like to backport this patch, one might also consider
backporting:
  292f902a40c1 ovl: call secutiry hook in ovl_real_ioctl()
* be4df0cea08a ovl: use generic vfs_ioc_setflags_prepare() helper

[*] $SUBJECT patch replaces this code, so applying this commit eases the
     backport. $SUBJECT patch won't apply cleanly, but the merge conflicts
     are trivial.

Thanks,
Amir.
