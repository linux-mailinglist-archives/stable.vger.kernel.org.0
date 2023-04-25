Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2246EE604
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbjDYQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbjDYQqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 12:46:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3481616F09
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:46:40 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso5050655b3a.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682441199; x=1685033199;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eza5PdWpInmBFExA8Sj/fJUAyMhpaoJw48tFr6ommB0=;
        b=lmOykHpVKFfb5k7pUXQDylkBCM3jJSYwlr0iR+x+S5FKrzgh5tcXj0lWEeBG2h6djO
         4ixXEzcJ2aMqy82ObmihUHF4XznmQnKMNcumJFm3O+8PeRV9hZ9jz5XEjEKrDEr6MA4F
         JII64RJdfjMvLoqOPTn98LiTAUAeY3aI0m6kGGAAu9xjKA0dNS2+H/W1h9Bn7I1jNrFx
         krj2p2YP0Uo85P784OfznjSr/e0lZp6YffNbhnWqFDrP/Mk+f8zkJXUbzvwOn6yPZdFE
         5LvlFFXyv01SGm0IO8g1U/yW9gwzD8Da9hKT+fRN3jVikQvSqDz8AcY2qQEFciKHaBuZ
         M7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682441199; x=1685033199;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eza5PdWpInmBFExA8Sj/fJUAyMhpaoJw48tFr6ommB0=;
        b=Eta3oZaFivWf0nY8b5ieHUmtsg+/r15MoV8Ivl3/ZUD80cztAG8YynmFaZdPHJMT9G
         gniWkAW8Z/pzMUxO5blUBQbguHkGdAm/Pa33DMxukRzU+NHzhVWTNgbheEkimDMUpN0v
         xSHRXzA1mgJdlaQ3e5c2B40slV7kiSIQZbANIULAKwZYVMav2Xzp8i/l1EnaMy1AwTVD
         8hLnTgIkUOyUGXWQq1FP3zwE/j53h0Al19eibLhv+0ZAR4duS1TD/YI6BiCpjvQVU60p
         7WfcT4UgPB3sI/5rhtft+he0TDpJs8PmhGv69SHjRehZ2F+ys6fM1UzCVHla5qIQXHjW
         /swQ==
X-Gm-Message-State: AAQBX9eUT6FoUkah5CMFGJcO0Ye5r3EuAVkDqn07lLeCevwxWjvLIWrO
        TozEO+9H9uuzO/u/4ssFla129fkFkrBkMuUkI9sgWdZw
X-Google-Smtp-Source: AKy350aHimChfE/e3Y+TFGV6emPQnrxVgqS9b4E2kyA1jU5cINJd+BYoHjUZh1inVqDB7ER2zp0KhA==
X-Received: by 2002:a05:6a20:7da5:b0:f2:fe09:bdba with SMTP id v37-20020a056a207da500b000f2fe09bdbamr7519671pzj.37.1682441199199;
        Tue, 25 Apr 2023 09:46:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 145-20020a630797000000b0051815eae23esm8282691pgh.27.2023.04.25.09.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:46:38 -0700 (PDT)
Message-ID: <644803ee.630a0220.57b4f.0ce9@mx.google.com>
Date:   Tue, 25 Apr 2023 09:46:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-362-gfafbf80db7ca
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 83 runs,
 2 regressions (v5.10.176-362-gfafbf80db7ca)
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

stable-rc/queue/5.10 baseline: 83 runs, 2 regressions (v5.10.176-362-gfafbf=
80db7ca)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-362-gfafbf80db7ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-362-gfafbf80db7ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fafbf80db7caf604c7c90bec37b0e63529409afe =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cd46e8874559132e868e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gfafbf80db7ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gfafbf80db7ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cd46e8874559132e8693
        failing since 26 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-25T12:53:17.657653  + <8>[   10.991946] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10117264_1.4.2.3.1>

    2023-04-25T12:53:17.658188  set +x

    2023-04-25T12:53:17.763519  #

    2023-04-25T12:53:17.764615  =


    2023-04-25T12:53:17.866248  / # #export SHELL=3D/bin/sh

    2023-04-25T12:53:17.866522  =


    2023-04-25T12:53:17.967096  / # export SHELL=3D/bin/sh. /lava-10117264/=
environment

    2023-04-25T12:53:17.967367  =


    2023-04-25T12:53:18.067992  / # . /lava-10117264/environment/lava-10117=
264/bin/lava-test-runner /lava-10117264/1

    2023-04-25T12:53:18.068289  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447cd1b398bfe3e2b2e8605

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gfafbf80db7ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gfafbf80db7ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447cd1b398bfe3e2b2e860a
        failing since 26 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-25T12:52:29.196814  <8>[   12.062713] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10117245_1.4.2.3.1>

    2023-04-25T12:52:29.196896  + set +x

    2023-04-25T12:52:29.301387  / # #

    2023-04-25T12:52:29.401993  export SHELL=3D/bin/sh

    2023-04-25T12:52:29.402200  #

    2023-04-25T12:52:29.502748  / # export SHELL=3D/bin/sh. /lava-10117245/=
environment

    2023-04-25T12:52:29.502959  =


    2023-04-25T12:52:29.603508  / # . /lava-10117245/environment/lava-10117=
245/bin/lava-test-runner /lava-10117245/1

    2023-04-25T12:52:29.603810  =


    2023-04-25T12:52:29.608824  / # /lava-10117245/bin/lava-test-runner /la=
va-10117245/1
 =

    ... (12 line(s) more)  =

 =20
