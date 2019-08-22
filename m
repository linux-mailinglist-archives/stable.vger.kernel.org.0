Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8F9A33E
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 00:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbfHVWrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 18:47:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34144 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHVWrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 18:47:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id s18so6890250wrn.1
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 15:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tERyJvrKlE5HTAaO2//D80OMvA4DYTLGiqdgOWOv/38=;
        b=1c6ksSUAtpZD/dct9fEi+RgOr3QLae+93p5Y2te5GIlo/DTnxb8MCyj5BrPr6X5qjH
         W2eVHg9WdRE+Z2sex9xW7GGMu2hCAwoDlVjPJKOq8yHyQfbFSHHgCj6WXvCTLF81jaGg
         OHXYDYcZIgjPdftUcpPNOIKx0GFjEmo/l/XUPjXS7b/YBRWwtGV7ajbCzvjiNVzK02lQ
         QtJR+DHWqIOqtwa3wUnoEKx32hETCLLdq0vNagQGfnzluEGFqARU5HAOKgGE1LfIKwX9
         wdMmDLOFzX0z6UF70jUEImogEIaZ9ghDPBuK3MpCgjyGizUdFvL5YTw0/hEIIrvkhLAf
         REcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tERyJvrKlE5HTAaO2//D80OMvA4DYTLGiqdgOWOv/38=;
        b=UD0LaYklRCiczDMzwI8TVhrGfrJhBy5lH3QFQHOb5PoFAj7nhmgKJeO11pxu9zsPQl
         sCrK+mDqGpOCXTeLdk3mdfCOd9Lhr61+HdZVWE3flASNxzxIn1jr8jwNltb+RkcwZtJl
         yavco9+3zX3OuG60uz7q2Bn/5Xm5NycQCwLZrhvoA653LVq9+a1HmmBJXEjIFgXZbAxC
         4FLI8KyQo0u9vo+7vWDPa73oKyl0t8gx0Y0I0FkHMtU5yiW7WpQvv47uS36mZXtDCeNj
         33PNufn9IbDBGalMWQz7+6rGRWVH1zpvhkRmkv+GD5YLznAJcMyiFGz4oG670MKctxZ5
         BiUQ==
X-Gm-Message-State: APjAAAWylnPzb83T3VKCRiCtyNofqjGw+oHr5G+oR+NE8of5+fXQFYNF
        13pUN/cxqWUwaV4cp608sFRVRpdVm1FUcA==
X-Google-Smtp-Source: APXvYqyz1DLI8aUZICUQfE2geeIesCxPxv/1DoPPni8inOdhAy7ccm+30/ltimcJJjyKLzRUW4P0rQ==
X-Received: by 2002:a5d:4f81:: with SMTP id d1mr1163226wru.177.1566514070326;
        Thu, 22 Aug 2019 15:47:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r17sm2523216wrg.93.2019.08.22.15.47.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 15:47:49 -0700 (PDT)
Message-ID: <5d5f1b95.1c69fb81.a0645.c85b@mx.google.com>
Date:   Thu, 22 Aug 2019 15:47:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-104-g7a35fdc061cd
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 95 passed with 15 offline (v4.9.189-104-g7a35fdc061cd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 95 passed with 15 offline =
(v4.9.189-104-g7a35fdc061cd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-104-g7a35fdc061cd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-104-g7a35fdc061cd/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-104-g7a35fdc061cd
Git Commit: 7a35fdc061cdc806d06bb3a34ed5c9c0d08ffc0d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
