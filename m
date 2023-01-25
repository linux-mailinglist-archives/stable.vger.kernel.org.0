Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABE367BB83
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 20:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjAYT6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 14:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjAYT6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 14:58:09 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7D4EB6A
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 11:57:52 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 144so1192973pfv.11
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jDsMMCKajsyYyyUcVvnlycuv5ffnm08C67tOf1dMCds=;
        b=yKONgN3d44WTp8dEYOXPDfb2A3Yqqpf9oamls0nYznTd2Vkvtv5bLpw/2pbouywJxo
         7SyyD7JRZIttkJz09B85MjuDeoAxdUhT7nDOl6BW6NugKRXaMliccfopJf/5xZq8KkTB
         VC5PXaX1ttcKcIS7N/bOxgyqrmu/OTfm/j1YLSNQoSZomXJ62aqQeYTdmPH9x5qdwSeB
         GHroHuLm2IY8EjHuZ6hhJorDGdaFEUc5fZm5rDo7J5gmjKIToWV9BbvTpAsmfmahTA8k
         Ie17qIFQmkYSkQTrH+B9m7bUB90b9QyZ4S+pVYN2dDCerJGN1T2TutWqqBVCwqgJbf8v
         JQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jDsMMCKajsyYyyUcVvnlycuv5ffnm08C67tOf1dMCds=;
        b=RJIXhXI5H/67Ce7dc8ZqhcVAkjYmdxcyIvPqNATJ89WVXKAYvMECP+wvxepCDQa8bK
         GW/W2omZGaf1iPhLz+SOoKySVZ1wZCogS9fozBVz1f5OJExxX6wOcgFk3JXijPguhZYJ
         br8hoIH5kVobNLn8aFM7znLu1lhKas3/P1vDVcPfPtUu49fVYTKrnX/AfalLqU3H1F8h
         DvoOW6eT9WA7AfU3et0ln2+PP4i+RWUrrgsqHqEWDKYEepb5yaemFxpRcVDhaoVoLgH3
         1soiQkNpn+9AmuFlI25W0DaLbP/GOT+qQoYqu5Agut2u3beV7AxOy8L06fk+dMeoOAuy
         0hPQ==
X-Gm-Message-State: AFqh2krClyq+yg6CdZiLssyw21qDWnSDHREVn5k75gOZCL6s+OTAoLm3
        wpZ0kOXZwsZrLTfUjgSebRSC+ZC7JJ/LHKfPUX1MEg==
X-Google-Smtp-Source: AMrXdXuzLUyZn6hnJc0wpXgLT6D5mTFU0ZRurfd7xJDEyDviRAnzfYLToZchWK1kKIaWQT1m+TN1Ig==
X-Received: by 2002:a62:1c93:0:b0:583:3adc:baed with SMTP id c141-20020a621c93000000b005833adcbaedmr32133679pfc.8.1674676665492;
        Wed, 25 Jan 2023 11:57:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020aa793ac000000b005898fcb7c2bsm4158344pff.170.2023.01.25.11.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:57:45 -0800 (PST)
Message-ID: <63d189b9.a70a0220.e3412.7ba5@mx.google.com>
Date:   Wed, 25 Jan 2023 11:57:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-122-gb1a94e4085d6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 148 runs,
 1 regressions (v5.15.90-122-gb1a94e4085d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 148 runs, 1 regressions (v5.15.90-122-gb1a94=
e4085d6)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-122-gb1a94e4085d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-122-gb1a94e4085d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1a94e4085d6e82791c1b7d3c2714cbcad7bbfe6 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d1574a668629a549915eee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
122-gb1a94e4085d6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
122-gb1a94e4085d6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d1574a668629a549915ef3
        failing since 8 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-25T16:22:17.100047  <8>[    9.969038] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210958_1.5.2.4.1>
    2023-01-25T16:22:17.206614  / # #
    2023-01-25T16:22:17.308094  export SHELL=3D/bin/sh
    2023-01-25T16:22:17.308504  #
    2023-01-25T16:22:17.409671  / # export SHELL=3D/bin/sh. /lava-3210958/e=
nvironment
    2023-01-25T16:22:17.410068  =

    2023-01-25T16:22:17.511303  / # . /lava-3210958/environment/lava-321095=
8/bin/lava-test-runner /lava-3210958/1
    2023-01-25T16:22:17.511902  =

    2023-01-25T16:22:17.517256  / # /lava-3210958/bin/lava-test-runner /lav=
a-3210958/1
    2023-01-25T16:22:17.604380  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
