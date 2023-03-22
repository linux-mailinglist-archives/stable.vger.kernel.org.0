Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCD56C56DC
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjCVUKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjCVUJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:09:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1FE768D
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 13:03:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s19so5971638pgi.0
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 13:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679515331;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sgDx92AIit2JbrTDZC2atPWUWKziwj30hRoJPknHr4g=;
        b=C4Q4tamvHEhN1uzqSkSM2+x8xJBUN0aeqZc0I4wZ8uFj8OdFDkUPwkdaNSA44Fpuwq
         fOHvWpvFoPSMsRJVSbduKJ1A3N603Zd6Sppj7bJ1iH+frCXkyQWfSiwUV6aRfCzT0+I5
         7X/qWRxWNHZPRbm2Iyy5Lh1DiQbe9XS/HG58+vk3vz5wP6FRwgJeK0CwB2HGuvfAxhBp
         6Zay7wfx2mP+qCF8GOKk6sUCr4rI564wbPnEDe11J21uZyK0SYKhvuTyPugrWq8WgImz
         zWRibDX688BBL2RiByUIDghBQyyzTpAp7DrkD/1mfPUt35Vy81uhJg5c+quydgGkwIOh
         i2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515331;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgDx92AIit2JbrTDZC2atPWUWKziwj30hRoJPknHr4g=;
        b=is48sd4rOg1A89Pvjo2qsVzDn7yNkxI6sa7AHLRERTVmif59s4p5pXiPqYo/IcjSF2
         pZjsFa0OMcsR4aGhYt+E6HIE7GkrjQbTisBp+qIg4XBnh9AZdG6bkhXEYRKgYY2kFHcn
         4W9HdfumlbC7OBDzNtboy/NmxoFYwfkwaBOqZUVOtPKkUIvOyM59WSE4ytfndcCQ2wUV
         cyjD3fcix6Ml8Ts9+qBBOYTHgDR/Imyc53h0M+WSXR+CKslDqcoeNTbD29qNbq5Ne133
         p4oIrA2lX8dsze2bOtzDUW6/VfmmmptIv/xKunk4mYPpOGustdbw40dzoG74Xi2jFSLY
         Nctw==
X-Gm-Message-State: AO0yUKV1blsRDE8rvhT1/xhxNRFYKz55jpNhbrPdXfAMxRkFxFwkAeCl
        J4OtPL24uSl+/9hxvTDS0avsY8wD4kyac+DhtGYHAg==
X-Google-Smtp-Source: AK7set99jAfOlcQkq5fTkFoJ7UR3xIUBvq+XYaXHhGfxF8TwaZwfhit79LNFxaY09/vDA8idF/YJgQ==
X-Received: by 2002:aa7:9470:0:b0:628:1a59:4c1 with SMTP id t16-20020aa79470000000b006281a5904c1mr4336785pfq.13.1679515331262;
        Wed, 22 Mar 2023 13:02:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v6-20020aa78506000000b006251e1fdd1fsm10394890pfn.200.2023.03.22.13.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 13:02:10 -0700 (PDT)
Message-ID: <641b5ec2.a70a0220.158b0.32fe@mx.google.com>
Date:   Wed, 22 Mar 2023 13:02:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21
Subject: stable/linux-6.1.y baseline: 187 runs, 1 regressions (v6.1.21)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 187 runs, 1 regressions (v6.1.21)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.21/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.21
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e3a87a10f2591f296d1a50c5af6820e2181d564a =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/641b2ae33158c699249c9543

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.21/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.21/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b2ae33158c699249c957a
        failing since 5 days (last pass: v6.1.19, first fail: v6.1.20)

    2023-03-22T16:20:15.869758  + set +x
    2023-03-22T16:20:15.873529  <8>[   16.854511] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 208374_1.5.2.4.1>
    2023-03-22T16:20:15.989809  / # #
    2023-03-22T16:20:16.092507  export SHELL=3D/bin/sh
    2023-03-22T16:20:16.093464  #
    2023-03-22T16:20:16.195208  / # export SHELL=3D/bin/sh. /lava-208374/en=
vironment
    2023-03-22T16:20:16.195664  =

    2023-03-22T16:20:16.297008  / # . /lava-208374/environment/lava-208374/=
bin/lava-test-runner /lava-208374/1
    2023-03-22T16:20:16.297892  =

    2023-03-22T16:20:16.303631  / # /lava-208374/bin/lava-test-runner /lava=
-208374/1 =

    ... (14 line(s) more)  =

 =20
