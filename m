Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899D7A9778
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 02:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfIEAET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 20:04:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34341 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbfIEAES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 20:04:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id y135so3648571wmc.1
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 17:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MCwGjVWQ8geMBz8XA4P4QY9ik7qf8xcDkwmUNH/Zo/w=;
        b=RfcztV+HlD0h50s9hy+yssVrEg1GNvTwnTOc/GjubHkt68JXX/HG+USBrG9QaMv8QM
         4M/k52/AfZrftuJmlNkPxUSOcNFN0NXuWZNDRH97TysFxd9NBJrUrJEsFtV8l5Ue90+6
         MnONOmtL4XvZu6RHkfUg63lQ2B/Xz0GnCdgZsUODwfAqFdWzv2MZt0IwMJTHGsP4DzaJ
         iI65zP3Vkk6u2nggQx5hnFRXZEwv+8M39VtGNLA69T8OpzOQ3bJNGkXMhGMNVvQCjJ3+
         L1QTOfCK5Wmzp44IAn8Tl5Jc9YdUfPrCLyM7Fwmw0X+rN5CON/eH+74rkETsfG6kk/po
         ryqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MCwGjVWQ8geMBz8XA4P4QY9ik7qf8xcDkwmUNH/Zo/w=;
        b=lxoEXdPjoEfjQwUTKhDkY7izCrCXBRIpyTGumyn1UHQmIAgkKg47RI2ZLAheCYp6I4
         2AwQv0tOV3dVAQD3Ye9q2JbxRcVq58WDFvVmwgznwTL4PFP7ykLprUq1Sx0F+OZutzVG
         sunk/Lslz2+1t8Lpbo6WqQKvocglFneHSGueXQBVrooAAon2KFQRWDhG/F4OXZC8iJja
         odifNJhJLRzKtBwkTtXDgNVorM02dHaZ5GJZr276tnyK9UwbqKSe+7q0PBu3HHoEsT9a
         rxpGwnBUjvQuCZ6nMBc0pjp3AGiIGpAz5eU4YuKaUWsRvCUXGPJcRV7FkouKX+V6GJKK
         b/1Q==
X-Gm-Message-State: APjAAAW0TLIsLfmu/wazG4rKm9H5BhizXjDiFAP6Mt3WI9veHPN4j6tI
        muvbDuNC13KaU+l1roog2i8sQDHlDy6DqA==
X-Google-Smtp-Source: APXvYqzAslD24GFX6z6XhZi8TgHKDzsWX/im9gnc4z1Jqaw9cs3CcSBtCIaBXribuVfulCkC+gDXew==
X-Received: by 2002:a1c:2bc1:: with SMTP id r184mr577988wmr.40.1567641856479;
        Wed, 04 Sep 2019 17:04:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g201sm1081590wmg.34.2019.09.04.17.04.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 17:04:16 -0700 (PDT)
Message-ID: <5d705100.1c69fb81.8759e.5610@mx.google.com>
Date:   Wed, 04 Sep 2019 17:04:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.141-58-g39a17ab1edd4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 144 boots: 5 failed,
 131 passed with 8 offline (v4.14.141-58-g39a17ab1edd4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 144 boots: 5 failed, 131 passed with 8 offline=
 (v4.14.141-58-g39a17ab1edd4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.141-58-g39a17ab1edd4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.141-58-g39a17ab1edd4
Git Commit: 39a17ab1edd4adb3fb732726a36cb54a21cc570d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 201

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
