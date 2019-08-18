Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE19163E
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRKwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 06:52:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42482 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRKwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 06:52:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so5727050wrq.9
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 03:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C/luYUauKvaYo8wF+x1D66trQUUl8495oWoYRSVsjtg=;
        b=BFAwhArTBGgd4449G7H+h5H9Snw2BrR3AQEDEl7IHIT1Dm4lTnrmH7y2R5DpmnR9sI
         s6ouFSvqOQHxoSclSKUg+Mn/adIu7HclWbEFORTpgXDBO+bkmeqlvkVbVnOXhy6Tjuxu
         XfliD5ArJXj4aT9367Ns44vniIAvb3gQ2HT7ptS71psfZNI/lfY8ouBuS1dKa5F9A5JJ
         g252wYAW03pNwJ5qbtAxrFmwO6uOVlMrA74xWljh3rvrMQv5E1nRr6FZYHTDypQZzRdj
         io4m4IwS5FIKoSWs4BClk/VxEX162ZxPMeIO78Pt4AdH3ECNS0mb3pAeWpi88thWTvEt
         mYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C/luYUauKvaYo8wF+x1D66trQUUl8495oWoYRSVsjtg=;
        b=J/Nq1qcOo3OzjyzCsDnSTFznALVKNrg3N4I5uGzg5C4KKRsAIgvnKUTftOq0bv9jFj
         w4x5hKLxHx+WZHZ4o56irVpb7zlBaPpLPrW88HZex6cRyrwjvh/xM1JW6aiRdfKERPq2
         e7a6xTUMqKUtSM6E+hTkaw4XCTyedJVTmKag/koti6U4HuzW1QnFwxGAZzAr8cFoBokq
         eUe1+hKTo4uooHFfmcaruF8kbZJ3dfY40fSHdJD8Gq2kmbhRdg1WQE8rFh8ULHyk4Mb1
         wVmlURcRodfEpmJpysOVjDDoaCQ2tWarxo3wrCL+icGTgepfm5AjqRXoCqWpx5duoh6I
         c/ZA==
X-Gm-Message-State: APjAAAV+VaddYD/bLeHP0MNltFGwIVBAxpmNMmDplBEDgdifFOdIlVI7
        8IEFzLbnPM2bUi/hvkr5yADdwMHcfoo=
X-Google-Smtp-Source: APXvYqyd7IG4ne9ZtqxkvJf1fOAZq3ciT0UAMmZIOJA4E9o8XoJe1ISzdIxhTAIdTXY9cMX7RQ0Y3Q==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr12221706wrp.189.1566125554751;
        Sun, 18 Aug 2019 03:52:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a17sm11820024wmm.47.2019.08.18.03.52.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 03:52:34 -0700 (PDT)
Message-ID: <5d592df2.1c69fb81.fa079.95cb@mx.google.com>
Date:   Sun, 18 Aug 2019 03:52:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-45-g244e47df71ff
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 95 boots: 4 failed,
 76 passed with 12 offline, 1 untried/unknown,
 2 conflicts (v4.4.189-45-g244e47df71ff)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 4 failed, 76 passed with 12 offline, =
1 untried/unknown, 2 conflicts (v4.4.189-45-g244e47df71ff)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-45-g244e47df71ff/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-45-g244e47df71ff/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-45-g244e47df71ff
Git Commit: 244e47df71ffd95fa811d8683c50198866e8286e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 189

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-35-ge6=
790d05646d)

    multi_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.4.189-35-ge6790d0=
5646d)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-35-ge6=
790d05646d)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
