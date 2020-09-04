Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5EE25E3E5
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 00:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgIDWxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 18:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgIDWxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 18:53:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C7DC061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 15:53:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v196so5398503pfc.1
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZyBmMBiKw7cc7l8FFNvqn0JJcsybrWo0qT+BmtOuUBM=;
        b=ptOndJcg8G4BIKyv1+ajIAs8ecMTgj3h0AOaAMR9rK6DaaWwMWlZ4QvYyJxzfhVxNu
         9nbhpg0HaPrU4Y+CpX9/IJ4TXKwQ07UYSg1FFUKITdWHxe7s2Tp6xgEdXmN/7vCjtkLn
         r6YebQQorXYWKGvtZwG9aKtvQ4fsaGNTFPB9X5J/3/OwTc4lSQ2X8IBec9btdzcd65Oh
         WxcxayDSUxB4LF0j9Tu7CUFq7pbNfBaBYCgsE2ycr86PN0WL5kCwXUd/fa4GSfuuQmY7
         etLauTAsjUdsI8Un08UV062w7LgQtckXUcDp88Gdr0krZqV5j8xTG1DhpXMc1v8Hq0zz
         JBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZyBmMBiKw7cc7l8FFNvqn0JJcsybrWo0qT+BmtOuUBM=;
        b=dTCXjTeUDSm3TH0ETD8Na4FryF6f18lGdwVwrmHHXERxAWM9jxIQFw/RGbi0bVUan+
         sMlD6cAQgs2kJii12zi+zyfp7LPWzVjVBQcQD5yOcwWvqw4s/a6KpxcCNrIBSxIqUaTh
         NkZka9cV1zSXnAQ2kIyiOdsQ6SotNZ+U8xTr1jr6lM4LUZk5XdVnhNxYdQNpAFURiOOM
         nMPx4SifXwM2emAIRoLyMasKCAOvVDmBcqMzAyhqLQVpsCsP3/lR+ot6g4aRfvjegCjr
         PrYaUXr00tMUgWGNt/Ihkt+Lu9Y/4AxArrgXQVMVQ2/ps6n0a1k0NWrjVb1TDRe+kEk8
         G/kA==
X-Gm-Message-State: AOAM532aNKERwRLFMVvvJdZXkHgpxmqy5KXzvS8VQ2krpXnV9of1dtez
        Y2WOlf2cfACwUYAxtq4T0WfDaVwqN6/vAA==
X-Google-Smtp-Source: ABdhPJyl5GXK0j2IO4DbpX5QbD3QpKawYOWknAGdX/MTWvpRAeXXPPN1+THEeHOIEoRhMvG8xqOhFQ==
X-Received: by 2002:a62:648c:: with SMTP id y134mr10927617pfb.114.1599259988024;
        Fri, 04 Sep 2020 15:53:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm941401pfr.141.2020.09.04.15.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 15:53:06 -0700 (PDT)
Message-ID: <5f52c552.1c69fb81.1cf80.2e7a@mx.google.com>
Date:   Fri, 04 Sep 2020 15:53:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.234-67-g0c80902e3fa1
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 104 runs,
 2 regressions (v4.4.234-67-g0c80902e3fa1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 104 runs, 2 regressions (v4.4.234-67-g0c809=
02e3fa1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.234-67-g0c80902e3fa1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.234-67-g0c80902e3fa1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c80902e3fa1f6553f3b7341e888f5cfc6d9c024 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f529298fe078505bfd35396

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.234=
-67-g0c80902e3fa1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.234=
-67-g0c80902e3fa1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f529298fe078505=
bfd35398
      new failure (last pass: v4.4.234)
      1 lines

    2020-09-04 19:14:49.116000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-04 19:14:49.116000  (user:) is already connected
    2020-09-04 19:14:49.116000  (user:khilman) is already connected
    2020-09-04 19:15:01.149000  =00
    2020-09-04 19:15:01.156000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-04 19:15:01.160000  Trying to boot from MMC1
    2020-09-04 19:15:01.349000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-04 19:15:01.590000  =

    2020-09-04 19:15:01.590000  =

    2020-09-04 19:15:01.597000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (449 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f529298fe07=
8505bfd3539a
      new failure (last pass: v4.4.234)
      28 lines

    2020-09-04 19:16:35.743000  kern  :emerg : Stack: (0xcb997d10 to 0xcb99=
8000)
    2020-09-04 19:16:35.751000  kern  :emerg : 7d00:                       =
              bf02b8fc bf010b84 cb8bce10 bf02b988
    2020-09-04 19:16:35.759000  kern  :emerg : 7d20: cb8bce10 bf1fc0a8 0000=
0002 cb9c7010 cb8bce10 bf24fb54 cbcf7030 cbcf7030
    2020-09-04 19:16:35.768000  kern  :emerg : 7d40: 00000000 00000000 ce22=
8930 c01fb010 ce228930 ce228930 c0859564 00000001
    2020-09-04 19:16:35.776000  kern  :emerg : 7d60: ce228930 cbcf7030 cbcf=
70f0 00000000 ce228930 c0859564 00000001 c09632c0
    2020-09-04 19:16:35.784000  kern  :emerg : 7d80: ffffffed bf253ff4 ffff=
fdfb 00000026 00000001 c00ce2e4 bf254188 c0407668
    2020-09-04 19:16:35.792000  kern  :emerg : 7da0: c09632c0 c120ea70 bf25=
3ff4 00000000 00000026 c0405b3c c09632c0 c09632f4
    2020-09-04 19:16:35.801000  kern  :emerg : 7dc0: bf253ff4 00000000 0000=
0000 c0405ce4 00000000 bf253ff4 c0405c58 c0404008
    2020-09-04 19:16:35.809000  kern  :emerg : 7de0: ce0b08a4 ce221910 bf25=
3ff4 cbabc040 c09ddba8 c0405154 bf252b6c c0960460
    2020-09-04 19:16:35.817000  kern  :emerg : 7e00: cbcedf40 bf253ff4 c096=
0460 cbcedf40 bf257000 c040671c c0960460 c0960460
    ... (16 line(s) more)
      =20
