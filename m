Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC71B3596
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 05:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDVDgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 23:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgDVDgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 23:36:15 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDC7C0610D6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 20:36:15 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w3so381599plz.5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 20:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WGtYDq9itHn7cCt/cBr7Ykka37OcwyRyi4uAt4aC5M4=;
        b=RFtUHyjTyry7P0d/IVQRwaO1kp4ICLcUvWqY7yMBMHWnNHhEuaACMEvxHZV2/PlyWT
         pCPHvUkU8gm7gjkuYnbwlOMGDn+NgmSiU4zFpiGWxfjDKt5VlDC0l2I73SAKie1vGoFi
         ZU6ROAkEWpY4nHernwiD8fxXyLjsiC5E9sBKk/3p1mdI2cuB8gU/2SVMJs1xcWpuZmMv
         DeOWjzrc62eQ+/Xnij4A1QPKZ4AXm9/m7pBnbctgxPZCKUA/+jsji76hodvWzQOmro7t
         fbmmhdPy+6zVDhKZ+qx76ZWtZFUzG8nwiHqvzrAL55y4oqfxhIFsO4tErXU03DinDGa3
         gWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WGtYDq9itHn7cCt/cBr7Ykka37OcwyRyi4uAt4aC5M4=;
        b=tnhJhdGPHQp6UeOELedVOM+mzb27y7phTs7sP14s074emBwNzSfK2P6op6XctAMmOQ
         S6Vwpk9vTcaQyL1P5HTJrcn/t319FkugRV0ljB/ef/C4qWTYLEBsTMbvBENTG3M1VU3h
         hVxkXWXu7MCCEDrSVtiZiUXGZ1uHhXb4GVuqcQdWOPAbV3rEQWsB3ei2KxTvg3ubFtdi
         EPbAhvk4xoKaGcPzC1T/whi7D3sX9UQW0VHZ+lAEBQgVAvfC9A/6ByT6LcaV5By7kVWj
         CVVNcHfk+ZV4OfWV3bIF1aVq/x0pkQpk8LgxkTtryfal4tQIHDpkIGb3k9APSHr9YpZu
         3S3g==
X-Gm-Message-State: AGi0PubVWjmMof3Tn2vtJ18JRrrZOfiskMiTH0b1lLHXzyPhIJkOX6/B
        HkpCo9O8L7utlKd+qBrlP7G96bf+m9U=
X-Google-Smtp-Source: APiQypKEeeFO5Lc7SkidOm66PrmEK5HYo6GwOrG/zqv8zzpUnhvpLkq2svleTtlPYEd1OvJc9Qcp3Q==
X-Received: by 2002:a17:90a:9b82:: with SMTP id g2mr9480542pjp.72.1587526574313;
        Tue, 21 Apr 2020 20:36:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4sm3757179pjv.30.2020.04.21.20.36.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 20:36:13 -0700 (PDT)
Message-ID: <5e9fbbad.1c69fb81.eb112.d777@mx.google.com>
Date:   Tue, 21 Apr 2020 20:36:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176-167-gef12a8a0e717
Subject: stable-rc/linux-4.14.y boot: 52 boots: 1 failed,
 49 passed with 2 offline (v4.14.176-167-gef12a8a0e717)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 1 failed, 49 passed with 2 offline (=
v4.14.176-167-gef12a8a0e717)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176-167-gef12a8a0e717/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176-167-gef12a8a0e717/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176-167-gef12a8a0e717
Git Commit: ef12a8a0e717f288006bec1fb28ed65bf950284e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 15 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
