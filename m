Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525AB2A8CB5
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 03:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgKFCYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 21:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFCYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 21:24:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3830C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 18:24:35 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r10so2760018pgb.10
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 18:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v1bp7IumCcTypPKjGfAV5P0ELWCf7GRsS5fYl1g+WoI=;
        b=K4G0pfrZquoLBXIvGW6hwvjGOYwn2Kl2+n6vuGHf4O5DWlcnML5JKeCiAhMJFAxv5I
         8hjO7rqWM6A+BqmslGb1YE3BnLjwugyxgKD98pCsUGGyBPen/uYzhDpplAR7Rim4I1Nd
         Rh75XhJ4XCP12ovmmkO5iDsFdYM9ufsrBQoRDDirhkX/scL+aPNxGa+b0/ZTJYewylaJ
         51Qt/7O6QOvtna4OSLnJyK7qhlgDlD9JxINDH5Jho2ZCja7j6IividV5FYIyZCAuFIVB
         7qC292WsuSkbOOoy74xAku2Z6HBnKvCV2HVI1gFIKS9Cbrv+cI4NQ3ivR93sqrqLSu9P
         rPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v1bp7IumCcTypPKjGfAV5P0ELWCf7GRsS5fYl1g+WoI=;
        b=l2ybpqRtxAxpVJFvUg8mWIZ04dmT2LKmDVfGenzeZKyp4hNiQm/BoTlkgDjWUcfwMB
         NWNwYFGWkIN+MEIYqXG0BVKGS5Tp0iQ1dkk9fj2xEkdkWnwKPNIV7FFuyCdsdvsdsPMh
         NqBNtYE9TTD8uG4mijtdGje9rLoqY0F33jDr4mwq+j12hU0LQ67v/yd8am/Yh7jTnoB4
         nLHSY6YACsealLeRAll/eJAiMc80ZuI2/y88VjykRHCsZSVqrIaOiWUw3dgSRwJTA32x
         zVnHbJKpQASOB2VyEodViuRmqRq+pmpmQ+nu2SQ8Qo7rwK2zcqofAU6yuyDM3Ue6yruR
         0kbQ==
X-Gm-Message-State: AOAM5334a0lMBGturq4KyI1+IRpaob08OyPPSr4rGRavg+aqZWyrbA3z
        yYwNhjJ+PpF3+98JA8dtatLiWEAdCRXcNw==
X-Google-Smtp-Source: ABdhPJxojo99aMP0oIRkOi5cdGiIxtn6ZCFyhoKVR9eJOn+C0NPM5SPuW0BuMC/FgLJtOtsBw957kw==
X-Received: by 2002:a63:d40f:: with SMTP id a15mr4961373pgh.143.1604629475087;
        Thu, 05 Nov 2020 18:24:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 23sm3960004pfx.210.2020.11.05.18.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 18:24:33 -0800 (PST)
Message-ID: <5fa4b3e1.1c69fb81.65167.8435@mx.google.com>
Date:   Thu, 05 Nov 2020 18:24:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-8-g388c3f1e122db
Subject: stable-rc/queue/5.4 baseline: 200 runs,
 4 regressions (v5.4.75-8-g388c3f1e122db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 200 runs, 4 regressions (v5.4.75-8-g388c3f1e1=
22db)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

meson-gxm-q200        | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 2          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-8-g388c3f1e122db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-8-g388c3f1e122db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      388c3f1e122db4707c9cf76f9dcf77d8788c0d75 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa47e1d05a9d7c1d8db8857

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa47e1d05a9d7c1d8db8=
858
        failing since 7 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
meson-gxm-q200        | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 2          =


  Details:     https://kernelci.org/test/plan/id/5fa49779a626890364db8872

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fa4977aa626890=
364db8876
        new failure (last pass: v5.4.75-3-g2c2cf8e6c77dd)
        11 lines

    2020-11-06 00:23:16.894000+00:00  kern  :alert : Mem abort info:
    2020-11-06 00:23:16.894000+00:00  kern  :alert :   ESR =3D 0x96000006
    2020-11-06 00:23:16.932000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2020-11-06 00:23:16.932000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-11-06 00:23:16.933000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-11-06 00:23:16.933000+00:00  kern  :alert : Data abort info:
    2020-11-06 00:23:16.934000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000006
    2020-11-06 00:23:16.934000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2020-11-06 00:23:16.935000+00:00  kern  :alert : user pgtable: 4k pages=
, 48-bit VAs, pgdp=3D0000000068132000
    2020-11-06 00:23:16.936000+00:00  kern  :alert : [0000000000000028] pgd=
=3D000000006811c003, pud=3D000000006811d003, pmd=3D0000000000000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa4977aa626890=
364db8877
        new failure (last pass: v5.4.75-3-g2c2cf8e6c77dd)
        2 lines

    2020-11-06 00:23:16.969000+00:00  kern  :emerg : Code: aa0003f3 eb01005=
f 540009c1 aa0003e1 (f9401403)    =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa483d9fc291e001bdb8864

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-8-=
g388c3f1e122db/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa483d9fc291e001bdb8=
865
        failing since 10 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
