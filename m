Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED3D2A769
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 01:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfEYXps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 19:45:48 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:53084 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfEYXps (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 19:45:48 -0400
Received: by mail-wm1-f53.google.com with SMTP id y3so12706312wmm.2
        for <stable@vger.kernel.org>; Sat, 25 May 2019 16:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TOw3V4B8fdILo5if7Ku6nMK4nnysiFCzC16GvP1SPJo=;
        b=O+azrjnP9jSybHSIVFxE8AaFyVxB+R++EV8pHz9mPhbcgWNcOJqfWWlizQdums7ug4
         k8Gpw1V7CR9m4Z1qCvF6L+cvFss1jtbVLLQJ6evn7zePktwralrBhfba5ug9DB6lQQSt
         ASNlSEuwplzkiz2UEGRdeaPShMrGe1wF5ykLriA/nzqGT9KCxr04juSflptlCbSL2Eib
         BiyC9chR0gPWVV9aA9aaKAh6Bq1GRW5kNCVSa1JczoTOijpZFhZtVneC/uc/aa75Y1c/
         aS6IJxx8Ivp9DCm4tyisCHgcs4qLEeZm1wZV4Llyq6pg8N+P3iIj4W2q0XknS1fMqK/n
         Grsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TOw3V4B8fdILo5if7Ku6nMK4nnysiFCzC16GvP1SPJo=;
        b=ogYWw/2KPfv5hZ9JCSOO/Nb81knfiLW8LSOu8U4Mon+wgQbqmYgjYLb7f0e3fKqoDx
         czwBvBBkVqj0nCguY60xdVDmwl0GMswCkbMh20uidO5o/J+IykhmeqkSosgIp86GV/V6
         ewS8DMWpyXJFdLV2imASdzamjNkbfzMaJ5GadHrS1Tt4wWV9F53ZuBEKwY3bLdxCcIis
         Cd5Ggh7exkcaIfaDKKaj+DcgJ3Rx2fGZVEgDxhizEr5iwrNm+Fx5EqpFOmKP8YZ2nZas
         h/IELFCBz5tByCeBIASOPxL8V3qawNezn4KwdSgmofZHpAcNBc5fGT4mpmeWrOJDduia
         Bi7w==
X-Gm-Message-State: APjAAAWZSb52FoS9mwYwU5tG5loSmnT6we4hNNicwKY3PRjYk/sPfQnM
        B0dwH3xWRpIB6FiBeMcGYrVQ1P+cauQ=
X-Google-Smtp-Source: APXvYqz3ahpAd24WGtM7Bqmtuasx2RNZ5UoUs3VfIq0xqVgRFWh03t/LV97QZunnJ3wSH6ku6aDdaQ==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr4540378wmk.72.1558827946483;
        Sat, 25 May 2019 16:45:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm11815293wmd.38.2019.05.25.16.45.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 16:45:45 -0700 (PDT)
Message-ID: <5ce9d3a9.1c69fb81.e4eab.263a@mx.google.com>
Date:   Sat, 25 May 2019 16:45:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179
Subject: stable-rc/linux-4.9.y boot: 107 boots: 0 failed,
 90 passed with 15 offline, 2 untried/unknown (v4.9.179)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 0 failed, 90 passed with 15 offline,=
 2 untried/unknown (v4.9.179)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.179/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.179/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.179
Git Commit: 2584e66ffbf0fceb85c2d2f9179b6954720ec55d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
