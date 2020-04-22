Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DFC1B377B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 08:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgDVGUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 02:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgDVGUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 02:20:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CABDC03C1A6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 23:20:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o10so583983pgb.6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 23:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YvUm4XxUxT6HDptc0TNoMQYnFY/O9iMJSh41WHqCjm4=;
        b=UrnPfP+BBMA/Mkz55THS2Er+q68OkOmWcR4S/F+XmtAzeRRSGYlzVcNWpHjZf3PwtK
         b0AnFm4rEZfDVecTyf3w/Lw9/DW4S9OKAk9zim5ylKSSF+fK4zY30kvuupIIhj+3tMwl
         bQooUiw128kihJNuJWCDoDegWgYyavJ/LmjVmkc/M6H09dcGBowT7oqx4C59p9u1Ko6N
         weLlo7G5idAaKc1HE0yLQ/LGnLMTlcY2KfOQDSXIgXS0jcL5l2ySAR/sV12D3eyQWAax
         3A5fnbgHQ0Ipun0goeiHK8CjijjcBsJTnYuKPaCqUhoLlzJQAOHUetGJcPQSX59R6BLQ
         cMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YvUm4XxUxT6HDptc0TNoMQYnFY/O9iMJSh41WHqCjm4=;
        b=fwTXQNJFH89E6wfBlMIVAym47O0JIdIOhIbB9fJb4xqX8idQAEWBZZXzpxFUo06hCa
         Vb+DWGuV1ylDcQlTD0UUyqvZPuVAt7jgjDw73Nfe0jEcm8VDdw0i4jjkYtEKX+xFN6f6
         Z0OHCFTe0insJu1qMI9bD8BPKyyrY9fXdIPem6q0/NtjyBi78slNiGplzIAARPo/XF4W
         UiifxPCTzaPkBCJaPjRs7rh98qOJlp5mpBvuzcSr12NkrNL0Z8EFpd+cDg56DPXH17rL
         K/PbPIWHTmEm1Hs05CTLG7E/e8ygu8EjYXXI/FTtXrcHr73ksv5UE0dqoExWWWXF4q8u
         jGHw==
X-Gm-Message-State: AGi0PuYuXKzOfVbxLQwyxwUaDEf/UQ9utbiy9ESZY6xF8jLckTW/D4Jw
        NPo3gH1bd9+xTKloitXP3bDZqknlHW4=
X-Google-Smtp-Source: APiQypKhaPlEvq4q16aViDQn8/UaCaNBX31OoY2tAWbWitNt1XtlSTFGV4/xFQi3jJ+mWMlCx5q12Q==
X-Received: by 2002:a62:b501:: with SMTP id y1mr1423549pfe.307.1587536417808;
        Tue, 21 Apr 2020 23:20:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm4433833pfc.15.2020.04.21.23.20.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 23:20:17 -0700 (PDT)
Message-ID: <5e9fe221.1c69fb81.c2c6d.04bd@mx.google.com>
Date:   Tue, 21 Apr 2020 23:20:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.34-32-g913df976b290
Subject: stable-rc/linux-5.4.y boot: 89 boots: 1 failed,
 83 passed with 3 offline, 2 untried/unknown (v5.4.34-32-g913df976b290)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 89 boots: 1 failed, 83 passed with 3 offline, 2=
 untried/unknown (v5.4.34-32-g913df976b290)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.34-32-g913df976b290/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.34-32-g913df976b290/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.34-32-g913df976b290
Git Commit: 913df976b290e0a3267ba98867edda2eb48b7ddb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 20 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.34)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v5.4.34)

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

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
