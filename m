Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEF74C07A2
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiBWCKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiBWCKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:10:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F33DA4E
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 18:10:23 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z16so13933891pfh.3
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 18:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9D1SO97WNRyZCFCVCQwY2tJaMrud5Sls1dkPBBkSqBE=;
        b=N3cN+Szq1jF3tnAM521LPNzpxjGtYBk2/THkLh5lFGRbiHtle3wb4cqgpGtfEE9Ty1
         kSP56Wcs7577y74nYgWuOc6dli/dht01MDMhHpzu4bx+BOmHkh45dAnOu8LuKzdhYzbH
         OCzaYt5iBcs1gyJH2Assu9mZVr4qnpMJxGgA6D3cPDMpTGruqvRWAHxPcYZuBZSjkvWH
         ntb4azaXqwZXip60Ld5GHpbdMd+Q6odXoxkuY8woRKJ/o+dC6ygdu5hc0luxKHIVgs7x
         fBr74bEz0JY6eifWJ8nzejMgbZMTfAK29G04HkWVolTI9aBe38MyuE770otgYMELRNrq
         3ILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9D1SO97WNRyZCFCVCQwY2tJaMrud5Sls1dkPBBkSqBE=;
        b=PLC2CUiUOh5EbzDjgQ8ZmlV3hy2g6ZbJ2bx+ER2xOc0h8DeDmzRna85RYBtmzl21Ev
         FLp05qHirn+kcSSN8QoO7xx0Vls4wZdRKYyAwrl8GftFiQpUJp4jDtrVmPJZuWunHVxE
         bULyhz1IV98LMXKgFdA8RO3zfA1xzYceYUvrm9nGj+P1yXWi+HN/aXrVKE6Jm5ctuhUj
         1CocYbwqZRUI5ppQ77fA771SSPA3NpLUxbeh9b9oGSX/PPObLJGhtVpUFxts83h176YH
         QA2hOOSuBvrfncOKAKEfp+LmuKjLHkOVJmpUOHhGNeB4hVSwNZezICP4H5mWvL9dxkY6
         K6hw==
X-Gm-Message-State: AOAM53299ATcsAM/YWAxC0ZOlhAxqJbHjwUCes2BmeRUhIKmnK7dOJxC
        HyVEwQ8YwoPhAGSLz+cpe4B7oG3Sam8dhWFS
X-Google-Smtp-Source: ABdhPJyepw0+TLJfKX/A7nZXlDBAOva6kr7ttxA1t/TyDSL99kbtQ0cFNfWx2RMltx9YaeffhJqHNQ==
X-Received: by 2002:a63:602:0:b0:373:efe4:8a24 with SMTP id 2-20020a630602000000b00373efe48a24mr16340266pgg.287.1645582222469;
        Tue, 22 Feb 2022 18:10:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm17218926pgb.22.2022.02.22.18.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 18:10:22 -0800 (PST)
Message-ID: <6215978e.1c69fb81.9d617.e335@mx.google.com>
Date:   Tue, 22 Feb 2022 18:10:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.101-119-ga44dbfc77727
Subject: stable-rc/queue/5.10 baseline: 113 runs,
 2 regressions (v5.10.101-119-ga44dbfc77727)
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

stable-rc/queue/5.10 baseline: 113 runs, 2 regressions (v5.10.101-119-ga44d=
bfc77727)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.101-119-ga44dbfc77727/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.101-119-ga44dbfc77727
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a44dbfc777272b059e3d847de9e69963b8e51c74 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/621562cbd014c0d958c6297a

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.101=
-119-ga44dbfc77727/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.101=
-119-ga44dbfc77727/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/621562cbd014c0d=
958c6297e
        new failure (last pass: v5.10.101-121-g37c714b8817b)
        4 lines

    2022-02-22T22:24:55.669250  kern  :alert : 8<--- cut here ---
    2022-02-22T22:24:55.700138  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-02-22T22:24:55.700439  kern  :alert : pgd =3D (ptrval)
    2022-02-22T22:24:55.701504  kern  :alert : [<8>[   44.973784] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2022-02-22T22:24:55.701781  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/621562cbd014c0d=
958c6297f
        new failure (last pass: v5.10.101-121-g37c714b8817b)
        26 lines

    2022-02-22T22:24:55.753393  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-02-22T22:24:55.753669  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2022-02-22T22:24:55.754292  kern  :emerg : Stack: (0xc2405eb0 to<8>[   =
45.020975] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-02-22T22:24:55.754628   0xc2406000)
    2022-02-22T22:24:55.754932  kern  :emerg : 5ea0<8>[   45.032167] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1606913_1.5.2.4.1>
    2022-02-22T22:24:55.755259  :                                     c20f6=
79c ef78f540 ef78f540 cec60217   =

 =20
