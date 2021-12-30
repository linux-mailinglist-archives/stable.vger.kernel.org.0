Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812F6481DD6
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhL3Pvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 10:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhL3Pvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 10:51:35 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241ACC061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 07:51:35 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t123so21636630pfc.13
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 07:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9PfzMXz73yUtXFo1OK/nPQjDNbr3VoIEw9x4mCMR5IQ=;
        b=ZGTu3sJxVzZlZhk0xNRR4gGJ8sdXVkdNQ1uxMV0TjkOkgQIVGv6jY1ssGU7UdvfOpJ
         9nk5sGdEvpf+jyd3Rls0l35cwgExT2WhPOCw4406cflbcuntzSQbQ0S0r6ohp3X2OhsQ
         FNWFdnBKpGZK8xnCr+XLczkyt3iTtNTVuooPcCOd7aKuAfGv6QWH94aoJ1oWy9cTtCSQ
         3cCLwBCWZLIEFkFRaA74tl5rytV1FDGVnBgLqwzBxU6XaxSagjIrhEh9ANvCxr5HpK2E
         52rWdiAgtrRswj3IplMnfoly/88fp+wcrGv/PEchWPujK8vfPEMcTXImvNC89rhmIekB
         hesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9PfzMXz73yUtXFo1OK/nPQjDNbr3VoIEw9x4mCMR5IQ=;
        b=xskF0l23bDUrK1XA6vPwQ0v7dSmB+zDBMVcHXnDe8BHju4AXivCB66UMzxmDueqK5/
         kkr3m3F/wLtbYaMjNutZClpCBZAs0QsuzONp/bWJM3dEeXdxV30H0WngIslPB/weTLKB
         UGQFdvpPQGreoU4TCtaDRdJd+t28LOW75oycCtUjMxFSz93XF2hTzM4XBj2wG9GpCShs
         HcpI+Obqm2YQxvBjN0dWyouFcuA8SoxstuNNL00XWaXvVlrzBAAc7r6jstQHnXSi29nX
         j82JIT/uP1eK8Hb3UYv1g4+DpFp5AdeHBLNYxK94SegCr9CyGZFZXfiMfZxr70/GI4K/
         vQVQ==
X-Gm-Message-State: AOAM533R308XJJ1NybjliBJ5SSx/ewq2D/bruXb/X0lD47VkwKRa7wYI
        TF6MNIIPaWnXPvtk+1tJf2RbddEPm6s/gP9z
X-Google-Smtp-Source: ABdhPJzvAb+TIDLh4nJmpQJglu3vZAstroddqYc5IJcxkRdg/S6Pmhb0UbP6+RmtpdKQ+32VpdyU9A==
X-Received: by 2002:aa7:8f37:0:b0:4bb:a19:d3aa with SMTP id y23-20020aa78f37000000b004bb0a19d3aamr32423668pfr.1.1640879494401;
        Thu, 30 Dec 2021 07:51:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cx5sm25597107pjb.22.2021.12.30.07.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 07:51:34 -0800 (PST)
Message-ID: <61cdd586.1c69fb81.17137.7c25@mx.google.com>
Date:   Thu, 30 Dec 2021 07:51:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-3-ge96260346109
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 64 runs,
 3 regressions (v4.4.297-3-ge96260346109)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 64 runs, 3 regressions (v4.4.297-3-ge96260346=
109)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.297-3-ge96260346109/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.297-3-ge96260346109
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9626034610927579924b872e3e1d1f35c910341 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61cd9ce3e09276baa9ef6766

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-ge96260346109/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-ge96260346109/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61cd9ce3e09276ba=
a9ef6769
        new failure (last pass: v4.4.296-18-g954deba47211)
        1 lines

    2021-12-30T11:49:40.710443  / # #
    2021-12-30T11:49:40.711245  =

    2021-12-30T11:49:40.814514  / # #
    2021-12-30T11:49:40.815043  =

    2021-12-30T11:49:40.916329  / # #export SHELL=3D/bin/sh
    2021-12-30T11:49:40.916678  =

    2021-12-30T11:49:41.017798  / # export SHELL=3D/bin/sh. /lava-1333217/e=
nvironment
    2021-12-30T11:49:41.018132  =

    2021-12-30T11:49:41.119140  / # . /lava-1333217/environment/lava-133321=
7/bin/lava-test-runner /lava-1333217/0
    2021-12-30T11:49:41.120325   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd9ce3e09276b=
aa9ef676b
        new failure (last pass: v4.4.296-18-g954deba47211)
        29 lines

    2021-12-30T11:49:41.584327  [   49.415496] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T11:49:41.636924  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-30T11:49:41.643182  kern  :emerg : Process udevd (pid: 117, sta=
ck limit =3D 0xcbaea218)
    2021-12-30T11:49:41.647437  kern  :emerg : Stack: (0xcbaebcf8 to 0xcbae=
c000)
    2021-12-30T11:49:41.654715  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61cd9ce14fd63c1753ef6758

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-ge96260346109/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-ge96260346109/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd9ce14fd63c1=
753ef675b
        failing since 9 days (last pass: v4.4.295-12-gd8298cd08f0d, first f=
ail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-30T11:49:38.115221  [   19.049255] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T11:49:38.157743  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-30T11:49:38.167005  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
