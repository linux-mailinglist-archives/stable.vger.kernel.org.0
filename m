Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA564D025
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 20:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiLNTj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 14:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbiLNTjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 14:39:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B27C2A416
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 11:39:23 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so276110pjd.5
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 11:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qXouOJJYfhefJD1Cqv6Z9GRFOb6XM5M+uaNw9i5rZbc=;
        b=Ydi0N3Z4sczyxCpw2tTP8Nsa+FXo5UI9UfEQgA/Z/KYeqHjJ2HV8OlyQ69R/Dvpsrw
         YVEDOzCsYzPUzsnhxknZMl5hmXpMx/demRBxVoHw6BfNhSZ9wqksNXRB/4S/yKeZEtMz
         Yp/GxxC1igO7ep4NEou8ivFi3fpdRIX3rwjKESHUMETnGCZmDF1y6BzddPinPOSGAKQn
         CHUE/rrloGvYvIUDIlhifLoPDsj8dbzKmrEoIItGrLSs/RG/bb6CI+u/jTQl/7GB1RVT
         yclMMKbV+3t5OP465WmflEhQYDAd3CBwb5wkTyB24he6CCkM+5wJ1ixgp4rd8yLeKE4f
         LRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qXouOJJYfhefJD1Cqv6Z9GRFOb6XM5M+uaNw9i5rZbc=;
        b=wYE7BAMw07SPPaMI3zOnAWD0DJC6ykB9SasRu8ZVc2nqW/EprDnewNO9wXOG+K6G8K
         PF+5m019mftue49MF0ETUaz/zodWZ8i5jTV906C0+UW6vZWTfRCnIGIHOmk4PgKoiP/7
         dmSvmW1LeEahbHqv5yQfQS2XiOCu1pUQn2H+0WVnGehANpQwGTUAHkxzb5ucWjfymkvV
         FGnBWQRd8f4bUV4jw/pUdVKmAxE5v1a3yXabisWZbjc+BVwSl8URkTRRVJi7VUVzQgHB
         29+ZtgKytHJZi4gfOd9mmL3UbvDyqKx7DpnzXteVoh7WynB+m0CSpuxZ+syjbS0QtP54
         MWXw==
X-Gm-Message-State: ANoB5pnCEFK1OXg5+rFS5CRdH24a4UDeerVdY+9/tdSol3UY8jcseC20
        EB5BK84YFjiKzN1xUkvh0CcbRZuPiV6JARp9Y+ZicQ==
X-Google-Smtp-Source: AA0mqf705MsGPo9iDjFSnVBTurH1RCsoNrciApy53DSzp1ZCYtOJxhjEj+K9J5uOtXfj3rjERBO3Sw==
X-Received: by 2002:a17:902:e411:b0:189:8790:73b1 with SMTP id m17-20020a170902e41100b00189879073b1mr22308676ple.65.1671046762420;
        Wed, 14 Dec 2022 11:39:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b001895d87225csm2225997pli.182.2022.12.14.11.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 11:39:21 -0800 (PST)
Message-ID: <639a2669.170a0220.23ab7.5802@mx.google.com>
Date:   Wed, 14 Dec 2022 11:39:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.226-66-g7d95ada83f22f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 91 runs,
 2 regressions (v5.4.226-66-g7d95ada83f22f)
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

stable-rc/queue/5.4 baseline: 91 runs, 2 regressions (v5.4.226-66-g7d95ada8=
3f22f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.226-66-g7d95ada83f22f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.226-66-g7d95ada83f22f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d95ada83f22f39ee7063a1c3f717e3a59b5ac7c =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/6399ea38dc3e33a7072abd29

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.226-6=
6-g7d95ada83f22f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.226-6=
6-g7d95ada83f22f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/riscv/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
6399ea38dc3e33a7072abd2d
        failing since 56 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)

    2022-12-14T15:22:16.935270  + cd /opt/bootrr
    2022-12-14T15:22:16.936179  + sh helpers/bootrr-auto
    2022-12-14T15:22:16.938476  /lava-3041038/1/../bin/lava-test-case
    2022-12-14T15:22:17.943131  /lava-3041038/1/../bin/lava-test-case
    2022-12-14T15:22:17.944248  <8>[   14.553529] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6399ea38dc3e33a7=
072abd32
        failing since 56 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2022-12-14T15:22:15.844658  / # =

    2022-12-14T15:22:15.849983  =

    2022-12-14T15:22:15.958489  / ##
    2022-12-14T15:22:15.978219   #
    2022-12-14T15:22:16.081555  / # export SHELL=3D/bin/sh
    2022-12-14T15:22:16.090321  export SHELL=3D/bin/sh
    2022-12-14T15:22:16.193124  / # . /lava-3041038/environment
    2022-12-14T15:22:16.202524  . /lava-3041038/environment
    2022-12-14T15:22:16.305300  / # /lava-3041038/bin/lava-test-runner /lav=
a-3041038/0
    2022-12-14T15:22:16.314359  /lava-3041038/bin/lava-test-runner /lava-30=
41038/0 =

    ... (10 line(s) more)  =

 =20
