Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186FD1383FE
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 00:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgAKX3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 18:29:05 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41647 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731621AbgAKX3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 18:29:05 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so5113229wrw.8
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 15:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MLFRDPGiNZt8Tojk6G8mdmD98pAHh/i+aMsPRHH1PZo=;
        b=WJRaF5CpFILrsjpzetNhZLAZA181ztJts+cn/6EcmTt9PBwD78fab8IxADp0LJRgaa
         Lf83fKDACwC6ukCqqb1tp1IcxENx85CnGHOwEnKbFfA059xPtWbKTE/MIk8ikIcDO22T
         36Fnt05PbPzfbV6thzpDakKwxAmwYEkHHyX10XyPlyP92sg3OHyp4Z7ElyKwC4/FjSOB
         /pq1vBf5L9hyuW6bx8psj2lYRsNuLAKfQkqZMissdlogpIWehZ/rl/gYbUFB2Rpwv+gm
         03cx0kjpz9X7MZeuJZ2F3NyLVQoCOHr2OxrEGqsW1CeaVDqApQrAg2Cso6GNz0hWE+tP
         gjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MLFRDPGiNZt8Tojk6G8mdmD98pAHh/i+aMsPRHH1PZo=;
        b=cLYWgEz28DINcx70bT8VSHHzl++jk9K5yFUA18p9pbL89/l/3zF8sI3tIN2Q4GFByR
         ITyo3hc5A+SiSa9QgSCI2vp8RT0zNtbFuJkjH7QMpP/MZgmMmJ/FDMls02nH4IJoafw5
         qKHL5JirsxfpxgAT8whVKWUcG+IE+RW8yVKcm3DU+tbbDOWWYC5dyCVMgQ7RA1JBNEzp
         Z4YWJvWQhsa1y1qEfSgwKoVSHJEud3ah4/6Z5Q3QefO48kXRSMYpVR+sTqrukMNW57Wo
         5yVDFfFFlj4p7dQR0NQmNVpjg4wUj79d5Q8eMjd336vcnJhU+2ZEK8ljL8MzGf3UCH1e
         grag==
X-Gm-Message-State: APjAAAWMja0/IE6bSLyZ0UBsK0bbDy7uR0h+wRXRjo4blD9KCBftS43G
        taBwOaEAqDR1a1xWkaplPa/uQjshkY3cGQ==
X-Google-Smtp-Source: APXvYqz2EJ/XeWGPY7JM6Ksxdir0SvBaW+Vso2rhS6jeFqIeSUJXL9Vb7aLPWi5HHSgQikV63jUcWw==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr10498660wro.202.1578785342810;
        Sat, 11 Jan 2020 15:29:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i10sm8340866wru.16.2020.01.11.15.29.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:29:02 -0800 (PST)
Message-ID: <5e1a5a3e.1c69fb81.48768.3416@mx.google.com>
Date:   Sat, 11 Jan 2020 15:29:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.163-63-gf19c9ce58066
Subject: stable-rc/linux-4.14.y boot: 67 boots: 3 failed,
 60 passed with 4 untried/unknown (v4.14.163-63-gf19c9ce58066)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 67 boots: 3 failed, 60 passed with 4 untried/u=
nknown (v4.14.163-63-gf19c9ce58066)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.163-63-gf19c9ce58066/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.163-63-gf19c9ce58066/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.163-63-gf19c9ce58066
Git Commit: f19c9ce5806662f4d9fd123d41bfdb5195bfc96f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 14 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: failing since 1 day (last pass: v4.14.163-42-gd=
508caa26185 - first fail: v4.14.163-48-gc277ad1cbef4)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.163-48-gc277ad1cb=
ef4)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v4.14.163-40-g2=
58da0180e68 - first fail: v4.14.163-48-gc277ad1cbef4)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

---
For more info write to <info@kernelci.org>
