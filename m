Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05519203F
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 05:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgCYEyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 00:54:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46124 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCYEyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 00:54:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id k191so556239pgc.13
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 21:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FE2Cnz8wXkQaW5oZzYWBZ2Rr7NZwUy2tiwTTwoq0XM0=;
        b=p7uXM0Vxurh6moQ1dhs5MXgBgIBI3fLrQmx2K8SCdy/ybPW0YP2N56pV9eQecnZ0oN
         gTxvF5qieihYD6lx2nRqfyPGS8bKUxd9oENsZCvJF8HKtzEK0c3marRubX0qw46HTZsJ
         YE4Fham9qgc5Xvwm+KIS1N1vVqnsg0NcWa0fSq8k1KstnkVR0ATsKajq5Gbxd5cDMX1M
         UgEwI38nfa1ixQiXafai6gnHuXo5zdV2pWuTUYidat7QcZbfAcVWWAvrf/bPPTpZyU5O
         uJIlc7fXuyhrPqXVuIChmi3dMMZueJb3ZK7lTDHNoVuPXBbgd5Gq4oHlgjqTZBd/D+jH
         +kaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FE2Cnz8wXkQaW5oZzYWBZ2Rr7NZwUy2tiwTTwoq0XM0=;
        b=av0+Z/L7QV3+lkYpA0afNA45/x34u9g3wcLRC8aQQBg/mvJyIMGprtw2XKVn72acId
         0lCPD1IGbeBZB8tQw4hq+LUhN75TTl7xRJ+eTT+PmOZrByCTSzzdCY++Wc8h4zm1XrVZ
         QeOqA6cMk6VTTzIdpn7i3shqMPkop+Yoo36u/6fvPI8hD1izVZ78zVbnfoNfMh4Hg0BC
         EndvO122QAzCwk4rZf1O7O3B8LDJ7G8OiPwJakdFsa98pOp3hZTaGAxSuCSKR0SFsldZ
         DZ+t+b9RvRs3ZDiv7DXgPjc2kTkZ8KJiZEFD4Ve7nBDW1UgdE9Cq08ZbK2qBe+TPF8Bn
         QAEw==
X-Gm-Message-State: ANhLgQ1bUGsV2RB9WiqOn6pQvz97GNkmBUN0Vs/bjI4rNaY464YMxK58
        Kg8vbBHP2GP9ST4wdfYtmuz81PNCsms=
X-Google-Smtp-Source: ADFU+vvMjMq7nb84WswQRt9r59UuXudisb5l7T4mHiYXr7T8cWxR6PsDNi93HJjP37bJyhCUYrks3g==
X-Received: by 2002:a05:6a00:2cb:: with SMTP id b11mr1466467pft.42.1585112058342;
        Tue, 24 Mar 2020 21:54:18 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9sm17625856pfl.179.2020.03.24.21.54.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 21:54:17 -0700 (PDT)
Message-ID: <5e7ae3f9.1c69fb81.8105d.5015@mx.google.com>
Date:   Tue, 24 Mar 2020 21:54:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-278-g14bb11f6495f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 162 boots: 2 failed,
 152 passed with 3 offline, 5 untried/unknown (v5.4.25-278-g14bb11f6495f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 162 boots: 2 failed, 152 passed with 3 offline,=
 5 untried/unknown (v5.4.25-278-g14bb11f6495f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-278-g14bb11f6495f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-278-g14bb11f6495f/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-278-g14bb11f6495f
Git Commit: 14bb11f6495febf1ba14babcf03935cc83827808
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 45 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 9 days (last pass: v5.4.25 - firs=
t fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25-269-g7e333f844=
521)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25-269-g7e=
333f844521)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.4.25-269-g7e333f8445=
21)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

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
