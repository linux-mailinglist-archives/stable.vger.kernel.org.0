Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61E012493
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 00:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfEBWbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 18:31:25 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42325 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBWbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 18:31:25 -0400
Received: by mail-wr1-f43.google.com with SMTP id l2so5445183wrb.9
        for <stable@vger.kernel.org>; Thu, 02 May 2019 15:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2xX1DTWDMMg4NiNeilKXOGy/BGadjxHNrX+2mYxFkMo=;
        b=C3X5FdLiTS8plRFHQg4rT6Yx3D5iaZXbbP/P9/qw7sUKuVxiz5DTEy/Jgh8u02L7bz
         XY4KEyOcoZV1Dg8qGCNcwJI7IaQktbjnsQeN727h35YUSuoeEk2BBUpXWkINx0NhLajR
         0ERopZTniFDscHSvBQ7kcL5SPOwEdqL9iPYNSG1zWYWm5EcPfB33ByRRS8rzn0ZSoNxi
         Jk0OcJtpQAVaJArgIxWwJjjCd55x8p+3Kd2kCuAoVmQfZNGxSht3bUkFq6S1QojRJBYj
         Q2SBffBAnI+dmCS13eRedpGBAZzdUR517i3s4RafS8YKtI6IKkVHsNWHBUh1CL4OG3vj
         JyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2xX1DTWDMMg4NiNeilKXOGy/BGadjxHNrX+2mYxFkMo=;
        b=iIohCLq9gZDuwMF5po3NK2CiYVV08irxkDjKwwHo/yx/oVSJK85KyHy6eK2sqFAXMA
         ZvmIDL9DBOjE3N6PpXQoMJBTm+bZP68ArfrAAE2P+w37RlTfsM8w3VIQIbzFr19qIA6n
         XqMNPEDKLVZbkk5CEhirsghtJytIlw5yCOEzFH2h+hspckzrBtk4w3iTLdG2Lg4mioyo
         bqLhiskaAjcHH+i5wnCFYYNxNP7mu3UdH0cPo4Pxdjno8Y1aaPSW0I15pGwvMWXHWEip
         gU315433XBDlrQDS+fJBq/BN2VdWAvTxGY724YvEH1hs0p9P+Z+E3VkQjGjOIN5Q0j2B
         tk2w==
X-Gm-Message-State: APjAAAU+1jJoKUVnqPHp7axIQYE03YFxIuRXwyamYPeSUc4kj8V829T2
        OfY45cqDCpePWF0VocIWZsPbf43qaovY2w==
X-Google-Smtp-Source: APXvYqwtKQHkpuj55FO29E87p7in+FlL/eczQBknjt8pJuqraS2DZrSFpcHLrI9dnZjNw94Mx2Vw+A==
X-Received: by 2002:adf:ec0d:: with SMTP id x13mr4346521wrn.268.1556836283645;
        Thu, 02 May 2019 15:31:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s17sm751026wra.94.2019.05.02.15.31.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 15:31:23 -0700 (PDT)
Message-ID: <5ccb6fbb.1c69fb81.aa068.4ad3@mx.google.com>
Date:   Thu, 02 May 2019 15:31:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.38-73-gdb2d00a74567
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 123 boots: 1 failed,
 119 passed with 3 offline (v4.19.38-73-gdb2d00a74567)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 1 failed, 119 passed with 3 offline=
 (v4.19.38-73-gdb2d00a74567)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.38-73-gdb2d00a74567/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.38-73-gdb2d00a74567/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.38-73-gdb2d00a74567
Git Commit: db2d00a74567be6e93472fcc4bfa8ada96cc6397
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.19.38)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
