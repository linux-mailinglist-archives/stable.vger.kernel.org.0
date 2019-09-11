Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7CAFEAB
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfIKOXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:23:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54689 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfIKOXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:23:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so3730429wmp.4
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 07:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sSyvNBTCrjrqCszwLmF4d1XETdxp5+9ATioKvctb3KU=;
        b=MQczS4wTxR6b0KMuB9DdoGAQ7Kky8CR5y+sW4BO4wPXY4NDoOE/cKjOGQOXJRNnpls
         TLbzjLqViz6jGt3drapdLY+9LqwEEWKoc6wl2yo/0zGYynkHSUS2ad31IAB1i3BbUeo8
         7xtn8wIDZBYVYYKrzJwnYoieP9+/p9UvQoTuewZP62r2IA35DrsQmF8gp7IMkNzD8diU
         BX8BqSYGHPY2tbLvycJqOzOm/dTO4uYBUV4pxRGAgO3MkTSJz0p1Zqv10AVDFuLb+yGr
         v9Y2tDCRor7Ab5WTprjw55A/LCgEIvd+nIxOg6E5SY3iDn6q7ZFngpZAOAcGwrQS57Jt
         J5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sSyvNBTCrjrqCszwLmF4d1XETdxp5+9ATioKvctb3KU=;
        b=Y/1YFG1oXfatITYCs+1YL+u5j107D+NsoHtsjaVzQo/2BQPvyiTH6BMpOPqwo7W9ca
         b7AAY2Xt2sOuM7uzaufAnTdrn4g5ivCn+Qvtg7KAhY8evQfsTYeEY1VLrkPYJhGdSoAX
         mrcIVmmCXAJYhACcoPeeDAV/5SIc1wxmC0kUpLEQoNn7MrZiEDW3U0luG4W+gmL0zMD1
         EvD6BBqewIz007WgAPtPBAOjb4nGom6MInndLu1Rc4yxY1GvNRaGxjZLYdq14QXZvoZy
         RZiGudNFTyGR8yx6zZI1PdOaRxY9vDv/qJw+mMUK1QZxpnhmBOXMGXmPQnoP3223Nv7l
         C9HQ==
X-Gm-Message-State: APjAAAWoxdcIFP/Gu0d1/P4T5RSsI8FwBR7iY6wCuQ4YyRpwKlqjxvbq
        dJ+eqv+oFU5QsTWjspxRH/ozeOPRZMAbIQ==
X-Google-Smtp-Source: APXvYqxAZ8mHGZQyz9x0HljncuIVU/AMhDfPm9+JDcx3C0blhTg+GxFjK0LMFgfxce476AhwUp+jYw==
X-Received: by 2002:a1c:7a14:: with SMTP id v20mr4578468wmc.75.1568211784500;
        Wed, 11 Sep 2019 07:23:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b7sm2652717wrj.28.2019.09.11.07.23.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 07:23:04 -0700 (PDT)
Message-ID: <5d790348.1c69fb81.8b6b6.cda0@mx.google.com>
Date:   Wed, 11 Sep 2019 07:23:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-7-g1976d5fc6a71
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 95 boots: 1 failed,
 86 passed with 8 offline (v4.4.192-7-g1976d5fc6a71)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 1 failed, 86 passed with 8 offline (v=
4.4.192-7-g1976d5fc6a71)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-7-g1976d5fc6a71/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-7-g1976d5fc6a71/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-7-g1976d5fc6a71
Git Commit: 1976d5fc6a71831ea31130965b571294ead2795e
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
