Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD2E426486
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 08:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJHGUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 02:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJHGUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 02:20:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE37AC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 23:18:25 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so2134853pgc.6
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 23:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zi1tCaQHnJRHFmg9DIH2R0MixENxOF4621kGwqNJLw0=;
        b=W7JGxLX6CqdWGDsUMDGNM2r+zhOORTCSHzOu2wLI/W/xl0PLp6nB9pNyg6IQ6xcxNr
         EcgBo1FJu0nDlQhlJceHMDYh82GHmzgBCv1BrFRCT+ybRblJvv8dXZsJdEU1iX4zLZRv
         Tev4teeg1loN/WF7aZNw+VWBJb5rCdVaexFlN2dEJSfcTQSumsU2+33N4rXilPJOwUj8
         JrcPeUoC3aiSkgxmbAtua0AYziN9TLKJhIn7uiBjSwzUtu4/wreiQct1Ax5CNx3fWQlM
         TMJtjH95saUIuAn4fcQgjg507v0GYES8ocTQUPjdC69y3q/Ik7iBZFT/zDp1XbRTnQtv
         Y5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zi1tCaQHnJRHFmg9DIH2R0MixENxOF4621kGwqNJLw0=;
        b=BursBUMmcZcX9PP5+ryoy1MOoNrEiRr0zPtZLKSwtV8dIiF7vA5NGnZkIXwtVleZ6m
         q2yR9lCb7ZhMgJr0D4/f0A+0BjZaGctSd3NN4o6LdQb+jytK3FIT7VEQtd1qJ4DpttSs
         WVqtrrHlU9s6N3eaNMOUPAuZ6QRZV2s2JurkygW8qhS/ep+OBb36wwJ78sn9SjUtHHON
         +nAPlVITEn2X9CFLbbR51WDee3OF13io9WjwWtfua/i8MHz3gsFl/Wq0+Vx4VHksSJP+
         tmMxHqLqvQMRLR0WDTUZQ8NrJaxqnFMfhROFQZv2rqvzNpS46y3rjvk8eCl423vzUhvv
         XdDQ==
X-Gm-Message-State: AOAM531p+hSQ8JFD0pjrqdkb2QtllUEYkMMiyzDIdzra8c7Jnnn3MdVL
        MKFcwVtFDjBQS00ktM1C11lYoZ83ceOxXEDK
X-Google-Smtp-Source: ABdhPJxwk8YFOoo/hjjZMFOinqSiWJy/6UxYfoe+ZWUJoJ927mlsrkBljVp41RIDLs9YyIq/50efyA==
X-Received: by 2002:a65:5082:: with SMTP id r2mr3124134pgp.353.1633673905124;
        Thu, 07 Oct 2021 23:18:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25sm1285995pfh.132.2021.10.07.23.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:18:24 -0700 (PDT)
Message-ID: <615fe2b0.1c69fb81.94776.4a60@mx.google.com>
Date:   Thu, 07 Oct 2021 23:18:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.249-8-g9a91d3213756
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 109 runs,
 1 regressions (v4.14.249-8-g9a91d3213756)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 109 runs, 1 regressions (v4.14.249-8-g9a91d3=
213756)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.249-8-g9a91d3213756/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.249-8-g9a91d3213756
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a91d3213756efb919573f88c9c2894aa5a651ee =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/615fa904157187cbda99a321

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.249=
-8-g9a91d3213756/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.249=
-8-g9a91d3213756/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615fa904157187c=
bda99a327
        failing since 1 day (last pass: v4.14.248-75-ga54482216787, first f=
ail: v4.14.248-75-gddb29baac18c)
        2 lines

    2021-10-08T02:12:01.497488  [   20.485961] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-08T02:12:01.540326  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-10-08T02:12:01.549356  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
