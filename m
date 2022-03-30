Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53EA4ECFC1
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 00:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiC3Wil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 18:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiC3Wik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 18:38:40 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA357144
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:36:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u22so20176122pfg.6
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DQ0CBIUENlnxszxblZGMK9Fiucf9BEsPe3rmSRMVdwE=;
        b=McubRo55sHP1SzvQIJ1Y3VCXFmlkXPHtCcozFjyGuSHe+23x8688FmqxavVCCwMSGA
         TxhjXcnPlMDFkhDkv5sIRi6mm7P+ki4Dn+AbzgCQUGGR/8u/kP8Plx0wSztuDaGkESKo
         IUHqmjkGLsFQnU0Nn8ShgRWxaOop1nVfVD8iMWdc4MDxVIDBj//tclCvPlhrW/XMRAAq
         sIFsC1UWRv8lMnndQSzfCAJaIBxGLvg+9rng1LvM1jETyqLrlWZNvZ7ifkhx4b4XO2ej
         qqCKKHRg8ujULGtgOIqqLIcr+p3ZUquYjEZ1FuGyc4/f3Fzr8+TO+3CQh5J+x5+NCsoW
         tiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DQ0CBIUENlnxszxblZGMK9Fiucf9BEsPe3rmSRMVdwE=;
        b=MN0HycrhvBYjDRrY5eoap5Xpv5y74Lj01C+TgAZRA9ecd8OCukJxvJAg3caErEtvea
         7zvLEiPUAVUcUalHIYQm0lXeLt6QR+/xYmxmdDoLOxAFSDxuPHkCSWMqNeOeXXI7jPkq
         GwDCiq0bWGCBtROHShomU65COI6mEmGDW4GN2nSkJqolO4BA7pgD2lmPz8taWy5i748R
         GiCqh8HmSx+yBuTE+DQ5o7TXrHXrOWBl36KnBEWDPTjyttkfgP/vS4/PChv5ZSvJfy6T
         hCLtHMp1GJym8ZJskX3zPTmhNbGIpeAS9W+rnWUFEScBJurdo7uh9x6M+Ufqpy2G7rZo
         QG3Q==
X-Gm-Message-State: AOAM533R76bQ9RY7q3w08+XabpgZoj5Q9HepsJzWxXQo/OVK5Si9CE5X
        ZLak7+AN2k6pJ7ButdUlp+zeuYvO5h9LoUkmFwQ=
X-Google-Smtp-Source: ABdhPJyfKhrcFNTHXyf/F4lwqcqYa3wZkc1mL+R92ywbQOVRYfBv7CJeGN3+XislpmMtOf+tdFnxeQ==
X-Received: by 2002:a05:6a00:2148:b0:4fa:92f2:bae3 with SMTP id o8-20020a056a00214800b004fa92f2bae3mr1793101pfk.69.1648679814322;
        Wed, 30 Mar 2022 15:36:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id be11-20020a056a001f0b00b004fb29215dd9sm15020042pfb.30.2022.03.30.15.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 15:36:54 -0700 (PDT)
Message-ID: <6244db86.1c69fb81.9dea2.786b@mx.google.com>
Date:   Wed, 30 Mar 2022 15:36:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-15-g0962c4e581ac
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 82 runs,
 1 regressions (v5.4.188-15-g0962c4e581ac)
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

stable-rc/queue/5.4 baseline: 82 runs, 1 regressions (v5.4.188-15-g0962c4e5=
81ac)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-15-g0962c4e581ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-15-g0962c4e581ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0962c4e581ac6f915f24f3f8c335a58db2a56a14 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6244abbe15ab3b0962ae0689

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g0962c4e581ac/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g0962c4e581ac/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6244abbe15ab3b0962ae06ab
        failing since 24 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-30T19:12:46.712875  /lava-5981996/1/../bin/lava-test-case   =

 =20
