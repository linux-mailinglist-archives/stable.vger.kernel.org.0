Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15CF96F3D
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfHUCJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 22:09:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36891 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUCJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 22:09:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id d16so486140wme.2
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 19:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OkHTy/70ktmbiT4SzPFaSgXBg6qdgGV8p1GWe2Kax5A=;
        b=DNihiYBg8OtNa94+7uT17gaIEfWRYq0ERKsjGD674jxw6WLu1t0yb28olWbrLmQIBM
         US23CN70vD0KWgokUYCSKn20AMdqBqksq9hppa9GeoFNW2vfY0APa0E+uCfJmZzhgW4I
         7xwNhCbSui9w7MI2mkpcGqaeUIik1WZ+E2q8nJg9BF2jHp7mGt8Nx2Zn4v/iZmHXG9m5
         gmcE+b1jdckrkvnMfQ/KWzeUEHisJmeSx22KNV7QbmqnWtCFZ0/YAqQLIYpQc/zGUQxD
         FJVkhiKEekie1tZnnlafTKs4EI+Jv/5HbAHXtU/t0bsqaWCnxVKvL7pt20unoxPvlMtu
         bZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OkHTy/70ktmbiT4SzPFaSgXBg6qdgGV8p1GWe2Kax5A=;
        b=OuV1rLIrkXRb+VPVekH14c9cr0Pheg3As2V5UAYzRstjAR0AxTAuJgJe8KqJCMQ+tW
         h4rM8ezhmAojM1rL8tvVO3Pg/Axnf4CvLYKV3dBmuOruI9KwuifC29hfwsTTawT3JQc1
         VvJ4stqyc7Q1QuFTzIgfb+7cl/2H1DHZbHBepTt4bQn3r3+GplATtTmSCjtQVTjgR5Wl
         U/6/nFNu6XmlDfKiCuhxU0iSeassQg2mKIBFEZwjmGA6ILG/brq8od2yW7yT1MtZz72x
         MmHcTSuSeH+P+Pn59YiFUsb0rR8O2H6HVdhy2qG0fqEnF4YjvpQTay7Dz6wXODISclpT
         Fpmw==
X-Gm-Message-State: APjAAAVVHWmRiHJWYzI1HK4cMbYJ68KMwYlQc9u8tFLN+PmLn+AbNkM6
        mXZGCWCO0+Q6Kz6h6+weapNNzvhqYl81Ww==
X-Google-Smtp-Source: APXvYqyJcaQ2r4FlGAqrWxXFJ6E+xzqTNq24M1OuGiEhOKyzOc9mhUzESWcNNIHMhgU9Soqp3CXW8w==
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr1356996wma.106.1566353377135;
        Tue, 20 Aug 2019 19:09:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f17sm1559992wmj.27.2019.08.20.19.09.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 19:09:36 -0700 (PDT)
Message-ID: <5d5ca7e0.1c69fb81.48c50.6d44@mx.google.com>
Date:   Tue, 20 Aug 2019 19:09:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 128 boots: 0 failed,
 119 passed with 9 offline (v4.19.67)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 0 failed, 119 passed with 9 offline=
 (v4.19.67)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67
Git Commit: a5aa80588fcd5520ece36121c41b7d8e72245e33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: new failure (last pass: v4.19.66-164-gd=
0331f9a5a7e)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
