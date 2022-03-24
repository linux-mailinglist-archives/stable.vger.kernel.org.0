Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD994E68B9
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 19:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbiCXSfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 14:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiCXSfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 14:35:00 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074102AE1E
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 11:33:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so1332276pjb.3
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 11:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rp82rgzPU9y1IcARWONNzhvvkafiZuMugAN3elclwTg=;
        b=2R0SjJ6d1YaVM4oDome6Unhdk27DcV8yqbJl6mJOq++HwEQtUq305tBowFdOmCi/c9
         kqeu0d1kOTKjOdxIP8NwC1p62aaBf+t/3b/WxkHj5P3hcFcdTdD6PPiBsizYYfRAYV4A
         Y5k1KSAPHWGL2gIUwP9NbuoiKAC9lWUnudhjeckgsb3mQpGmGJqqipBuIbhMyP2vNEVa
         tig+gmIaXZV+rj7KxNn01vm6V4QCHhc8rq1M2Gc4Jexro12TvQhvxsQ6nGfz1IJCMGU0
         qq8OalKLL4wCXfIIdVj9XDWTzSmSJFZa/rYKaoDFpBIvy/ETU4H2MtEWKt4qRZEk0F7j
         Zc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rp82rgzPU9y1IcARWONNzhvvkafiZuMugAN3elclwTg=;
        b=GgdzbBFOyDHwAVtks+xalbe7Xdd7zGaKA0vlD4D3ruDKES2DrmooTuzTnZqGdcy8RT
         n/RdB/z2RvkNfHjCWVU9HwJAD2zkVHJZNs4+s2ybwmk47JEpNMG6y3kbmVGJoArDpxPc
         8Q3riwY4YssCUksCMW6I7Nq/zlWsRc3EeLkkX8U0nblilUtx9UHxgpYZgfbcTzE8n+yO
         HJzuh37/a9FIsxeGk7Qq93YZI56xLE1lZ0TGZYwjVYIzqzAyKDDDby1rgEkQhz4mVEEv
         o7fqx5rvWf885aUTZKbJAjkJgLZc5WALxdD6YKoYWoaZhJnAnkVFoq0VmRQ/3qAq/OhJ
         QhLg==
X-Gm-Message-State: AOAM531R0vHwAz7V1+ZKffKrdukVj/PYQVCvR15pQXPBjJJRa7gzI5HD
        WZjHe73Lm0E6oLemD9zG3prg0VoffVzWlHQHkXg=
X-Google-Smtp-Source: ABdhPJy6/hZ/30yIr+kUgDOeVwD5pGd03XJ0OinTLOSNtvmVb4Cy0Mc6FCRauL4QjUi7lmpbH7PKhw==
X-Received: by 2002:a17:90b:3508:b0:1c6:e4f9:538b with SMTP id ls8-20020a17090b350800b001c6e4f9538bmr20342522pjb.158.1648146807355;
        Thu, 24 Mar 2022 11:33:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090a65c700b001b936b8abe0sm9770985pjs.7.2022.03.24.11.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:33:27 -0700 (PDT)
Message-ID: <623cb977.1c69fb81.d8a75.ba62@mx.google.com>
Date:   Thu, 24 Mar 2022 11:33:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108-6-ga011512dbfcb
Subject: stable-rc/queue/5.10 baseline: 98 runs,
 1 regressions (v5.10.108-6-ga011512dbfcb)
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

stable-rc/queue/5.10 baseline: 98 runs, 1 regressions (v5.10.108-6-ga011512=
dbfcb)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.108-6-ga011512dbfcb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.108-6-ga011512dbfcb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a011512dbfcb06ec266b79079430e99c3178c693 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623c876a892fc6f150772510

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-6-ga011512dbfcb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-6-ga011512dbfcb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623c876a892fc6f150772531
        failing since 16 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-24T14:59:40.458698  /lava-5940407/1/../bin/lava-test-case
    2022-03-24T14:59:40.469487  <8>[   61.125403] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
