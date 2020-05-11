Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A188A1CDBA0
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 15:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgEKNpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 09:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729514AbgEKNpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 09:45:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E650C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 06:45:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so7804991pjb.3
        for <stable@vger.kernel.org>; Mon, 11 May 2020 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rYNhrHGj/CY0lAMcC4Ppq6pRDMNIYyW/94EqMTS0rTs=;
        b=DXJODA7/Sor+8nLVC1fBRcTRRSPVNeTdC6Qj84Fn3pHAN6pplHFVovQN9UjWsFvpDn
         2HWXfo1rvuPPVF7lOTrnOEX3yV22ki3LKkQptZu9JAEEmE/RY5oZSBwk+s6Ch1ASI4kD
         e3saZ65cvnYTLcXfDtRHROGhmaCvzN3140cy8nf8JNjvoX5+9NuSzegpAXjf1Vs3f1Xk
         oXg50v4PIbL5P0/73LCJ8hmTyMPGHKnjG4hjm3GvwVyOldjV5A6NzhF1Tj/xTg/hcbML
         vb13cNNRNxzClfKVynt/NLJOcqsa34xUFAJJPrDG1QWrP3B39ErRD5n4NlAZUerrGrPD
         H2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rYNhrHGj/CY0lAMcC4Ppq6pRDMNIYyW/94EqMTS0rTs=;
        b=tsUKUjd7laoCVlU2UPUaj3MTF8u8aJeaniIhPtRM2IGlDR1+gJfqtgejPzygr5y5UY
         ZDilVBeFMcnc6jeguGC5Pi9v2OY/+7A7VdfYi3G4YytiZOwHM8u9DU9MRY4/aZav2JUF
         L6tMRb2URun6Bv9AICHX6jmz687iyXaXB3/Cd0euzFbaB0G22ITTc2x5PtWozZttN+0Y
         Tc4FykBU4kphiPipYCL80QdRRy9wLDfUJpE6+rKii2DK3mW6AwL4v1PsCF61d9GZHnc5
         4E+MftlWyvDmVWzTA3GStjlgl21BFtJUONn0I7zYkM9paUehsPOY7/RIwfkrV2HbU6As
         47Ag==
X-Gm-Message-State: AGi0Puanhe0RgX8YsldTNm97joGKXvyNjq/ZtqnfUWWMUrGfN7Cb6CZj
        x9MB4y9bbuhSULpLFDUm4latGdQE/8A=
X-Google-Smtp-Source: APiQypJOk56CjMFECM6KXGbV/MNnFAc5ZyDTHZY4x3AGBdzAOrlKH+xSE/5IEovuFrgHfSj0WtiWVg==
X-Received: by 2002:a17:90b:374f:: with SMTP id ne15mr22317756pjb.181.1589204732563;
        Mon, 11 May 2020 06:45:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y78sm9356622pfb.127.2020.05.11.06.45.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:45:31 -0700 (PDT)
Message-ID: <5eb956fb.1c69fb81.c49cb.23c1@mx.google.com>
Date:   Mon, 11 May 2020 06:45:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.223
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 106 boots: 1 failed,
 87 passed with 13 offline, 5 untried/unknown (v4.9.223)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 1 failed, 87 passed with 13 offline,=
 5 untried/unknown (v4.9.223)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.223/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.223/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.223
Git Commit: 270f791a316d650f70ff3737eab347088a1bd5f7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 18 SoC families, 19 builds out of 195

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.222-19-g7d=
23d52af97e)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.222-19-g7d=
23d52af97e)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.222-19-g7d=
23d52af97e)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
