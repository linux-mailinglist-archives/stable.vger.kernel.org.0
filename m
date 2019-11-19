Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72FC102359
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKSLik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:38:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51931 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfKSLik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 06:38:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id q70so2812491wme.1
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 03:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OOyHNGhYPbszP/8mSnotR0PXb3SjUUMEabHp4ztAP6I=;
        b=WB15ZzZg3P+ZxJCjr6jhyyOcBCGXIHsFn4VNcZJzj5hHBg5YnPKycyads/XTokqRQe
         ZBzYGfhC4a5RfPqpOrSg49s6bGaSXAETlXQL2nC7wgl3HhzDiWbZWsrXjTRAF650VpLf
         ALEpVrdcspKcnfUr2HeCU0cVBEXYntmWd3Ppp9e/X68QGN0zpgdJAjcTG+DtG4XvHJix
         zPzQcuAz5C8PacftVgpCqHn7iLlZ1qeGzHag5n96e6yYXWEQfrsURAr04ZpJfVg4X14X
         0llffMsqT6UjNZCfke4O/+B8XJsU8Wi0eCUNLg8TW9CfAnhwqEVON8cuvP/XxITCOn3E
         b04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OOyHNGhYPbszP/8mSnotR0PXb3SjUUMEabHp4ztAP6I=;
        b=PkdkNdfkzkzX2LDO6EqMqqNk1ppUjUqWOEOTO3b+wLkMJJ5LvNMys/LaNVA3I0jcZY
         cayucFPxFccCQscsLlccMpgfmhZxYwcCrRFQyugdsBQWiOVIe29Z1RJLKYkLLDuSuL9N
         mCOJ1IXSbanfyEedaSBkVXO83oNicg0qoHGv8A6bzbbFRrmUcGaK7olGN0gv6VnHOMYL
         VgRt9Xba/M22HHn6nMxiBtpEgJivARdrDdkiOuFRVBE9x751Z3xMefIhiWN+7RSIyUS8
         V1ZRyia26zgSSfzXBbT8K/laPhzjpGec4qa9JNiJO7q3Dx0UO6RZjTKAXuxr1232DuwN
         Qh8A==
X-Gm-Message-State: APjAAAVb9as7YfInrTL7r5gg1ook5TYgYGVSFCKo0lG39Vgdr4K6uTA7
        9MWIjhZ2RhXywUXj5qRSqrWVBvrK/kfEEQ==
X-Google-Smtp-Source: APXvYqzuj7MoC7la9Qb7amDv0eN2wAsAPi/di1V/7Ar1qh+I1sogQwHS0Ok1KMocWZ5xcgWIeOSBLA==
X-Received: by 2002:a7b:c858:: with SMTP id c24mr5252388wml.174.1574163517258;
        Tue, 19 Nov 2019 03:38:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w10sm2685737wmd.26.2019.11.19.03.38.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:38:36 -0800 (PST)
Message-ID: <5dd3d43c.1c69fb81.7fe89.c8c5@mx.google.com>
Date:   Tue, 19 Nov 2019 03:38:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.11-49-g0a89ac54e7d5
Subject: stable-rc/linux-5.3.y boot: 116 boots: 2 failed,
 99 passed with 14 offline, 1 untried/unknown (v5.3.11-49-g0a89ac54e7d5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 116 boots: 2 failed, 99 passed with 14 offline,=
 1 untried/unknown (v5.3.11-49-g0a89ac54e7d5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.11-49-g0a89ac54e7d5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.11-49-g0a89ac54e7d5/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.11-49-g0a89ac54e7d5
Git Commit: 0a89ac54e7d5ea976ee9de1725c056faa5ba526f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 23 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.3.11)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4ek:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
