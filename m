Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3931A1048
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 17:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgDGPfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 11:35:55 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39542 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729381AbgDGPfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 11:35:55 -0400
Received: by mail-pj1-f67.google.com with SMTP id z3so911606pjr.4
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 08:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k+o2/T3My0hj3aoHUQm/323KHfUmfhx/aRzITmSi53c=;
        b=ghG8pQvN/DTMlm98zxKvcqzRgxaOrHkHrFIOhM302zbY5deEWZUxBIQmCW/KsYy6HF
         Jib7G8A/jdQtWmOR0PPtIzA+lmb+11LcdQKGQGrWVY4WnWH/r+4ujWm8M1rdWG6n2b4s
         Uj6ui2Gjii/PMC/Z8f25033CBOApts7zUl9idMHQpNV5kGsfI3qX5miWp8dcgV6SRMWs
         fUoi9+0Uwr+/xc4WGIYxJh8J78bWTxMP+jjR6JY69U/lqCCfAqVOMu2yKInvdHZK4REn
         oq3joT2KiXH+l5P2UKHQu2Ngdcf1RXrb9ahZlzGPqQPPtq0ywwzoiEQRrTk8zIEaGrmZ
         CjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k+o2/T3My0hj3aoHUQm/323KHfUmfhx/aRzITmSi53c=;
        b=R+6+b3bZpyzsWi3ydZPMnBsGwetVbL6nlO6EsYCI2uCdCFQ3rYxEqXf6vr0JVDer8S
         Bz3KTZ71NRlrqt/2C+nSkNvdo1L1Tu8oHfvX+jPqVqMz0igD8Rh23+6yun4A4AYwVGTW
         9FVWIF/k9yUexcttz3I7OVDBPhb9Q6QUbGt2nCu37tdKlLTxevRXaFalPKq7GcnxPCM3
         dEddtcksGJ5YfRhll8g5EET7uW6xYNbFFvVd7imdDx+Nh2z0dPLo5r4IpBlbef5hGq6Z
         6Eu9DW9j0ce+OGe43PupHfFiuoes7TiZ2mw+dv7nbdFKmgz7Tb2FICmPHBYZabX3VOH2
         M0Kg==
X-Gm-Message-State: AGi0PuZGIFRJ54VTDEkOGAzIQtH+VMV/Ws+ST5DGCGsBxHPwJWTsj4ri
        gLfeDmDxoD8/UfAVOw1NPaKJXjmqlSs=
X-Google-Smtp-Source: APiQypIQXM6FBZrukzE/COE0vrk3PPCCVm5W3um2riOPURhHZd3EuV58/3bB6noAnmfvA84ow+uT1Q==
X-Received: by 2002:a17:90a:25c6:: with SMTP id k64mr3443160pje.9.1586273753541;
        Tue, 07 Apr 2020 08:35:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17sm14344127pfd.175.2020.04.07.08.35.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 08:35:52 -0700 (PDT)
Message-ID: <5e8c9dd8.1c69fb81.49c0d.0a16@mx.google.com>
Date:   Tue, 07 Apr 2020 08:35:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-16-g126d7ef13f87
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 87 passed with 2 offline, 4 untried/unknown (v4.4.218-16-g126d7ef13f87)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 87 passed with 2 offline, 4=
 untried/unknown (v4.4.218-16-g126d7ef13f87)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-16-g126d7ef13f87/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-16-g126d7ef13f87/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-16-g126d7ef13f87
Git Commit: 126d7ef13f87cbc604a354cd6a02eccbfa576c7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 12 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
