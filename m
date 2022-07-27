Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA60F581CC4
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 02:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiG0A1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiG0A1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 20:27:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182223AB20
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 17:27:46 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 72so14580488pge.0
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 17:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JrgQxfomYfluMlje2RCt5Y0bmCgsap849zIjJ8qjDqE=;
        b=OQ+OwvTWEwvGp8Nr7gAY7zIf7bdjObIiRifRDYCVVzf/ncnH0vtbkxZt1V3nQ//r2p
         z8TvgabZH0qH0vAvlskfM/gy+pIQP2yI0YW/0r1NE4fXxLa8mA8YKDTADvP1Pg81s+sg
         iqttzDXVdxHTUcqiOlyMqAADFHGCs8ZWOPwhx2Jv2BaBOJOoRcUGXljp8bpUUywfoxV3
         ad8l0q5QcmexgNnuqRFS32PwjsFjJwHOe9WIOXH8DTtqgNncLqq4V9RQWb3SqiCgVTsp
         IAUnVs27EM0siWgZ+Mlsm1vYlrXXiBgYlixv6y46mdNbhccpkWoBgRgHH+vNs+E0n2XM
         7/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JrgQxfomYfluMlje2RCt5Y0bmCgsap849zIjJ8qjDqE=;
        b=AX+agb5CdCLgz2vUdoL7rmy0a+KQF/ApT1JqKBhu0HztK5XLdLjPdpE2/4qTaWlsk6
         YcnWX0eCVCb8t2/HnnibHAo85ftufFPQIcY8oeomOr4QTVIv+USH+3QiSdK8diLmagFv
         DU+AuXRz71nWzr+QD3BdB3QQx6ayLzCzVSkNlUm40dF/yHLVdFxh4yr2TytRZqLX4Ugf
         C9dOWM5Q3MGZWuV9VEc3UjjPORZolN2hXauVA76+89m3cjqJjYpzRBpYdPqvdzgLwXf6
         1KbG7syWPzGdrNE0XWymUoUr1bnr8s6LH/6TI2DzkAAj3awCNK10fvzSKgEUceoeNxyY
         Sqfg==
X-Gm-Message-State: AJIora+UPEuPYDMVrs0toFsybbIlvCkfdHByWkEM+EDdQlj4AIE58d2M
        7H1+ZFrRFCE6iHRdFdoIU9vSgowjpHTVBhzI
X-Google-Smtp-Source: AGRyM1sGbRFRT9Q6vXOO3toSxu6tx2hzXFsfSYjRLwz79CPXuT+MHgwdL+f3VV6ke1FO05Kpm1ndiw==
X-Received: by 2002:a63:594f:0:b0:412:96c7:26f7 with SMTP id j15-20020a63594f000000b0041296c726f7mr17411225pgm.110.1658881665347;
        Tue, 26 Jul 2022 17:27:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z1-20020aa79f81000000b0052ba78e7c20sm12620511pfr.97.2022.07.26.17.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 17:27:45 -0700 (PDT)
Message-ID: <62e08681.1c69fb81.1888b.4a5d@mx.google.com>
Date:   Tue, 26 Jul 2022 17:27:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-150-gea55d06a53af
Subject: stable-rc/queue/5.18 baseline: 193 runs,
 2 regressions (v5.18.14-150-gea55d06a53af)
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

stable-rc/queue/5.18 baseline: 193 runs, 2 regressions (v5.18.14-150-gea55d=
06a53af)

Regressions Summary
-------------------

platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-150-gea55d06a53af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-150-gea55d06a53af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea55d06a53afd55d2a1d022c7f6bf45d6793c81f =



Test Regressions
---------------- =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e054c3e4a0cfbcfbdaf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-gea55d06a53af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-gea55d06a53af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e054c3e4a0cfbcfbdaf=
05f
        new failure (last pass: v5.18.14-150-g590d7faf5de56) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62e05dfb8db7b0d925daf0ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-gea55d06a53af/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-gea55d06a53af/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e05dfb8db7b0d925daf=
0ed
        failing since 20 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
