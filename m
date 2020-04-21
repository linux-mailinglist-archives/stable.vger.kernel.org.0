Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098D1B306E
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUTeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDUTeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 15:34:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F7EC061BD3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 12:34:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so7241201pgc.10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 12:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q/gWr7YCErmg9lp428fGEwOFRo+wgawj4scqEMKypTA=;
        b=EirFP1CMpgAKwLZPkb502tL//3IqkAULA85fq0De51gzY3XbFGzD7a92PwrD7imMWz
         upfOMG1DWVKqfqgTI9N/QRfchJc2EuzSVoYgn/Fahiobx4WlA4NoAOu7uEszi+Dw5EEt
         ksZUx+/TLzTbHGqkyptZPtB/zMPJnRlpLc6U0lM1YmJGZp72I6CRTg0ObI9/ATABQ23M
         nxovknx4mnUpBfu1MNs09jdPyMADwt5SGoSlAmbcJazUU49TTBRY/+lbs45y4n04XBit
         2P5+wLpZcESZlfZk5Gn+67blzGRb4QsQuTwb1j2Sjyf6YmKYCUOV3KblHZyViXWvL/8+
         mpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q/gWr7YCErmg9lp428fGEwOFRo+wgawj4scqEMKypTA=;
        b=XtynLvRLhas3wiOtMsaobE/WUqIC8292WXsWRwGAlGLcb875VMdGE5PF66ufhizu3P
         7RV+nZQWOChEH71hVRPFox3Th7q9WbUdTrPx37A4eKt9nAUuVi/HZXiv5N56l9DpHgg7
         3df1/sfawZbxEABaN/mcG7m+2zgtPZGXtkKKbBI1kSTst3/6s9IbHXlvJeiW6CGWOAmi
         zzFRxKQLox8N/kL5mrkq2IVaQoFjXXLGyS6to1hyHIJ+1YK/00U06mwGd7t0d78VEZyp
         SfUI3QX4SOfOdK7zfloWTWufQuUBt1MIYrJ00zZu/mAgxjauhMC6lznmettH4dQPsNLO
         26aA==
X-Gm-Message-State: AGi0Pubskl49QNL/u8Uosn+SbnPTWrt6uFh/CF/6GpOOsoqbQ3LFlC18
        7bEMHyCneS9d8aWs9ADP3Agj6onI2Z4=
X-Google-Smtp-Source: APiQypL99qsYxbHxSfoHE/0WbIkL9YkpZs5NOXgpWBsduaUkGEU/fKRitzbKBA0eSTq35H4kpkQLBQ==
X-Received: by 2002:a62:808d:: with SMTP id j135mr6508387pfd.53.1587497643506;
        Tue, 21 Apr 2020 12:34:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n16sm3178134pfq.61.2020.04.21.12.34.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 12:34:02 -0700 (PDT)
Message-ID: <5e9f4aaa.1c69fb81.f173f.973d@mx.google.com>
Date:   Tue, 21 Apr 2020 12:34:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219
Subject: stable-rc/linux-4.4.y boot: 41 boots: 2 failed,
 35 passed with 2 offline, 2 untried/unknown (v4.4.219)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 41 boots: 2 failed, 35 passed with 2 offline, 2=
 untried/unknown (v4.4.219)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.219/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219
Git Commit: 10d9c6f92756c1b9049e409cd5e7faed40f95294
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 14 SoC families, 11 builds out of 170

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
