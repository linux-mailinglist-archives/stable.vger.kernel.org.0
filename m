Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9916921B5
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 12:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfHSKyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 06:54:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55304 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfHSKyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 06:54:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so1189963wmf.5
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 03:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JWaz0LQsDdG7a6O79NJSCduQKVtjt4zKVlfBW98FLDU=;
        b=N8qH+LbUv4DmUIsDZrZoIX0M1fCqHXAl/y7hcp6GSciOwVPVYnNqY1KX4Ky9fzftW4
         QTkOtriqu4f+J59SORCb3Fjp5c7yGB3KB80/Xt8i/CKX362IH4+4R9m4iAc3OouXjRFk
         g99gOFm5uK04rc1NPAvxtDrjgbtUAri4BsEtNhC6OoTjcrFfkE0aZZaCXFzoE4DUeube
         LjUc84MI1a137x1ldu/hlXFbzMy3vYZsIjAYIvSRXgksy8YIRVXhhq7vEclQEBxr7KFd
         BbB0ajT2m3OjgckMT8JdZfaoNGLbtZybzfz30pkwc4NAt3e4lkWrLzVMzoMnC72pMXyb
         BB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JWaz0LQsDdG7a6O79NJSCduQKVtjt4zKVlfBW98FLDU=;
        b=ICfZehBLHoqeBNDPp8bCO+Y35e0NurCTWKtnMtFu/1W+L9Tc66TDZGBUMoc0eKsc9K
         Pk+5jYeqk8mJsiqZNaG74quXzZgsD20dTd+v95kVI9iwsoxFnwptwusWscdHWWr2bEAJ
         0RdwlADhnQDKjCW70n3MsmFNAhvfTPCcdluhJnfJnAmmbgh/s/Cp/QIYjk+UxrtJRwA6
         SXzH5NQgaZutR+CoPpWBPl6sfkJebW5SjPTlFGaxRwgiHxT1iDKma4w0exb4Uf9E4KHc
         HrO0tZ1rWY12J9byGxbfh8nB8ObpO/VHAuVtQjUG8WPqVd3+1rFrnhSf0ZVkmbefwBzZ
         6aSQ==
X-Gm-Message-State: APjAAAX055YXfnGLX43+RjU1PD8QvRPvvjGWWTrgtY+6Gv9RrxspIVny
        1mAt7pHSfMV+L1TEWg4etYEmeJYc2qc=
X-Google-Smtp-Source: APXvYqzel9v2fSFc0xruUNZQrFc08AP0tkxBa2XvkLyrzy5nN/TNounlroBhDG0uUiei8X4HdM0DmQ==
X-Received: by 2002:a05:600c:214c:: with SMTP id v12mr19873785wml.28.1566212061994;
        Mon, 19 Aug 2019 03:54:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e6sm12436314wrw.35.2019.08.19.03.54.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 03:54:21 -0700 (PDT)
Message-ID: <5d5a7fdd.1c69fb81.c40e0.9eca@mx.google.com>
Date:   Mon, 19 Aug 2019 03:54:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-65-g299ce87d0c13
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 95 boots: 3 failed,
 79 passed with 12 offline, 1 conflict (v4.4.189-65-g299ce87d0c13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 3 failed, 79 passed with 12 offline, =
1 conflict (v4.4.189-65-g299ce87d0c13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-65-g299ce87d0c13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-65-g299ce87d0c13/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-65-g299ce87d0c13
Git Commit: 299ce87d0c1346269018b6b4c0d80a50d8049cba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
