Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECDD1A08DE
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDGIFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 04:05:21 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43428 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgDGIFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 04:05:21 -0400
Received: by mail-pl1-f193.google.com with SMTP id v23so923525ply.10
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 01:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/BE4AOSscLgJPg2Br1M/s4mZwn7m8VyhaJ6dDfuptIA=;
        b=aOah+tn6yOdohAo8qqMOKHU4+5GLmFMuwWs/wA3TniqKhW5s93fw/fMYYJoDncuCNm
         mAKkosXtUSYXpuCHe0624ejLt7wwwrNOaQOSERRtRueDKxUQCJ84es4t40Klgx6BoClQ
         nvK/HncD4+6PqUY8ckndA8Lo3+7ZThAWtdT74J1EW6oUmLhBjkHQc5v5obJcJSbq25RD
         3Ydxk+GTCd+f72EqQTVVv9EwnMSyVqwr6bovP1cydAj3diht5eELumpQaEBPXVSSSHKJ
         qjURUxMVes9+IzjLNu9lzlOknYWnoc1f7yrIrVE85yWoX6qG9DSNWJnmw94cKgDH2DNr
         RSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/BE4AOSscLgJPg2Br1M/s4mZwn7m8VyhaJ6dDfuptIA=;
        b=NPXD/a8idH+DhkibIK3Jw42la6Il90S9+JO0OH5O2giwhsCnwymB5zhBn5L1Gv4YgI
         S+UTg7XAFmFau/4mnwMsKdryop1B5uZGLp6DOTqzRR3iwSqyOsylD6J3DOeQGCfd3hME
         MJoMB+iEfmPVNu4/VTJvE7pUdzkLhU2iwQuuxQbBqKUYV1JN3PwHCbfi/UMmKns07OQN
         z04wDM6LvDbjw/qMUcTH4DL5pEelBNwz+/QmYA+Jdn6WweRO8bIDJdVWBTjjlzAGf0lV
         GzZAw9Rf9rBoofF6FFc3FLGHRR7TOx9DUmi1x6eQk4GrackeQVsZ9Aa0+eX27RnssChr
         OmgQ==
X-Gm-Message-State: AGi0PuaSjQMCzdJTwN+hAcGfajuVl5pNjghsEBSwllKpFqD739Nj9pbc
        IgK/lr07lU6wTumeKudA+it4ERP42Pw=
X-Google-Smtp-Source: APiQypKr1I31VtisUgv0nKPW+/FQPKnFeTziJqmciA48DMe4T3d+6cVcnCxPyA5CPgqt+6+4ZC5YZA==
X-Received: by 2002:a17:90b:3ca:: with SMTP id go10mr1360067pjb.9.1586246719768;
        Tue, 07 Apr 2020 01:05:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm13396437pfb.31.2020.04.07.01.05.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 01:05:19 -0700 (PDT)
Message-ID: <5e8c343f.1c69fb81.86d58.f4ac@mx.google.com>
Date:   Tue, 07 Apr 2020 01:05:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-26-g701bb843eab1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 167 boots: 2 failed,
 155 passed with 3 offline, 6 untried/unknown,
 1 conflict (v5.4.30-26-g701bb843eab1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 167 boots: 2 failed, 155 passed with 3 offline,=
 6 untried/unknown, 1 conflict (v5.4.30-26-g701bb843eab1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-26-g701bb843eab1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-26-g701bb843eab1/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-26-g701bb843eab1
Git Commit: 701bb843eab1df5a772c77bdea640339247ce93a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 103 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.30-15-g3db2f4cba70=
e)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 58 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 22 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-15-g3db=
2f4cba70e)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.30-15-g3db2f4cba70=
e)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.4.30-15-g3db2f4cba70=
e)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
