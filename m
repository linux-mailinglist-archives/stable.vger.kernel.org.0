Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D432F1E2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCERxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCERxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:53:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6658C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 09:53:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id fu20so2302705pjb.2
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 09:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KJm8hjCpK7HzWQ+JujJGHSyWqThnAePELWORMt8s70M=;
        b=x/ug0eEgFdQp082neJzGgoMcLQ3nsIpp5fbCKjHjs3V/dIL/FlGEPD1QivSUP6lxnL
         u2R1A/YDgiFusqFKclRknaizeItatSEPktNNpOa36rLpk2MSb79zbHzuXNijrq7xTjna
         VjsfwK6Nq+3uevbWI18eMqL5yuw6uYPCXYKYf2mHXnL/7Msyn47p3z08L7ZblAvk+p2K
         EqsUpYO3/4tIp0xpKiMKpa4xPGS4L64Ne7b1GOakfojIESuR2Qmawy/ayZfgiRNoKSJY
         TQvPU+XFXY+KKmOA1wxK1t7eYH4DzJUm2kb/94DWVH49uoZLSAF0g6pHUX7rRkvYen4m
         2XOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KJm8hjCpK7HzWQ+JujJGHSyWqThnAePELWORMt8s70M=;
        b=K7qEWtPQbSh2//7h3SOoxbij079YDNVrteM4mXdG4qKGu7tXA6WoJbY0Tl8WvMhgup
         jNIujXDU05U4/S+YVrcczE3zovGmcajaVR6554Sz4hL2qPVICE1SFNIofenbGKLsOHPf
         yibsBQlk9KgGtOr83VrxwpckHJd7tm8Qb8g2lZu9iB9NDYeD4wmSgh4jA0mKVTak/CQV
         SPkBcGx3yMTgf9qX+Ar0IlXCvZwY8LsXNzD2JZpS6eiK3WMFCfTaxNhk26UHQJPF4PNJ
         CgVk/oP5SRLYZckD5k6RHPP6AMgBCLiEBuYozHEUHNHc6y3oy03zpNxtJzfxCNOHsxcU
         O+Xg==
X-Gm-Message-State: AOAM531wDnraQ6Jsuy4ALuOjGpOtgHJbkWQ1z7xDtJVTQVE6YgoZT8bd
        bwSkXKXWmpO1Sdc788Ax08IDBND7kstZsrfJ
X-Google-Smtp-Source: ABdhPJxICEIh2nqZ1f1G2maXXwc8dRRKLZc5FxDJM0Ouyva+BRe59wcj4wGGKDg43a2Hk1XMZ+FfUQ==
X-Received: by 2002:a17:90a:29a3:: with SMTP id h32mr11790767pjd.209.1614966796202;
        Fri, 05 Mar 2021 09:53:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm3019218pjw.54.2021.03.05.09.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 09:53:15 -0800 (PST)
Message-ID: <6042700b.1c69fb81.e9827.7f8a@mx.google.com>
Date:   Fri, 05 Mar 2021 09:53:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-103-g80aaabbaf4332
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 167 runs,
 2 regressions (v5.10.20-103-g80aaabbaf4332)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 167 runs, 2 regressions (v5.10.20-103-g80a=
aabbaf4332)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.20-103-g80aaabbaf4332/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.20-103-g80aaabbaf4332
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80aaabbaf433294d1f075981fa3785d7f4b55159 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/604240062c40408005addcba

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
0-103-g80aaabbaf4332/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
0-103-g80aaabbaf4332/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/604240062c40408=
005addcbe
        new failure (last pass: v5.10.19-662-g92929e15cdc0)
        4 lines

    2021-03-05 14:27:49.989000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-03-05 14:27:49.989000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-03-05 14:27:49.990000+00:00  kern  :alert : [<8>[   39.348704] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-03-05 14:27:49.990000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604240062c40408=
005addcbf
        new failure (last pass: v5.10.19-662-g92929e15cdc0)
        26 lines

    2021-03-05 14:27:50.041000+00:00  kern  :emerg : Process kworker/1:2 (p=
id: 138, stack limit =3D 0x(ptrval))
    2021-03-05 14:27:50.042000+00:00  kern  :emerg : Stack: (0xc3af9eb0 t<8=
>[   39.395157] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UN=
ITS=3Dlines MEASUREMENT=3D26>
    2021-03-05 14:27:50.042000+00:00  o 0xc3afa000)   =

 =20
