Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735851BEEDF
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 06:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgD3EBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 00:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgD3EBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 00:01:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5710BC035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:01:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so2247403pfv.8
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TCxSYF7H8vAJ/a2TbIWyLS0N80Fm1wL64LDk2KMh3Xg=;
        b=Jsltnm9OJop6gt+ID4miRtfd1t/ol6ud0NTQC3jgOJ3vsRgolW268eRrA9/9OY6QCC
         xxDMDvW9F0XS2Qyh5NqZ7r0aCrdck3kL9wWNtq7HsT9TfbD1ZcxlU4epsXQW9XAk7/3V
         i7y1H7UOz8XxHGUR10chewWRJ7QC4yH/QgPrrvqXPvku/pEKW2yV1d5PObcR0mJYVt2t
         8QtLAuMnPv17jpWSSqK+FmPq2wY954eOPwuTtT++mUfPsNY3jG3OgdssccBQm6mlqU5F
         +lHxW/TvYTX+VzBuzvm9v7O4oUdO6zQUb3XMdriOGOUTm5vlqx5fJ6aXWBg+eaCoSXyD
         5O9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TCxSYF7H8vAJ/a2TbIWyLS0N80Fm1wL64LDk2KMh3Xg=;
        b=a1f/K8Gj8euwpXNiY/Z5tKjcp7u4sodNrsODXG54EaHST0I1KV35KVYYR3ImHuiT0p
         JNnXAkfgjxlFYZlzf7c+zvOJO12gjVIQRMgo45PrkrrzAfL00oz0j9pbWydL1VuV5b+z
         wVB7fpd0jkTQ9bTRiszDPTmsTEPVZC/op7q/SN0EIXFBppncponnvpxDq80FD+6D/018
         kgy21wODd5TS0jXiVJvz3esVSUqr8YG8VsoCFbfeT9ItQv7rqvyOxZJ5KokAFJ1UjycY
         ygB0aH6KU0Tn7MipLawyMrG9SYxM9jCg2rYoG2BqULAd30k6pj5KDft8ncGDeGNHawda
         6yqQ==
X-Gm-Message-State: AGi0PubNRDlUMVW/Q0VuPUigaJ1t89yVZmoiJn5xOmdx2cSTDwlXVCVI
        18J9ESgLefJ0/CBj3ldBL1VvjNmB9vo=
X-Google-Smtp-Source: APiQypJgpbeSdTNEvNbHQV5j9kj+up3NRa0VUSlDmV8VpzBl4SfXjBnvPT7KWPjjgo9+nHiWiamATg==
X-Received: by 2002:a63:dc03:: with SMTP id s3mr1509348pgg.128.1588219273468;
        Wed, 29 Apr 2020 21:01:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm2256397pfl.97.2020.04.29.21.01.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 21:01:12 -0700 (PDT)
Message-ID: <5eaa4d88.1c69fb81.23cb0.8598@mx.google.com>
Date:   Wed, 29 Apr 2020 21:01:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 102 passed with 5 offline, 5 untried/unknown, 2 conflicts (v4.9.220)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 102 passed with 5 offline,=
 5 untried/unknown, 2 conflicts (v4.9.220)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220
Git Commit: 0661b3d6cfd774e28a2e2ba90a3d87479e5c399b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-125-g0=
1b8cf611034)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-125-g0=
1b8cf611034)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.219-84-gd7b7a33b06=
09)

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
