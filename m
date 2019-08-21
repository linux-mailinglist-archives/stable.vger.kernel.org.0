Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8704A9706A
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 05:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfHUDfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 23:35:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46408 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbfHUDfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 23:35:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so530378wru.13
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 20:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tpm0x2hPwVG4TByEPptdlpwGapXEk8P/PzUPWQ47YLM=;
        b=va/H6Dd94VLkPD/jOWeKcnqTp5qICOYjeC3/hKJSY6UAGecFi4XbUqLeqfxOCmeyht
         uXCc+h2ZuQDNYbEBDsFULDKnOt2ncS3USK4jl1R+d5BSBsrDw5ueF4Kfllp3y+F5qJQp
         ujeJlccKirt/oIXdM4jJL9YjR6XWC5HpANaUzGHqXMHBMvWV6xedU/x/+q7wxol6tWOE
         hAWgdhYlFWsgdaWhC+BP9UwL78nCvy+cmTnixDMh5HiOva0cBfveGOYmcFB70nCpa9yf
         AQVVzKT25yotNVm6AAmXmBAGCkSs882fjy3mq7RU+UCilGNtpyd5c9AcLESU0jNVVdyp
         FRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tpm0x2hPwVG4TByEPptdlpwGapXEk8P/PzUPWQ47YLM=;
        b=rHhL2hx6paKKaZH3JGDVlaSZ0XFKeYyWQrJ3+BKzk5G3kuiFT09hm/IIYsKCNXLVAa
         RszHcdDEiKqrahRpdXBpQSac/xdbP2ShrPuEUVsQZSLl/fKWOLVQDO+Ll5YQ4ILPJIZ4
         pcqhPhUWZ82asLDk4ekn0KEI96hudkD1YcbR1iMIUPMDyI4+uH+aq+T8yXOy+fG4Ze6P
         NLniP1GBXKot6mcToEjVvekNmHvp2NuGWwGWARsPj8XIRlpxo2c2j0UWeQ/uh9/6olJL
         Q1s6rwAZJei42/ORDL+R+FW5rI+zFbQBYrjnXa+9Gfa8co4Q/sDlaJowcmaIQA83Ngqy
         bKYg==
X-Gm-Message-State: APjAAAU48XxEAQqwzZnlzRWQAHQ9s0FeM/dl4W2cdbDOCjc/zC+8P0wI
        dRHMUQSVnbQYOmVgF9MtN3ZppFboWMm6Rg==
X-Google-Smtp-Source: APXvYqye11Rqvh0uQDTZO4ZJnlo5zCDkXV5WqGYY5H73WvWJMEyd2C+F9BUQRYrOHWucGxhTD0tubw==
X-Received: by 2002:adf:de02:: with SMTP id b2mr37993691wrm.204.1566358549890;
        Tue, 20 Aug 2019 20:35:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm2949820wme.17.2019.08.20.20.35.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 20:35:48 -0700 (PDT)
Message-ID: <5d5cbc14.1c69fb81.6e8e3.ce85@mx.google.com>
Date:   Tue, 20 Aug 2019 20:35:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-61-gbd132fe9de83
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 2 failed,
 118 passed with 9 offline (v4.14.139-61-gbd132fe9de83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 2 failed, 118 passed with 9 offline=
 (v4.14.139-61-gbd132fe9de83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-61-gbd132fe9de83/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-61-gbd132fe9de83/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-61-gbd132fe9de83
Git Commit: bd132fe9de8318eef453cded850f3d7599e8918c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

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
