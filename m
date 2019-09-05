Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21495A98E5
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfIEDau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 23:30:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32956 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEDau (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 23:30:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id u16so922089wrr.0
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 20:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wdCg0HhXFQYvWf13Dpr72Lu3ccPJEKe2R3YxRA7hBqY=;
        b=rn0CAwVlJ4dcvC2mRSO6LScJaPyQiSQT+tgovEpfIPa+jN0TRhusiRjRMbTqjbMR5h
         4WDJdT/De1PFMfnsr5khpj07QaT3iy39sU0v5lHxBSWqEzcu8H33w5+iupewqyCuoK0E
         wuMt8u70w2H9Xdl20hzg9ykj/ICG4bgCzBArhbntytg7tv53xQSsgb+MXqjHDT7tNs6/
         aEo06kSRKe1pddkC+DCoj7zTqQDWc5ZvzlfUauz53Ou8zIuusLYQxp84lsdwNadav+aC
         83lmLJZReEmNEkOSfA76JdGKsS31iS+M4HZiulL5dl0mJETcYLzLfkQLU7skE/fP2NkK
         Ho4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wdCg0HhXFQYvWf13Dpr72Lu3ccPJEKe2R3YxRA7hBqY=;
        b=miEvLLYvFo2vxIRNnUmo8QQWQm1XVbHKBCtzr+rZ8IDZQwkNs2qmEMuWOrDnIYAWeU
         KwVghBZ65fEsRMNA8r7BLVdh/7nlQO52muf6mE/auG2Oxsfn4/AjBzIGWxjteN3Z1zwF
         CmpTrUwu62TnYDunOlj4zuhYfidxi/cO1E6KnisNa0jEl0T/9Z5/phTT16MqBhbmPBIV
         1lXQT58ehi1stb4ZFQLvJrDMV2Vju/vpwJ+ke6a7K+cV+mp60zNicc2fXYv8g22nQFoT
         xa2KIposxQHA17in7s5lp88Mr0PJkTAMHHb8WKgpYrkpdhujFVVIr+qM1Y71BUFB5rTM
         ndVQ==
X-Gm-Message-State: APjAAAUzqOKuzzBmJ4KAvyZmqw7t5ySu8uD+r+9NLLALVuRMTG1NOdtQ
        bpAflLyQ6jteNJcxXW3wVEVvuaTsmGWntg==
X-Google-Smtp-Source: APXvYqwFzdhwC2pEh5OiAWpzn6hQfKboMfuLG2eNCb/qMYFzI6yDBFaMTrw52z1C17JlVXcqaYVrKg==
X-Received: by 2002:adf:e881:: with SMTP id d1mr594193wrm.301.1567654247970;
        Wed, 04 Sep 2019 20:30:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f143sm1181314wme.40.2019.09.04.20.30.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 20:30:46 -0700 (PDT)
Message-ID: <5d708166.1c69fb81.65459.5158@mx.google.com>
Date:   Wed, 04 Sep 2019 20:30:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.190-84-ga232f5b3e312
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 129 boots: 6 failed,
 114 passed with 8 offline, 1 untried/unknown (v4.9.190-84-ga232f5b3e312)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 129 boots: 6 failed, 114 passed with 8 offline,=
 1 untried/unknown (v4.9.190-84-ga232f5b3e312)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.190-84-ga232f5b3e312/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.190-84-ga232f5b3e312/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.190-84-ga232f5b3e312
Git Commit: a232f5b3e31224799f7506f9e9d4257d3d357d1b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

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
