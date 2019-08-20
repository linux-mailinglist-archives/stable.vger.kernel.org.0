Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25EB95B25
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 11:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfHTJkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 05:40:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38235 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTJkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 05:40:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so11680715wrr.5
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pX+YETJEf7MA8nt5fZhHuUZpub71kBidw+OQKvxn2aw=;
        b=vZyNuWO/8ahOgzBBJjUE3XtACF2FnM30a6JjahcYZyYDVca2+beHu9M0483VholJpR
         Rj38bcolD3keyG4u0BUA/I9a9r6/F27ooEDvlBt+OtrWIRjenONr3ouHpnRXPXc/vyw2
         nY7Kp6b63x0c3xXeBgU0AMed66JYMVmrdZLyv7ZCMiUucLEHkJ8JkXiecujZy76XdHyt
         IwkW5K2HmJsBaZRSZqvebWqbtuRuxTtPwqucyrg9xCVzpLW9xTDeRpbkB6VWO8iHa6J9
         xChXOJv8bY2HFbFxGfIhx5gt6I2IGrHMUh580qr1ZGJrQyWtbK3LSQwPvjXbq/upg3uf
         oGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pX+YETJEf7MA8nt5fZhHuUZpub71kBidw+OQKvxn2aw=;
        b=LBnJuPXA+wstfzrnlc8bfpBWBUu2UQyaf3s5M+YLW370jeg1K2RHk73PQspa41kTsx
         MWXiCK+UYtR2rYdBqVIxjVVMZqzukx5WazlCXITPrMhPNsaj/ya39WAiEu9Wgi0pa3WE
         zh2nLy70UZW1QHXBSFdydTLPadRxZP0C+rDMEIJxz4ayC1AhJxbDQNU3S6/aRDjSn96X
         LiA08LCLOsfYNQBTVb3KqftSLbKAAQyfByVxFwzLLpYO4H2xVMpqH29Rro4PJZzauDbY
         I5BiN7/dk/EA40oDo8fs/BS+CjQ+1tniUVTVY0nERj21DDuhAMyNtrMFgFZfgFR1J5cf
         tAlA==
X-Gm-Message-State: APjAAAWlVvCTLGy/vv9kNJUSLIuwQQWWlIYMNcrB+czYSjREtg6kfZ1E
        n70EfTVokv3QGhwHQwM/39rupCQy7wYYjw==
X-Google-Smtp-Source: APXvYqwkQoFiTOxRfFuPSrC+SAXJryCunzf7gF/u27OxoOLvig2SQmS1Qsw+QKO/PTIQAD2atSA8MQ==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr30543501wrn.264.1566294016495;
        Tue, 20 Aug 2019 02:40:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o9sm27368101wrm.88.2019.08.20.02.40.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 02:40:15 -0700 (PDT)
Message-ID: <5d5bbfff.1c69fb81.35ba5.497c@mx.google.com>
Date:   Tue, 20 Aug 2019 02:40:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-250-g5def0a7fef90
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 129 boots: 1 failed,
 110 passed with 17 offline, 1 untried/unknown (v5.2.8-250-g5def0a7fef90)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 129 boots: 1 failed, 110 passed with 17 offline=
, 1 untried/unknown (v5.2.8-250-g5def0a7fef90)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-250-g5def0a7fef90/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-250-g5def0a7fef90/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-250-g5def0a7fef90
Git Commit: 5def0a7fef90a9637ec278bf974a982ab07ed5fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 26 SoC families, 16 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
