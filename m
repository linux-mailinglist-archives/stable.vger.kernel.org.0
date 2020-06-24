Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49507207F1E
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 00:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389773AbgFXWGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 18:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389453AbgFXWGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 18:06:23 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9FC061573;
        Wed, 24 Jun 2020 15:06:22 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y18so2094523lfh.11;
        Wed, 24 Jun 2020 15:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UgyMArw4CzkOtjq5ORhsXeOYAj7kLhbHa9ROjF5N1ZA=;
        b=brcPr/qdwolNKlQ2seNrW+NR5dn3F8qzG/5QSrP5Uvzqyojcl+GZUA33WwbzgAcUpQ
         J4HFOf5CWTkwIKQOAvIi7Nl3+3d+D5CPJ9s+e3POhZZbTliBmMb5a4mjKqR/Ncj93rm8
         OKxUFVvEAFTjS/MH3GX1V3tHhI6eKR8ieKjHheZ3zU54uVGBQLwNvX6cB2waHX29T7H0
         w4CJ6AuMuIsb6NvZipexg3gLOsXnZrMMxyt0fEa04d5oIfxPT1kfrTVh9Fvix4wV+ZyT
         VPvcaCGITS2n9Wl0i2hPkqumA2s6XPuw5PvSLeuCjRis6U6u988o1lDIBTVTmk39pUTk
         S6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UgyMArw4CzkOtjq5ORhsXeOYAj7kLhbHa9ROjF5N1ZA=;
        b=ky8ZCwh51IFDSyyYzmAoCEQEYukKuCwdew17fXZWd5KF4KoRKcAzPQw+R7rNZ3u+29
         MrTroFR0/UStoNMSKqD1XWDIH3Okr/uqM08fwhTFxDtVG0NHFEaOLJlX3e3YbkpZQHkk
         1fd9mcNMVrHZdjvff9KxPPVTnlM0B8XojbvL3MDEm+aDm571vgZTdce7LArQpHit5ezF
         noAMFO67BbcGHLw3ugnAz3eM79ZF5akWoOdPU+3iN87s2z5hUWUx/wA2PH5GpBueD4dc
         670Ir84E2UrxV9cWc2oJAXdWsmU/VSRZOrGFHx7FWPB2AyGNxbH0JNdMYnbOaSgH8Atb
         X0kA==
X-Gm-Message-State: AOAM532mCloLUOfIrc/5a6UYxs2+L4R+ev1SUySrurIwRjzJk4BDSvce
        uZ9KClJIGAyvTBKxRjsujkGRcn0L1ST5wtjp3A==
X-Google-Smtp-Source: ABdhPJziBSIPd70JafmfjsSZBN5adlm7ZLw/+u52IOWV9W91ao6QMegxNcu8vWfFtx2lhET9gfIAJ60yhX40DrLEejc=
X-Received: by 2002:ac2:5c09:: with SMTP id r9mr16809657lfp.176.1593036380605;
 Wed, 24 Jun 2020 15:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com>
In-Reply-To: <1592410366125160@kroah.com>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Thu, 25 Jun 2020 00:05:54 +0200
Message-ID: <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
Subject: Re: Linux 5.7.3
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>, angrypenguinpoland@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> I'm announcing the release of the 5.7.3 kernel.
>

Hello Greg,

> Qiujun Huang (5):
>       ath9k: Fix use-after-free Read in htc_connect_service
>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>

We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
while working fine on <5.7.3.

I don't have myself such HW, and the reported doesn't have any experience
in bisecting the kernel, so we build kernels, each with one of the
above commits reverted,
to find the bad commit.

The winner is:

commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
Author: Qiujun Huang <hqjagain@gmail.com>
Date:   Sat Apr 4 12:18:38 2020 +0800

    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

    commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
...

Reverting this one fixed his problem.

I don't have so much info about the HW, besides a dmesg showing the
phy breaking.
I also added the reporter to CC too.

https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea

If you need more info, please let me know and I'll try my best to get
it as fast as possible for you.


Best Regards,

Gabriel C
