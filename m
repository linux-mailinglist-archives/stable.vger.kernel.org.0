Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5024ABF0B5
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 13:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfIZLAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 07:00:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46108 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfIZLAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 07:00:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so1891595wrv.13
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 04:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zwCFL0T5XZgKnIyzdmjTDOF/IFhZrSqe+bemSE89vqg=;
        b=oUJ3dRX7YXucCIzwEMxyjIYaYI63RfqvkC+ezTxHlaPQZgdsR1y3NvbiSK7NqzVWFb
         W7Afg810MsLDGQt8HxBfjiOWfZWmhGz5gdZ/AFTfo4tm8Q4oeZu2RWlHV+/ufnBaKi9e
         E+JrxbNr6be4A5nh4FwRPZmbUWOVi7iBmzdygt00Sah4IC/YLxWp6bvT3txqoc62zrSz
         kJtPOZIQg0TX9TYQY9B9QZTTce4RyL5T7J4XXwH3UjCL2HSPP3KuEdDouD7YOkt+H6og
         qdMEu/r+RIg7u8DEKl6YAyxcNkoWxkgNoZrPrDAA+7pwxVGyIQhdWOGcngyEbbdbAf94
         NlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zwCFL0T5XZgKnIyzdmjTDOF/IFhZrSqe+bemSE89vqg=;
        b=sRr4hShRuX13WQnYbff8SmhvUhzLgynmxH98tyR/NZkKKoTnzbCzrKA1bn5tybotwe
         NoJuIDU1fDBkwnPF3S36vCk/W5qspNIv0kEtE1sqxQLbktFSopzT+xisWuTYnFhh25m/
         5TjRJYLdAfr2pAkbuDxDLXDN7Ah1QmS9En8snX935M51S2bEcREZmvs6npw0yq3eaMxK
         PZ4sJkoVGPU+4HadAAy1qOVTw9nE5rIb3DXEPjaYeW3c/LIPVGVILrqxGBkqie3V4uHE
         n9RIy3IVtc8yI4TkWM9PI9cDx0kV6Slpm3vJwUYT5ll/0z9AxiJ5vPxgjwuKMppi3xvb
         peYg==
X-Gm-Message-State: APjAAAWa7kdAmCFph+heqOYZvVbjpir6JUT5ewBAC9hiU2XOWm5AbXPR
        uOtE7/ttl0NKiYKsg1spHwm6izAuZiFjSQ==
X-Google-Smtp-Source: APXvYqxD7fQo88J3k4cbwQnCFNRglRf8DgVMC58ow2bTmdMt7LqCu7C+ZCEkc6TWsTXGUfIwMBHGZw==
X-Received: by 2002:a5d:6242:: with SMTP id m2mr2389210wrv.261.1569495644258;
        Thu, 26 Sep 2019 04:00:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm5280296wrg.67.2019.09.26.04.00.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 04:00:42 -0700 (PDT)
Message-ID: <5d8c9a5a.1c69fb81.d9677.61ac@mx.google.com>
Date:   Thu, 26 Sep 2019 04:00:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.194-11-gefc375d8cbe3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 102 boots: 3 failed,
 90 passed with 9 offline (v4.4.194-11-gefc375d8cbe3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 102 boots: 3 failed, 90 passed with 9 offline (=
v4.4.194-11-gefc375d8cbe3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-11-gefc375d8cbe3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-11-gefc375d8cbe3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-11-gefc375d8cbe3
Git Commit: efc375d8cbe3d869ccae8d5996ef04c109db2dc3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
