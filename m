Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09327B24E2
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 20:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388920AbfIMSMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 14:12:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50332 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387802AbfIMSMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 14:12:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id c10so3714482wmc.0
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eesOvB99Cl0gjrazfmmlL6YJHFrMtDGpxz3w175TqFQ=;
        b=zOhqT2djogSPqrdWy0X0UCIu5nHuUQNFwGkGOUZGJcn1X4gNSZoiL/KcsiuJvPQpkQ
         Vlmtxa4V61/Xe1Bj73j7v7Nld3XUj3nsLoPVuYfSg0quJeNewluwFTcBEDrpFeM9dzJU
         BJnrLUGXKOcDDOStehTZdsNqbFqD4CYn7/XcvVc9VZVW/x25hBWkARdr+k8LpppecCV/
         GJk7mN9i77NN89RBIxPIUQlvakNpMmKRzudASnR+72ArV3HQMJJWy8JqJJo3p33FXwvV
         huY8G86+LMIXLgcDLKFcRRCgZ9/5Xs7lM3f3JP3agypUaNCImQuxsGkz5bahExSCLSJA
         YblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eesOvB99Cl0gjrazfmmlL6YJHFrMtDGpxz3w175TqFQ=;
        b=ROcuJPWey++HFMq9b38EzezHKbNYeEUu5l9fAjfWq13cK+JuNodQbh7gfIz2ziXKOp
         eJy6axgZtpceljfBhU8bYvZFAuz/hF91Qv8CmE7QOMVkhKKEYCltsPVwKNXRYdNXMS3O
         LH58pHt0kK5gv3Ax18sW+k5TGfc2NHp5Jf5Pa5Q69Ewb/U2WlECtb4cTbqdq9SDb7QX5
         avLnJaBIdYdfyC2P5A6wC0fHQIqAMiC6PtpytVKnF+kyIjFSLZJU9RDHG9IRKaZJp+qr
         yaV8vJjT29tCSEv/1bc+g6CvfH3Rbh4F4RLq8fknfbZgTdKjliO/FjRXdjQL9/EV6P9R
         yN8Q==
X-Gm-Message-State: APjAAAUkPH91xZCvy9M4THQZVpI61uZCqz02RmR/b5pf1d+yKlz62NCk
        W4cg1jt78JTQ2RI/3hep7YpBjGZRt35WUQ==
X-Google-Smtp-Source: APXvYqyeWE+2Oz6ILrDPKpU+DDLNZ8sl/U52Pd+hsSlu/JYAMDp2L61DtWRTbEmjVwr4XarZCX7khA==
X-Received: by 2002:a7b:cbd8:: with SMTP id n24mr4421781wmi.170.1568398325474;
        Fri, 13 Sep 2019 11:12:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm2454908wmk.20.2019.09.13.11.12.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 11:12:04 -0700 (PDT)
Message-ID: <5d7bdbf4.1c69fb81.96bce.bc9b@mx.google.com>
Date:   Fri, 13 Sep 2019 11:12:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-10-g0a1ee44c6916
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 102 boots: 1 failed,
 93 passed with 8 offline (v4.4.192-10-g0a1ee44c6916)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 102 boots: 1 failed, 93 passed with 8 offline (=
v4.4.192-10-g0a1ee44c6916)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-10-g0a1ee44c6916/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-10-g0a1ee44c6916/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-10-g0a1ee44c6916
Git Commit: 0a1ee44c69166b2750a62fdb079320a396dff30c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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
