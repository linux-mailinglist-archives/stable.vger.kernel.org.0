Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B061901D9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 00:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgCWX2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 19:28:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46667 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWX2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 19:28:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so6872580pgc.13
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 16:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sh9CJAoTkQ1db4tBVJ6Aq/9q5qYnV6BQGtpQgOk+HAI=;
        b=EVFxf3Jh3a5bcbXutWQTTSVXcIMlZ6Delkn0TV3FycrXuRFImtGY+bQA5HebE9V/av
         1HPOW3DeP+7Oxs5Vo1ji1sNTvJJVudtaKzjuyUMEfPsiC1fVJUI0yWkd68k++TfSAFxg
         WAMHJ7aZIEFA3/oHZlsj1C48VN6CNuR0zSqCoxQmtRZEgUUqQxU7M0Pn1aQpx/ghvp11
         98FVzWHFj34eh2nXJ/koAHC270v3KbXh8K8sn+hjyk9of9TgKJxVKrPKWyFF4wTV1+v+
         G6fgGIQpGBWXZmchBBlrGD1PzFSk8mUFGh6lW2ECwojzJtbiz0YT23g/Gok3PL4YbCVK
         wXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sh9CJAoTkQ1db4tBVJ6Aq/9q5qYnV6BQGtpQgOk+HAI=;
        b=Kzm5dFR11/y5Uib7dyDdBg633kO/1yJTCFXAcGtVQ2nA/gEkHGzxJN6aJbWlVYn86B
         LqCskN/CX8MBrJ8T72XrkXIxDb7ugjH0PCRYHebO3oSQ5xr5eqI7qvXCQvo3LYIxomnh
         YD8Z6PzMJ5t2MMKDKkDU+HYB6MyxYsubwXAK/u7Ls7gnvkM0jJlQ4q41ZOsNPKAtBvoo
         HLNMg0M0WZjkoXIm0kWf8Ng4bcH18SKg9dRbHbbFcIXMrynSE4gtGe5OgWqtafCXl7S6
         RG0G0x0yk7/yZmmI87ywUoaSaIx0cVkGpEWOxWcNB+kOAS7fzOugkcDmVMCCKyTfb/Ea
         8tBA==
X-Gm-Message-State: ANhLgQ2CDRWeHUT4dv3pncir86YI/IVVmpVveRWL4hcznA8Ng7nD1im9
        hPpUeC8HvpwU5zksY3iesjiqY4yVslk=
X-Google-Smtp-Source: ADFU+vuK4mA8hjT0FibwKx8/921uhQ5gPy/hpZhrSEqwDdUHcdestitb1sPW9/fLNPHOhCtfcJQtkw==
X-Received: by 2002:aa7:9af8:: with SMTP id y24mr27654158pfp.91.1585006103327;
        Mon, 23 Mar 2020 16:28:23 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f68sm621618pje.0.2020.03.23.16.28.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 16:28:22 -0700 (PDT)
Message-ID: <5e794616.1c69fb81.40251.2e3f@mx.google.com>
Date:   Mon, 23 Mar 2020 16:28:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-119-gde70109aa333
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 110 boots: 1 failed,
 99 passed with 5 offline, 5 untried/unknown (v4.9.216-119-gde70109aa333)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 1 failed, 99 passed with 5 offline, =
5 untried/unknown (v4.9.216-119-gde70109aa333)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-119-gde70109aa333/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-119-gde70109aa333/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-119-gde70109aa333
Git Commit: de70109aa333201f221fd033e5d9fe7bf280c5ad
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 19 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-91-g81=
30ba7a9b6d)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-91-g81=
30ba7a9b6d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.216-91-g8130ba7a9=
b6d)

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
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6q-wandboard: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
