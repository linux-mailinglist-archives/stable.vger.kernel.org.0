Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7044C9F6
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhKJUFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhKJUFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:05:45 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A2C061764;
        Wed, 10 Nov 2021 12:02:56 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id d11so7467165ljg.8;
        Wed, 10 Nov 2021 12:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=QrY6DTXVsJXnxgZM0Vf8TBQU6FkE1rvTuD+fiMvH20c=;
        b=Feof8M4nyNH527Qrvhf9zoyT0pcoz6VCbSW341AfYot8EsdyZe/LBgPtHi/oFwgoH1
         8okXUyJnJpXxRAS9I/mECNLBkzXjxJGEsBOjXbhbV1hvy/zwHs+DUd6giijj/fuUCdr8
         JCVmfvYNsn+7dcDQ1E8rlCJvV0/lsRWqD3XW8fRGBxPMIvGvmcpjHiLC8eKGZxLoqQ4G
         +z4ZVRAqJRRKyMRHFyRiTYP0AFQrchLq8Nts6ASOn3eNNKCMGEb5Zn1Wa3TAqkS+V4pS
         74QdixjWc8UOe77Vo22nU9qhwZKe/pso1RbuP/rb9MkXSwvhYQ+y0L2fHCRADr6G9bEi
         QX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QrY6DTXVsJXnxgZM0Vf8TBQU6FkE1rvTuD+fiMvH20c=;
        b=heR8TjBmrXM0UKJ4Xu3MgGBIs1oNjuEa4HChbUBcH1VnKzWyZHmHb6WDbD4LqD6N3l
         bqJjU92g8Pmd4J2yR8kXHkzwy9Dq6yXr6Wq/trX7I84d2Dl4vLpKl3+S9q+lWokkNhzM
         e0ytTUS862wT1wEmGLAQFX8sDZa6U2E3we0eroliXBJSofzuryW2T7aYXYn8mKO+WmSJ
         at0MakuJXndaJTlDKSy9VmCeYPMIIf8qm8z7rh3ylTLG0uCHpvjeB68O1NdZnsfHtttY
         SIGI9i4hG9qqRd1SEpdNsldzo6N6UsKvwdtSdQbxBnw3+NOZ9JDqTcGjTGUXhF0gpwvx
         nH+w==
X-Gm-Message-State: AOAM531VeGprvgqLC/mVoRv0ttHobIZrY/KymzaG9uIbFIMOqDk8+/Kr
        tPwkpnrxJolVRsCSWXioDw/27/ekPf4=
X-Google-Smtp-Source: ABdhPJyopJbTR3pmC18s8EjWmFMTxwza5dakDnojaHWRZIjFaxEm4Y55Xa357tNVVGrgvOonVSjPxA==
X-Received: by 2002:a2e:3a18:: with SMTP id h24mr1448702lja.372.1636574575025;
        Wed, 10 Nov 2021 12:02:55 -0800 (PST)
Received: from lahvuun (93-76-191-141.kha.volia.net. [93.76.191.141])
        by smtp.gmail.com with ESMTPSA id i6sm79856lfr.163.2021.11.10.12.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:02:54 -0800 (PST)
Date:   Wed, 10 Nov 2021 22:02:53 +0200
From:   Ilya Trukhanov <lahvuun@gmail.com>
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, javierm@redhat.com, tzimmermann@suse.de,
        ardb@kernel.org, rafael@kernel.org, len.brown@intel.com,
        pavel@ucw.cz
Subject: [REGRESSION]: drivers/firmware: move x86 Generic System Framebuffers
 support
Message-ID: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Suspend-to-RAM with elogind under Wayland stopped working in 5.15.

This occurs with 5.15, 5.15.1 and latest master at
89d714ab6043bca7356b5c823f5335f5dce1f930. 5.14 and earlier releases work
fine.

git bisect gives d391c58271072d0b0fad93c82018d495b2633448.

To reproduce:
- Use elogind and Linux 5.15.1 with CONFIG_SYSFB_SIMPLEFB=n.
- Start a Wayland session. I tested sway and weston, neither worked.
- In a terminal emulator (I used alacritty) execute `loginctl suspend`.

Normally after the last step the system would suspend, but it no longer
does so after I upgraded to Linux 5.15. After running `loginctl suspend`
in dmesg I get the following:
[  103.098782] elogind-daemon[2357]: Suspending system...
[  103.098794] PM: suspend entry (deep)
[  103.124621] Filesystems sync: 0.025 seconds

But nothing happens afterwards.

Suspend works as expected if I do any of the following:
- Revert d391c58271072d0b0fad93c82018d495b2633448.
- Build with CONFIG_SYSFB_SIMPLEFB=y.
- Suspend from tty, even if a Wayland session is running in parallel.
- Suspend from under an X11 session.
- Suspend with `echo mem > /sys/power/state`.

If I attach strace to the elogind-daemon process after running
`loginctl suspend` then the system immediately suspends. However, if
I attach strace *prior* to running `loginctl suspend` then no suspend,
and the process gets stuck on a write syscall to `/sys/power/state`.

I "traced" a little bit with printk (sorry, I don't know of a better
way) and the call chain is as follows:
state_store -> pm_suspend -> enter_state -> suspend_prepare
-> pm_prepare_console -> vt_move_to_console -> vt_waitactive
-> __vt_event_wait

__vt_event_wait just waits until wait_event_interruptible completes, but
it never does (not until I attach to elogind-daemon with strace, at
least). I did not follow the chain further.

- Linux version 5.15.1 (lahvuun@lahvuun) (gcc (Gentoo 11.2.0 p1) 11.2.0,
  GNU ld (Gentoo 2.37_p1 p0) 2.37) #51 SMP PREEMPT Tue Nov 9 23:39:25
  EET 2021
- Gentoo Linux 2.8
- x86_64 AuthenticAMD
- dmesg: https://pastebin.com/duj33bY8
- .config: https://pastebin.com/7Hew1g0T
