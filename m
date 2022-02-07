Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CA74AC138
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 15:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbiBGOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389318AbiBGNwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:52:19 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA23C043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 05:52:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g8so3201124pfq.9
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 05:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KPMda97qPyH0RT8ZbTVPX3disfBGzWj46JNWywcf56w=;
        b=DeYPdc0yWVhz248pEwdsCFaezINwQprK8qx4bJvpEDoidGPMWp+Jy1jf4ykkGFi5p3
         2AhyJXnwDgGnzpOWK9ENIY1voLrYknVO4Kmkz/gDmjYgw/enJVXYh3g5HhXFks7z926E
         od4z/39BT3vlTOwqz8EfHEcJ4dqGRXT5+zh5XyzgUkrxb/QpZioRoB/BKRnFC0Xh+xJk
         Irp52fr8Q26PMYGN8aGPYvoIRVbAuxrIFgUA5ERAT9p/LeK14PSAuA/4+Wene8njH+IX
         R12lgWK1288O4SZMIeYepSGJ9qdsXYy2SbFDhYC6oxNc6kKKhHVad0aNmQayoTHZ6H9c
         0iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KPMda97qPyH0RT8ZbTVPX3disfBGzWj46JNWywcf56w=;
        b=m5D8E4S0aCADJphheSnvGO9tF0aum6wb2YIHKqIFuTRCg984lQmghniZrncAkot9SK
         j3P6pW8ko3Mg5hx4/Ysoxj5mX21QDGmWJPjcVhfm20J3uWnyouXxjwB+pXWmjfamH8Ld
         TqrEBK9RWKPiSmZvzuyhgnWbcEVK2zYqqAEfoWbLOE2KqvL4HHf3Kc0Z+NBXBZ1XTYDe
         Z4VVOKL9ZWxdx38msmm0eCWrLFW5JSWmJfQy6OUITG7gdF3WSdpYbTGF7xCsyExm8KSA
         zFnZrbAc0ixblalHX0XXBQH8OzWJJXLcSW/gzIPs01Nf3cv6piRziHwPnNN9qjg5SUiz
         QaHA==
X-Gm-Message-State: AOAM532oj2hmeoqy2KXgdGqRY6nS+eda9lpKQyO2wpcOE67+y1Pcd+qV
        Ggt8jFUOa3r7JZX8DQwn+4qTbr8EL6eWCMMo
X-Google-Smtp-Source: ABdhPJxXsy6mNGC5ndcC+zSBxIs9O63VNEKMOoVlCYLEKtu2rtoZNVimPPc6RTpBw89+P/YnUyZvKQ==
X-Received: by 2002:a63:618d:: with SMTP id v135mr5808709pgb.270.1644241937547;
        Mon, 07 Feb 2022 05:52:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk18sm11475209pjb.26.2022.02.07.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:52:17 -0800 (PST)
Message-ID: <62012411.1c69fb81.c337.b8c1@mx.google.com>
Date:   Mon, 07 Feb 2022 05:52:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-69-g76aeffb5cd68
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 1 regressions (v4.14.264-69-g76aeffb5cd68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 1 regressions (v4.14.264-69-g76aef=
fb5cd68)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-69-g76aeffb5cd68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-69-g76aeffb5cd68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76aeffb5cd68bd0cf49f1248f4c504581006b2d4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6200f2233c3ba9ab8f5d6f1e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-69-g76aeffb5cd68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-69-g76aeffb5cd68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6200f2233c3ba9a=
b8f5d6f24
        failing since 1 day (last pass: v4.14.264-40-g54996bdd9ffc, first f=
ail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-07T10:18:59.712839  [   19.934234] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-07T10:18:59.762967  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2022-02-07T10:18:59.772238  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
