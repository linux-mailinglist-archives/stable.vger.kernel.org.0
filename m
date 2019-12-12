Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E911D1AC
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 17:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfLLQBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 11:01:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34134 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfLLQBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 11:01:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so3332911wrr.1
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 08:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bcd1EWIVUfsupb4T0CMFbSGhPIadmViX9GbAV6CTQIw=;
        b=0zEqFXBKHOEdxaVFH8r4A4RGTSB7nRoLu2S1oo60E6omgH8BoxCDJ+sMHH55f3DTQ+
         TdhtzolWoNHxQ0dWBjQAKMVysxyG65eWNKpV26Gn/2cuaThh6dFLD3V+RYeZNQWVzZ2b
         5rsHpUOe7lSKN/dSXOzM4jrxb9GK0rNqNEEU8Gmh2GxaGSnwqAJsIVIFCPuP3c1SUBhP
         DbrBQ04fRYRjOMW9faL6v4HtDDzom9P/wb1iwOAOhYo5lvc600ABkmr/QIOa4xCn/02K
         +3bEPeB/nXnB0Qk1emihzHUFFB5ETE5S+zz0pRRqgrwgrLGJNJTu7hMarUKnnBPuvkgT
         GBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bcd1EWIVUfsupb4T0CMFbSGhPIadmViX9GbAV6CTQIw=;
        b=LJI0e4Hu66/prO+oFavazG81TdE1Tny4S8D0He2kbPITo1CN02D9EEGEoucEy1bVlV
         vm0rSnmYEcb4pIsLMSlmy5CRHr1hbDiyMFsbcl0zFLJEet9DMxoB9K6viEjiF31iXRkl
         FgI9zE8OqQ2Le2zGgxo5MIdIdYrBc3wB1s7V+qmmHaZCYTzEJXLevHOfE2QQxMkDqc9v
         +t6YmNu+1fyEZl9b86nY6tPq2Sqob9pRHBo166X5+hZW2aGFoT1e1LDJu/GKuDzXSUn/
         E7QcXqFkv40HAvrZzZDbz5ShRt3XdIXPn1PorNKrKPcW8hX87EXypR2qNEgXctCmS+e1
         BZDw==
X-Gm-Message-State: APjAAAUugATW4WyDorGx54Ro/+bCCtkGk2qBMcm80rintLeiITD54IoL
        lzwF1NTjl98snTiktoeAdcydVshzo7OsXw==
X-Google-Smtp-Source: APXvYqyUjAkZTvdOJcZVjYz1KMHQDAELVAnJGKbB/E1MiMMRs09E8+hkzCxV8yB5X6kjzy+BasBkjA==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr7095959wrp.322.1576166480312;
        Thu, 12 Dec 2019 08:01:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm6694428wre.68.2019.12.12.08.01.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 08:01:19 -0800 (PST)
Message-ID: <5df2644f.1c69fb81.f7f0d.1a28@mx.google.com>
Date:   Thu, 12 Dec 2019 08:01:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-160-g8d615e65ba28
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 77 boots: 1 failed,
 74 passed with 2 untried/unknown (v4.14.158-160-g8d615e65ba28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 77 boots: 1 failed, 74 passed with 2 untried/u=
nknown (v4.14.158-160-g8d615e65ba28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-160-g8d615e65ba28/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-160-g8d615e65ba28/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-160-g8d615e65ba28
Git Commit: 8d615e65ba28d485657390c7fdec808141485e64
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.158-153-g1fe060c1=
745b)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
