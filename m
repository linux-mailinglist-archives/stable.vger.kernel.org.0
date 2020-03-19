Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33D18C038
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 20:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCSTVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 15:21:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40461 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCSTVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 15:21:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so1931823pfl.7
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 12:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/ymKDH7CZCve9UsDBEe/7CiEzwke9ig66yjeBa7Ak2U=;
        b=q7V796l4eLF3RRBPIjfUn5JLPZ24ujbrKg6DsYmExxT+AeSPnjDWFen9cCC7FJv9OF
         KV2o8Lg0m1yTABl4G4AojQ29f3J5ODIvNC6PbItoTuhDhorOppWBppvDQ87evwiG1qQB
         Y3wLWbjxcsEJjiyCA27Z4VeMBbuTsKHFGuqeH5mmejHw5dsSEOTif7HBLgsiRwieG78E
         nGheJLKGK7voqJMKrNM9eioCP0H7eDaUTELQuirMdjyaM0Hz8HkJHz0McGXl8pccL4CD
         +6chnV1cFrM5uTuwbx58eGup8FeGYq08I5i7Bgtwj+UlaknhY6dN2i9WXIxuMOpjAg/P
         0ttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/ymKDH7CZCve9UsDBEe/7CiEzwke9ig66yjeBa7Ak2U=;
        b=AAV7q9gVrJllouikUo9KK8YeXnP//uvanjDgXp5P0BlE6Q/Q4lCMZw6i9Kt6nir8QE
         atCww+0HLcGbhys3vOomsDw8t4yfNVfg/WlVrW/E05YdI2YBtyWMwhkSvZx6DZNIv8hr
         HczHEITPl7MNJ62Ex/O5EjMZL3X8TaKGH5TRXfmoMkxV5pWUGj9zKeFu6iqAG8qZbnAO
         9Xks+1499rYcACkN9mlCHVYsRJN65mihpHL1NkS+fqK1ktGlTmYJ1V8buQytKFOphf6K
         iBOXD0bfm3HjMrCUfZJ0hHATr2SPlqIgRabBD8Lr2xEf1MvE/bHMny/XObzjYymHHZxM
         pM0w==
X-Gm-Message-State: ANhLgQ28qrYAU2lIu5YSYdfl1DufjmDbFZqsIUHEKag/fgeuubJpxf/G
        mMn0MkAn43mef3nnxXQMR8owkg/N6tA=
X-Google-Smtp-Source: ADFU+vt85wOo/VbNvYtU201aAFqAOCuV3aqnOf/oWTZgSUGup/YeDD/1owpU7oGCSUwaqErfd7GFxw==
X-Received: by 2002:a63:2356:: with SMTP id u22mr4692784pgm.245.1584645711338;
        Thu, 19 Mar 2020 12:21:51 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm3056803pfp.88.2020.03.19.12.21.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:21:50 -0700 (PDT)
Message-ID: <5e73c64e.1c69fb81.6e746.a3e8@mx.google.com>
Date:   Thu, 19 Mar 2020 12:21:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-100-g5510299b1b08
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 2 failed,
 119 passed with 4 offline, 5 untried/unknown (v4.14.173-100-g5510299b1b08)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 2 failed, 119 passed with 4 offline=
, 5 untried/unknown (v4.14.173-100-g5510299b1b08)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-100-g5510299b1b08/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-100-g5510299b1b08/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-100-g5510299b1b08
Git Commit: 5510299b1b08a51cf5805bd223de3e9453900d9b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-82-ga=
352cfe419d8)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 40 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 28 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-82-ga=
352cfe419d8)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173-82-ga352cfe4=
19d8)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: new failure (last pass: v4.14.173-82-ga352cfe419d=
8)

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
