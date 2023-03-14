Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767876B892C
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 04:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjCNDuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 23:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNDud (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 23:50:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F009010
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 20:50:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so13841153pjp.2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 20:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678765831;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8mQ6CKA0tobmX/S2jGAkOag1bGqqz5bNOO+viVPe7Dk=;
        b=XV1mpJ6eusyXRpP3GlVvO8szBWfk/rugddRMAB527o9lr+rcMaVyMQJmcV/6xYMZVT
         K9KDuDfWIw2B786UiRZTquBx+xe16tsGUcvBUpeBV86E9FIJoZnS/rdxmeCxID21wKi4
         BXI3eLvCg5IIz1CHnVzlE2RrWVDUxyIhQgIg94JqT0OA3LzJ1MqX+QojwOa17SMRb0Ys
         iJ5kbd0C+i8D4smZvtKVhml5QRSY/y4AYWWlUJ1t4X8O1PqDszuD8RXPMo5A72HQVitm
         zXRTYn6UrPEF49NB0sjyJPbXNck+yrGAdRoX652upeAEZIbPEWonUpT430BmOKxurXCr
         RhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678765831;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mQ6CKA0tobmX/S2jGAkOag1bGqqz5bNOO+viVPe7Dk=;
        b=YCblx8WEDcumjoxWadN3OAgdKlfw1fpoQP7BdLCgGfAyWtJLpBqaL0HkixDGYjduWK
         QIZVXZPK1L+3IQy41pgHkgCy2kShK+kwZe/+GteiQYEBws6z0uVbcdNYmjzv011YdKHr
         6S2D6Kz/bzXkQrZmxaMaYFF1eDnPZy1GaU/LzJPPt1fBTBeUTX8V4dV4bU1xxkqCatIy
         z7hqqeHa0VDCPrW+/by5AzrNKZYFKYWtki7LNzS6/y767XNxVO7wxDelclYGDOw0jZO7
         lJFmY1JXcjHmfbf2/UiuM25Xx/mAYAsH5MRLB18SyRCwBUomXpACwj8Ykq+qrzmZLz2t
         vdRQ==
X-Gm-Message-State: AO0yUKUZqpCUo9+0TV8dvEtdP6Q9+SiGvuvtOHUPnrSOjquVw+9Fi9js
        dX+RQYP8df57+K2rd5xQpvSSmgLpHA6Jj5laLR28yOd9
X-Google-Smtp-Source: AK7set8dxv3NTiHifxksABSnO9rs6FwmIZ/a76+c+/9TDjjGenoWV6dam21gtMP305Qv2MPmHPcCMw==
X-Received: by 2002:a17:903:2290:b0:19c:dbce:dce8 with SMTP id b16-20020a170903229000b0019cdbcedce8mr46326759plh.15.1678765830986;
        Mon, 13 Mar 2023 20:50:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id le13-20020a170902fb0d00b0019ccded6a46sm563343plb.228.2023.03.13.20.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 20:50:30 -0700 (PDT)
Message-ID: <640fef06.170a0220.a0da.2b4f@mx.google.com>
Date:   Mon, 13 Mar 2023 20:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-86-g57e99da285e2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 1 regressions (v5.15.101-86-g57e99da285e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 1 regressions (v5.15.101-86-g57e99=
da285e2)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.101-86-g57e99da285e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.101-86-g57e99da285e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57e99da285e22be6db44ce8aaa616c37f6dac735 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/640fbd2de9baafa7bf8c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-86-g57e99da285e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-86-g57e99da285e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fbd2de9baafa7bf8c865d
        failing since 55 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-14T00:17:25.991001  <8>[    9.890750] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3408657_1.5.2.4.1>
    2023-03-14T00:17:26.099456  / # #
    2023-03-14T00:17:26.201237  export SHELL=3D/bin/sh
    2023-03-14T00:17:26.201591  #
    2023-03-14T00:17:26.302708  / # export SHELL=3D/bin/sh. /lava-3408657/e=
nvironment
    2023-03-14T00:17:26.303160  =

    2023-03-14T00:17:26.404427  / # . /lava-3408657/environment/lava-340865=
7/bin/lava-test-runner /lava-3408657/1
    2023-03-14T00:17:26.405028  =

    2023-03-14T00:17:26.405200  / # /lava-3408657/bin/lava-test-runner /lav=
a-3408657/1<3>[   10.273319] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-14T00:17:26.411574   =

    ... (12 line(s) more)  =

 =20
