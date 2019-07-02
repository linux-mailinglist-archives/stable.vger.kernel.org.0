Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3AB5CEAB
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfGBLpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 07:45:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53494 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfGBLpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 07:45:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so536149wmj.3
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 04:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7XnS1nSglGl3J4iwz5UZQop6wVOESU077vgMnQIwlF8=;
        b=hlORffj1x7217Wuo6ckSEeyuoXlSnU81MBl/YYYhbB6G6j+SGky2fn6wVaRo1TOekr
         54d1g9yTCSL+jfGROBw/lY6CN+k4XOHMfsoQHWdwqYYgUepeOMkNu9sZShu06Bhh8SUk
         gmplvqn0PI3nY8y91eY1NuN+Z/rtxAvTABh9G9JOrDbS8GO3QkLioRSJFb823OUuACGv
         oEMxbK51eufA+pxwdGTCDA9+IK85O0yxULwWPSZC7C4P4L0dV1bvsZ/tpfQL2wXk4Gbp
         7ES841zS2Ichfv+1dXrXk+C9s97bJZiwimte1+zoXlyh8qwZERKyj8NEPhGhzvP/Dh2X
         URHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7XnS1nSglGl3J4iwz5UZQop6wVOESU077vgMnQIwlF8=;
        b=fOTOYbSk9S7k81tU2QdC4tibbzdrCj1nhxW9bFAnLZ/NpooMHiiJxxG6HPKwrf1arF
         o2EX6y4tbT7RV+mGhtBOKkf6r86t6oDuFZ0y8gB/1tJBphvdXq36H46j4kftljk8i1ik
         sk6v4PWaI8iLRL0G+j2DdEH4Qqt6j87QQPgenb744oZ+KuvMXXiKEHycaOdlS3FdwLVY
         k0bzGKz+01V36QamOTKFYiXakm0Q2Vw2tPho0itgs6EISNp5JTV8cUUBj8Z1x3SIU9nW
         4NicBiY1d5d3dSNYY79FnG671uji4/gihs16y6O2MCAKTWtMjaCLQLBMtrMnjYVanRwR
         QfzA==
X-Gm-Message-State: APjAAAVjG3xx7Vt7f7Irw/e9Fa+JmJPzXUXxxqh5f/mDza6u684/4XEL
        /tnizXeJ0dHGASSIbB4uRC81BI5EGpk=
X-Google-Smtp-Source: APXvYqxnxewY0JAQRHIPtt5jfC6oIgmvqIYlrvp8C4Z7AQf+myW/YybEPw/lkdgnC8+cpFlI1H+S9Q==
X-Received: by 2002:a1c:5602:: with SMTP id k2mr2981579wmb.173.1562067911099;
        Tue, 02 Jul 2019 04:45:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x20sm28462582wrg.52.2019.07.02.04.45.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 04:45:10 -0700 (PDT)
Message-ID: <5d1b43c6.1c69fb81.51f06.7465@mx.google.com>
Date:   Tue, 02 Jul 2019 04:45:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-48-gc9cfb526e8ad
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 94 passed with 1 offline (v4.4.184-48-gc9cfb526e8ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 94 passed with 1 offline (v=
4.4.184-48-gc9cfb526e8ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-48-gc9cfb526e8ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-48-gc9cfb526e8ad/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-48-gc9cfb526e8ad
Git Commit: c9cfb526e8addf9ce28ed0e15ec5b4413c06c9a1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
