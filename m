Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC845D562
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 08:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhKYH3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 02:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhKYH1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 02:27:23 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95098C0613E1
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:23:32 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b13so3875517plg.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nt/wSdwzpvDo16vokskLQGSF4PGvL+mkGHz3CgSHvAQ=;
        b=ptTwL1V/BncxUhzBakKgTAJ6jY2vRVObwaL5VqT08tK0LL8rgmmvP8XfKNfcPa7AXU
         SN7cy8lXKxymK1FUu/M6O7cCU8n9r6+BPSc87G3EkfNuWlByyCtBHvSthtqBgIfxcQDH
         F7Picm9SNuynMIvInzONDeZUWeZnq3HVCzZfRmMP24TALKIuHzz4McwZOHXG/UrlCJHM
         x1pgRlQVXP6WPmbZiV0WILCu5KvktEilwKmKsqmFCC+09kVZ2RGFJIv6jHkkjw2yLRqZ
         J6WledZBTeNQiKkaivPsJC9tJKhrgW/Ff5l0GtEnVyrXGOCQ+gX9mj/QvikP83ZHFaiz
         yc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nt/wSdwzpvDo16vokskLQGSF4PGvL+mkGHz3CgSHvAQ=;
        b=EsVbqRW7PfkPVDe2iTeMtH3/z6rK0vuMdq0Cd01x4wUfHR6wo/IkwqwIVUcr6lqmli
         oS3p9aKIcgjqIn1WhGfvrFZelsPjfMt4td7b9zpGQe+Bul3Yfe8g7XcSqNY31FyReIsv
         Fqrz8YNkZr5BbiT8O9SWb17x7Th4MqQCUJcgnKI7b42bi7gYC0Ymq9E18VC6oxWMAdh8
         gdNORfzloj+pNKgawL8HvfpGFyYYnclumJhLKzEbHwLqssrDs6yotYC5TKsGGYit4ZE9
         U2+N8UaOd91b0CSrdVzzHR/b+YWUDxTiSpgpN5RkKB1pivPHWdYH3+denww8L2V6TLeY
         pZfA==
X-Gm-Message-State: AOAM531vwECgRsZaEspglg8kFeOFGnK70rzfADQzIUXsiuEacBwGNV4k
        MTS8vQiUA2x2WMBnFRzAywjkRu4uncJVwYvqDAA=
X-Google-Smtp-Source: ABdhPJzguaGQCnCTURfOmHDTiTtUPItgYKUvjPPC4o0LzLHSif3oX49K8vdIy7hAqM4vJWk/3RDwYg==
X-Received: by 2002:a17:902:a605:b0:143:d289:f3fb with SMTP id u5-20020a170902a60500b00143d289f3fbmr27177046plq.41.1637825011939;
        Wed, 24 Nov 2021 23:23:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm2057578pfv.131.2021.11.24.23.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:23:31 -0800 (PST)
Message-ID: <619f39f3.1c69fb81.80d16.6815@mx.google.com>
Date:   Wed, 24 Nov 2021 23:23:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-248-g76c25700e43f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 105 runs,
 1 regressions (v4.14.255-248-g76c25700e43f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 105 runs, 1 regressions (v4.14.255-248-g76c2=
5700e43f)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-248-g76c25700e43f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-248-g76c25700e43f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76c25700e43f1b0bb3cdef6f7b586cd91d157445 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/619f06ea718d7d9af5f2efb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g76c25700e43f/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g76c25700e43f/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f06ea718d7d9af5f2e=
fb9
        new failure (last pass: v4.14.255-248-g11189523779ca) =

 =20
