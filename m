Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1449AA10
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324034AbiAYDaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3418590AbiAYCOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 21:14:20 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35EDC02B84B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:22:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f8so16848290pgf.8
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uWR5WPLjrfrhBOAuRt+/bOXsjQjre3Xcv4eBKxR8vfk=;
        b=2NzMHOkGQAcArw6jrmvtaEvfe+TcMpaEHw0e+lVn1Z9ofgrKEQYg88fgTjooVyS2mx
         v7ITyZ9DJVOcXssSVU3IFpuRfge2qOyz8jfSuLVTAKGb/GQkVIqrS9IzdHB2s4gg8kid
         UldQdUJQQLhDdRNABuVTyADPz7l7Zm+j+NF+KbeihAJON+4kpiKEgwDoZ/oHQWkpE013
         JToVsKt2UF+elXSD4yr7lOL/K1nGWIW31JG1lB95/inkMnFx68tv8ztC+imXoVmD6Knj
         Py/4TtcKe5zC0+ZRiGvN85xGGs8eETo5ZnFo5dGzqd5Bgc7st6xtVqce8ZjwXEcE14+u
         350A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uWR5WPLjrfrhBOAuRt+/bOXsjQjre3Xcv4eBKxR8vfk=;
        b=xOQryJDwjr5uzF3lfcVzJLKb3IAyYqyF8i+Zir/Yr4yiyVlf17N8ZLdGCKwRWi8rBS
         iAK/AZR5ak2r+NZjzav8Okj/ajJeWcDn3tymsK/1QlDJ3H3NIViMMS0SjFQt2xmTTZpl
         2/umm7ygZE9DKIRFQJvG9UqMS0InPlVIICHdki7kjl/n+4pw60zZwDZ8BoF5qhkJneDR
         RXBGQ6APPZ0TSYA5GTo8Nv4kHin83M1Q2RcEgYLcAsoCaBjBEAVvJKhMZqSJlA6apE8J
         JmSsCOyeXesNg8JiozujDbLQ5uBM05hXrZcPpjya1r+ia/IL/zlFpbd7DEsHuzi77Zxl
         SpZQ==
X-Gm-Message-State: AOAM532XuXwqZlR3VQXLz2POowvVPDtZZUc1kucsWihVLwSK6DLNsipr
        KDz8/DgXv6tt+cKKG3qMIQm8yhxTWPXMvpqB
X-Google-Smtp-Source: ABdhPJwslqAFKKykfZ/RjHOsjZIzXeKkWJFTJ+NOjjfrjxVcPLnQafwZJgtUAHGU3QuCnO7+v6fMww==
X-Received: by 2002:a63:2a44:: with SMTP id q65mr13346774pgq.479.1643070141001;
        Mon, 24 Jan 2022 16:22:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c26sm12454638pgb.53.2022.01.24.16.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:22:20 -0800 (PST)
Message-ID: <61ef42bc.1c69fb81.89148.2b07@mx.google.com>
Date:   Mon, 24 Jan 2022 16:22:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-186-g8d362d8866d0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 94 runs,
 1 regressions (v4.14.262-186-g8d362d8866d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 94 runs, 1 regressions (v4.14.262-186-g8d362=
d8866d0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-186-g8d362d8866d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-186-g8d362d8866d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d362d8866d02d2c07dbcbb037795edc115c5610 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef07d214281854bfabbd2e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-186-g8d362d8866d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-186-g8d362d8866d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef07d21428185=
4bfabbd34
        failing since 1 day (last pass: v4.14.262-15-g1464c5d2671d, first f=
ail: v4.14.262-153-g395d30f2bc10)
        2 lines

    2022-01-24T20:10:39.284545  [   20.039703] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-24T20:10:39.325036  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-24T20:10:39.334750  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-24T20:10:39.348726  [   20.106567] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
