Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2FC18794A
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 06:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgCQFjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 01:39:47 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52419 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQFjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 01:39:46 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so2592115pjb.2
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 22:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OJkjW36K/LCcu8LovLDrCsw6HjzetW8GFZhkfeQlR7M=;
        b=WD+3cpYLrrOiaZHW/zLcM0TUxLWV//RKZEhCms+yL6Ne/Bqa/0+eFHGY6hoziTlo+l
         JWiC4SzzxrgoVAlksnu2kk0h4Qvn5vtjJwM9RJAMtfL5Vl5i6hhyDzUuBZdBaKe/dYa8
         lcpEISrWE079SQkPeRM3lOog1evxSRPvIi+Wo1jOLCeyM+TAFbqrCKJmuEk+nu3WiLWB
         6QMCAJ0vPPeIzdFyt4XWXCMSFMGIRKHAKqgniIxwFTZjDxF6oA0m6PBAjLiQoDacWu6v
         9BFX4Yd/Te5GtyNBW7/Jxl9GjA6/XjnrG8PMVgIqHi7Lf161yOKUAM+rNSsxJg+52QSh
         vGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OJkjW36K/LCcu8LovLDrCsw6HjzetW8GFZhkfeQlR7M=;
        b=Z7mLuYJUdy++pgF3fLA7cUMErMClfMqr7dl2Y78CFOzqAfGIAGYokFtO/JwEoFfbjI
         NeTRXkUtbeBRiIAtZy7Vl9Z4JkVV7XqMAlhE2bZROkxnkqMGAP+ks6ksyuXR998Debf8
         Bcx/XoiTEzonNPtvh7ig/A9uwUan8gWjljUx1wX/xZoaHwFicYIaSZeFX5oyx0l4c0Iw
         b9ovd/8KYd6Z6k5Eu53GggHp9OW8WuTXRz4BWqZceQe6Cvx6d3U4rNDRrljBNJbMhcv4
         9OgapAWEiUWe8mUu/J2T8EA6Zg67RDZFvrUlw26xdoYeQpfQxjpAn++tBdg6G4+ykQhi
         tkXA==
X-Gm-Message-State: ANhLgQ03gO2QdXobUaeOzv/2qFjvO2WTK2/AVyDQXTJsDF2AU6v3Xq7K
        bHt6GRQQd6B4FlVUboq94NT03hib6D0=
X-Google-Smtp-Source: ADFU+vvH6ZpNUv5SbiM2Q29a5NElydCjrpS8ZyEz0OD/aoesy1Si6sXxuzQXmv8uoruSiODX2jABhg==
X-Received: by 2002:a17:902:9a4c:: with SMTP id x12mr2567179plv.297.1584423585325;
        Mon, 16 Mar 2020 22:39:45 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm1590794pfp.67.2020.03.16.22.39.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 22:39:44 -0700 (PDT)
Message-ID: <5e7062a0.1c69fb81.5b93a.7cb8@mx.google.com>
Date:   Mon, 16 Mar 2020 22:39:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-124-gf8af896ae672
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 164 boots: 2 failed,
 151 passed with 5 offline, 5 untried/unknown,
 1 conflict (v5.4.25-124-gf8af896ae672)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 2 failed, 151 passed with 5 offline,=
 5 untried/unknown, 1 conflict (v5.4.25-124-gf8af896ae672)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-124-gf8af896ae672/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-124-gf8af896ae672/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-124-gf8af896ae672
Git Commit: f8af896ae672995341393642d3228ced9a8b2aa2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 37 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 1 day (last pass: v5.4.25 - first=
 fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25-58-gc72f49ecd8=
7b)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 1 day (last pass: v5.4.25 - first=
 fail: v5.4.25-58-gc72f49ecd87b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25-58-gc72=
f49ecd87b)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.25-58-gc72f49ecd87=
b)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.4.25-58-gc72f49ecd87=
b)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
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
