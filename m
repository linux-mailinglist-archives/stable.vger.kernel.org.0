Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8118B9F216
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfH0SLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:11:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34179 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfH0SLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 14:11:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so19769462wrn.1
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 11:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tJ6JT4mbjmxDTtYCcCKRvbFj/AkxPciRIoJmoc0g31o=;
        b=W8kLlpbxNlIOKqORt2u9E/rK5TqaClXVz80C6yGxJign5KnuqcYC82skkEEuBKpD7u
         0EFKKWCMoklAqgUTYgSf65YTVtK5GYRI45P0YJug663YhbxIdGfNVIHuGxfb1VLodGRy
         GYOI8hSoyekd3CDMOs4gdLKfR48BdRZsXMfyPf/ghdt1MfTjox0Uvs9DPSrPYsQuKJLJ
         uPcdBb1M480W8weqrYiBvW+sqyqrMwkxxz68axhrg4AcZmVD9kdL0/MMsRxZdDBh4NQA
         wwogl8eqkNZPwyggZLGDXwZj0oib+KfZBuLAKZEgI7rGwOus0mWIh9pWyHqNIAFnmoDa
         nQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tJ6JT4mbjmxDTtYCcCKRvbFj/AkxPciRIoJmoc0g31o=;
        b=tn9ytPdyTzQkjqJOMM1KQQPNMmWzr5kVYBIcOWFWf+qw/fnGGOyupTOitKupEOJnPT
         0pj7x3m6m0+sjcvMRc2alHNCd5LgxfH3CoDAUXAy2tWFINwP9eS6PYRxCBgopNu3zr8K
         F5qGIX2gNggJeEnUSrpyDUkb7VJ6p8qcs5msWw8IFqNKt5bGY3NKTAs6/NSiluO2IoqF
         Wwqrq97wMLzoq6n1wqOa7+xBnplMMLnriLENAql/UDwvpfN6mqFFP1c4isfSxCT/DqEY
         o3oaF6obAjRv4agtnQ9TMlI2adQiBNk8xhq1EnckoavVBKyL9mKgQGTyasjoL/qCFdFE
         G8NQ==
X-Gm-Message-State: APjAAAUNxC5tuINKtww6+GrwxJ/HLiBN3qomG1hSmEC/6Pwk1qEzL7Oz
        pffjmdVchkJ7V/uKztRdA28J2KaWs4K5Mw==
X-Google-Smtp-Source: APXvYqwlJsD65JXETobDGEs3ajrLd7EGq0nMUmCz4E4rnBOPhs21lSyj9pin91xochDSX3vf4olFxA==
X-Received: by 2002:a5d:5041:: with SMTP id h1mr33115815wrt.30.1566929470644;
        Tue, 27 Aug 2019 11:11:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a142sm237386wme.2.2019.08.27.11.11.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:11:10 -0700 (PDT)
Message-ID: <5d65723e.1c69fb81.e38fd.10b0@mx.google.com>
Date:   Tue, 27 Aug 2019 11:11:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.10-163-g9f631715ffe6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 149 boots: 2 failed,
 137 passed with 8 offline, 2 untried/unknown (v5.2.10-163-g9f631715ffe6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 149 boots: 2 failed, 137 passed with 8 offline,=
 2 untried/unknown (v5.2.10-163-g9f631715ffe6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.10-163-g9f631715ffe6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.10-163-g9f631715ffe6/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.10-163-g9f631715ffe6
Git Commit: 9f631715ffe68666bbe4c5f7ad0dfc1ed387e1a1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 26 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 12 days (last pass: v5.2.=
8 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 12 days (last pass: v5.2.=
8 - first fail: v5.2.8-145-g2440e485aeda)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.2.9-135-gf5284fbdcd3=
4)

arm64:

    defconfig:
        gcc-8:
          meson-g12a-sei510:
              lab-baylibre: new failure (last pass: v5.2.9-135-gf5284fbdcd3=
4)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

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
