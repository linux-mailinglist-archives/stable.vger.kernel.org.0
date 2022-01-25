Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7510A49BE6B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 23:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiAYWYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 17:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiAYWYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 17:24:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092B0C06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:24:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g9-20020a17090a67c900b001b4f1d71e4fso4250665pjm.4
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=98SLZdaP3Jkcx24Jl27cFkSiHa0dXFT87x7ZzPMyOJ0=;
        b=XBmqJpnnwOVnd3MQG7tq2Z/P8Z7M6lv7dp9suRSMho/krwSMS22Kc9OTh4i1yv4h4K
         Cv1UxKFvWywsEn9hn0TCPLSZVM6yp0+x/raqCsOx9di1d9oifDcuQFjtzxIzzTCopZ2U
         izRJgoqfTddeD/kKeKKerMiUyh5zxS5tt8I4HLjgyJhR4fl0iAj/oyD1qO0nPhvwG3Iw
         ApoZ+wwcd8+3e2be6472Anl4jyaX3+4wTZ5pl+Mr87NjSfrKs4GDc1WEYhsvKqBn6wpE
         9r0twcbaxlqoBsDVO3HZ7PIC/nHTGYsR6WLA5C6O9LsTNNZwCRaTWSF0KAI8oAYR+tLC
         BOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=98SLZdaP3Jkcx24Jl27cFkSiHa0dXFT87x7ZzPMyOJ0=;
        b=1oboTo9GIMp7a/hnsPy9nO68btgPU6m4rwuDF7EjEpyc4nnR1coVmCKwyZW7o39a3r
         49tsoGncbajLmsUwmAYmXLhLTSradwSX2nrJZCW5xJ2DgCKCMn0l0h5N6+Si0SyXFueq
         N/gA5XjwnMEPAwXQOm1n5MJrZ2OQOiihNF0QyQmDWC06bJLu/u5PubvT1JXIqX9jYYN6
         1eYfgGmClZlW2OJXXC6V1wUMOeMOG/LK9Rz9VlqxsQYAzc3o9MkannDE90o+zJeX76Ed
         uJF1UOu3Bp6nn15oA0tiQbmBiwC1Hjq1gz6DhwXFTCbtjoEgpqql4IrHzVvZ40LuRQR5
         56UQ==
X-Gm-Message-State: AOAM530qXtNB41+Qp7Ergzn31JkdbRyNFdKG9/oObSLYbbpiqms8WMFr
        H3iupC9ZPBg0YPxsZSciHXcqST/zSGLD6nlY
X-Google-Smtp-Source: ABdhPJx9eMYtDG/QhA6kmgGBouKpgxCrsnzSS+OaPGsvu12EC0QJa9ev2C5EIy9oWB8HocZi/DrI5g==
X-Received: by 2002:a17:902:b184:b0:149:be5f:c6f3 with SMTP id s4-20020a170902b18400b00149be5fc6f3mr20081035plr.174.1643149439398;
        Tue, 25 Jan 2022 14:23:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm26196pfc.188.2022.01.25.14.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:23:59 -0800 (PST)
Message-ID: <61f0787f.1c69fb81.1925e.01b0@mx.google.com>
Date:   Tue, 25 Jan 2022 14:23:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1033-ge4f2c5155f37
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 150 runs,
 1 regressions (v5.16.2-1033-ge4f2c5155f37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 150 runs, 1 regressions (v5.16.2-1033-ge4f2c=
5155f37)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-1033-ge4f2c5155f37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-1033-ge4f2c5155f37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4f2c5155f376c65f371fe5207fa10b0d1f0f642 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61f040597bb2565ea6abbd58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
033-ge4f2c5155f37/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
033-ge4f2c5155f37/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f040597bb2565ea6abb=
d59
        failing since 2 days (last pass: v5.16-66-ge6abef275919, first fail=
: v5.16.2-847-g4e4ea5113e47) =

 =20
