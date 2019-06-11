Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C563D1BE
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 18:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391600AbfFKQIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 12:08:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52874 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391497AbfFKQIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 12:08:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so3587712wms.2
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 09:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pMhH1RLEi2JE+SGX9evp3J/JkMl0W+s9fPHDwrc+CD8=;
        b=ERHe+Z1M3OEsdNeonoQM/hN2bSvq79p7Pg663z0efqZQmKYyZ8xkgRU9C++z0pMbmq
         pDUesgPnJ2szv22R1whJoeOtUVpGzxcehb5UtCbz92IH+PJ3r/ywoirIdr8dFmp2YQSW
         EG3Z5YH9NlR/XIsPMyYnRIl05GuFUCFLBHP0T4fwcoL52qX4TnnjGaGE7BSUrbQZUZC4
         LWbVpYxyUv6m2EJpRCD6vlSwiSIAIelcQaDzHru1UjuJrl4/g7lUBxecEVXwHeK7tisn
         amy0UjbxfALusXu+30DpuAlh2Wf2WZ3G54PiATxbofOQxZI2WTCF80sAlu4I7JhsxEIz
         U9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pMhH1RLEi2JE+SGX9evp3J/JkMl0W+s9fPHDwrc+CD8=;
        b=mSLcKNcQnEAZgq1Bp/j8Y/KiGcf2UvBcZ5n9wyJctMok5Lo5XfvZpdS/K38JyXoI64
         1ceaoF4YSUNfuvnU+cSuDDMWmy08oyp//4DHr33wE9aQqCzZGLtku6W4xjek/9SGgE7P
         jsr3Tw5CT4/OmPK4rNm4bbPKUFXK8RJR34ipM3gbjJyzc5exHahi3h/G4tSL9UqW83GU
         ZVT3mb0UsO6o47hU84NyeGau7YWHHWqmdlgNkoJCSg1x+xWv9VYNKSIZZgn3ic26XBr2
         /GUElqdoAv2ZAwdpyzNZY1jyfmMN/9nQxC8nc53PzyBMbxba9wp8ZCCP3Tp9ya4fsGEs
         51+g==
X-Gm-Message-State: APjAAAWCH2u1Yzcv+BLznkl+sj0wx18n2YUkfjOfCnthVCGFL8zyheR8
        VONtV33uKpYe12Lo6/eN3w5HM+gH+ouLeQ==
X-Google-Smtp-Source: APXvYqz+kVc1pbaTZFf2qB8JKb8M1GShPnNKKO9ZRfl/UOI5yllF2jurBptAWvOJPvUTm7bDOeI8iQ==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr18377694wma.68.1560269321716;
        Tue, 11 Jun 2019 09:08:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f26sm3181927wmh.8.2019.06.11.09.08.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 09:08:40 -0700 (PDT)
Message-ID: <5cffd208.1c69fb81.7daf7.27bb@mx.google.com>
Date:   Tue, 11 Jun 2019 09:08:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.50
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 67 boots: 1 failed, 66 passed (v4.19.50)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 67 boots: 1 failed, 66 passed (v4.19.50)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.50/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.50/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.50
Git Commit: 768292d053619b2725b846ed2bf556bf40f43de2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 11 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
