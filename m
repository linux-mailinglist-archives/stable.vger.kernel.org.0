Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E22D1A3CD3
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgDIXZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 19:25:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46627 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgDIXZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 19:25:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id q3so245884pff.13
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 16:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yLK7IJBNdkmuqsj/SQTNRRh//asLbHXZ1QThzAjFrZ8=;
        b=HLr+i9+Gkt/mcIBlO/TmicJrpibOs2gqMiNkYhgZufgBVfri5gIJWZuZEf1WQ1NZ6E
         5YgfV+XZY2nxSlaZtmY5313gOiYHT0cVnuqsHQj95W8vcy7qKrL85SwiRU1e2ly/nCd4
         kxs8wQcmyqSIuE+gzGvG9X72Ntq2jUaOc91qBvH5j3tePHpBuDT4yFj45WiYcorz8B6I
         o88mE+p+6WuSwIXVZ8Sqr999cb59dGyv2CIxogYeKO8OIAHJ+xP6sYfi/2uuy+PzCwXm
         fxkA3fgnxQJzHhuP5u6IAZLl+lXBqFWF+g23TjC2qL5LBsGJpR9WT0/JkbjxSyBF/mEe
         Hfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yLK7IJBNdkmuqsj/SQTNRRh//asLbHXZ1QThzAjFrZ8=;
        b=GyXcc03MoaqXYwxEnUyEGen4+DwquYepCexW23yZRtJc66SLkiqUMnydKqgvbIa2Fd
         Q60dlGZV9fNuEBU/XQhrAjXb6ja5WbhIL/WI+Ds83cb6MAuAbmW4zVVoAnKhfMDlXK13
         OVMqAZw5r8s/2H++DMWo+p92Agna+L9J8/v+F+DI9UPDQlg/gKxvxqaYY4V8F0Q9riqO
         2aEHeTdumtUYDqbr/o/JyxWThpA7KBZzzMY18/PbU3LBelTMGGoRRFVR/Yamyl+fHwH+
         am4ZPoHj/bISp6bCWM36ZbwxWw+7dE7ymGumVkNuL0NKf4IrBW3hAxuZtVtt123ygJgU
         0v4A==
X-Gm-Message-State: AGi0PubmVgP2AoygSPH9/RTOlgyEmRmseePZu/KdBqyvNOEsZBc1OhiD
        rvOe828X7MD9Zj7kGD1F2/+3NifL98s=
X-Google-Smtp-Source: APiQypKXrY7KJHT7fjWoolzLpuC88eFFgEIVXTuk/DKzCY6wNYfrqhQ8FhMT2ytzPYGTqFJAQoHgPQ==
X-Received: by 2002:a63:c409:: with SMTP id h9mr1834995pgd.251.1586474750622;
        Thu, 09 Apr 2020 16:25:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm193647pgz.0.2020.04.09.16.25.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 16:25:49 -0700 (PDT)
Message-ID: <5e8faefd.1c69fb81.9adb5.0b04@mx.google.com>
Date:   Thu, 09 Apr 2020 16:25:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-35-g7ec457f57a75
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 144 boots: 2 failed,
 133 passed with 3 offline, 6 untried/unknown (v4.19.114-35-g7ec457f57a75)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 2 failed, 133 passed with 3 offline=
, 6 untried/unknown (v4.19.114-35-g7ec457f57a75)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-35-g7ec457f57a75/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-35-g7ec457f57a75/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-35-g7ec457f57a75
Git Commit: 7ec457f57a7540c70239b0935c3db02324cae4e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 61 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 27 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.114-29-g4b947bfa2cb=
a)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-29-g4b947bfa=
2cba)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-29-g4=
b947bfa2cba)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
