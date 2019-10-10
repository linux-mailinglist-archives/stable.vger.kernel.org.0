Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CCD2C84
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfJJO2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:28:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34624 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfJJO2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:28:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so8192243wrp.1
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WvpcapkJx8ulBJzj4PJvqG7ZVPifCPQ0JR/mWjZ/O3U=;
        b=T+YQFAOYKPesISzdHvFEebH1oYb4wBfWTzo59OFfOGVDTIMTSeUr6vLfpRYzvpT1OG
         Ut6Pdxk82CPVznm+IcFger556sbkFcinUr7PQMJEXnyTIAINql/Te3GejMjJCVKEyauU
         6ztNNl95f5jdJfL5t94K1w6qutrnrjESGM0fyK4sZgg+0B85V7ycbvtwPE+tzccCfeSM
         WGf5HuFEUIvHk7BmrWkWZdG66Z/9nSmHt4ulBIBuyECdU+LxtM4DXJp2cJmp3hmuME/L
         OGaaJEmolQSAjGT1Bjaev/3ksh0Ax8xbOEPAb8ic4OBCpXR4iDTbq7lLRyQqhPlVtUtx
         kInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WvpcapkJx8ulBJzj4PJvqG7ZVPifCPQ0JR/mWjZ/O3U=;
        b=SlrFCrP+CF7qrh9hyY10Guii7OiJoa28Qgj5mfte+bcOODMKX0HxjDrTyTZCJcpCQc
         bxvhNymdcw18pEOVscZCf3iNpF7bx3bGiiBtd+kokYdSkTGmRk/74x82rBjK2yAfmoGY
         0uHENeRwGrvFe24ABrs9kNQx5GDiYQxEs5O9VDOJMAoZx6tQm5Azzn2Jgrsr2XWm3T7U
         ZwOpxTu5Zk4Z70H8Cp+cUv5V1QS6RqGNc6lQ+JA+OrDeyZYqLEipJHrE9rE9l6NMQcNZ
         kFf7TC4hD8I53zlNXuJeD6sfgtXtVmno31uVHoVniF+gckCSGR3y6nRavemgfoNfeQ7A
         DghA==
X-Gm-Message-State: APjAAAXOYheDuKIwyP38wIBrdkucZgjAh9DqOsyOpnkPq76tAOhtFHRd
        hF9MB8JaUMd/AMu5Qii76j2E4S4WL8DoVg==
X-Google-Smtp-Source: APXvYqyuFzeBixTr0uTp/ENSTeq6YZg7LN/e3LcszvhEKHSl66RSrWbvySDVOgq/8v4/P4LIkM5Jtw==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr3878827wru.21.1570717687060;
        Thu, 10 Oct 2019 07:28:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f18sm4816360wrv.38.2019.10.10.07.28.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:28:06 -0700 (PDT)
Message-ID: <5d9f3ff6.1c69fb81.44aca.6302@mx.google.com>
Date:   Thu, 10 Oct 2019 07:28:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.78-115-g4d84b0bb68d4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 117 boots: 0 failed,
 107 passed with 10 offline (v4.19.78-115-g4d84b0bb68d4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 117 boots: 0 failed, 107 passed with 10 offlin=
e (v4.19.78-115-g4d84b0bb68d4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.78-115-g4d84b0bb68d4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.78-115-g4d84b0bb68d4/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.78-115-g4d84b0bb68d4
Git Commit: 4d84b0bb68d49edd179af2b16d4b912c1568a182
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 22 SoC families, 16 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
