Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B841519038A
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 03:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCXCZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 22:25:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44476 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgCXCZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 22:25:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so6758162plr.11
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 19:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e7jYyLmeRVbgECxUG3NAI8DtdrWSZKKJq7Xpq49NT6g=;
        b=JiHAWlC+IGwxpVJUEaHsiTZs3xTJv0zKkAG23txGCxAcqcGIq/sy7Pm76Irbu0v+Tr
         +O6QA/aIkFUXDwZRbN8TtA78dPwtBb/Qifh41Cag8gLpv52AutEmELFA0JdRE2MX0tWG
         /czxp2Bze4bqiR4fs1dzwAsyfqr+SXiRUpSUDXBPVhxBxSfj4W+G5o19wN0+ZsIIWiA0
         AJnDWfOhIwRM83TC65O0zLi3aD9DDbVlSXWD9vuD/A/Izbw6VpWLtGvirZCa+E+UEt9A
         1/Yhi3OXcYEV1nCr1nUy9axFrI2EkeGCdSq34WJ55xm1ZlZW8nmU8FU1QXLzY5f52H17
         oTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e7jYyLmeRVbgECxUG3NAI8DtdrWSZKKJq7Xpq49NT6g=;
        b=PQfuACrRQsRV3Am9dumRUFh7e8aJKk7p9+rUb3yj3jKaRXpdVfggurtSe3Kx2Yo8We
         S3uuZPTyLhV7iWZ2WEMAJmyg3F9sdSnCOgiaXCYWOzdaGSuR2ADdUXUX4APvacIzz5eA
         JIHTmjm0Dck2ELWGCpBgrUsE84B9mh/xfu0EGP0nmok+DENoVSt2IgDHLmRC6KbQiRg+
         OhpMFShKPl15WtzAVBrlgRHetDrLzCWXEQoeN2cy+pHwXmC0E3lgCIBsbvFQPwu9Q4HF
         KKARFSNW0k4NDb3X6e80nbPMWaHRjevfKQfwkgF+tNolXB1K43IxIQdosb1HHzE2zme2
         cpwQ==
X-Gm-Message-State: ANhLgQ1wV4d+QokDTYaOFXf9iSAF3/wTDa6Jh2uMbF/7nI6UH4e/f9qY
        k5FHx5k+1W9ei1eniVAEGuB0MuGQS8M=
X-Google-Smtp-Source: ADFU+vugjmPNc1EXt9HW1dyygxRQEnoLeWYiSgz9eGfI0uWRhi6BA0tkLzJxnWdGdHJMMz6Eo2Vfog==
X-Received: by 2002:a17:90a:cc0d:: with SMTP id b13mr2609646pju.115.1585016719125;
        Mon, 23 Mar 2020 19:25:19 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a75sm776022pje.31.2020.03.23.19.25.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 19:25:18 -0700 (PDT)
Message-ID: <5e796f8e.1c69fb81.dbd9.4cc5@mx.google.com>
Date:   Mon, 23 Mar 2020 19:25:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-269-g7e333f844521
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 164 boots: 1 failed,
 155 passed with 3 offline, 5 untried/unknown (v5.4.25-269-g7e333f844521)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 1 failed, 155 passed with 3 offline,=
 5 untried/unknown (v5.4.25-269-g7e333f844521)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-269-g7e333f844521/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-269-g7e333f844521/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-269-g7e333f844521
Git Commit: 7e333f8445216f333bead6e3fddcd9c1089f78dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 8 days (last pass: v5.4.25 - firs=
t fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25-175-ge72abf1f1=
1a9)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25-175-ge7=
2abf1f11a9)

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
