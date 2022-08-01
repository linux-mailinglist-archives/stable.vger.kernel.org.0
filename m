Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8958739C
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiHAVwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiHAVwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:52:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB823C8DC
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 14:52:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t2so11702896ply.2
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 14:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DSjx5ESRkE6J5qM9SItlC8+3YSKs3/SsUSl/zYm3BAs=;
        b=ms7qqoRASU4lhk9WzLC/YQaIdRaDXA8MutDBwJHozc+cperoDIRIyuUQlj42CNgpCl
         J4KLnCD7lhAdqrDV3nSqeuNACp90CTYGxWi6kZuQQFug3aqlFabiyhOxr+VgI6vn1tr6
         dKRlYrhBjBChyDJZm4kZ1Zn1Qylb4FXHv+AHLAyB4XFwGBMnABcu08G55CQu2Dr/QfsY
         13YHY76g6LFwOcjbQCkOc0V1Mmhv2or/608WzquBkuSypb3ilOsMyJGVs24b8BPsWj4Z
         uY7Zy2PjEOmVkwRxUH9J5X+HAZH6Q4nwuL1zeXnpHUwhjogSLXn4SDo2mT0uFn+8uf4K
         yJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DSjx5ESRkE6J5qM9SItlC8+3YSKs3/SsUSl/zYm3BAs=;
        b=EnOopcYdSpDNtzmJSdv9HKEvPkI8yjN0/xueJCJchjUrxu6fJrI2kYgkJpl4pzwMQe
         BVUm23nmDY/0/TGhuSrBc8MJcwbHCbdP5rA2h3zJPl7n+TBJLLxtYpbbZ0HlUdtHDn6L
         n7yBBrhQ60BNl++z0OlW58jenkj0YDzGosajQxxDunj32pkXBe+Ix/2A8F32vlmGFSOu
         pO9ljqAgTqEffC/hYVCOTEmeBILRnuJYP50aHnUsHVyDHC0kU3oSP154N2lyreVp1FA+
         1338peNfmSHz+I36969BZfNbrMXBB+RIT54ueQ3UEMMQK7q2lJSjm8LROdWS9m+N6sja
         gujQ==
X-Gm-Message-State: ACgBeo1HQmFySGbBr1JAoNSXAZKzeAnN40LmXq6IF6JCprNM4GlkzvN0
        pZKaMK/SQXXpE48SFj8LFn8cxUmHxrZGH9jdBfM=
X-Google-Smtp-Source: AA6agR4GzsnEphrO72kg6NkoSLbVpDKfEMURgXj31qLbskLdoFZw3nGF5DDzmZsCCQpD46qwSOSNKA==
X-Received: by 2002:a17:90a:540c:b0:1f2:26f1:6a37 with SMTP id z12-20020a17090a540c00b001f226f16a37mr21079175pjh.68.1659390753274;
        Mon, 01 Aug 2022 14:52:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19-20020a17090a4a1300b001f329d1c54bsm8489926pjh.6.2022.08.01.14.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 14:52:32 -0700 (PDT)
Message-ID: <62e84b20.170a0220.ee3f.cee3@mx.google.com>
Date:   Mon, 01 Aug 2022 14:52:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-247-gf2dafe30428d9
Subject: stable-rc/queue/5.18 baseline: 119 runs,
 3 regressions (v5.18.14-247-gf2dafe30428d9)
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

stable-rc/queue/5.18 baseline: 119 runs, 3 regressions (v5.18.14-247-gf2daf=
e30428d9)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-247-gf2dafe30428d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-247-gf2dafe30428d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2dafe30428d9a388867711c9a1be6d1e38f84bb =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62e822c4309f6a8e79daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e822c4309f6a8e79daf=
05b
        failing since 26 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62e81a0ad8231e7d44daf07e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-i=
mx8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-i=
mx8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e81a0ad8231e7d44daf=
07f
        new failure (last pass: v5.18.14-247-g0a1610bd15a5b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e8199207c7fbf92ddaf078

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
247-gf2dafe30428d9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e8199207c7fbf92ddaf=
079
        new failure (last pass: v5.18.14-239-g0cb79a713f90e) =

 =20
