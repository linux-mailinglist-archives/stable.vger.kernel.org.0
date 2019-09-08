Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5BACF24
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfIHOIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 10:08:24 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:36526 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfIHOIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 10:08:24 -0400
Received: by mail-wm1-f54.google.com with SMTP id p13so11800095wmh.1
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 07:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KsX01YNGGb4b5wDjteOz4a36xqsRC5dy/Xny0oxOpsg=;
        b=jBJfzZ1XlaElyE8edu1rF2eFZq21kQA6OqxYLsgaC8pvyIcbDcbbgVmBBr2cSxxoij
         XD616oH7Bbv4hx7o0DBeZOQfmEk2L4qRUgSii7JNgIgW7r/NuVQeVvt8A//ZSNk+Emt7
         4Vn5rR+O6oXdJsgUT3a2/di9uh8ZqLMfTWwO3ZhhasTRDucdESCiuQgd1dEVET5zDOsj
         eNhDoCWtiWXWzYSJXHZHqJGTn1LGAfNaLO7z53WdFBXmB9wM3cRvgnlYgdyHyyyb4d6o
         Fr4ddfI5BIiCehkXm6LSLDUZi1wIWTaxn01P0N41hWGqJpVZjS6iknz4JUAeyWqxXr3m
         lBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KsX01YNGGb4b5wDjteOz4a36xqsRC5dy/Xny0oxOpsg=;
        b=cESyhSDaZPeYxDmR5NnanTIY9RIRQ160Vjp3NoFcphR26v/oFqhRb9zo7A+g5lrJUo
         rviQrqpzskVi5eDfIMP70gDeMRrSCBfDGLpxvrDk9aOJmNVMFaZlkvKjvpEe10JBUp+I
         3vGzUaj2HOPLSPy1f+B8/kzd/edzwWLcp7y2e3iINM9b83r2XGpJbT2u/cRc83WumTcD
         TlxxZkEqVDGuJ3vpKT7a6zplaVJnsD5bHssRORHh2E3ZjCqmzbONugT8/cjzKm1Qz8EF
         iBxJPrLdKr1+z+yhBI2YcZGPf8fvMCCN9OyyDsAc02HVrsO0Bo8G7Tzps5/9YKJgl+6v
         H6TA==
X-Gm-Message-State: APjAAAUXH+G2XU1yAoFWEyfk8+bizemo0sKFp3HSnpn4TYkyjaRqQOho
        C+AjM/GUrecv4AqWX85hAFveS2rGJGU=
X-Google-Smtp-Source: APXvYqxUizzlGdx1A2WbFr0fvDtZQxAjXAsIlnWxHRR2lcYCNCOfZJ234WaT8GhJ++aCNUnfutQoRg==
X-Received: by 2002:a05:600c:3d0:: with SMTP id z16mr14229435wmd.32.1567951700369;
        Sun, 08 Sep 2019 07:08:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k9sm23130690wrd.7.2019.09.08.07.08.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 07:08:19 -0700 (PDT)
Message-ID: <5d750b53.1c69fb81.7bce9.bc5d@mx.google.com>
Date:   Sun, 08 Sep 2019 07:08:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142-33-gcaba048ce704
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 0 failed,
 123 passed with 8 offline, 1 untried/unknown (v4.14.142-33-gcaba048ce704)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 0 failed, 123 passed with 8 offline=
, 1 untried/unknown (v4.14.142-33-gcaba048ce704)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142-33-gcaba048ce704/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142-33-gcaba048ce704/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142-33-gcaba048ce704
Git Commit: caba048ce704e11c69623207036c8405c2beb663
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 13 builds out of 201

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
