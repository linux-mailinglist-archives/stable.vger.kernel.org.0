Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D470590394
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfHPOA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 10:00:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34513 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPOA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 10:00:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so1669100wrn.1
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 07:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O6lGc5XfL3tAqXukAh2YTbIGiPilFC8oV4siuiRwKMo=;
        b=mpXEuzoxJ6WMzg4tE8SW/urEHtMdtCxawAgiQCnfaxi3kfrhUCiqjhF2H7ADTnzZeR
         K/06APgUOvvJ/BXBahFQv77Efu1dZvrYVwtDpyyCpkX/F98JgcO6xhiGh9cG9USYvcCL
         YIeBoZoVTdIFb1DS9oHKUVUI1/HkldaVlfm4TrPjBtxVMft39s54V5rdyLi9vnflKz+k
         v1MeDWRw0p47o2iTmJgv6R2z6XjANba9BHp7yYFefJ1mcxAcEGrMixIcVZXnj+zDPHMd
         6MgOip+EEc5GqEtQtlKZ2k5JKpFXRHi0GM/6NHBp3O2vUNc8rWqlGlsYeDX+zG7qqD+z
         IGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O6lGc5XfL3tAqXukAh2YTbIGiPilFC8oV4siuiRwKMo=;
        b=Y3M+ZjISR/7EoqQspm3zz5QbZrydZwo6/BvKeCkvMLFIEr2jHbc7cdsPkBrSkYLO2X
         1B4tYsZTDnGXWQBJboHgJ92/vAUivnuzkIupWc8fjefi9qNgUiX5PFY/6AT2CXB3nYfu
         QA/m+yqt5NdDhRy1sLlwFfcjuUgBrdNzckoyzA7ySSKb0drksD8DGCxlOZSC8QN+PETy
         0AwzTlN8xMocOwGtbERhKekLtRGyCqGmxFqJx3NCmEZiT1B3ObCe7BThe3gZc6RtXQlr
         qFK7fQePavZWbNPdWD6VdTjL66cQy1FqdKUDwPVYKhWeHRv5aZi6isOboKOrkcnyHKH0
         agWQ==
X-Gm-Message-State: APjAAAWPYq+DgS2XGUIOLSdtdo/hjGa/J3qpbf3LZd6eW389BcYG8bFY
        PzBi4yV0TbLHwl4qjxjGkugy/s48bZc=
X-Google-Smtp-Source: APXvYqwsHgHgxMGSl0gYEE/ZoKHTiP3AX0+w/Jh7mwol+//1ZNnxvkCvBst/ULrCvxUImEHhkdI2UA==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr11582102wrx.241.1565964055975;
        Fri, 16 Aug 2019 07:00:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l14sm8531430wrn.42.2019.08.16.07.00.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:00:55 -0700 (PDT)
Message-ID: <5d56b717.1c69fb81.18f07.bd26@mx.google.com>
Date:   Fri, 16 Aug 2019 07:00:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 78 boots: 2 failed,
 75 passed with 1 untried/unknown (v5.2.9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 78 boots: 2 failed, 75 passed with 1 untried/unkno=
wn (v5.2.9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.9/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.9/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.9
Git Commit: aad39e30fb9e6e7212318a1dad898f36f1075648
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 18 SoC families, 13 builds out of 209

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.2.8)

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.2.8)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: failing since 6 days (last pass: v5.2.7 - first=
 fail: v5.2.8)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

---
For more info write to <info@kernelci.org>
