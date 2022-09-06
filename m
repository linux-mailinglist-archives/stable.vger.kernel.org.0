Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1B95ADD36
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 04:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiIFCRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiIFCRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 22:17:38 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4566B67B
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 19:17:29 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 73so9394953pga.1
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 19:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=MUD2dQ0iCjuQ+facOZ0aRLY8Wd7+Y718oR3UwVIPyT4=;
        b=zvJMoT4wUgme7TLJ5Tc8DkYeD5xGh+s0FtQ96l8ZNi40a3a+hZc5p6dxYEPHGAPI5x
         KBJEl4NoI1CScRVyjh2/lFWJSHrlBcDyiuTJRzapCrri0MjlnJVaYRqi4z+8UZf2REJb
         4bHx8pXnK4U4DOzIHQVPM4JXcd8ipkp9lXTEakGDjJJz3VufmviXaHl3OnYgelOa5Il5
         HG3UTko4PZbOpi08S6ebPWLpY3Nw/DyHKk64VZhBF2NrqTqDXcVjvalllPevf724n6dB
         WCKjfCMIpdwquaMIlN8o2mBmytDd1n7G56+LOIGQskLQ3ZBDHv1gqeMQTgpFrMWiqOeT
         /CmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MUD2dQ0iCjuQ+facOZ0aRLY8Wd7+Y718oR3UwVIPyT4=;
        b=yQTc4QBhHnm2jT82iuDWN1h/xz9vk69LatRK435Z6Xx2GHsx/MEVXo046rWvUz5bFV
         HCm56oMUoGkiIPvpldnS0P/m2CA2K88WqDgiaE8QyEWHZcmfEqmJA1O7C0+omqKDZ4Vg
         fCw7TWQzkWSEASndt/nQiHZ4BZQh0xBstxFQPCso6BHuu50EX/fBioIjb26QIWGFJkBe
         PgOQAOCobYqtHt/9iN7Yolfjb4U6p/ai4S4cIcosFR8dtkTks0NgR23qyjLLd4376woS
         M1VFIsW+q3N8XiRVeTZBx6EKHYgJAnn8cxEw42m3lKaz+OyaDLLpamqFYxFBscDSvm2R
         g5eQ==
X-Gm-Message-State: ACgBeo0kyD3Oz0n5n29m7c8iPI1B3exFyTH7QVF7G+42dnpCkLSGghG1
        6CPU4i+rtmE6UvZqoAYWcKdEEyQcQ0KHFu0SLso=
X-Google-Smtp-Source: AA6agR66Att37/i9yQaGyK+IZfcWvycfP9w+QE5l23Ddh5GzhWgv6amBx/xnG04xtkWHBtrX6b0Rzg==
X-Received: by 2002:a63:d418:0:b0:42c:8166:9069 with SMTP id a24-20020a63d418000000b0042c81669069mr30233454pgh.66.1662430648711;
        Mon, 05 Sep 2022 19:17:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s128-20020a625e86000000b005364c8786b7sm8476147pfb.215.2022.09.05.19.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 19:17:28 -0700 (PDT)
Message-ID: <6316adb8.620a0220.feaac.d373@mx.google.com>
Date:   Mon, 05 Sep 2022 19:17:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-318-gb22688ea1c79
Subject: stable-rc/queue/5.19 baseline: 127 runs,
 1 regressions (v5.19.4-318-gb22688ea1c79)
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

stable-rc/queue/5.19 baseline: 127 runs, 1 regressions (v5.19.4-318-gb22688=
ea1c79)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.4-318-gb22688ea1c79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.4-318-gb22688ea1c79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b22688ea1c7944d952973fab17e2b40e76e544cc =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6316903259d7fec7a3355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
18-gb22688ea1c79/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-3=
18-gb22688ea1c79/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6316903259d7fec7a3355=
646
        failing since 20 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =20
