Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF79495E6
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfFQXdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:33:18 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:52500 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFQXdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 19:33:18 -0400
Received: by mail-wm1-f54.google.com with SMTP id s3so1180693wms.2
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2owNOIpSwsqPMVihEmDRnRo+m9ACeukBLCs5WGuFMXY=;
        b=YWS1NCAW3zBwSjfxLxoee5tmap+tI2u2HCjItIR1AlubUP4UxW1OGB+SOhenxpNbTC
         f+0ioL3LfIauqM9RvQVW7kjZvv4I8E+NQZeTCF8ChHlhPmBZAKkxLw+VxoXsX7nPJBJ9
         /Nw0fD7V0TvW6NQb5KK6uoXzFhxg5slzbQZ7CUr51EgEP+C+MreMCh+VGsHpaTlU/pQJ
         yDhAHGn2lsq1l/MCEo3VjCWQCZ7Zpks+ZPNuypSRmZ+6e3AgXmV4sPnx4ZSWVBYHK0H9
         744hIM3wbNLtlCsqitW7bSw8XXyNwoq1cnn4nUjqe+sK91PcarlUJu0l9TO5ycCRnydZ
         F0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2owNOIpSwsqPMVihEmDRnRo+m9ACeukBLCs5WGuFMXY=;
        b=Mv15303R1WnQRL6bbdBaK6BFZIP2/jstnvCIpvPaRaBAhb6YDWLm+Lsv73FSqqrioN
         5swliPHI17TGlLK2sFhz0Y6BT0hvaLcLP9WUskR1gH5NQbwwYMWyNUJ8Bsni9y8Ryaju
         H0ae3bswHuYW24avLiIMgKKNb7xN4s7nuI77X2nHKGetv8lKmBXfyknoOiaL7vXqOAev
         aqXAc69sJCSE45C93ygOFFbXP1V7ZFIFSo1D246gbBEXpss9Ux90OMnqPc8gk5JuOnA3
         XzHK9hDI+8MCL3bSSAzGpMzy0RSg3xcszkNxDY7RctVmJ8ftJiYlbSNB0nv9CpsxTIGQ
         D9Fw==
X-Gm-Message-State: APjAAAV71ay+FFb1Y6/xwjYKWeosdhkmiYibl0ss21Fy0ITSfClJOzSQ
        yIxNIfsvfoYhowBQ3toQLtCOhL/v1ZHOcA==
X-Google-Smtp-Source: APXvYqyfPVLq6Q81M2mNDzV2GfxK6/eMStL9SaGiLcs7qWfHn6h/hvSlOY0t0NVpKcLRBKEok2tDJA==
X-Received: by 2002:a7b:c081:: with SMTP id r1mr735271wmh.76.1560814395784;
        Mon, 17 Jun 2019 16:33:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q1sm505458wmq.25.2019.06.17.16.33.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:33:15 -0700 (PDT)
Message-ID: <5d08233b.1c69fb81.cb12b.2f2d@mx.google.com>
Date:   Mon, 17 Jun 2019 16:33:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.11
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 6 failed, 112 passed (v5.1.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 6 failed, 112 passed (v5.1.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.11/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.11/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.11
Git Commit: 17bb763e7eaf2093a2832fd1d1a80281fb0e5ced
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.1.10-42-ge4ee75284c6=
d)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.1.10-42-ge4ee75284c6=
d)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.1.10-42-ge4ee75284c6=
d)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v5.1.10-42-ge4ee75284c6=
d)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.1.10-42-ge4ee75284c6=
d)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab
            sun50i-h5-libretech-all-h3-cc: 1 failed lab

---
For more info write to <info@kernelci.org>
