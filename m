Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8818780D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 04:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCQDTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 23:19:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39230 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgCQDT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 23:19:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id d25so3118766pfn.6
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 20:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8zGrHTQFUQcOmXZkx9BafhUQCtxt+QH9apJ5S7kl+fE=;
        b=iLrQ6S0iDOFdCwK21z71/EPMw3M+v4vpffNgdSRVTQrd2MMmftrQxiDd7dMEk7xuxT
         T9LVtsLQeHAra+RLKF1GoFVL/JJ5M+sCGo6afdDIEUQTa08h1tkdyqRH3hVxaOwRL68U
         qNljd8Fj2KUVb5q2emMiwj4Rur+TNoGbyW4zGkibESp7zdmwcHo8t2eTLQjJa/Dkf9BW
         FDC8ULA4XWmvsk+6HfcgyppLbyij741mHhx9hEj/GFipDd7F0MKXAhPqeWBl3CNsPMTp
         80MqLsqSbKJC017tX8SXwoYYB0xWlvAkx2KEDgLx1OOt8zlSo30AEwaD3ztWc7tWYIV6
         ZDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8zGrHTQFUQcOmXZkx9BafhUQCtxt+QH9apJ5S7kl+fE=;
        b=n2F+ndJK1sVl/0NKnM85ovfpGrnbKuY6g8SFqF6kFER9fYnq4lo794n79mAXyM4SG/
         eRT4Y4+zsfLI/a+ZF9eK8mkGLpyQRToCcrPI/SxRAHTpyYb4/aoSQPq3/ZhVXpY4PXOH
         0XyWE9sTlBfWI1yb1RiyeSKBVKJD5aN+4INdazT5v/dBr8TIlyqSCTNUzljk3CH4KfCK
         VItcpzw6Slq3dscJptt/t6CxFlvQI5BaifD9I84ThFienqfVojgbmmm/pRAwgO8yauee
         sSFiNOsrPPF8palirbVlb4liCFKe8UFZeF06EiZweNholF0awf+YM+lOmGdpcWZzLDzP
         u2ww==
X-Gm-Message-State: ANhLgQ2RDcRzbU3MYSnqTsTDsZweOl1ISwNoWxYpGsU/B0eUaL0lRwqn
        ui/kgbr/h6mhTOf5Q6Lk4ihD8mKAqU4=
X-Google-Smtp-Source: ADFU+vuRHsKSD6nKDo6W76YqLV5VK2JurpdVa8NUvryp5ulIOCFtoRjumoC61xdGXFxe1+tidb9yfA==
X-Received: by 2002:a62:53c5:: with SMTP id h188mr2980336pfb.114.1584415167129;
        Mon, 16 Mar 2020 20:19:27 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9sm1012735pjz.7.2020.03.16.20.19.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:19:26 -0700 (PDT)
Message-ID: <5e7041be.1c69fb81.c3491.6221@mx.google.com>
Date:   Mon, 16 Mar 2020 20:19:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-67-gd37b117e1ccf
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 132 boots: 2 failed,
 119 passed with 4 offline, 6 untried/unknown,
 1 conflict (v4.14.173-67-gd37b117e1ccf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 2 failed, 119 passed with 4 offline=
, 6 untried/unknown, 1 conflict (v4.14.173-67-gd37b117e1ccf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-67-gd37b117e1ccf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-67-gd37b117e1ccf/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-67-gd37b117e1ccf
Git Commit: d37b117e1ccfcc2bf0ed4224f8f6d3ac6dd4ad65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.173-37-gddbe3d93d=
f89)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 37 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 25 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        tegra124-jetson-tk1:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
