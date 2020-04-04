Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8319E29D
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 06:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgDDEGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Apr 2020 00:06:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33349 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgDDEGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Apr 2020 00:06:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so4611938pgo.0
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 21:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vtz65BcbIk9WfZ3jnaekXmmXZqqNdV9Nig+kri06Qy4=;
        b=L2KQn/pKqPivi3HrG0/X5mrrGLTK88HfrNvd1xp2pIPnBDUrj1dOk6ARoFB0khCxqb
         E7B1ot7gHBe4xRbDJOhrxzy2FS686JiI92sn/QStxuLvWqUd/MLQgFMdYBDLKMhis6hl
         PLI3lItolecDK4FDEh1OUAllDGA2YQSi9ydupKF50VQgvy6gQ15CCvhdP2LBoPBM+Cil
         15dBT82MTAvHfmlJI0ewlb+MZecWkz8H+YHwC/jeveAbNYtGCNOGZqSiJziv5/2oYY33
         NdeYmu3kKohS1SjIkCkqThd++Pe+Wsn8xkJROyXBPbhbd+eMkJrGnYgfpPLa0fpBYyHY
         v44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vtz65BcbIk9WfZ3jnaekXmmXZqqNdV9Nig+kri06Qy4=;
        b=i9gmlFHvo/1hXagff22E86F8FFoXJveiuck3WTpErsRlrmpQXjcnCviZLUsC7Oobjh
         NUZAvjz+W3TsWNfgHK0VCItUEVdBZbM/d99Wr6u+RQDBXuM+qiOHJZwTENnblGO+EyU8
         GtmyBMTyUWFrXn652tbAl8ugd3j9iZ2djL6jOsuPuxovr3fbBKsfxOKBWKtFM8n4qK7A
         XrXCbLEm0bG1FtdzRrlAepBecsozxsMtpyR9pqePaFBGrc16SMu0M/RhDPtn/3Or016z
         9WekEYhdY5eSFDGrUSkFVRpsMUQ29GC2uU29xn0Dq1H17OJa41tZUe+Nifg2y6HLOJJh
         XVRw==
X-Gm-Message-State: AGi0Pub58Z+XtCIPiumSplZ3LIlDqr4kD9/vXbZjQEvUlts6NICW6s5q
        LqEKOZ8WdDkQAlbGUlw85EUZ3XhISaE=
X-Google-Smtp-Source: APiQypJ/G0CcFjSmLDdz06Yx0nm3yWAuPP8/lKrRPDCL9jo1/qRuUCBAQIR2eMVtVQjSlHqEct0LtQ==
X-Received: by 2002:a62:880f:: with SMTP id l15mr11519160pfd.218.1585973183410;
        Fri, 03 Apr 2020 21:06:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ck3sm6815259pjb.44.2020.04.03.21.06.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 21:06:22 -0700 (PDT)
Message-ID: <5e8807be.1c69fb81.0c9f.121f@mx.google.com>
Date:   Fri, 03 Apr 2020 21:06:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-5-g1d2188f191be
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 89 passed with 2 offline, 4 untried/unknown (v4.4.218-5-g1d2188f191be)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 89 passed with 2 offline, 4=
 untried/unknown (v4.4.218-5-g1d2188f191be)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-5-g1d2188f191be/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-5-g1d2188f191be/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-5-g1d2188f191be
Git Commit: 1d2188f191be66572f9e20c9486eda0544ab750f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 55 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 8 days (last pass: v4.4.216-127-g=
955137020949 - first fail: v4.4.217)

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
