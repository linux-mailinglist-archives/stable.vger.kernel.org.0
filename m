Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F97B6A41
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfIRSHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 14:07:48 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41197 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfIRSHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 14:07:48 -0400
Received: by mail-wr1-f52.google.com with SMTP id h7so369152wrw.8
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x+txWhlDRMcFimzpPn5NqHJcLmPT1/tOs6N0bGAcz5I=;
        b=mJKeTUJ0d5wdMLp8mYxHEI8XJ1dQuZVJ3iosgPLEiwnG8C5UKbn1qFyQ5UyXsSgdb5
         Eo/S60dSEeOunU32auGWIvfup77hK2l7NHHo5r33nf/NZjxbiovlKF+sJ6v3H7sH5lDT
         y5UB1zmZSTEGjrgMhK72o3AJ2ujK4yA1fg4RgJqcRUEExJ3ColSk3j4A0ZPc5FWQl5rE
         8D1NpQGnMrMl9IXq0pYt93casNwU6u281j8Z/KrSUdeyubWrf7i8E7xcLlKeDLF3mqAB
         rU3BkmT+iZ8SyRi0Jl2JNL+y1rJtpvPJs7PebRYP1w7kXyMg1Bzh6Z52mptOURY/N1To
         xbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x+txWhlDRMcFimzpPn5NqHJcLmPT1/tOs6N0bGAcz5I=;
        b=kpOcpigb5Iw2rlLkch4QHeOeSSAOZcEd/pDMEIelVZ4T4BQYTPYNAIXj3qDILfPrER
         ZJdKQXu6TTmUWl1z4mr1EIGP/WnpJqe08Q3MHJ0T9ioHQtAku9JSb37LYp1picoy/OS8
         DRWLHAmIcSEgx/Y3x5CKXSFDkWff2YfFpPeaPUMPBpsp+7R5DwZa8pnEpSsWVPjd1yh8
         erJjcOzrSW5jQ2DzYKWMup4JTmYxqb7Rywou28qBNheG/9I0bBso1l9p3fsemaaG0TbX
         bGM5azRjgKJANztwmIYNAx7Bu9IjudWn/29HZx2xLbL+dbRuluqequNNjfPAKAdEtYG2
         hnCQ==
X-Gm-Message-State: APjAAAV21VKx94cAfnk0jkEuvp0mIBaEQeKie02LwlQfEGRJE6kH8XVD
        hBEqVtSyu8gmimoQcjoRku8Ui/Md7zDIJQ==
X-Google-Smtp-Source: APXvYqxzJ5+a78eCXujbzs7gQQ5LowlXZcnFp6vTUSeG6ZvvKM6UTnpOjfSBBsiZ3KkswvfBQVkmSQ==
X-Received: by 2002:a5d:4708:: with SMTP id y8mr4089911wrq.318.1568830065569;
        Wed, 18 Sep 2019 11:07:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f197sm3512677wme.22.2019.09.18.11.07.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 11:07:45 -0700 (PDT)
Message-ID: <5d827271.1c69fb81.ed5f8.fd1c@mx.google.com>
Date:   Wed, 18 Sep 2019 11:07:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73-51-g7290521ed4bd
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 134 boots: 0 failed,
 124 passed with 10 offline (v4.19.73-51-g7290521ed4bd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 134 boots: 0 failed, 124 passed with 10 offlin=
e (v4.19.73-51-g7290521ed4bd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.73-51-g7290521ed4bd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.73-51-g7290521ed4bd/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.73-51-g7290521ed4bd
Git Commit: 7290521ed4bdf6c7ec60cab4c19507fd1f53214a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
