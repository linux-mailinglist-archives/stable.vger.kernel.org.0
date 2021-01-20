Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A32FDACC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 21:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbhATU07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 15:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387588AbhATUYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 15:24:44 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3B5C061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:24:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id md11so2906367pjb.0
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QRYvOKi0bspwTt21PwFK9tKry70NlXALtq72SsTPtmw=;
        b=OGvdE7QiTA+Gxhrf0rNI3rLeIzzsbpmCHeCgbCqBsd06ZZAYd85g+gNE/nFSHkBjkd
         XzTOX8W1ue9DGjzjnX+E4kyEwBEujm6PUutsGlqJSPWB+ydp6ioz+M8hD3QqNxQOdUnJ
         ZHW1P5Mxin1I8jnACCUCtvSwy1EvPXtgG+ufKuOVkj3uJMe7W2pzQwoI5dXNwlnht+yI
         puI/C0OTTWgOhiamHizKcpzSW4T6M2CIM1Zq85+IX78nFBEH9+6/ig3ntIIJ7npkiLFD
         0NbLxLPaX/EFPkrSqwOH/Xwmzr4uQ9zehkY9giy3tGuTWf1J/eJ+/uq3q4+HqpkMgfLQ
         53lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QRYvOKi0bspwTt21PwFK9tKry70NlXALtq72SsTPtmw=;
        b=GnIJmytlVjG6J+hArhcfZRiC5H22+xrV2LO4WuguAC891ff5ZvWrqbFb4dJyGtsQOY
         eT4w4Kvl5xGZ9J84+vnWSPXgt4rGDmiCOJwvZOecgTAkTuOF5Ag7lGAVm++A9ynQhYq1
         R03WNrf9Uh7120/9yKxnkyIr6pbJNTgWnIXpy5jqGOjlVzhkGfUPZXiIzoRn11NjJzpz
         O3aT/Mynm6fnEkT+UFSatq1cRLn7+m4MCZLC27zIpg9+wq10E6BTPRuw1k5E6VQqU1Uu
         qRzzeHRwcRVlWF1MiYEMIL1TOXoBI/Fu86CAv0Z2qtsOljIa9nS0VdaDRHdViFVKc+E3
         ntlw==
X-Gm-Message-State: AOAM533cRJ3oRKHKC8BQzwIe/BG/PG3QE4noCXALKYAt7n+qOO6HqKE2
        L9V1X6mcOxZi3DGQm58ZeFikAYrAejKL/tOVT6pYPg==
X-Google-Smtp-Source: ABdhPJxcv2gwwvGv5HrtDHjBAjWTwKcA54LRXYCFS63pnUcxpgv+v9NjTs8jFIGrS4+S3ItpWisaQ001hfEDeJ49MAY=
X-Received: by 2002:a17:90a:31c3:: with SMTP id j3mr7423722pjf.25.1611174239613;
 Wed, 20 Jan 2021 12:23:59 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 20 Jan 2021 12:23:49 -0800
Message-ID: <CAKwvOdk_U6SEwOC-ykaVTMu1ZmEjWC8cCiTetvU2k2dQ6WPCoQ@mail.gmail.com>
Subject: 44623b2818f4 to 4.19
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,
Please consider cherry-picking
commit 44623b2818f4 ("arch/x86/crypto/crc32c-pcl-intel-asm_64.S")
to stable-4.19.y.  This will allow us to use LLVM_IAS=1 for Android on
x86_64 allmodconfig.  The commit first landed in 5.8.  It has already
landed in 5.4.74 as f73328c3192e.

The backport to 5.4.74 (f73328c3192e) will apply cleanly.  Jian Cai
sent it to 5.4 for CrOS, but we're trying to be a bit more aggressive
in Android supporting 4.19+ with LLVM_IAS=1.
-- 
Thanks,
~Nick Desaulniers
