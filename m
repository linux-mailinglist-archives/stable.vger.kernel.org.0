Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85E9297E60
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 22:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762278AbgJXUTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 16:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761257AbgJXUTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 16:19:25 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53154C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:19:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y1so2752433plp.6
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4jMDY6WNa5Z6o4Tfdv1muwt3PTTfECx1ZyDOlxIXImY=;
        b=QhihmOk/vdi3k3K68jpd8Xxkn2Hb5cpQNWQ4WwjS95Koj/QQgjn4JoXlXiui0IW/++
         0Lm7H+G6HVhjcT84JWy24GKoOH520spTitg44NI155Ubhy8ykATTfQwqK9AKwHNzS1X9
         Y9b/Rrvs+MM555kiw0ZmGzzqSowGAfVjHjDBU6kavkQIG+K+Lqmk9LD97z1xHi4bwhxy
         uJbOBftTINiZREp51iBYY30nFTX+7CVpBmkQBLPxiwqhnMNYMWJlhlmtmm+ZZjxeKFYZ
         hOC//UoJwdFmS4zemdMwbVAKlEKl9r5d983MM4pxUdY3590R/kYcrTC47b8ePvZ5HSWA
         XipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4jMDY6WNa5Z6o4Tfdv1muwt3PTTfECx1ZyDOlxIXImY=;
        b=pNVJoQhph6qe8tya9SybQ6vZhR/VS/h5gSdpXZZscBTYm5GH7sxQiNydP5yzcXyeJ6
         ToV5x4TkiD3TM7F9IHiB5l7TnwfaAKDhi4d1/Ev1pTmJrq5ylPR0dcNW7p/dkBaCCeMT
         bsihLTRhCuVCdIFSgEngkjAZFAVPDdIvalLUQ81n6+NebeGM8sPN+EJuVyDeIXkjvBhF
         uIznwX6od7kJfStPuhmthFJeLd8V7Ciw7mloIvEKFi+Y6ElnDa2p5EW5fTF9mfhTay4O
         8dcdPF49tEx39EF//sC21Iw//m5a9cNnaS4zFNwQHy+SV81AJ2Prn7TA2WhwmnCleQIl
         csLw==
X-Gm-Message-State: AOAM533NG6rBdWvk+tVbjxwgmWhs49MNDb3FH33Xuf2MaKXQYoNU5Xe5
        vlTp8SwLxZ4E+OxK2lw+dXCMa0JeZqks9w==
X-Google-Smtp-Source: ABdhPJyjB9q7OpS/4Nyn3RehRHB+WI+3nKvo209lc8MgbaoNCvXgPIqTKqoH/fj9NnHc16ibKy++3g==
X-Received: by 2002:a17:90a:7d16:: with SMTP id g22mr9001651pjl.135.1603570759324;
        Sat, 24 Oct 2020 13:19:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w6sm6156788pgw.28.2020.10.24.13.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 13:19:18 -0700 (PDT)
Message-ID: <5f948c46.1c69fb81.cb907.a5e7@mx.google.com>
Date:   Sat, 24 Oct 2020 13:19:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-18-gec7216aecf8f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 112 runs,
 3 regressions (v4.4.240-18-gec7216aecf8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 112 runs, 3 regressions (v4.4.240-18-gec7216a=
ecf8f)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-18-gec7216aecf8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-18-gec7216aecf8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec7216aecf8f41b9b280266fa73c561b83655a1b =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5f945a891f779f768d38101c

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-gec7216aecf8f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-gec7216aecf8f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f945a891f779f76=
8d381021
        failing since 0 day (last pass: v4.4.240-5-g7222bd699321, first fai=
l: v4.4.240-18-ge29a79b89605)
        1 lines

    2020-10-24 16:45:14.107000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-24 16:45:14.107000+00:00  (user:) is already connected
    2020-10-24 16:45:14.107000+00:00  (user:) is already connected
    2020-10-24 16:45:14.107000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected
    2020-10-24 16:45:14.108000+00:00  (user:) is already connected =

    ... (466 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f945a891f779f7=
68d381023
        failing since 0 day (last pass: v4.4.240-5-g7222bd699321, first fai=
l: v4.4.240-18-ge29a79b89605)
        28 lines

    2020-10-24 16:47:00.336000+00:00  kern  :emerg : Stack: (0xcb97fd10 to =
0xcb980000)
    2020-10-24 16:47:00.345000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cba4ac10 bf02b988
    2020-10-24 16:47:00.353000+00:00  kern  :emerg : fd20: cba4ac10 bf2240a=
8 00000002 cb8cf010 cba4ac10 bf24ab54 cbce1510 cbce1510
    2020-10-24 16:47:00.361000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce228930 c01fb3d0 ce228930 ce228930 c0857e88 00000001
    2020-10-24 16:47:00.369000+00:00  kern  :emerg : fd60: ce228930 cbce151=
0 cbce15d0 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-24 16:47:00.377000+00:00  kern  :emerg : fd80: ffffffed bf24eff=
4 fffffdfb 00000028 00000001 c00ce2f4 bf24f188 c04070c8
    2020-10-24 16:47:00.386000+00:00  kern  :emerg : fda0: c09612c0 c120da3=
0 bf24eff4 00000000 00000028 c040559c c09612c0 c09612f4
    2020-10-24 16:47:00.394000+00:00  kern  :emerg : fdc0: bf24eff4 0000000=
0 00000000 c0405744 00000000 bf24eff4 c04056b8 c0403a68
    2020-10-24 16:47:00.402000+00:00  kern  :emerg : fde0: ce0b08a4 ce22191=
0 bf24eff4 cbbfa5c0 c09dd3a8 c0404bb4 bf24db6c c095e460
    2020-10-24 16:47:00.410000+00:00  kern  :emerg : fe00: cbcdebc0 bf24eff=
4 c095e460 cbcdebc0 bf252000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f945a77a0365b937738102b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-gec7216aecf8f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-gec7216aecf8f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f945a77a0365b9=
377381032
        failing since 0 day (last pass: v4.4.240-11-g59c7a4fa128e, first fa=
il: v4.4.240-18-ge29a79b89605)
        2 lines =

 =20
