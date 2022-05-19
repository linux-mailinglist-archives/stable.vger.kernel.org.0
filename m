Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5CC52DEAE
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244784AbiESUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbiESUtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 16:49:23 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0DD986D2
        for <stable@vger.kernel.org>; Thu, 19 May 2022 13:49:21 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u15so6063847pfi.3
        for <stable@vger.kernel.org>; Thu, 19 May 2022 13:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SI/n1v8mzKb3VMpIMLUI6Kg1Lp3lpg7IFPjtxGYHZPU=;
        b=Dc/XfN6K8anO5P/7hdR8e1c7o3N40MYyXhKfG/O87dBGBDu/JGSJVKKDwbZ79BT/QA
         RB4YdW70APdqjkyShtujj1skiWFz/jIPI+cysZ5nCJv2HhFLCLGMMMDxQ2r0B00ZpoH+
         s0F0vPbPSIcZ9QTHI4P2FAo+Gq/TMpt6NUsIdkQ2hz+q/KZ1UMiIghwTlqJdIkCDzkKI
         8h0RHbSf6TfE8pG322MOrAa7aVNrfAX7qMZqEg7suaYUoLMPjAcA/rQkZodLg5HdFYyd
         XONZti5zEmUteahBxx+DXqbCLELefw6L4kTC9I6s6HlyXoOAO05PAbYva45Wtq/9kyrI
         AARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SI/n1v8mzKb3VMpIMLUI6Kg1Lp3lpg7IFPjtxGYHZPU=;
        b=J2PoJJch6Orzf62x9hbqABvIE/+YW6bIxtulQPihoilVUJJdJ2EwaGaaTq/8Zt8A92
         Zn5Qav+JiWw1oNcGZBX8qImeHkOA02v5Ty/4FCJGzVRqe7BN7ivdSUVqZUqHu4OS+PTu
         qgvciIAu2iRonmC0drETExtKsb3X3GqGXxgT3sObpyDjs/kWLCG5a/ekX7EByJSyCGvo
         1Qw0Cc8QY4sTYrBA53WOeQgRHS5gWE+H4ek3UyEb6aSSalRXA8H9vuo/jBfjCA7nILXF
         FB+7Phd2BalZKugFpkpuR2eANOUwTQb8dVONjzntZ1VgDY5NgAMVQYuftYc6jT0dMV3s
         JB8A==
X-Gm-Message-State: AOAM530h9PpT+OSe7naWjiqsP3HOxWOTTghJtNAyzhU2K5uC6OagUHv0
        kRrwtZegK7R8e4++enK+pebbgvxSaJbF1OXr3LA=
X-Google-Smtp-Source: ABdhPJy834f/ZVF8IdzQrILCiWw3Ay0fQ5Nn5P0X6y8pJNoY7TqLKhce8um5dVqgv7GaENS+HmMjjQ==
X-Received: by 2002:a63:6981:0:b0:3db:1a89:8849 with SMTP id e123-20020a636981000000b003db1a898849mr5390347pgc.505.1652993360619;
        Thu, 19 May 2022 13:49:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902b68900b0016162e01553sm4115509pls.168.2022.05.19.13.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 13:49:20 -0700 (PDT)
Message-ID: <6286ad50.1c69fb81.401bc.9d11@mx.google.com>
Date:   Thu, 19 May 2022 13:49:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41-47-ga444b605ffd3c
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 101 runs,
 1 regressions (v5.15.41-47-ga444b605ffd3c)
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

stable-rc/queue/5.15 baseline: 101 runs, 1 regressions (v5.15.41-47-ga444b6=
05ffd3c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.41-47-ga444b605ffd3c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.41-47-ga444b605ffd3c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a444b605ffd3c8aa04a9379de519b965c57cf621 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62867ed70c25c9deaea39bdb

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
47-ga444b605ffd3c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
47-ga444b605ffd3c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62867ed70c25c9deaea39c01
        failing since 72 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-19T17:30:42.515234  <8>[   32.147364] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-19T17:30:43.542500  /lava-6425024/1/../bin/lava-test-case   =

 =20
