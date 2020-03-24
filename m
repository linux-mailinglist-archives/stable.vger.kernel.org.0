Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E40190E34
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 13:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgCXM4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 08:56:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43809 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgCXM4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 08:56:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so8969524pgb.10
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 05:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tkfmwj3RBlLMXgPipfvJ93LuxSBf2OvK+Ff+jh0Ehg0=;
        b=emhxi2eBq0EO0xqFJmN4FnXb1jez8v5FN4BF306ExKf1N6BMYP9OeuDs48hbbvrnEY
         XWXTPstm8G0egVCju5hec5D7wNm4ty4HVHNrO9/U+onOkzZ5wg8M1wQ2BahBZvcmpY8M
         YQeKBdc9pvdK9I8RdBoQM7iLRzlwtmlDexkkinvCxE5dNCBcAzKt7VDV6mo7hpCY09Di
         dFkU4pj5q5vSE+8uWUqlpWXJtWBMqIECqhoecU0vivb/5hu/LS8CoXWWm951llhbb5Oe
         7v99AZAhMZR3Mycx2vo2KCJ+FeL+/WaxFzJQl4Yd4SNW89u+l7hm5aj4BqMuGuxV+GDT
         u/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tkfmwj3RBlLMXgPipfvJ93LuxSBf2OvK+Ff+jh0Ehg0=;
        b=fwM6JvX5wTlzLJSjSm6lcNX4en93SESTKDc92/yZgdjv6F/MuM3v7n4ZaT8Ae0qUs2
         lC7ZQSif0ZLtIm9+q9g+/y5pcFBpJ4xyL8GPVH9QpuBZxgbueAxXEze+srHsDzcGC8zk
         DLwktKYwp9n9KP3J+B9j/tksXWNGY96u2HpC/USPAj2CejuMZ8wdzkDAYfA9L8wAXVDA
         jCYBXUHxtPdLW5+6puaH3z+MnlIE2941LrEmQONGrjvk9NUfNmh27C0+DzTra2zhD/GZ
         TZBx26qkUzEf5+huy0aYKEoq0wF3Jr1pPSeppAAJ6MmTReT+CZgsz9wMywrzke2BHYm1
         ymKQ==
X-Gm-Message-State: ANhLgQ3ER5ckMLrN5/hWCob+kkSTFonGC9YHxSp5dKyiv8ApR2Mlx3IJ
        2V9+slmwWiw81vuOg4B97PrddKhkgm4=
X-Google-Smtp-Source: ADFU+vvpcX62gEQtlqaV25+L6KSxyqG9RGTtH3ZeMQzBE7bPwrNzIDlZ4KUgJDrZahybhJEQKWNbWg==
X-Received: by 2002:a63:2ec1:: with SMTP id u184mr25936761pgu.446.1585054582216;
        Tue, 24 Mar 2020 05:56:22 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y137sm1325831pfg.103.2020.03.24.05.56.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 05:56:21 -0700 (PDT)
Message-ID: <5e7a0375.1c69fb81.7c03a.47fe@mx.google.com>
Date:   Tue, 24 Mar 2020 05:56:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-123-gab9a373d5af1
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 95 boots: 3 failed,
 84 passed with 4 offline, 4 untried/unknown (v4.4.216-123-gab9a373d5af1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 3 failed, 84 passed with 4 offline, 4=
 untried/unknown (v4.4.216-123-gab9a373d5af1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-123-gab9a373d5af1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-123-gab9a373d5af1/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-123-gab9a373d5af1
Git Commit: ab9a373d5af1af68b82712bdd4b9d7838c97d450
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-120-g8=
7aa7a2e6d25)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-120-g8=
7aa7a2e6d25)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
