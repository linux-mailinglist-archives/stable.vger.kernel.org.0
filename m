Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EC1A5DF1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 01:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfIBXFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 19:05:49 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:54819 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfIBXFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 19:05:48 -0400
Received: by mail-wm1-f52.google.com with SMTP id k2so14588411wmj.4
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MUdGnN17qxqzwdx12bhBplj7f0vRe2vNNH67eaD5N9w=;
        b=FQgSWRWdqW69Kam+ydS/guOsvLdlwPu3iVo2R1xUsEFSZ9k5cpOpFJhD9oLMoafBUf
         KNpfZprWymWKTT+kPjfVRN+GYHSXVRtXXyYaYecTOOH3tKkpC14Ppiux0y38V9OFDYVm
         M0fNzJQDnpOEKgb5LeiG/oAN1pj1dvl8koqtgIrjPfhpCXc+BIOlgtIlmuaGksiAJiQK
         dEuGpHEgv9Q5t7oPj7ge/Iii0E3PwrpBBagGDGWMEUlo64URvvDXNfbjT6MCvCSzLayb
         aIVekrWAteoE+VmLA3y7/ZXs5p43HmY29OYS+ZxJJk4QquISj4iULgARsYGOaAAYsKIC
         ut/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MUdGnN17qxqzwdx12bhBplj7f0vRe2vNNH67eaD5N9w=;
        b=KbT2ETBxPskX0Tc3aCgRUgm/YFUXjoHO2T6IdrtZN5yNuFr+xq6LmPHoUp7aVDAQLg
         ZzaisuFJqjBA7Z3TsNLXN230KF5X0K0RraiquwSEsbOEa4+mBap6raY3cVClTslUTD4d
         HN/Rm2ihkZ1R0NySnEPjcsrOdxGCUQM4a7mJr+ug3apuHPAhqfH0oTGCcF1BVOrdO6cO
         rsY1nG/boYOx9o/p36h42FBx6snbg5b4poe08Y79zKxJnOI5I/lW1qRAG2vBG18CrJKm
         IqwMjujh/wmq5+Ohqiy9gXlpVbAEyXTy7mrPpJZ5tCPZoAcvnbENzyU8RnLSh+R1uJPv
         7HsA==
X-Gm-Message-State: APjAAAVRU2UqGaAoJOkfT+DVyO5SuLvCN9zWMKRnSh2UoWAZHXsTvkdX
        38wq3GTREW8vIjtJcNDBrxcXuCfa+yolJg==
X-Google-Smtp-Source: APXvYqy/X48fGun4FQEWR89TYhwLKiHlzVCxgF4UFtdUmQPtgf8pDvyOknrbFezzYqXjRP+6KHZ5vg==
X-Received: by 2002:a1c:f704:: with SMTP id v4mr26981976wmh.90.1567465546533;
        Mon, 02 Sep 2019 16:05:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o14sm45285069wrg.64.2019.09.02.16.05.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 16:05:46 -0700 (PDT)
Message-ID: <5d6da04a.1c69fb81.ff86b.7122@mx.google.com>
Date:   Mon, 02 Sep 2019 16:05:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.141
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 143 boots: 5 failed,
 128 passed with 10 offline (v4.14.141)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 143 boots: 5 failed, 128 passed with 10 offlin=
e (v4.14.141)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.141/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.141/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.141
Git Commit: 01fd1694b93c92ad54fa684dac9c8068ecda8288
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 14 builds out of 201

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
