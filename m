Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF987547132
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 03:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiFKB6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 21:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFKB6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 21:58:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D32513CFC
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:58:52 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so675335plg.5
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iZLvS1Nr05AzMwC6h5YxKX8l6UJwBPeSbhmwD2th/0Q=;
        b=mQ6KNZykSU2cWeo6qJuQhn4ZCewXFWABHVnn9NxY94ulnGr8A7vbAy2WNCx44CQgqA
         bW8X6HwT/5P5JQPfCOPRfH4zPF8IVr2WVnTBeleIfvj8oUG26HMyLvmSKcRS3eNz24jZ
         QJJtKpKflfhzIT7sU1SQnoQKQ28Q7MhgAtp4K7aJO5HkjTKHzHPaipxK9GUiaVBURr2L
         O+NZMvchN4qD2L5O1K13AUqBl2r+cOniqMKrSCv+8Sgx5kbX8ToTJiyV0IM3I2j9luiN
         zoPhiP1OeOFfnl4UhPjME2qX8Whob7aNi0e8ED5wP0Un3K+H2/rXPMG+AaQMbEEXQZW3
         NlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iZLvS1Nr05AzMwC6h5YxKX8l6UJwBPeSbhmwD2th/0Q=;
        b=IImRTcrKJAy45SVS01Jh5Gx0FJPh3LCc+331GJ0zbjT42DJONeKMzf6CFJ7ggnC2+8
         ju91aP7Q4Ddejr5vMmTI5GVyKFd1SGhEt+PpcnzB5R44Xz5ou0n/3Gr21197krmoC/AI
         MQjw+lU454XrBH8DEFlfVUtFDukjtXxXMId2csNo1HdgD5slZn6/mLWzXk6V7OCa0+p3
         fvUbMlMWpQ3ZkuRpVAuki+wN6LDymyl9JW12AAqYVAdv5qtU4SKiZsIOO/fl2Y+8c8ym
         EsT+m/VEC94LFEE/cUrCAzcyqK6gD+gnpKbp3YbGmqXecUUbzOWsz3/yOoYbDV55U8Aq
         N79A==
X-Gm-Message-State: AOAM5326EUxQrxcM6hU8cGO6L5F6msPQ8c4crCljOAwaGJoCxgZhDqE5
        3GvIcZjBpkb0P/tOYzNBF/natHU+Yk0w1x8vYQw=
X-Google-Smtp-Source: ABdhPJxEHWZNjKKJCc+wceRqvGyVvCIOJCpDJ5xPaVbUrEsW16GIHhlTQYZVnDs7qzSemvjRUA4R0g==
X-Received: by 2002:a17:903:2444:b0:167:5fe8:4a16 with SMTP id l4-20020a170903244400b001675fe84a16mr36757570pls.20.1654912731958;
        Fri, 10 Jun 2022 18:58:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3-20020a170903024300b0016784c93f23sm369557plh.197.2022.06.10.18.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 18:58:51 -0700 (PDT)
Message-ID: <62a3f6db.1c69fb81.ef685.09a7@mx.google.com>
Date:   Fri, 10 Jun 2022 18:58:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2-1057-gd2f82031e36a5
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 116 runs,
 1 regressions (v5.18.2-1057-gd2f82031e36a5)
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

stable-rc/queue/5.18 baseline: 116 runs, 1 regressions (v5.18.2-1057-gd2f82=
031e36a5)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.2-1057-gd2f82031e36a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.2-1057-gd2f82031e36a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2f82031e36a5efe1e87553f2e65a1b152c82877 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62a3e9cd2cbb1b5696a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.2-1=
057-gd2f82031e36a5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.2-1=
057-gd2f82031e36a5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3e9cd2cbb1b5696a39=
bdc
        new failure (last pass: v5.18.2-866-g0f77def0f4d00) =

 =20
