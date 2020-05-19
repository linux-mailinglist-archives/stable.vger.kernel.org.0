Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043541D917D
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgESHzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgESHzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:55:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993D6C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:55:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q8so4338826pfu.5
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=00JBw1Ae7tDCaV7yPPb0emiluWML4/TciTnTWTQkwwQ=;
        b=1s98L/4sUzqxp046objJAZfEh3PzLFKFdeNO8lyp2tBfKAtkQrKh3imvD9e5NXzlDp
         ssuSOUrAB/42+kU6r0XVVBLN7tFJzeW0a/9odKYfLJS2OqADpBDoflChSfRQeEJUkOUy
         VOzpL/1kaKv1649jZQIU9IrBfsk/sT4oNFEIULkkcSu+J0NNOWl4awhCWSP2rsUCtIe6
         +NgBZi8GVGwS4shtPH1V+i2JCWKQss+em38BhmauTSabG28DwcEx+uzyOfjwGhaqCjtU
         LhCCOspQOvR5WHJOz6A4vPPmdv98U/3sngTXW9J3vSpMUTIAY9+3VH3EvH6n0dBybW9T
         ylaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=00JBw1Ae7tDCaV7yPPb0emiluWML4/TciTnTWTQkwwQ=;
        b=T2gU/7aGEDAQ1AWn2OHGCmd4O6qaV1RU1xs+Kt/4N3jgSw09aSWpSX+G+x4qegAGzj
         xCfIE2GcieLFrhvJhCoOjLoSf6XIHBwjBt3gh5cPq7n5ZngwKoAKp5EU1wg3kC6IradV
         MVqAm+ZTZ8snHDISlpvox3wnGOM6sCK+NWAa6yurJOFWYzxahS7D4QmmIXtT38HQWMP6
         AbZ56i0QE6iZdUsBG2GJozpWfHJ4WIj55mQLxO/YC/50gMUiZ6kaZLQOD4hzqqixRyGd
         1peyiTrmJZFyJuYQeFSLrfq615xbPnP4qfnAexfTJO/k83XxiscdoyCt8i1rHW8vabFw
         gLxg==
X-Gm-Message-State: AOAM533y2uknM0yCBYBR4mOIqk695zLuunY7TnnHho2XfmClSDKj4H27
        dVvx1AFr6ImFW+mb47BBwinRx/xDzAk=
X-Google-Smtp-Source: ABdhPJxntt35VUYfbUsV17dyySu0o4gPLgU0/pJfO8G6zvsG+xD1cGhKrlYaRQIlxppzWBkFv3CX3A==
X-Received: by 2002:a63:d918:: with SMTP id r24mr3377210pgg.119.1589874934716;
        Tue, 19 May 2020 00:55:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o190sm10664362pfb.178.2020.05.19.00.55.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:55:33 -0700 (PDT)
Message-ID: <5ec390f5.1c69fb81.700e5.d938@mx.google.com>
Date:   Tue, 19 May 2020 00:55:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.41-148-gcac6eb2794c8
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 138 boots: 1 failed,
 129 passed with 5 offline, 3 untried/unknown (v5.4.41-148-gcac6eb2794c8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.41-1=
48-gcac6eb2794c8/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 138 boots: 1 failed, 129 passed with 5 offline,=
 3 untried/unknown (v5.4.41-148-gcac6eb2794c8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.41-148-gcac6eb2794c8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.41-148-gcac6eb2794c8/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.41-148-gcac6eb2794c8
Git Commit: cac6eb2794c85e7777fb0caac6fa75b6364d81a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 93 unique boards, 25 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.41-2-ged1728340b22)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 100 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 41 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.4.41-2-ged1728340b22)

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
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
