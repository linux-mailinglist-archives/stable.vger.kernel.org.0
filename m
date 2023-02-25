Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077AA6A2B09
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjBYRN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 12:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBYRN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 12:13:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726911645
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 09:13:56 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p20so1418402plw.13
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 09:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2fxRJtwkzlqOiuvOTEmFJBX6xgGUewXaV0VLWO02iXs=;
        b=lK9U5Ci2+mSPI5zMKS81vzNr3cSqw7y7wSJJbSRW8p7uK1Bqz3qwkD8Y7z6HRtHeBY
         mbjUYtws0xWWCR810kbmfcvH6yH5SdezYlUocl6ABr6F5Yd49qAP2KVwRmGoIhFT5DrY
         zqPtxSwYzAACfCaPMVvnT5h6nIBUKlthtJbjG2+hzmNB2LZkRqLS/aUJPNZzmDbkmBsM
         0D0qvKpItHSZaUJB1l2HpnDXwULNHoaiZ0rM6UhRgKz7EAX+pH3mmCZPSTWhNYCi04ZH
         R7bLpttvH/jG3Q1m1zY8rC0vpcyucv/d9bQYploNG74PaI47ucbmqx6c9r6oJMpAG2cH
         lOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2fxRJtwkzlqOiuvOTEmFJBX6xgGUewXaV0VLWO02iXs=;
        b=u91ot/mB4D8XTpnGENRPomutcBPmoq9fIoIm3PbD6SMY5D1Zr88UnoW2BGko6beseg
         3hXkWOsX5ZeEkEP2+DF3C40tUN/Hxud2DUkOlU2+s0kOYPFImzdsHI16LMGSQJeC+Ky+
         KXnWQO3Vtxwyzfo8DlVwSLvk5Ur/VkWDhU+zKrQm+USNzrF+orJmBN6CHa/YpCYwyT9K
         OVKaMRSSjycFPxnjKWzgjvkOULiF9kdeX74ziOYLWo2AtC5YmOTluLPEMWxgw4tgRutY
         CLQoLPKQobaXdE1QVZ3GNNqQaFmW6nL8WLCuIvFkaYh5Bn9IK57DKQ5XWbRw4O7gjS4x
         /r1A==
X-Gm-Message-State: AO0yUKWn7OrcPWrgy1aZ75v6KVBerRWY3Xu8wmBAa64iUSCR1WCcjGgc
        wYu/IVhgZqIOn+Qp8b3V6llRhnV3+T0VMXPmCgMWEw==
X-Google-Smtp-Source: AK7set8bKw6UZkoclHgQKcrtJ6saMQGmJiIp4EX5BoNJvdRAQ3TCAWClR/U++QS0M3sQqAOpCsUk8Q==
X-Received: by 2002:a17:902:e547:b0:19a:abb0:1e with SMTP id n7-20020a170902e54700b0019aabb0001emr24464436plf.38.1677345235541;
        Sat, 25 Feb 2023 09:13:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b0019cb8ffd209sm1503641plk.229.2023.02.25.09.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 09:13:55 -0800 (PST)
Message-ID: <63fa41d3.170a0220.21e35.2124@mx.google.com>
Date:   Sat, 25 Feb 2023 09:13:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.14
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 112 runs, 1 regressions (v6.1.14)
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

stable/linux-6.1.y baseline: 112 runs, 1 regressions (v6.1.14)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7d54cb2c26dad1264ecca85992bfe8984df4b7b5 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63fa091ebf6624eefa8c8663

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.14/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.14/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63fa091ebf6624e=
efa8c8667
        new failure (last pass: v6.1.12)
        1 lines

    2023-02-25T13:11:38.190661  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 538abf9c, epc =3D=3D 80203594, ra =3D=
=3D 80203588
    2023-02-25T13:11:38.190845  =


    2023-02-25T13:11:38.227219  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-02-25T13:11:38.227409  =

   =

 =20
