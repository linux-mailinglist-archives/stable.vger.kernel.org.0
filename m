Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795E719B960
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 02:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDBAKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 20:10:07 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37769 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732137AbgDBAKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 20:10:07 -0400
Received: by mail-pj1-f66.google.com with SMTP id k3so783415pjj.2
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 17:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cbQfWTjl5jDQmHs/Af+VRKsZbaD3h+FYCYILZWE9cKU=;
        b=fGlrf1P8tdBKdU2spRTCc4UDYVUrYBG5AdQT/VCmbtnR1lP3ons7LUqEyClZjn3xTT
         EvlpXweGUw2mnVL0j3h6YSU0WKwkFKvb9V0mL38lXt1rDvUVQpSKJUmcRKC/+4zy/7lN
         aVaeJzzq5h3qLle3z/I25HmqvpM/oK4BeS7kMQ1FcUCJSu73aiTtXpEZD/fWJohy2LQi
         kDwTRgtv9FcL+HZwyryQzMDGXTJupXTdT0CSoTmjdwXdzKxFRw9H/EWmid/d94T/oShl
         Nx4pmKUXR3K9nseCP0runz1jymNW5VuGKWDlfecawkf+6TblnZoy86NRtICTzxrGg0Md
         jjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cbQfWTjl5jDQmHs/Af+VRKsZbaD3h+FYCYILZWE9cKU=;
        b=ttj2B4TOFNlWabeCkWoE4CPH1YTB0JMS5usxJ4ufqOCvHwXqMT42EZbzla6rilvOjP
         RT+UgSYSFqzp6dXHRnk355/6+ZEjPTPvMLDRrksyB3X/tcv4UnfUtSecXucbphUdkqBx
         WrIcMIWULwLvrIQiMinRASWaYIhQi6HylKDS5i///pFl9Mw8gEIf6LApjOrojKMfCrHv
         5ZgQw2tudfegLiytWyMseV2cY9B0XqGjR5yJIkmzDgzMeexhxwFN2OgHRkYrQKc8jkeZ
         GLuayNHmTKLl1iqygjAV2P2gwoFY88kgBNOkICwkfyzPeKw5Ce+e3s9rlV6as8w7bFGe
         5ZkA==
X-Gm-Message-State: AGi0PuZRYWCPgUXDkove2bsd5vb/WjkDLBnMPyRKKhlsHQPOt76L2JLG
        fe6npGDfK7UUsHDP+I8nundaaseuOfU=
X-Google-Smtp-Source: APiQypLDU9vSu2KOUO4bA4I76cfCRktvTQus3E5ZlyRFhJQC7ULfKm6e1FT2ZZ5RghPaGcuL+eXUHg==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr667479pjn.119.1585786205623;
        Wed, 01 Apr 2020 17:10:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n30sm2318458pgc.36.2020.04.01.17.10.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 17:10:04 -0700 (PDT)
Message-ID: <5e852d5c.1c69fb81.b2d8e.c391@mx.google.com>
Date:   Wed, 01 Apr 2020 17:10:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113-117-g558d25f4fc65
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 147 boots: 1 failed,
 139 passed with 2 offline, 5 untried/unknown (v4.19.113-117-g558d25f4fc65)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 147 boots: 1 failed, 139 passed with 2 offline=
, 5 untried/unknown (v4.19.113-117-g558d25f4fc65)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.113-117-g558d25f4fc65/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113-117-g558d25f4fc65/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113-117-g558d25f4fc65
Git Commit: 558d25f4fc651a7a3febb5018aa9135178a836db
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 19 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.113)

Boot Failure Detected:

arm:
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
