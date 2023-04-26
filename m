Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A06EF891
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 18:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjDZQls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 12:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDZQlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 12:41:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C316A40E9
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 09:41:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a6c5acf6ccso56105125ad.3
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 09:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682527305; x=1685119305;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LkmEtvWHp4zGZyBfsec30m+xYNEVSzk/K5SuIBuhJJY=;
        b=WJuvzOTbVvut774r/E20q7Hvarx55DuETcpYa58oTbtWrv1hOW8i1eq9iVxNtCqLK/
         Oxsc3obsVFuBUVoGCHMYmCKfi41P3qPHwIGjk9WdnEHjS2lg4uSxRFECbjrFwUOXHrQV
         Irq6xaXC1s8ZvuYWJrVDrqW5hoNjVN1vq7w9SaxVze9bgPAItbf41Lk1wUuIRu6CeyFm
         zYJmAm1GaapYxJXKltN785b262GBC4VpC+8KS6MIS8C6elUZSdhBSxxdHKF1Vqv+Czo5
         h0a3i/2899sYDY0dr3gbIhbpyIL9aGUrfebLoSFsRf8d8A+nhe0jePvwt3rSvKWrSfZZ
         op/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682527305; x=1685119305;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LkmEtvWHp4zGZyBfsec30m+xYNEVSzk/K5SuIBuhJJY=;
        b=T/xQ41W9bHsRd7V/BkajTwIaS/H7Ajq9XW3/jSsxS8LGv2T08VEKh7IXIu1lHkVri8
         nhw20R+ICsJK9TxtpN27WXn3CmwbtxwzXC5M8Xu4OhSDGrO3ml8t6Q/yf0WWTwpvN9gc
         25b2d5waqvXbkvz/RUfq8pc88+FnczVaKOxr0HUbr4aZ9Gpe4v2G+0VGfQM28DdtjA40
         ldSnwww5MaykoDVfqVefrqt38y9N4Bo+vopCytvkajx9UFjbAf+0P+utcjSWlq2O/K8w
         fcKvWvTvu1PQKzAFucyVBdJZHb/xCe9dWKlDmNdE9/hUNnmZMV6OCwHD3N0Blntxll4A
         DjXg==
X-Gm-Message-State: AAQBX9edJWQXaWkHiV2suFWNzS/3RbuoM0omziLvSKG+Pnh9xGbU1OJ/
        aZYA6sKvnXPDawwMZnOtx31KhodEOtmmCgYISNv63g==
X-Google-Smtp-Source: AKy350bgOMGa5pU8758jujruYgeb8FFb4+D7cat4QUeOapM7s5L2PHBdM+fR7XEXt8LDOcOBDv4YxQ==
X-Received: by 2002:a17:903:2348:b0:1a6:413c:4a3e with SMTP id c8-20020a170903234800b001a6413c4a3emr26991391plh.5.1682527305471;
        Wed, 26 Apr 2023 09:41:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iw2-20020a170903044200b0019a91895cdfsm10187622plb.50.2023.04.26.09.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 09:41:44 -0700 (PDT)
Message-ID: <64495448.170a0220.bc4fa.4cf8@mx.google.com>
Date:   Wed, 26 Apr 2023 09:41:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.179
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 85 runs, 2 regressions (v5.10.179)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 85 runs, 2 regressions (v5.10.179)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.179/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.179
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64491fdd620dfd60e62e8619

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.179/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.179/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64491fdd620dfd60e62e861e
        failing since 21 days (last pass: v5.10.176, first fail: v5.10.177)

    2023-04-26T12:57:48.562522  + set +x

    2023-04-26T12:57:48.568957  <8>[   10.907404] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10130810_1.4.2.3.1>

    2023-04-26T12:57:48.673771  / # #

    2023-04-26T12:57:48.774443  export SHELL=3D/bin/sh

    2023-04-26T12:57:48.774654  #

    2023-04-26T12:57:48.875205  / # export SHELL=3D/bin/sh. /lava-10130810/=
environment

    2023-04-26T12:57:48.875422  =


    2023-04-26T12:57:48.975972  / # . /lava-10130810/environment/lava-10130=
810/bin/lava-test-runner /lava-10130810/1

    2023-04-26T12:57:48.976267  =


    2023-04-26T12:57:48.981200  / # /lava-10130810/bin/lava-test-runner /la=
va-10130810/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64491eea628b6216972e85eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.179/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.179/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64491eea628b6216972e8=
5ec
        failing since 34 days (last pass: v5.10.175, first fail: v5.10.176) =

 =20
