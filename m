Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C94B1C0D67
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 06:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgEAE2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 00:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726153AbgEAE2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 00:28:36 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3F9C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 21:28:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c21so3272938plz.4
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 21:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xio1gwjP/d+CReoBKZja1Spx51s5kyddTQQffeL3Dks=;
        b=mO79wol13q41SFQ9a+bq0dmrJnYzSKjPUJD6aDPk9kZOZYzlOaJ/crlfWbDFme8i1O
         7u10/0crkO9sTPdYEy8xlRq6QzvFLY1eXTdk3D4h1UpWd/n55Gab1NlvnKDZLK/gBCt+
         n0ygqVcu5Kgq1C1xqH4mkp5W7BfTFIMLSs1HHkJCqhXI+ol14sTEa6sjowz9rFImHEhB
         6u++o5ECZwS9Nl+UCKGlMKkydImuv+Y4itZRA1w3JgN8uiguTAzP25yesNmXWWF5Fr4R
         cISWbey1br9UDM7eT5WC2n9EkyFgWC1QOPbh9U+en2aytjWTghLEPTF1R8CUjpf3B2c1
         wg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xio1gwjP/d+CReoBKZja1Spx51s5kyddTQQffeL3Dks=;
        b=qwPtpj9b/QnF0WXhgAZqRQ2hj6s+7L0ANnZBz+pxK6cJ3QrfvmcA9tFLFrTNkyyEVG
         foOcada2iTWP4P+rrWYRZca8hkTc6KgE+onGfjksGMnqo9KH0ynBu6WhayDhMSAANC6e
         /KuR0jcmklTgYudUMZLl6ctrHhkge7qAH6If7klTZ4bMp91JvHxpwlzfmjmDw2SEZWC7
         dBSosRgK3U5RClIMk5Tk03yBI0AOf3lsEUUqzwNM8qfDji2R+h8W14F1fPtqI8/5hJRL
         k+S9LEIXfsRW8bsqe+f++liSP7DdgHuqw8AeGn+i/PpCNEKVg3ZDTWJNOCoy6k+GSwm1
         0glA==
X-Gm-Message-State: AGi0PuYwgwVEUAniWoqRHFPT0xJl4U2eTXwjBDexKyzu2JHG1Du0vlmi
        4y5iMQ9XfwwNTa/Uu9so0Mw89WM87Mo=
X-Google-Smtp-Source: APiQypKVGtF3AkJw9+pUnMzxhtwp/svI6SePbOqyEfP69eSbXkfvAe8ygdh5oXOii9CxUWSd5Uybow==
X-Received: by 2002:a17:902:c40b:: with SMTP id k11mr2460841plk.50.1588307316027;
        Thu, 30 Apr 2020 21:28:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l63sm1033979pga.24.2020.04.30.21.28.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 21:28:35 -0700 (PDT)
Message-ID: <5eaba573.1c69fb81.20692.582a@mx.google.com>
Date:   Thu, 30 Apr 2020 21:28:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.119-27-gf142d35ff6ac
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 121 boots: 1 failed,
 110 passed with 8 offline, 2 untried/unknown (v4.19.119-27-gf142d35ff6ac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 121 boots: 1 failed, 110 passed with 8 offline=
, 2 untried/unknown (v4.19.119-27-gf142d35ff6ac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.119-27-gf142d35ff6ac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.119-27-gf142d35ff6ac/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.119-27-gf142d35ff6ac
Git Commit: f142d35ff6ac935dfc73eef04abee476beaf8683
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.119)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.119)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 82 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 48 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.119)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

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

---
For more info write to <info@kernelci.org>
