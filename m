Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BBB188A20
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 17:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgCQQY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 12:24:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44407 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgCQQY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 12:24:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id b72so12210442pfb.11
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F0Bg4wHUz1VBBxKaFduOGM1Unvv0a9rIZOoFf4KLM/I=;
        b=zaHIebSoUCksWMfuXRIoxu+VzCG9rFGSW1p9q6drkK6By9cdeXc8ly1oeLyv3WmjLb
         rq/pWdd3bt32UGMJ488scQF735J82bQiLH+DenPurMicblzhkV4pp2Sm+oqA4e5w07ZI
         Eg8SrZjfZDWIPLR0m3gePf3j7BMk4eH67WY6NAVvX1v5/6t750C7+NAYYd1mtLiS+HpU
         3jnyj1y31W2+vD/uGkJHKDcofYcc1f3NuI4deKIke2aKyxzf+JV3CewKqg/LNtgNdoJ/
         BjtarrvmPJqDoZgmwmyE8R1bQ+OBtC4FiFqwU1WOMOnBsXY3cz5CWkLADXoGVPCyda7b
         hjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F0Bg4wHUz1VBBxKaFduOGM1Unvv0a9rIZOoFf4KLM/I=;
        b=op1Dsn5XyI5YpDKm7QCZpLDkeO7cBqhXZvNuhPsa3gatVaeitsBLbcff3c1jN4Sa73
         SVyVx18Bf2E/4uj1VfxyVQcD8sfG9L1sSNzPphZE2kcQSL4gqN9HST0Gt4Cw2DdHQxA5
         jP66PsuvbYgnCJjwknJF69B6XGIIHgkBnbiKfN7nhCiPZbLTOUQwb2fJfRxgFHqgj6wK
         u/i0PGmfcRKBFr/GH8n2X6Wd8ZoXt0sGbbEVQE0u5/6dTCKclcbtNxb7cIUBOO60XxyJ
         aweOS7vish6NOlFOEIvowNQFFTVdn/iMA48E8s+pgOovFUv08ENbw5uvVTCPG9SXNoeK
         e0hQ==
X-Gm-Message-State: ANhLgQ03ORu8VsF2AOKdMJiUbt2YAxunwj26XFn3NVDWXLBpli4SYNcm
        TWYtQHZgcKYaJQ9RQEoZO34AjBJ3QAs=
X-Google-Smtp-Source: ADFU+vsvTVtuXPK9XWyqYFPSVuF8KZXZLW6wT+fLP81POXfSHanJ8gLiDceS3UYwvb0gZgF2QauzNA==
X-Received: by 2002:a63:a601:: with SMTP id t1mr11593pge.23.1584462266834;
        Tue, 17 Mar 2020 09:24:26 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm3712785pfo.148.2020.03.17.09.24.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 09:24:26 -0700 (PDT)
Message-ID: <5e70f9ba.1c69fb81.b8f63.caf7@mx.google.com>
Date:   Tue, 17 Mar 2020 09:24:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-82-ga352cfe419d8
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 132 boots: 2 failed,
 121 passed with 4 offline, 5 untried/unknown (v4.14.173-82-ga352cfe419d8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 2 failed, 121 passed with 4 offline=
, 5 untried/unknown (v4.14.173-82-ga352cfe419d8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-82-ga352cfe419d8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-82-ga352cfe419d8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-82-ga352cfe419d8
Git Commit: a352cfe419d810ee9cde52d37c6c8b1cbafb6803
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 38 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 26 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173-67-gd37b117e=
1ccf)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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

---
For more info write to <info@kernelci.org>
