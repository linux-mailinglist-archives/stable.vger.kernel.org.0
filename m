Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7671382D92
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 15:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhEQNiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhEQNiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 09:38:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83832C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:37:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 69so3148456plc.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kqX2EFvUGM0sPl+YwW+14Xr3/43XjRcervueM6mnMXE=;
        b=QqWKJ2tbT/uIznc2sd1yA/9n8j9lyAk6lDgatqKvKxS5jCXA0eMstgjHrNTTk7Jvg9
         JSIGTs5CkE2tGbi3WdMS3Uw1UqXSvTUbqNmVfvuAwUEp1LUvA76bWCibLjsKXe5npeL0
         k3PCNGHmj26LMWwXZZRtdXzY/15sNu4Lugpg8LqNFZRVONy9/yU9OdZ92fQ7ySXoeH8p
         5sxp69S5v++NC+DEYL9KwVo6PFrsrtzteyiARtYH6iFJZpjDCO2BtfoXa3zomyP4xDMJ
         UOBdDtdXpXgzb1+lfnWdbV/AmCtZ2mEiKPhOEBkLIx6MlVBD6Z09wnm2KYk+RcFTxa4d
         wmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kqX2EFvUGM0sPl+YwW+14Xr3/43XjRcervueM6mnMXE=;
        b=HXGG4Fnvq4mM6wS7dcmpFzn+isxO1PvRnquc02ciG3PUwqKPh9P6cQwaJdQkIaEtTR
         JjsuQNq7tSW/Ny+QoZgwFDnww+H///Ze/nCONIo2SGttqMfKT9Iu3R+4ixHP2T7kSFU9
         w1qOptanM1WZeWp0ShEOCUsreBCx2XZ3/f+cYeQyvl4rZnu70iKllCg029xb76/otG5g
         WEJd6/ajcHijlP3qq5Tu58S8QIDJn2DZJdEkXaqYT/VLofzCSdCfeElPQVTemoCgdWll
         OrW5ZNaJlgeybkYKJ1mEhvuQdBjN9YVwWC5nP59tRu6sLNVjyDaO4BCawSwHXNpoSojd
         K90w==
X-Gm-Message-State: AOAM530WxQ371U9HL8b/z4NIsYn/0wN83D9hONwvcpwvex2BJYVvvXD6
        8dxbOVMsMRdKEIyTDU9g99ACe+niiijGA/UP
X-Google-Smtp-Source: ABdhPJwR6ZlEWmCxZrQNm96/e9R7AHLf5b4t9JdC76BMPBCrGCPvdnf+M3AyZSLim9ylc9aPmK91XQ==
X-Received: by 2002:a17:90a:d18a:: with SMTP id fu10mr26439169pjb.71.1621258655723;
        Mon, 17 May 2021 06:37:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm4845940pfv.60.2021.05.17.06.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:37:35 -0700 (PDT)
Message-ID: <60a2719f.1c69fb81.cdbd5.ee0f@mx.google.com>
Date:   Mon, 17 May 2021 06:37:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-240-gb8f335cf282d
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 119 runs,
 2 regressions (v5.10.37-240-gb8f335cf282d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 119 runs, 2 regressions (v5.10.37-240-gb8f=
335cf282d)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.37-240-gb8f335cf282d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.37-240-gb8f335cf282d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8f335cf282d7d20073688f4d0ad339cfdcaec84 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a24025aa60cb8c3eb3afc3

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7-240-gb8f335cf282d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7-240-gb8f335cf282d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a24025aa60cb8=
c3eb3afc9
        failing since 5 days (last pass: v5.10.34-30-g5f894e4a8758d, first =
fail: v5.10.35)
        4 lines

    2021-05-17 10:03:15.293000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-05-17 10:03:15.296000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 43.657276] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-05-17 10:03:15.298000+00:00  =

    2021-05-17 10:03:15.299000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a24025aa60cb8=
c3eb3afca
        failing since 5 days (last pass: v5.10.34-30-g5f894e4a8758d, first =
fail: v5.10.35)
        47 lines

    2021-05-17 10:03:15.351000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 80, stack limit =3D 0x(ptrval))
    2021-05-17 10:03:15.352000+00:00  kern  :emerg : Stack: (0xc34c7d58 to =
0xc34c8000)
    2021-05-17 10:03:15.353000+00:00  kern  :emerg : 7d40:                 =
                                      c3a45db0 c3a45db4
    2021-05-17 10:03:15.355000+00:00  kern  :emerg : 7d60: c3a45c00 c3a45c1=
4 c144a47c c09c54f4 c34c6000 ef86c4c0 c09c68b4 c3a45c00
    2021-05-17 10:03:15.356000+00:00  kern  :emerg : 7d80: 000002f3 0000000=
c c19c7834 c2001d80 c3a21f80 ef86c420 c09d2c4c c144a47c
    2021-05-17 10:03:15.357000+00:00  kern  :emerg : 7da0: c19c7818 d4673fb=
b c19c7834 c3a26680 c3a1e880 c3a45c00 c3a45c14 c144a47c
    2021-05-17 10:03:15.394000+00:00  kern  :emerg : 7dc0: c19c7818 0000000=
c c19c7834 c09d2c1c c14481a4 00000000 c3a45c0c c3a45c00
    2021-05-17 10:03:15.395000+00:00  kern  :emerg : 7de0: fffffdfb c22d8c1=
0 c3a89240 c09a8b44 c3a45c00 bf026000 fffffdfb bf022138
    2021-05-17 10:03:15.396000+00:00  kern  :emerg : 7e00: c3a1f640 c3bc710=
8 00000120 c26dcb40 c3a89240 c0a0272c c3a1f640 c3a1f640
    2021-05-17 10:03:15.398000+00:00  kern  :emerg : 7e20: 00000040 c3a1f64=
0 c3a89240 00000000 c19c782c bf049084 bf04a014 0000001d =

    ... (35 line(s) more)  =

 =20
