Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19259176E
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 00:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiHLWwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 18:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 18:52:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BCB8E0E0
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:52:02 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ha11so2223640pjb.2
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=Uu6qgWExl/3WvS+Feg4OYBga+utgxjmS2Xx6CBjMOGY=;
        b=1I/YfYcZTSbXxLbbOtwsKBKi8zZLb5g2MpzBeRWFT6a/+EXLJ5xwAjPXHYw3qLFtWY
         Q6LalK4FciZzZeeLbrcXVPkIbhZq45KTcwgh1bnJ3RZQv0JkxU8FD6+k2bwUp2Y10r1P
         DW25ZqS6wixUbf9x1kMpWdYkRJe8pL0y1M2WZzgNxYGiCUR2VhJbX/sS+mrtCmS9eddQ
         XrUQOkutbyGjXLW8xiTCunnDoWBP/bKFeIeNpYuc0jy3I9UtF3ljFHdJp6NFRExIdGzO
         9jgc2vf+LTs97KdySqZ36hnD3TbDbT9zPcPH0YR4aw1wf4+wIIghIYUrPr3JAP2h+YC5
         nN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Uu6qgWExl/3WvS+Feg4OYBga+utgxjmS2Xx6CBjMOGY=;
        b=B6jWRKlpz0se20s04WX5jJ+kBDhPb7MhMQyIIcAcs6Kt9wEnVTiB8KvDDRX+N8Xwhp
         MGEcC0dDLkUPBlkwCRcUdsxxXJdTHLxetnXt9tlab5OhGhH3zn6VPqqPevXEIE6Xq/lt
         NIFpeBOL43dextvuU7+z755Gn4/5423sFnCZb49Z0eyJpzEzvpaUu8ZsZ+c6fZYkwM2N
         e/Rk74GV3pPuGgjrp5CXAUgeltLBY0hP4S+BOrADRfPZXc0V4iQmE/f313hi6w1lSnvl
         iiCK7MUs7zIyuo1NASieStqNn5VO3EF6nx1+Qbv5uY4GT7HwRdYO4kZVUsmMw+wNgR4S
         pu/g==
X-Gm-Message-State: ACgBeo2JmH3ECjzXifa0/SFtv0UYnXAQrkGUdAs+fFrje0Sac2WV4adL
        sK55XjpfJCIbtAxCVKaTPpXD4SkNaypMYC5G
X-Google-Smtp-Source: AA6agR6f5bsyEPpm2lvDAPxu5mY2p8FWVctE3kZ2h4ROl1UnACalfRtVvgSoPYUS3s/m8LVd2rbaMA==
X-Received: by 2002:a17:902:efc3:b0:16f:1153:c509 with SMTP id ja3-20020a170902efc300b0016f1153c509mr6036561plb.41.1660344721762;
        Fri, 12 Aug 2022 15:52:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x185-20020a6263c2000000b0052dc3796cbfsm2119917pfb.75.2022.08.12.15.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 15:52:01 -0700 (PDT)
Message-ID: <62f6d991.620a0220.19a7f.3f97@mx.google.com>
Date:   Fri, 12 Aug 2022 15:52:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-34-gdab49837d475c
Subject: stable-rc/queue/5.15 baseline: 162 runs,
 2 regressions (v5.15.60-34-gdab49837d475c)
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

stable-rc/queue/5.15 baseline: 162 runs, 2 regressions (v5.15.60-34-gdab498=
37d475c)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =

beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-34-gdab49837d475c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-34-gdab49837d475c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dab49837d475cbebc5a4ae154bf089a3947427a7 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/62f6a46b1656c1a50adaf102

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
34-gdab49837d475c/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
34-gdab49837d475c/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f6a46b1656c1a50adaf=
103
        new failure (last pass: v5.15.60-22-gaa26185c2c1ff) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/62f6a7011cd7ef429adaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
34-gdab49837d475c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
34-gdab49837d475c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f6a7011cd7ef429adaf=
057
        failing since 134 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
