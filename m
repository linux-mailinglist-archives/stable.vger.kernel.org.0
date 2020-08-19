Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4C724A787
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgHSUK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHSUK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:10:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7A3C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:10:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k18so12222255pfp.7
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ozRMkh15tBq0Pfk+Eh+/fMYvGPKfrXMi14ZarXk0veU=;
        b=cGbInAO9HLL/qkDuHWCOhgnotYnGZTMuRoMHcRM/pC5t1zvNEuAQRwVKWIUp8FmIgx
         yaElxJ+WygeQ7b2OSl2V+x+2js8dEXXRKfDpCq0TNf2JAfgs1gs40wrDlMxh9agrCEga
         tCp2Qb2hLNm8xlFc/i/hdGuz1QMG9c+L25jQZYtVu6KsF/efX12pilHGkF3QpuUpVs5T
         bVbOK/akpOIZt+8rrVWm+VDYjkorDQFncOaNylQlVF5OrbSYXnyqZWSm2K5h0rrbo/9D
         T9C4Lwzhz7g0da6WEE2vJH/BnOYvnMVm8EDfIndhiELrccTwX8HCT7eMtj6nRDncjlye
         UYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ozRMkh15tBq0Pfk+Eh+/fMYvGPKfrXMi14ZarXk0veU=;
        b=Ti8VnhQTeMqxr90XERMmvdXwFwuQUD5KBZiZZqntv2XEvzVIlijKg5TXlQUx2WW8Iy
         SdZENRGuILhtLULK2Ztwn9/hU1ucbyvt9lYDiio+UhcojVzrDnb4/53/n7Hhtd6mOd/s
         OlRTvbjKaFtm7NqylA2ByI6F55wct2U5+g0ANVd5HKYoBi/9iZKiAHbTMJu8wm7+a7tc
         CUdMzjM50Pcflt78DlbXThRcF1uQqGkmSi4CucMZDkvSAzs2FF0iGkGsVvhDpTSyXdql
         kFz3lNaYlaUIVB6OIzIE+1/5mF/xEgj1//OrEtkjFh4JGN/8JM5ar9BMnvDPg7nH0xlh
         GuCw==
X-Gm-Message-State: AOAM531mBQwSRoI6z13STQV9lmj6jF8lSqU5eXkHd8M05QdCTL5RmRRd
        5WZyAAEP8CS5fZs0yt7cJ5x1YBayKwdNDg==
X-Google-Smtp-Source: ABdhPJzaz0mpxxlQBLrj+abSVtBtvUHO32MawDArouisbDvd25zEbeg43EB+ztoU0yP/M9Wlv7yPMg==
X-Received: by 2002:aa7:96cf:: with SMTP id h15mr20313639pfq.294.1597867854721;
        Wed, 19 Aug 2020 13:10:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b22sm48379pfb.52.2020.08.19.13.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:10:53 -0700 (PDT)
Message-ID: <5f3d874d.1c69fb81.c5ec5.0237@mx.google.com>
Date:   Wed, 19 Aug 2020 13:10:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.232-134-g2e631f07fd55
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 114 runs,
 2 regressions (v4.4.232-134-g2e631f07fd55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 114 runs, 2 regressions (v4.4.232-134-g2e63=
1f07fd55)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/=
4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-134-g2e631f07fd55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-134-g2e631f07fd55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e631f07fd55892e1fababf1f5c72a56679bbf40 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/=
4    =


  Details:     https://kernelci.org/test/plan/id/5f3d4e5282db7b7651d99a42

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-134-g2e631f07fd55/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-134-g2e631f07fd55/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3d4e5282db7b76=
51d99a44
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-120-g=
11806ba5e43a)
      1 lines

    2020-08-19 16:07:40.302000  /
    2020-08-19 16:07:40.412000   # #
    2020-08-19 16:07:40.414000  =

    2020-08-19 16:07:40.516000  / # #export SHELL=3D/bin/sh
    2020-08-19 16:07:40.518000  =

    2020-08-19 16:07:40.620000  / # export SHELL=3D/bin/sh. /lava-6716/envi=
ronment
    2020-08-19 16:07:40.621000  =

    2020-08-19 16:07:40.723000  / # . /lava-6716/environment/lava-6716/bin/=
lava-test-runner /lava-6716/0
    2020-08-19 16:07:40.726000  =

    2020-08-19 16:07:40.727000  / # /lava-6716/bin/lava-test-runner /lava-6=
716/0
    ... (8 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f3d4e5282db=
7b7651d99a46
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-120-g=
11806ba5e43a)
      28 lines

    2020-08-19 16:07:41.211000  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2020-08-19 16:07:41.217000  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0xcba14218)
    2020-08-19 16:07:41.221000  kern  :emerg : Stack: (0xcba15d10 to 0xcba1=
6000)
    2020-08-19 16:07:41.229000  kern  :emerg : 5d00:                       =
              bf02b8fc bf010b84 cb991810 bf02b988
    2020-08-19 16:07:41.238000  kern  :emerg : 5d20: cb991810 bf2240a8 0000=
0002 cb89b010 cb991810 bf23cb54 cbc10270 cbc10270
    2020-08-19 16:07:41.246000  kern  :emerg : 5d40: 00000000 00000000 ce22=
8930 c01fafd0 ce228930 ce228930 c085646c 00000001
    2020-08-19 16:07:41.254000  kern  :emerg : 5d60: ce228930 cbc10270 cbc1=
0330 00000000 ce228930 c085646c 00000001 c095f2c0
    2020-08-19 16:07:41.262000  kern  :emerg : 5d80: ffffffed bf240ff4 ffff=
fdfb 00000021 00000001 c00ce2e4 bf241188 c0407550
    2020-08-19 16:07:41.270000  kern  :emerg : 5da0: c095f2c0 c120aa70 bf24=
0ff4 00000000 00000021 c0405a24 c095f2c0 c095f2f4
    2020-08-19 16:07:41.279000  kern  :emerg : 5dc0: bf240ff4 00000000 0000=
0000 c0405bcc 00000000 bf240ff4 c0405b40 c0403ef0
    ... (18 line(s) more)
      =20
