Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E621900E4
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 23:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgCWWIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 18:08:31 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50591 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWWIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 18:08:31 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so508607pjb.0
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 15:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FA3EALDo+/NkJV7B2YTEwKLmdeKTH43qCVzoVWIlbcM=;
        b=bTJcOshSIx0u6NSEg4k7s47UztI8aCsRndzQN9ngBfS1GleU1anL9LXJnttttHT3Ws
         6R/B/igxTSEQMW50gVGIEt0QjHnixHJTn1tsItLeEztj2+LUx+EuNIliZ+Q2xfndx+l5
         BwisxjEAsb5Vn1WuFjkG+MCKFT4L22EwCIAnHWpEvEZb5McXkgokWAqXa3M+xSC8CoP3
         3PfsjLisL7bMYtUviLU8xW06+creQ2JU/fUNt13BQNIDsWb4iPEg0uAEsrv4qX0cpmBs
         kuxLVV79GIX2wFGoLK0PuChNk3HRAkib24sXOAzMBDt82BSSXmEvakpdQV7bIPcxm1i7
         YmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FA3EALDo+/NkJV7B2YTEwKLmdeKTH43qCVzoVWIlbcM=;
        b=o3UohwqBL6u8+AjMsY46dQdDkcHFgDJX6Hf7LI1iIrSA4rd3uuTo8GrClpgqbpF4oY
         2LgoXZ6jyLOixK7lH/UDCPmhStvggRZRLTe7Cf0s+K1e0GJMyVsnQ8lsjsQEjsmUPKqk
         hoSGW9k7At+kdTURvu5DbHKrVN8aYBZ2Mvq5o2N2/uTa7cvBW6LQrOgJz/cTLoXBg3qh
         wEKLWXTkhMqHnWviX0wOhqBZ/+yGiSl2JLO0cn3+NCSizONOxW6pGcqWbi4/PlGrevz1
         lh2GfU3R6N4LRreRwk6hJYoBGVRTT3zS5P+emABEZwHgc1+WC4CLnC+Neo+a/HbHFyC+
         RbGQ==
X-Gm-Message-State: ANhLgQ2VHwkiuPPRj87aKH5s0hM0HZ/NEINaqtaP2ddLhLRds9JJ6v5K
        OrD0HDYwjMDlSoeRb1vV5Of782n9m6c=
X-Google-Smtp-Source: ADFU+vtSxUb6UnNZ/MlATJc8mkD/3gwfQrKsUBTx3ppBxJZGSi5kQ2Dhz8N+UKpkQVgHxTI4HRXuAg==
X-Received: by 2002:a17:902:ba8e:: with SMTP id k14mr17740795pls.298.1585001309316;
        Mon, 23 Mar 2020 15:08:29 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q71sm7950998pfc.92.2020.03.23.15.08.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:08:28 -0700 (PDT)
Message-ID: <5e79335c.1c69fb81.7d6c1.e62d@mx.google.com>
Date:   Mon, 23 Mar 2020 15:08:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-120-g87aa7a2e6d25
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 93 boots: 3 failed,
 81 passed with 4 offline, 5 untried/unknown (v4.4.216-120-g87aa7a2e6d25)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 3 failed, 81 passed with 4 offline, 5=
 untried/unknown (v4.4.216-120-g87aa7a2e6d25)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-120-g87aa7a2e6d25/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-120-g87aa7a2e6d25/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-120-g87aa7a2e6d25
Git Commit: 87aa7a2e6d2511e0714bc451e3c8c193f1616695
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-94-g2f=
57fed8dba0)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.216-94-g2f57fed8db=
a0)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-94-g2f=
57fed8dba0)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
