Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5437CE8B00
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389380AbfJ2OkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 10:40:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39351 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388885AbfJ2OkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 10:40:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so13922332wra.6
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 07:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R/SK05KwXbL14SAo/JnqhrW4MWLOjoHP9lef4NxDqmU=;
        b=IDMUX/OQfH6r3erj5vBhA32+6QCohmnttp7982+x/FRhdnSM2kXUB1SMhZrXTe6hUu
         UdXiqC972wtwJAC7YyAmvhsd099pvtAhbW0y090PA5oc87/k3q8rmKYNqUqtsNcXtYf3
         eHqjqs2nr6FjTA9Sw9/yjJENfjbTvVIGzQj1GSlcBnleeBUghpzMzE5nnqe/H3+pTJRX
         1KsuTfIQQIQq8WW4daXe/x/o3JmQg/GKk5kDgVrPSrtIxxYGH1KOD+4Z8h4QjDWtE5+L
         kR+IWVHuEIHAIyWyYJCfVATI4oRb8qX5ffJmWmVwfw5iFwDq1H+tFu7nySE4lN11mYKZ
         oJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R/SK05KwXbL14SAo/JnqhrW4MWLOjoHP9lef4NxDqmU=;
        b=S27lxL2VI9I1K1O06d0zKKjuPeKaFL3kooJ20EKOjB+QE/2/e3mCvAVqZtP6YHQQtW
         wkNZrJyUnvYfhG31bR+TvTA25EurSDBQAeCFFTcNiXAgnNiocQzw8BQFdyinFAs+KSxU
         04qCbCKbq24rmbwBGW00LqBa5qamdDl2o0hCYC1Icd65uo/I2W6avQK7xt4ktwdnCn8j
         ZsJkMXK1SjsjJc77fLK1fVuTY/sP/14d04yvF92pGdsG3mCmQbXUbwMltTnwDr+a1nqU
         aWuILYofHgyoJ8PQERRd/85YcYyJW8Ti/0nfGKi7ShgCaPK5789pDc8I0tYRFRBm0BBe
         7PIg==
X-Gm-Message-State: APjAAAXFGNsSF2WmURRbOUMH+giFLoAlYCEDxocGNUpUfTifH7FX4XxM
        cdeyaBVi6yGmbA85e0msfGptOC9kNC7RkQ==
X-Google-Smtp-Source: APXvYqzStDKrsf6q1kDkGCZ388tEIT/ZKxyxpm1nYT5lKBD08e5/wxIL0wfY0IXMZPcexruT/DTnow==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr19365138wrp.56.1572360005226;
        Tue, 29 Oct 2019 07:40:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 65sm26623560wrs.9.2019.10.29.07.40.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 07:40:04 -0700 (PDT)
Message-ID: <5db84f44.1c69fb81.8a572.60f5@mx.google.com>
Date:   Tue, 29 Oct 2019 07:40:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.8
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 143 boots: 1 failed,
 134 passed with 8 offline (v5.3.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 143 boots: 1 failed, 134 passed with 8 offline =
(v5.3.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.8/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.8
Git Commit: db0655e705be645ad673b0a70160921e088517c0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 26 SoC families, 17 builds out of 207

Boot Regressions Detected:

riscv:

    defconfig:
        gcc-8:
          sifive_fu540:
              lab-baylibre-seattle: new failure (last pass: v5.3.7-197-g96d=
ab4347cbe)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-a64-bananapi-m64: 1 failed lab

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
