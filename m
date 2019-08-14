Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89A8E0F9
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 00:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfHNWrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 18:47:22 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35992 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbfHNWrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 18:47:21 -0400
Received: by mail-wm1-f42.google.com with SMTP id g67so112198wme.1
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 15:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HoXGJj6u/NObMh8ao6mFeXZ4lECpLSubmVU4mZamJBg=;
        b=wS2uqAF9OaT0cxGEhCI6Fxx2Wh3FvqW8vmTxogxNaX0ew/hC1y6ynz3x4U7o8ndxd8
         hdu0YG70GSgvHr6enyJtXu4+f0jb6XDyYlVg5+O5lRrCQWZhwiFSNNrPqakl+UtkjHI/
         gADmNj7ThFm9ksy638IkcGBvrtshqx2Msmm80vp7PEhhYAmn6K0o6J0+kzKOSak3a3aZ
         0MeeHv1FQZTOXYEtrNsnI0OjWZD4330ZD/9nuE5xiAiI0vbhG01qWvXxqOIdbQ5zsFvO
         7IHHX50hAo9kVMV5uRC1kb7qWydyyGogN021un9tDEsmnUtnSWLcHmNjkNkQRFg9AHjo
         RFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HoXGJj6u/NObMh8ao6mFeXZ4lECpLSubmVU4mZamJBg=;
        b=uXxTkjc639DYHEvL7iPFjGtiUYILlSSYyJcvItEPHQiQYO1nvPnnI0RsZmjhyx5y4E
         cp69OYZThRS+i2lc1yMB7gnldXQcqq2TygYZWc2xww5BauTQfX5oMXExtP2KHujvX2f5
         rBRbsM4zQ2C47PsRdtIQDJExOjIUbgBugcfoTjNMn1n/zKLEd/sg0oFPWkDZhOS+0I3R
         y8lZG1SdbrDeKuUT3mGJtzmKcOBUANkd7hfqtBab5mwzigwTUXPrQXRej65Yv4BwCLe2
         ZmPCFUWPhDM8IMZtEZS7s+soiGwStnOB6s/P/S1R40jX3AD8LpFyJ4+u4EY2r8iWHtbW
         Xlug==
X-Gm-Message-State: APjAAAVudWVNsoUfHzM35cyBs7NeLFIhoDPkLHEa450zswgHoO+Q6nGy
        sXIkBvVUAKLz4mnwWOiZUvX3j0sHJJROfQ==
X-Google-Smtp-Source: APXvYqw5Vrh7k/IFp7/BRzlDago9xrGhTp2/LfgyrHofKlYnkP/B8Fcd0VLazJ1EHTm4zGkAQjiqng==
X-Received: by 2002:a05:600c:d9:: with SMTP id u25mr139739wmm.26.1565822839454;
        Wed, 14 Aug 2019 15:47:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 4sm1610400wro.78.2019.08.14.15.47.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 15:47:18 -0700 (PDT)
Message-ID: <5d548f76.1c69fb81.5a03.892a@mx.google.com>
Date:   Wed, 14 Aug 2019 15:47:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-41-ge000f8795868
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 0 failed,
 101 passed with 12 offline, 2 untried/unknown (v4.9.189-41-ge000f8795868)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 0 failed, 101 passed with 12 offline=
, 2 untried/unknown (v4.9.189-41-ge000f8795868)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-41-ge000f8795868/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-41-ge000f8795868/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-41-ge000f8795868
Git Commit: e000f87958680ef8e8724d749ed5cd4c769a18cf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
