Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41E018E12A
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 13:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCUM02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 08:26:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39678 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUM01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 08:26:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id m1so3676913pll.6
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 05:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LCaM0Ua8B0Y+5ELt1Ess+oxT5KVqZnwhED4L7UL/9Jw=;
        b=j7M7FI3MvDPr92hd9ZZA4tmqboh+vt5o3rHjTDU4wf0jtaWlgb37ShWXmcDFs5gzk+
         PXeGmzyjaDQOcA6y60UQ9jUxRr8LWqzfcNIwRAc+xXUYWEpFG6rK4itE8x64peigvV7j
         6Xn0h9PfHsHAnS0m8jkJmSgGtpyi9OxHFHJ7zH/n3+ZVnOHWrwBRldaWPLOCU/eS9wnm
         Un0FuSYz2p3XCSm0mXP3VI8IfDLe+mRBUuyh07l9kOEiP+KSZWHIP4UdXea1jBKOJbtI
         G9h1IFwhiL5whpSkPwr0AJfdmX2767ClJdZ51t69wgvwaBbHq4P6FSlOGhHoz67GsFHG
         J5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LCaM0Ua8B0Y+5ELt1Ess+oxT5KVqZnwhED4L7UL/9Jw=;
        b=agpZsoWhN+Jmxrd0nK2VMHKXPoBLkSW9dXBnqCBNc8SfKitbYnfA5rPw93S/su2X6E
         HdCo8flK0cCZvB9SBVn3WaXGjL5Q8AsudrenPYC9drKXuWypXu2/lzSpg0mAVCRg5NTk
         Vwr1i4ZNprQ20ZIwpNRd0CL2kVKzSsK0H5q+06RaFxEFZJkZQthqCgAJ+DugpP5r4bG8
         HgjeBvPtExsC92IduQj5/9tAIHLj5BDELVqdW7pQWYT2FdpsDrZ33yK2HTrxmj3kvcFm
         U13ZqgZCJi4aTco3+Tsat6cm+PbuR+R/KQf/r9f2WfFRZtgWL4VzwXNEKm77id0A0oST
         TRGQ==
X-Gm-Message-State: ANhLgQ31IGahPBcYnoX0BquyxzxbKzolL2zjivJED5ZGoXbCcihXhj1M
        PhWHmiw6zvOKuXTxO3pxA7HuyudPh3o=
X-Google-Smtp-Source: ADFU+vuP9GxWMuQF4y+hypokPigtTObZ8lf4Er5JZQwhvDj2anpTXLxA9iFJ/v0kWe0EnF1dsJ3qNQ==
X-Received: by 2002:a17:902:a5c6:: with SMTP id t6mr12414625plq.323.1584793586107;
        Sat, 21 Mar 2020 05:26:26 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm7189478pjv.13.2020.03.21.05.26.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 05:26:25 -0700 (PDT)
Message-ID: <5e7607f1.1c69fb81.c5330.801d@mx.google.com>
Date:   Sat, 21 Mar 2020 05:26:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.27
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 106 boots: 2 failed,
 100 passed with 4 untried/unknown (v5.4.27)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 106 boots: 2 failed, 100 passed with 4 untried/unk=
nown (v5.4.27)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.27/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.27/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.27
Git Commit: 585e0cc080690239f0689973c119459ff69db473
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 70 unique boards, 20 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 3 days (last pass: v5.4.25 - firs=
t fail: v5.4.26)
          vexpress-v2p-ca9:
              lab-baylibre: failing since 3 days (last pass: v5.4.25 - firs=
t fail: v5.4.26)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
