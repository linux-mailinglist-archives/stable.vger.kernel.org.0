Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10CAB0A9
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 04:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391973AbfIFCdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 22:33:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33196 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbfIFCdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 22:33:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so4903505wrr.0
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 19:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4VH/PHcs39NbU5G44DxACsjfNLefGpLW4kXKGyA4I6s=;
        b=stx6H95/9ITbhQ5ltyg7JTFXaPH2N26PKmbAZH2FJAbaoXuXRzJwVU0OXXVDIME3Kw
         X5R3Lwp1RUgLJDrqxx7/4Ic18IStK57AQwr9oD2j45BJyxLl5rXZYgTdg18Ejp4uPbQm
         LZ+kVAaTziJEO65cGVAg0lDHeDuSN7LT52KNsfyEVqkXe9f6W/vtV5Axe9Lt1U02Q7tz
         bbl18ujR47L7mPzmOB3ru/nHJujsW7zMEp7/VRfDBV7XHfu4T5N1wqXtkVAFEOQQq0A2
         FWyKr+9sJ0DuTIvNlPGjx7410hHfF33M651GVynhf3SKI0EFgb8FswFfO0T/qGYPFaAO
         Ukjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4VH/PHcs39NbU5G44DxACsjfNLefGpLW4kXKGyA4I6s=;
        b=gMtyUZas42XPpJGjqREORv4mVisqRfam89UZYcgInEhuVKeMfdxBnLzjjrJPU+g1ST
         T4rIY+7v5Q64dN/gyylNivt6psulQmPt/vcN5f+Mz2dojYTmlagNLqQu5DTTY3YL7iCc
         SkdoEl7zAmyZUUEQdMh+Bo5P9UUmbiR1Wov6Yeg5tADRm6iPZAtGKnGGWRaM+ENbDYa4
         Q8rxorseYXqYOqaloQ7ArBx/ubh/lL8fZ3a/FQSiuF61i1a1zGcBehaFkHWhbhw5si8N
         dwtKLwAkK9er48XSo/QgDVZ73HvBwnzyTMPqVYtuvWX3XdVs5JLbnywWcqg6/Xn7jvqd
         jsFA==
X-Gm-Message-State: APjAAAW16h9Eb6H5gnQbjiLmnQdDo4GPlyB7WH+wh177990Vf1I50k5R
        oge0l3YSvWJHZJIxcTi+IUXIXLRi36kyeA==
X-Google-Smtp-Source: APXvYqz+Y3cSELN3CaT3h/f2cZjpKPrMWmllFbT5VmcokXezJhjeWW5lF+yTTHj/lyep5CQFxaHg3A==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr3628219wrq.332.1567737188427;
        Thu, 05 Sep 2019 19:33:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm6268712wmm.35.2019.09.05.19.33.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 19:33:07 -0700 (PDT)
Message-ID: <5d71c563.1c69fb81.50335.e9c5@mx.google.com>
Date:   Thu, 05 Sep 2019 19:33:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.141-59-g3fd5cd2a6497
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 138 boots: 4 failed,
 124 passed with 9 offline, 1 untried/unknown (v4.14.141-59-g3fd5cd2a6497)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 138 boots: 4 failed, 124 passed with 9 offline=
, 1 untried/unknown (v4.14.141-59-g3fd5cd2a6497)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.141-59-g3fd5cd2a6497/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.141-59-g3fd5cd2a6497/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.141-59-g3fd5cd2a6497
Git Commit: 3fd5cd2a649783c5f408481581d9e08e1f707b87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 14 builds out of 201

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

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
