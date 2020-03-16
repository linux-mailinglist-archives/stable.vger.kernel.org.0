Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4456D186D88
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbgCPOm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:42:27 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53491 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731900AbgCPOm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 10:42:27 -0400
Received: by mail-pj1-f65.google.com with SMTP id l36so8470911pjb.3
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 07:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OkIhqD+YkU4aMTR+ImT8XMXUiynm4xN1KasGdWaf1G8=;
        b=ly2n6ZYfmGtIY5QY7Uey7Sr7CTG6bXUCakfIMsaO5bJ/rF1I+J8zM1MG7vovLrbWtb
         inMq7WzlJyLu05LmhRTIIvXTEnfk7a2Bbsn1whgMhCogPVNkVOw30os3U0LVYQJ8AMYJ
         icgR7O5cplQFqiy4sOnLYo2ZIXL25X0yyEH4i3ZD0WoY4glpm/DXroA6DI6nU6IWcwFu
         78wo/bZjX8qyAY8FeUgxk47urw+lhSFBM7rhd0OBJjX6usYWYjQovjWld4axyt3b0ZRi
         WxC7fgtG0F2LpJBwelVoghdHShkJ9GK94Q1eQ+6dZBMBhx9U8maNZtx5zpXpAAx/GrRc
         PjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OkIhqD+YkU4aMTR+ImT8XMXUiynm4xN1KasGdWaf1G8=;
        b=m9IuMtxaF0bt52zKuz1oXj3vf1wLdKOTeshMcek9pg472/VZzZ4HQSkVf4PAptgCqK
         /ppj6tvmIf2ZpAT/8BDjy6Enji3u3zstycherkWgGyOQKLvOStAqgLQXP4Kx8N3rV6Ch
         BSPiTn6IN+6Yw50WfdDJMNJmlySIhwbfNdeo7ci2eUr1ZtLpgffZuo88bGgVga3JoEZM
         qlu1B+dXp3MEwD5Dkjk9h2qRu4v+ZxAvf8OkbhwNNXFnYPJjdNu9m6jrpbIApFBW2/rK
         yUpkXMpwr27qbzLIV1XLL4gzRKuFV1FfQgf/S0dXKoqMDajYfEhdtcr/kIY0vcleswF9
         rryw==
X-Gm-Message-State: ANhLgQ359NXmujU3HLe5TwfoqLp7fDPKPVqHK3U9qOiOqtMYpt2bvNZJ
        fNqniZ4SGbnBoc2mGguLFRkxHGdEPA4=
X-Google-Smtp-Source: ADFU+vvELTqJFUz8QObjUlGLKLyN6JNBY68mJzqsjBOqpyv4WBoYssWqleNDPk2jeazIOL0kquvHSg==
X-Received: by 2002:a17:90a:da01:: with SMTP id e1mr27074208pjv.100.1584369744682;
        Mon, 16 Mar 2020 07:42:24 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r22sm113403pjo.3.2020.03.16.07.42.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 07:42:23 -0700 (PDT)
Message-ID: <5e6f904f.1c69fb81.a879f.0aa3@mx.google.com>
Date:   Mon, 16 Mar 2020 07:42:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-2-g5bd9ed044815
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 144 boots: 2 failed,
 131 passed with 5 offline, 6 untried/unknown (v4.19.109-2-g5bd9ed044815)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 2 failed, 131 passed with 5 offline=
, 6 untried/unknown (v4.19.109-2-g5bd9ed044815)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-2-g5bd9ed044815/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-2-g5bd9ed044815/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-2-g5bd9ed044815
Git Commit: 5bd9ed0448153fd4e1d6e0c924769216bb2b0f1b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 23 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 3 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-46-g8=
fb46e602a12)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109-46-g8fb46e60=
2a12)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-46-g8=
fb46e602a12)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.109-46-g8fb46e602=
a12)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

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

---
For more info write to <info@kernelci.org>
