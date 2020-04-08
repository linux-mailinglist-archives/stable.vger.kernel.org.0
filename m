Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F09D1A195B
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 02:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHA6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 20:58:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33398 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgDHA6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 20:58:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id c138so2273156pfc.0
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 17:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3lALvOTB8/ikgxtkmVBJzkLFK0q/rVFd0/XWXQpupLU=;
        b=l69FOkBNBX4OVCjpYwQc2RqdIhT2T155M2wppjBPv4Lf8PQkEIbZ3dRdoRwGjWk34a
         +vNVe+aO7ZFEubm48wldQqFSUbfZBvVHRZC8JCtZ2nATd0JHLlxL36GOqRSDcreKaXY3
         BNoYrv9QT2AZA2B7dpwvtRy+LtpfRqqYWovBygaZuQ9ad0q0iyRXCe6uoLQ5zPLzXpSk
         QhJMpud2EbB6xcGUfj3duLJ1ssUOeaEhQDg9ngyTQ5Oa6ol6wVAPArYkQ+NYcloNhICk
         9O1yN73flEJar4MAQABUpHrW3WsY2PeTnvfdt/lk3UJmc5cPyewU5fpN/f6aIO+1nZmP
         Ptbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3lALvOTB8/ikgxtkmVBJzkLFK0q/rVFd0/XWXQpupLU=;
        b=eTGGVH4Z1hHfOBqNzRauRImbsTkl+ioVKVqbi4qYNSBbCPDPPhJXt9bVmrn8SWwV46
         zHDQKgqy0ueqRUy0UwLahml8sPD/SKVCSt4XnWmH72HQfwwU5t0vMfpetmKNjzwiMZDh
         6VFyFXXHTeRCVSOG8/qcghDiSt0G7xWNm77KdLLKezFoStnURmFr+U50lKC4mnFgJTWV
         EE9hljCdQslVdAgFbRMuR+RSguRAP95Mau/MdemVbBkPfpZf7NzKedC/bjakEJV2eMLo
         z40zNvxn7aE/Mul3QPIsrR4VbArifPR6fyqIpaLZOjwa6knsNHJYuiIX46lDG2ewqe3y
         DkJw==
X-Gm-Message-State: AGi0Puatiu65xhyKnEQ1uFQqIyauW20DkGvYvj7/S9T68p0ST7v/qL0f
        2v30DL41KYVi3FEoEli6jtHjyUo4/i8=
X-Google-Smtp-Source: APiQypLIFswWGLUOtOvmHEgsGnT8bz2x0DfQ3otp/iFoIcRTTr/A9AUk0aD+nfeXhqsyuC0GU7W8Jg==
X-Received: by 2002:a62:1a90:: with SMTP id a138mr5333015pfa.320.1586307500406;
        Tue, 07 Apr 2020 17:58:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24sm2711290pji.20.2020.04.07.17.58.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 17:58:19 -0700 (PDT)
Message-ID: <5e8d21ab.1c69fb81.b0bcd.a5fb@mx.google.com>
Date:   Tue, 07 Apr 2020 17:58:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-17-ge3343a706244
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 87 passed with 2 offline, 4 untried/unknown (v4.4.218-17-ge3343a706244)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 87 passed with 2 offline, 4=
 untried/unknown (v4.4.218-17-ge3343a706244)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-17-ge3343a706244/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-17-ge3343a706244/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-17-ge3343a706244
Git Commit: e3343a706244b81d54319c82c3347c66e26f66cc
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
