Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BD919B995
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 02:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732329AbgDBAoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 20:44:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45874 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732146AbgDBAoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 20:44:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id r14so879706pfl.12
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 17:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7DmBW1bAzrJsvERc8PCNHXT33OyiloMj542308vFq5I=;
        b=iEWz+8WHXczmV0N9I+OkO8caaKmtHQKa1vmCSgFC0uYZPrx/BhtebUECnil3QWxgBi
         +1LlRoPpPwgScoSmI81Lh/9Orue6KcZP9ZRcKxjDErDUJOTbtdmNehGiMa6E1FfLE5CO
         2BleWzAUiZ8FkpPV1aLwkYoTVtJOpKyMWsTdACwwonYxmm6GWyApmR6avFwk9VrjP5Uf
         TXesNzwf+gHIJBZvYnLPWxJNUCdhUa8L2oCHiQiAbMSbbLJIIUuavmc2W/hhtJ2lNzzo
         fjL5zv/4aQy2OC5V5v6DWRQ5JKXKFKHLivVE0twCW+q/RvOzp2PjKpxFxds0YmMpeKCW
         5vQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7DmBW1bAzrJsvERc8PCNHXT33OyiloMj542308vFq5I=;
        b=t4QRz5vMY6ksuXDMzsYUcmKTUK3eqRo+8WIFt3xU/wTTOWa6u5LIPCo1QWIRObbcgR
         3NocWcgfKwSvJOWi7GesD6cpniU4ZUTakm8HxaBl5F5odVqOVh7wEZnZEk2dYWFx3yhE
         QWkGpv0oG6Vs8iomcamx2bhLu+dVmgK5wt9+dQqZOTJT/F3JxqNMiyzJ7UmnoOok9i9O
         hUGXmYWKZI2scdplY4lC1O62t/rWHhVuiycVGTD0Pmo/Rr5zSfa6DvEH2IbDhGSSZlQH
         aWQbzVl/Q4N+ziHQK6KY+mfJGMbUptfuJWyWwXxLFLD6NiLuE6nmaeNASiAat01MwHBY
         e4PA==
X-Gm-Message-State: AGi0Pubqe31v7WcVlo+qQIHII+5niGhZnABzciXhQZU/h1L2QXnKK9DZ
        i+aCzrBJgKWlmDWQQ7ls22/vfGrfHS0=
X-Google-Smtp-Source: APiQypLubrSiEETlFhVKLPH5RVGQHkf/L5Hjp3Hxpj5q8Z1mqiQhlggzftpxhrzSM0QnEM0ZlpcecA==
X-Received: by 2002:a62:6141:: with SMTP id v62mr468556pfb.41.1585788253068;
        Wed, 01 Apr 2020 17:44:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i4sm2411150pfq.82.2020.04.01.17.44.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 17:44:12 -0700 (PDT)
Message-ID: <5e85355c.1c69fb81.55d8b.c8df@mx.google.com>
Date:   Wed, 01 Apr 2020 17:44:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.29-28-gc1d6c1dff8f2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 167 boots: 1 failed,
 158 passed with 3 offline, 5 untried/unknown (v5.4.29-28-gc1d6c1dff8f2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 167 boots: 1 failed, 158 passed with 3 offline,=
 5 untried/unknown (v5.4.29-28-gc1d6c1dff8f2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.29-28-gc1d6c1dff8f2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.29-28-gc1d6c1dff8f2/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.29-28-gc1d6c1dff8f2
Git Commit: c1d6c1dff8f20567448ba39841abfe8be3037995
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 26 SoC families, 21 builds out of 199

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 17 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.29)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.29)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v5.4.29)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
