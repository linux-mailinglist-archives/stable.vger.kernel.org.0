Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF54D688D
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 19:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiCKSlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 13:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbiCKSlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 13:41:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84BCA186
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 10:39:56 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 132so8152784pga.5
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 10:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Kw1rGULw6cGM8j/8B+a1F7PqUVbwjqEb2wtzmiJtv0=;
        b=6L4A4V8KwaPTtYKbLnxuKNWj/EqTPN/e30Knyiqh1O5BFlThFdM/KedLjigt9Egfsi
         AiLk2hJmUzi7kRYJzpRc6yimVQKFwR4EmSr6AURlmaButhf+FCy5sIi8I1m3heDScqUd
         RrcSUKQBrTWegrDllUMjyRuregodfd/0oYY5effFUmYBC0VjKG3y4Ztxp180myjx1yJM
         I8mqW3V996CKmmVHSDXjjEu0wuDXifI9vicr3J85g53xle7l++AUrSIGXT4osE8I+5q9
         1cfboSHnmUERDQ4HkyV7JxAEmbmcUbIQzjqi7kKpaGbMK+ycztUJacbvKXgOlrWi7w25
         VTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Kw1rGULw6cGM8j/8B+a1F7PqUVbwjqEb2wtzmiJtv0=;
        b=Rn/D3EsoyF9r2BoV4t2uTEIZAZpkMiS5JQCqCo2FRexX4Z0eA0R40l0Uz31v/qV3ix
         GIalWo8E2LW+9eQrhvIvsQ4eoPdxNbSuN+/olURW6IlNG8F38qW3HVyQaKt8uDXNiutL
         W9nzkRK2GWu2+XXUuHStT4sAQ5czQL5ByBncEXcK1lNcYtV4hpx3QxGu+h1W27HkyY8n
         A+BoH3jSmcaXc5rabkxFH3lYIXe8XsDG0Psdy1e9RFOj2C/9WknrCbVBHzXt6/fnTCWk
         3+lTyCDQTzwmLVtL5fdvZFCdp5MJqMQhaVZCGN5Awu2nHH0P49q1lwUT3JZkRKRYhWsW
         1VQA==
X-Gm-Message-State: AOAM532XN0DOoMRDMXtN6C7dLmgiggS/Ar7EbMhb+8DDBM415O9zasL0
        rU9nTXWWQOWyOWFZqwUAjzbXQaqVMbk8FDEYWlo=
X-Google-Smtp-Source: ABdhPJywZk1q0kbCaioUGnJz2UrYiX90d3drKvQADAnLn1fH17zn+17aUbm7YMkGvUJXZBQ+Y1zGQQ==
X-Received: by 2002:a63:711c:0:b0:380:fb49:3c2c with SMTP id m28-20020a63711c000000b00380fb493c2cmr6259718pgc.428.1647023995989;
        Fri, 11 Mar 2022 10:39:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lb4-20020a17090b4a4400b001b9b20eabc4sm10754254pjb.5.2022.03.11.10.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 10:39:55 -0800 (PST)
Message-ID: <622b977b.1c69fb81.f09b5.ba30@mx.google.com>
Date:   Fri, 11 Mar 2022 10:39:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-58-gc5c63ac732e2
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.104-58-gc5c63ac732e2)
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

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.104-58-gc5c63=
ac732e2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-58-gc5c63ac732e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-58-gc5c63ac732e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5c63ac732e2ad54f8ccb07163c746d90f36295e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622b60fe21cc3c0f26c629a0

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-58-gc5c63ac732e2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-58-gc5c63ac732e2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622b60fe21cc3c0f26c629c6
        failing since 3 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-11T14:47:10.159142  /lava-5859734/1/../bin/lava-test-case   =

 =20
