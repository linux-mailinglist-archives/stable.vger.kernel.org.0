Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F95433E39
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhJSSQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJSSQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 14:16:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B26C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 11:14:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso502388pjb.4
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 11:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QqNf70wUgRp3gXy8wqB7R6WBdnpKVj5mKRzOykCQJS4=;
        b=XbLQg7F5G0j9FJca4zTD2CZVN2vxSGTwkaObT2lAagoEWgs0h3l4hPmxlfyRN9fpT5
         BP8hk2xWVwKjWhT9Gvq8JpWDd1b7UIs4z+jXC4ALpj7zA2T52YRNcBWI+sDtxqp8Hobl
         GyZKhviSbiSdnX1J7/tzxTTL+yORhtJpjmdFLOgsXKlU91wbwg9h2E5c2mAmUo885zh1
         ASNRBoJBCwkSus1kF7afNBG4FLW45mt3Y0BMmVu1YgoORYtJJ9W+RRtK5rJwPs2UMmnO
         TGjHthKKE1JDUncVu/vKqGk4vqPzMZvTb1eYhaGQOZtNUIuFMCPPkQ9Vv96IeBAo8XGg
         nQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QqNf70wUgRp3gXy8wqB7R6WBdnpKVj5mKRzOykCQJS4=;
        b=NPM5W16vFjzZ1gJLncF1SBOopb/BIIrfvK4rmf36ynmUw5LeyFI7PEKUS2H/ofb222
         OPZKtfgqz4RfH1Skm05bsbW6iKZjn86FYgbA8Z7zoI8KraHcNrP2aUU4DDQCRkbJG7mp
         Yx7Pl21VAGRNN4NjUhtVd8/j9hqhLVLTuW6zsD8Z5QvS/azFaGyMJ0g6h/EvV2RlSQrl
         xzlSDoKZRl8rnswa3Q8Rw6vIai/cUJsjRUYyBCOoi1OgFW2J7yy4iEn3pZsZ21E0NrG5
         kKm7gGV1/T9sjlYeUqiGmoWhy7Ez6HQETCqus8DQx9EWhB5hD22T6KejqPz0p9nQ/DUV
         6XDg==
X-Gm-Message-State: AOAM530XHeLjQLPQGZZCi3jCOlHsvuFSRhHffmcW8tWIiz2Yim8U0N9e
        nPCjj7EPXnE/1N0TKz9m1l+XBgzrCWz10agH
X-Google-Smtp-Source: ABdhPJyN9ekYvYn2vWoB+ViZ2f8h0KA0Dcopx0aaaJaOdbMt5iG+13Wu5szfGtZEOWFtzQR4dKTbZA==
X-Received: by 2002:a17:90a:fa2:: with SMTP id 31mr1522332pjz.175.1634667273169;
        Tue, 19 Oct 2021 11:14:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15sm5029660pfe.132.2021.10.19.11.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 11:14:32 -0700 (PDT)
Message-ID: <616f0b08.1c69fb81.48a5c.d279@mx.google.com>
Date:   Tue, 19 Oct 2021 11:14:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-41-g7cfc0d2f1a45
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 121 runs,
 2 regressions (v4.4.288-41-g7cfc0d2f1a45)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 121 runs, 2 regressions (v4.4.288-41-g7cfc0d2=
f1a45)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.288-41-g7cfc0d2f1a45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.288-41-g7cfc0d2f1a45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cfc0d2f1a452effc00af78f2f95516001bbb888 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/616ed359b836a2ec483358fd

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-4=
1-g7cfc0d2f1a45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-4=
1-g7cfc0d2f1a45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/616ed359b836a2ec=
48335900
        new failure (last pass: v4.4.288-41-gb49a3cf35ed8)
        1 lines

    2021-10-19T14:16:37.643414  / #
    2021-10-19T14:16:37.644553   #
    2021-10-19T14:16:37.749317  / # #
    2021-10-19T14:16:37.749859  =

    2021-10-19T14:16:37.851101  / # #export SHELL=3D/bin/sh
    2021-10-19T14:16:37.851682  =

    2021-10-19T14:16:37.953139  / # export SHELL=3D/bin/sh. /lava-957179/en=
vironment
    2021-10-19T14:16:37.953574  =

    2021-10-19T14:16:38.054857  / # . /lava-957179/environment/lava-957179/=
bin/lava-test-runner /lava-957179/0
    2021-10-19T14:16:38.055780   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616ed359b836a2e=
c48335902
        new failure (last pass: v4.4.288-41-gb49a3cf35ed8)
        29 lines

    2021-10-19T14:16:38.490227  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-19T14:16:38.495890  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0xcb994218)
    2021-10-19T14:16:38.500238  kern  :emerg : Stack: (0xcb995cf8 to 0xcb99=
6000)
    2021-10-19T14:16:38.508612  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2021-10-19T14:16:38.516980  kern  :emerg : 5d00: bf02bdc8 c06a35ac 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =20
