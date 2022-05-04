Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78351A4EA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiEDQL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242114AbiEDQL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:11:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86F225EA0
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:07:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so5575626pjv.4
        for <stable@vger.kernel.org>; Wed, 04 May 2022 09:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NkHDXlKqUYbUYFn90comELjW/Lo8aEsrD94IcS87b/w=;
        b=Tdf95JqCpECZGntGRso1SPaUUzzivpNSl+9EeYA6HPZRMD440HDMl8MAdSYACBc5lZ
         rypUM/JYwiAIllijt5DY3zUIjAqNKBR8ywikQHR3+rS4sAZthchqyaAG+MKk14jE4y5Z
         jptWmZPgV6Wd3sdeLfEFRk5PtBxP9eUmJ3KM2P40O80eG3OGMSMVXuuTj7Fu8AO1A/Ag
         2dEyA1kSmc2vwMRMWQVB1SdDdGjqxn7KqFANDe3lWbsmidwFk987qVaz4/5vJzo674cL
         ZYPzY4DX/fr2tWv1yw7VyNAWNMRQFOvKxDRbHxrPEdi2UxSC31Zp5EhCXF+1skIML/2h
         gxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NkHDXlKqUYbUYFn90comELjW/Lo8aEsrD94IcS87b/w=;
        b=TaoDQ7zruBYYwDxfz3rE8DD96h4n5EieAQAUoRqmS7XbFpem/kcRKaURQ7rMqH/gAV
         0yfwZpCxnp5EkpZTY8aQIU1E32Awui3gOtHXbOZ0m9A7mBTGQJeizR0LE5XOd/C2ox46
         SCoTz0fLSGngyE1hYZH3nKdUIoz2W29cRUjDzoL/lqQYyD4Sr/azpU4uh+YQ4dkWjBnj
         aKJrmnIoq/Y2nM9dIrd5GDDxVji12NSRI1AVs1I4UV/qV707RkanJv6lT+XSXGrJDxWV
         lwvOci/U9lm1sTEKQMcdAQiIA2gDboo5VBE9nagP20S9Ioq62kHNczxvEjgb6IzfdN6Q
         804w==
X-Gm-Message-State: AOAM532CynY1i5maoa5hVXubzNwpkQbegchLIkXlCEqEFrGSGaLPUEDS
        3diO+TWN/nS2kY6dqVLweBuTUVOJ2Fi7AEmkpxE=
X-Google-Smtp-Source: ABdhPJzQCHHfuytCfNbeaeDRsFiFUIi5RsnOOuSYNmzzc9rHRvyDrt3Mt+2GOtWIwJNVhz8nnige1g==
X-Received: by 2002:a17:902:bb90:b0:156:2c05:b34f with SMTP id m16-20020a170902bb9000b001562c05b34fmr22898677pls.53.1651680469122;
        Wed, 04 May 2022 09:07:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902e2d100b0015e8d4eb2ebsm8302671plc.309.2022.05.04.09.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:07:48 -0700 (PDT)
Message-ID: <6272a4d4.1c69fb81.bbebf.47f8@mx.google.com>
Date:   Wed, 04 May 2022 09:07:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.241-58-g5e77acf6dbb6
Subject: stable-rc/queue/4.19 baseline: 62 runs,
 3 regressions (v4.19.241-58-g5e77acf6dbb6)
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

stable-rc/queue/4.19 baseline: 62 runs, 3 regressions (v4.19.241-58-g5e77ac=
f6dbb6)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxbb-p200              | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.241-58-g5e77acf6dbb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.241-58-g5e77acf6dbb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e77acf6dbb66987e8f728a141bd7e5b04b83d08 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxbb-p200              | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6272483b705552637fdc7b2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6272483b705552637fdc7=
b30
        failing since 33 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/627248799ba52e84e3dc7b47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627248799ba52e84e3dc7=
b48
        failing since 28 days (last pass: v4.19.237-15-g3c6b80cc3200, first=
 fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/627248bba2f92f24c5dc7b2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-58-g5e77acf6dbb6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627248bba2f92f24c5dc7=
b30
        failing since 15 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =20
