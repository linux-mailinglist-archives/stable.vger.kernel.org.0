Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D004EC680
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbiC3O3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245102AbiC3O3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:29:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAB421A8AB
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:27:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y10so15519640pfa.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z2fQ25cg++TK6tsVAXOjdc1vEMrWUelglnD7RfLt0uA=;
        b=sUjlHbXCpjeAlTrDky9unQDnF/4eGf3tRZAOBri3QhZpxxBe+qhNt3XAKEhpkbmgoU
         f1M0U6RZ2HxP30AO5lG5phBh1C/rtdQ3XveFrWs8Be1WFMLGkKJsgKr6jnrme+twrwCt
         5NKzV+LUW7KCNfk34LgEMuZRU7dP1qkeNYqBYsBt+h2yn+B3XCc/S/2+MvIglvET9PQk
         8QW5Bb3TcatJwMeecxwWPfs0tQ8SJGoNXve5ACP1G19Cyf8dOEi5Cd578fud6ZhGA6WY
         CZdoXkiRgifnmMstzWoFTFTtSZFt0Fa+jez246AY6y7NylSNxkdJSMrkz3Zn7gnUSx8M
         gAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z2fQ25cg++TK6tsVAXOjdc1vEMrWUelglnD7RfLt0uA=;
        b=3bi0HPvwaB/tLsxkrg6/QM+rxRK4Km6dnu1To+P+Yo0bv4OYLuSdHfj/8cgahuPE9K
         6tEWy0zTJBX61HQLsZJJZe93Hu+O9M0dYTt93tsPv6As5AWFumfFcmH16uInUJbs4U9t
         1CZq/GgSq2EODJap4Wbt6e22/ZyxkwlNtqJqFTCNS4LghFLoQBa5Ywkj569nG4mWlq6T
         CwJI6Q7u9n8JIkPt6ZIVwv8zyaQnKo5CmBpj/3Pm09Q0/1199XnTww+4YWUVUHM2hDlk
         402HkQd9JPO9cCzhoLJWxljt2s5ywPaeFU48vybz4hCJXRmFDxKUwxbZLzq+jtfi33n9
         Ef/Q==
X-Gm-Message-State: AOAM533p4tLFHZKEHIXS2Z7WZYClPaEpkvPUDDngvwu+1FfuBa2gf+xe
        Li1U5ra3KOebwoY8HpP7fhJPU2tb5oFjwkqyj9w=
X-Google-Smtp-Source: ABdhPJzUprD3zvaVT++AzmNldh3ABNMJTRNfL7B88+5ThMvHsi9GNdppmgIlF9k06/rRUi04j2OGUw==
X-Received: by 2002:a05:6a00:b53:b0:4fa:ecb7:1deb with SMTP id p19-20020a056a000b5300b004faecb71debmr31623683pfo.80.1648650446076;
        Wed, 30 Mar 2022 07:27:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7-20020a056a000c8700b004fb55798f64sm13002100pfv.90.2022.03.30.07.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:27:25 -0700 (PDT)
Message-ID: <624468cd.1c69fb81.84747.e2d7@mx.google.com>
Date:   Wed, 30 Mar 2022 07:27:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-28-g5cb7a79fa6cb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 97 runs,
 1 regressions (v5.15.32-28-g5cb7a79fa6cb)
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

stable-rc/queue/5.15 baseline: 97 runs, 1 regressions (v5.15.32-28-g5cb7a79=
fa6cb)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-28-g5cb7a79fa6cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-28-g5cb7a79fa6cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5cb7a79fa6cb63b06d30a69cde808b3b92c9a37f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6244336e0b64a238d4ae070b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
28-g5cb7a79fa6cb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
28-g5cb7a79fa6cb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6244336e0b64a238d4ae072d
        failing since 22 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-30T10:39:29.787691  /lava-5979525/1/../bin/lava-test-case
    2022-03-30T10:39:29.798652  <8>[   60.903942] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
