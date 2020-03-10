Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7DE17EF94
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 05:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgCJEWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 00:22:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36730 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJEWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 00:22:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id i13so5877225pfe.3
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 21:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yjC2fpbZPxyyoUDGWE7iKBQochzMhaSpmCCVUbqugek=;
        b=Hkm4MTC5AHqJpd4/XJPLfO2kTNJ9TylG+Wf5yMXxKvdaFqJ0x78EwoAGPbrrrla+R2
         4fZiyNt0Ene8dl4AHadhtlwsC88wIg3t2+zUGBX3am5esCDikuZLLkwCPIjUugweNHOW
         HrDR0/GiWWIUhi2o0l94eWdotQHESYwAMpAd3fEOK05f5W7w4fLjeq+Akt/NmwConhLY
         +1wgZ7dMohSaw3dIiGaIDkjQcWhI+XmaT2mK8T0c6dcAeZkw0kymMO7tWj1G54E1jYI6
         Sw/BwrkOnQe11nn8sjB0tnCpKAdhKy2xlr+k9DLriMCQ/u8LYacz/MC5PCHuHmq9+jLo
         11RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yjC2fpbZPxyyoUDGWE7iKBQochzMhaSpmCCVUbqugek=;
        b=YTgeLcHRs2vEd2/c8cXZYDAUNp8adRq4Xvgr7FXJ/B225aq7sWmziTVzvlicDnDZB4
         H3NUohRJezwZLOPbUEzD7yv70vwVJn5zeYHPxLaqfJFF6+7zCT/3j3EsAeFKrZHLfHQn
         WTyBO4D2pXmSO8JmVVIxsvr4j7/ybD+/YKTe9hALgSn06+9gFxvGxXQi2fxmUedQ9P5n
         7OHOYP667KQ/PYLGJHWvsGsBerncwNlCnnR6E12aN55+fttFnQ+weHelq2P6XvV1sqbO
         1aYDSSNq/6X++DNBa7d+h7aZG2fqFmol7KQSxNgmudjdl1SbBc95LkPnxjEg1+CpLiTy
         Wcxw==
X-Gm-Message-State: ANhLgQ0Zo+BX3myTp5mbEoGTnDh3tSYOGpZBLa4lQ95mrUU7wRafyjv1
        zNeq+j6spXu+k/vHSM0pJ0st4hBABEw=
X-Google-Smtp-Source: ADFU+vuy5gkHK7a0hTDLprZ2nFt0J3MjxaORqwJztOHNY8XeudkAwK/nVAQX6OpRnp7a22tlTru3+Q==
X-Received: by 2002:a63:5f13:: with SMTP id t19mr18674155pgb.265.1583814123987;
        Mon, 09 Mar 2020 21:22:03 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16sm989888pjr.11.2020.03.09.21.22.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 21:22:03 -0700 (PDT)
Message-ID: <5e6715eb.1c69fb81.609a1.53af@mx.google.com>
Date:   Mon, 09 Mar 2020 21:22:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.215-62-g1ef447a18aac
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 64 boots: 1 failed,
 60 passed with 2 offline, 1 conflict (v4.4.215-62-g1ef447a18aac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 64 boots: 1 failed, 60 passed with 2 offline, 1=
 conflict (v4.4.215-62-g1ef447a18aac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.215-62-g1ef447a18aac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.215-62-g1ef447a18aac/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.215-62-g1ef447a18aac
Git Commit: 1ef447a18aacdc2f92cf1336fbb2ba8c082681fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 15 builds out of 188

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 30 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.215)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
