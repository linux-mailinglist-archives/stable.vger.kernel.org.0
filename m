Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C914184146
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 08:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCMHLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 03:11:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36676 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMHLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 03:11:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id c7so4461493pgw.3
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 00:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v/Qg9k1Zv8X6u/sGnJPZvjFuNxQwrh7UIfMeyMcfaXY=;
        b=VJJjRTHfr05+VHrojBPvdA3QHPYW1lfug+6x5GM+X5QeWKKKAig1FfDQTJlwV4j6wF
         wVva4B5Y4LL7V5FNrdqBfKc7ygFczwnG3gTjw76516nreaTxoI5jOjpYUMdqAz4jTH0R
         yjhWdfU3XITftiIrEg9EKkTZ6I/qzeE43qupUyHXGR9B6kRYulc8zueR6uem/z8fWMJe
         hJ5tx2Zh7S3gIxBAHyOKgi9A4YB/0YNQABul9qqB/IHKnCOoHRDkFha55o1A5I4GzUtc
         C92Ascbah1RKRP1so1KZEKA+bD8Jl9mLUe72N8bWjTr0J+0dLX5d2t8ckoTVBZZEgfF9
         265Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v/Qg9k1Zv8X6u/sGnJPZvjFuNxQwrh7UIfMeyMcfaXY=;
        b=lhurGC9LMghBo7ipGvp7yjJ48g3vGBi1ArqNRaYaUqQjhiOia38WHpiBBqAjTa+nbe
         +0upmry/4ilEZDgiXGV8H/nu5zglaKseiLg2J1T/PkJfa/FJ3ca4PE0GA41btUN3rzga
         mLRYw9QiLj4xXktqg5y3qaTKGES8iJ7Dks+oe/PlYHIWFZZ8U5SlkaxvzyVe/2thb9JV
         xGY5RiJ0NP2Lap1p7HLM0WvVYVtUqqIZ8g1Aa4YbWaBzlremIhsVanGQ5K+HSALUh1bO
         zsX731ufpJhxXHsH4qGPXqKKp4AaUbT3O/RRHvc29VkjvYWaktFkL7iu/WNPGx7321xk
         EH1A==
X-Gm-Message-State: ANhLgQ1pYeI6uM3KdJSaqmqGqC6pIX6xuuAkNfk8/JokDkuppIylfiFq
        v7er8cf7T1yf4GUWt7HG1JKn3VRPxH8=
X-Google-Smtp-Source: ADFU+vuU0UNdidfFS4/FcONNTo7TVO1kiLhANg1iD4oSfltW8f5KzwfLbwQHMoaRyGPFmi62wXuDKA==
X-Received: by 2002:a05:6a00:4:: with SMTP id h4mr12188306pfk.92.1584083474332;
        Fri, 13 Mar 2020 00:11:14 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm54746924pgs.89.2020.03.13.00.11.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 00:11:13 -0700 (PDT)
Message-ID: <5e6b3211.1c69fb81.f3e6e.9b49@mx.google.com>
Date:   Fri, 13 Mar 2020 00:11:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 63 boots: 3 failed,
 58 passed with 2 offline (v4.4.216)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 63 boots: 3 failed, 58 passed with 2 offline (v=
4.4.216)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216
Git Commit: 6fd21f1d7907d9cfcd406bc64935aa00fa100b66
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 15 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 33 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
15-62-g1ef447a18aac - first fail: v4.4.215-73-g836f82655232)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
