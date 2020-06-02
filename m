Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678171EC47E
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 23:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBVo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBVo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 17:44:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3ECC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 14:44:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a4so82681pfo.4
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 14:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KodSx0XniRgUbVvwPJOZ7iPpDmMK1qlxlcCqkUZRZ8Q=;
        b=bT8mvA2hYRkxPxwpomQvn3GbZkNr3Bt96OsRB/UuM08nwKlN/yhKnohi0DbcL/vDwE
         Oj//JAFR0T6/LyJyO2OZnHXSUJMwSYEek2oCEZN5vtC/H338S0fKr1kIVBXvowg4dhrq
         BjifPsEBOcn9GDd7mWoXqpcBYRgjuXa8O8GXniCfd4W3+Pry1X1wsOrigNb/wu+dM+pe
         Kea2VagPLfW/n0XxJDNfZ7nnkH/UukwPdU0kVaQtjAyzOrWJxZ0R7sJ368HBfumy1rUx
         7Vd/aTJBBHeOrXod5XfW3EzDRGLFhFquzYYQkZtUotPUZD4VvctpbB+J/FUSOnXCXdm1
         cYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KodSx0XniRgUbVvwPJOZ7iPpDmMK1qlxlcCqkUZRZ8Q=;
        b=XwPhS7aGUt2VoMf9T0mMV7cbvcKf6B20xEmh9ml9IN4IsOb7/3qxSVtnmtgo8ZVDBk
         8tyVZHmcMDbhJ1p3TrGS9N/kijME1NkQpkoeI2TasuTB5MweEd+vcw7HV2d0CzcykhYW
         t7gaYriW3RHIH19SBU2gDW73aA0uzx5PAqcmfNoLDAEEOxmHRUSEM2w6cP9GuesjJFOe
         qms3GhBX0+Ex4RmNLUb57v9hYFnlwfzQGQIauqw90Ig5pp4r7PTAq/7FOWrkPvRA0wTG
         pbpcUgFtMOG83ibABDZ5IwZQxgG7a/+ev9JviN5Q1jAV3AMr1UdjamxCt0t45Szba+hY
         +u9Q==
X-Gm-Message-State: AOAM531lDQ5ksEdggDpMwq6IHl2uDAHIOg1Ct8ugWCpdKIDeUH0BBU/u
        ffRfax2rWjX26Izs+yfxKsX7ZPDcs7E=
X-Google-Smtp-Source: ABdhPJzgvlheZaQ9ZLmFiC4LgiH2RHe9459dh8OhUEjKAWueKPX1PfWHbuBoIQ6K33jaaJVXyXiYtg==
X-Received: by 2002:a17:90b:28d:: with SMTP id az13mr1437458pjb.67.1591134298306;
        Tue, 02 Jun 2020 14:44:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm1150pjz.44.2020.06.02.14.44.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 14:44:57 -0700 (PDT)
Message-ID: <5ed6c859.1c69fb81.dc0c4.0019@mx.google.com>
Date:   Tue, 02 Jun 2020 14:44:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.43-140-gf5694d7c427e
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 66 boots: 1 failed,
 62 passed with 3 untried/unknown (v5.4.43-140-gf5694d7c427e)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.43-1=
40-gf5694d7c427e/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 66 boots: 1 failed, 62 passed with 3 untried/un=
known (v5.4.43-140-gf5694d7c427e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.43-140-gf5694d7c427e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.43-140-gf5694d7c427e/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.43-140-gf5694d7c427e
Git Commit: f5694d7c427e7134b05b816e56fc41c191c4782b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 12 SoC families, 11 builds out of 162

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 55 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.43-143-g1fd4226c4f=
e1)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
