Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86340E911F
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 21:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfJ2U5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 16:57:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37527 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJ2U5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 16:57:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id q130so3890845wme.2
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CkkSpgU0Ah4rcNnaoXFMpZv+ScakfzqWcNdYgvBYkvs=;
        b=0+QJLzHbO1lcPMNavyWnlDt+gIt2OPvuVVW2gTvbEFM2bxp2QDwiSuSRFDdvyMz9MO
         PQlH7CUp9K98UyvfWkG4WlGG+k/YX9BVAFpxy3DA+s5+s7u+ho8+rcjM3aIIjG+xAwCY
         FjxxWqADzYiPtdhZs+t/iO0LS2CpCTfH6guTIz3tChQhmnhF/0z35dfLLYzyBe9sDWW8
         OwfXXLpeLg2HBh+Ie0LoQGHxP+kz6Mg04BYPCuhuGnWIB7k5/+hdlzLUy96s/+5bLgN7
         B/+AopjuS0qlP/IIyylkS6KYLwaQGAGHlZ6my4pnyvWznaPVjh799S4i+K+onf51KJOd
         N1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CkkSpgU0Ah4rcNnaoXFMpZv+ScakfzqWcNdYgvBYkvs=;
        b=mPLs1uWpmCbB3ocSm5riCoLqHc/FRL9bsoEoovccikK37kwvb9GYTAdYeUXwBhnCZl
         YhxdlpWPVh3oGMS+D9yuMgRm86C7SumkrpStHv08aheE2qFT1eJbDE23UZSnN2qyociU
         Y1Lui759ZS2qkrKLZUsTA6Tmqc2j2J259zdqASb+tLN6IsqbJ37lkcphk9YMTNoRF5Pf
         c6plRzfjOCcgufwLhKl2pPI7/Rf6izd/oZ0lFE1LswcqUMtFXmOWqUYOPMMVnjQkgLW9
         btu4Vu+HQr7ejHgK2fxBCoQp1vRGkJCAp5a1bwlxX/HmNOAFGax4cgzrCaJf79LeMH0B
         Eajg==
X-Gm-Message-State: APjAAAWZ0mhtwThOIZn6V05h0OAM8aOekHirZMbUzCDsDY/WZlnErnI+
        NFz5EO8P0BNFKRbdP16ezuMzbWvYXLR9tg==
X-Google-Smtp-Source: APXvYqxBV+MZoSBbm+H88sNT0mafRp+hqqQWcd6EUDvb+PiweqMt+WR8kZ6vdsUiZtNC+KWME/8Uzw==
X-Received: by 2002:a7b:c186:: with SMTP id y6mr6189539wmi.67.1572382618070;
        Tue, 29 Oct 2019 13:56:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t133sm4154929wmb.1.2019.10.29.13.56.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 13:56:57 -0700 (PDT)
Message-ID: <5db8a799.1c69fb81.f71a8.627f@mx.google.com>
Date:   Tue, 29 Oct 2019 13:56:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.198
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 43 boots: 0 failed,
 41 passed with 2 conflicts (v4.4.198)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 43 boots: 0 failed, 41 passed with 2 conflicts (v4=
.4.198)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.198/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.198/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.198
Git Commit: da259d0284b69e084d65200b69462bed9b86a4c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 10 SoC families, 8 builds out of 189

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
