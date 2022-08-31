Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D697E5A879E
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 22:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiHaUkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 16:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiHaUka (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 16:40:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B7884EC6
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:40:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h11-20020a17090a470b00b001fbc5ba5224so421725pjg.2
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=+I6NmwuARd4FaF2EzRJLTN/t4dInuq2lL1JD6859LrM=;
        b=uwvyIU60BHAUpDC44G8qipPuyiU+XWLcsoE5fyXfMEgMecymdgSX9k3fmm2p/ErXP1
         3xgi4HiLmzOwA0cuo3kV8NqszDpr3LJ4/P9g5Zy5T0x8qf3ZelcuRBlK/WC1LH29iQNH
         IMBQa06noNUzSrLoYuj5YkyGmFUYjrvoIVQDH4BA52u6AYSWiC2BtHH5lwSWUoNPNJ5n
         nBDiPDDwMYBboON9wfrH36PlbpyhOvmVho1j8mBCBqMlA/JOfInjm6G8pyq33HZclRoG
         KB3EDd5g0Mb52h02kUcU7KgsScl30qE7ZORew29DjB3iQV0p+A70b/qbN06TzQ9PXFSu
         R8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=+I6NmwuARd4FaF2EzRJLTN/t4dInuq2lL1JD6859LrM=;
        b=Pnmu35VNZ1wrXuCSNqRyjkcTYkpnF/HUS+DH7IotDpOBeW0wAsjpSZQtAlVaPoqD5j
         40WYU/5+QwTsTwJfS/oUDBb6+g4nVztAy5zFO1M3MpoIZbrbOEP4iiprU7LQUEfGkdj/
         3difa1GgtPVBpRIT/EfyBieQwCpxQOrih91FUVAI9+yjj00qN/HpWOg/QxJfePgRKBe9
         YSv0TW5Sy0Zx1f0kdd2HTZcvtVxrHawGLLVE3AS9emdeVKauseAyz9lMRET/nUVGvNCl
         vcFr1WkrE/I+roPHVkB8ML34ZOIED7zzvNeuxAZzAowNnVs060E4dy4dz/NxMCXv62J6
         Ywiw==
X-Gm-Message-State: ACgBeo0oxrdoEVB3itb4oLYHY0EhJMRdgIGX13KgRt+zvigvQUl0kMYC
        XQqzWZPvEcD4heOK5Yha3Ndg6aYqJ9cUbP4lxzQ=
X-Google-Smtp-Source: AA6agR480Vzj8+UEFGxeCl44UDN2wswnbxsKtxz2zXysIGGcXRu8lx6m5NEHiLHIFAis6x4uZhwgtg==
X-Received: by 2002:a17:902:74c4:b0:174:90a4:8a9b with SMTP id f4-20020a17090274c400b0017490a48a9bmr19166263plt.147.1661978428318;
        Wed, 31 Aug 2022 13:40:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902650d00b0016d6c939332sm12011394plk.279.2022.08.31.13.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 13:40:25 -0700 (PDT)
Message-ID: <630fc739.170a0220.bf1e3.6936@mx.google.com>
Date:   Wed, 31 Aug 2022 13:40:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.64
Subject: stable/linux-5.15.y baseline: 172 runs, 1 regressions (v5.15.64)
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

stable/linux-5.15.y baseline: 172 runs, 1 regressions (v5.15.64)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.64/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1ded0ef2419e8f83a17d65594523ec3aeb2e3d0f =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/630fc039627b5bafb6355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.64/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.64/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630fc039627b5bafb6355=
652
        new failure (last pass: v5.15.62) =

 =20
