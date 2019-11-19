Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0910238B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSLsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:48:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40668 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfKSLsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 06:48:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id q15so10644428wrw.7
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 03:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0DNtwBvozh9fqGSsAXWPMP3mT78xGFgP7ic/0T1B4Rk=;
        b=PGElhXaqGQXFwB2vCWHBvtIvjxmOBYX95z4g/XrB9fbPTQEBG9Kwg1cjm95lBgSzfS
         FRlZ6VgkhsSNUN2qm23kqIPmzWord24FEC1jSS84hJZbwrl2GLEQaizF3UgzUFOAbJ/h
         +kBZXJcWY64Sny72LtTSQErblbLdpJg3fzR+Jnj+RxCJhVLkLR9ci/3BwbvsjCxPH0ZE
         H322nwATmQwBl7vBSbAqQmdAca4Nvk24Jlco4nPec1HcXbBriR+z3LPzA6rUj5S0Mlti
         GHjBCmv49iBR2c+DqGqz1HZQaoKvRxrdUlyRaucXvDSruWadVk+nXqcB+PuO7BTUcerZ
         cJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0DNtwBvozh9fqGSsAXWPMP3mT78xGFgP7ic/0T1B4Rk=;
        b=paH+JM663RArbl5Thwjm5eOraT2emCbjqiNxUWBJSLkKok9BlDC+OXr2zjIFshqmlu
         xSOqhVjuvhwKR8hh7DX4iZduLqaXmjL/fN/iBFMPKSo+8eXMtNmqB+j7VTX+BtIgsBGN
         Ud9U0kz97Ga+eiXSCIj2EoE8BxfwmUVayE8gVOnryfF+GmoPj0QtJ+/5cDHcs5/qdPmY
         hxCOSKx/a11df7XlG5knOptYYncKdfp1ITPB2NkHuBpQzRF4a8QP1nLEOD3qWSAjSogO
         lJLt6IxxDYKzoj4t5trHBBZf8FPD1jz2Pd5OOGXH9Uj87eX9ru/LmvO2r4g1yixSslJJ
         K1DA==
X-Gm-Message-State: APjAAAWQZlg+0VxCRcYPpTOtVTYOkc3ArwPDRJlyr2qYJrGS3ElBSUWj
        AKgdT98MHRmnhTob8eOmIg92ueWa30Ch9g==
X-Google-Smtp-Source: APXvYqxF9lr3eKtBs78isdEcuofynRX2KhgEa6bHJMucm3tyDLecUVqaPikrXOMe+Z6zREPIjsWdiw==
X-Received: by 2002:adf:f985:: with SMTP id f5mr6424649wrr.364.1574164081261;
        Tue, 19 Nov 2019 03:48:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m13sm2950643wmc.41.2019.11.19.03.48.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:48:00 -0800 (PST)
Message-ID: <5dd3d670.1c69fb81.beeb4.db66@mx.google.com>
Date:   Tue, 19 Nov 2019 03:48:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84-423-g1fd0ac6484bb
Subject: stable-rc/linux-4.19.y boot: 67 boots: 1 failed,
 60 passed with 6 offline (v4.19.84-423-g1fd0ac6484bb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 67 boots: 1 failed, 60 passed with 6 offline (=
v4.19.84-423-g1fd0ac6484bb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.84-423-g1fd0ac6484bb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.84-423-g1fd0ac6484bb/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.84-423-g1fd0ac6484bb
Git Commit: 1fd0ac6484bbc5a0a4e64547a3a27a510d647fc1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 17 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.19.84)

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.19.84)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

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

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab

---
For more info write to <info@kernelci.org>
