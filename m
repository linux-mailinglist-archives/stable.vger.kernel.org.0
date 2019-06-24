Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F9351C8D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 22:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbfFXUkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 16:40:14 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:41148 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfFXUkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 16:40:14 -0400
Received: by mail-wr1-f51.google.com with SMTP id c2so15314448wrm.8
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 13:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CDemPgeWLZ8b5bYf1dhXjQPFMRBAjDYxgkrIzZyEjrU=;
        b=ZfsJeEYELcA+buigsFauruRdhUU06k/eZBZUIe1s4bVl6lxq3X6rwBGn+EvV2OEKn9
         DznuAS6UF+i+Tdp6cgVs2NVvDhIGTlz3Zl9xq4LmqtWxkwlLhpVVSLbFcgCqxEXTwX0B
         3LqwAJpD4uwRRiThf+2z9UA4g/0o5Zb2JmRMP4yGgSmOyhtx6BG6M2wW7pUkCenZ2lrK
         vc2KmJTs6gAKmW9lpgFtTNKetu+ZwbzJTOdSdAQdvp0q8wLX74zL4dNwmBTQLSTtefvM
         sd+uNPt9CXIyBgK8OfelfZj4WFheRA9T1ztZTwSQKDk/5zMDfiX07RuJZfnqADGaSMuZ
         tU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CDemPgeWLZ8b5bYf1dhXjQPFMRBAjDYxgkrIzZyEjrU=;
        b=MiUtdeNQU4ouDlvoaxItCyM6W5ARLGnE0f0lDg/eg/3U7Qt69dOf8RqE6YQYE0Q+6d
         QyYOrMqa8Wypso/B5R7JY0ToqaejLQnLxiuGnuO4b0CKZAAuBz26UtIkJ0dO+yTEgWpM
         nl6cv1wQa6KzVVyNt5AZLUDUQkIqGNNyTzbFJr6EFoPhf6/yL9xLaeZn5DEXZa73l2yi
         aaJUDMGSFPkDP++iIqspFZugIQsTF8aHe2zt5Ieq8LWlm4wizlfyAYSMvSSFNAfD16lf
         Vh/P2EeCC/pWYxcaw43URuf/L+GuLyNM9AzuG3R6TP1GAAqk5EKeHMVG1K3Z1Um0LEAl
         tdqg==
X-Gm-Message-State: APjAAAX6xfEVg9qdDfmMy/0zrZFO4qFsK15xoP+IYIoG+J3HbHQdbVMK
        rBKu6JPJacoUUSzw9scoNDOwxVYB/wBybQ==
X-Google-Smtp-Source: APXvYqyIc39/LYMI8YcLzKCQzqmdCgGIFlraV2yXkG92ewYSzaRPpcKkIHNBdNAGSm118Vnj+itEvg==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr34314371wrq.143.1561408812130;
        Mon, 24 Jun 2019 13:40:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y6sm425851wmd.16.2019.06.24.13.40.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 13:40:11 -0700 (PDT)
Message-ID: <5d11352b.1c69fb81.a90a1.281c@mx.google.com>
Date:   Mon, 24 Jun 2019 13:40:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-92-gd8e5ade617e9
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 136 boots: 1 failed,
 127 passed with 7 offline, 1 untried/unknown (v4.19.55-92-gd8e5ade617e9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 1 failed, 127 passed with 7 offline=
, 1 untried/unknown (v4.19.55-92-gd8e5ade617e9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-92-gd8e5ade617e9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-92-gd8e5ade617e9/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-92-gd8e5ade617e9
Git Commit: d8e5ade617e917a499d5d59b24e19e71f80886a8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.55-91-gc491b02eb0=
3a)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
