Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0B4EB34A
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiC2SXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 14:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiC2SXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 14:23:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B61F5197
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 11:21:58 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id b130so14094870pga.13
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J9KEuVIzy4y3KRwLW4j8sDBepcIphZ59tWXZzqA/0sQ=;
        b=TrVIDWSNDUIG6mFXMOLl7cI060A4L5qXv8WTTfS4DY+p+Zx7lHTilIrwIL4TvqwpTh
         WX1J1Hg3bCfKpjM6EhkhLBKI22BP8PvkJKglKhj+XO/2VbWM2szjfqsXDkenVk+/IKO7
         4Pb2jeFF5L8B+rrpzcN8ZaX5++9PA6blBBk4MZb73mKlyeC02i3UpSpmq8BWT1BFKWQs
         Al6TszthjfaDEu38sl4byT70GG8MHII8XYZmIwACfQfHqTLvwDBiowAdd5/hL4zkiqQg
         jtTdiwFjLyjBV/cOJZU4jx8gXTqLJNcAuVaXl0sL+FIKJwIFF2QeuY1yVaJE/lWT2W4S
         4UtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J9KEuVIzy4y3KRwLW4j8sDBepcIphZ59tWXZzqA/0sQ=;
        b=rJddfX7gl4+DimX8pgAjX6soVAhKb973jcM8kZt0NHFr/T01ZV2n2FB0h0QwxHODdS
         4GkIrr7czfx4amn/hsEJuMXpMon5TrC9TjICz6VJtDvGCjqsS9bqqpw1Zl91N8NGUMFY
         bZ+mNPXtK2N6a/F8rJ1+hTgl69NCqOiODQtkipnGilaZYM88w1Yazf8JA56qyo2h4UwF
         r9Ai04OGkX7c1IV2omoMGRFHUhVDGPFI55cdBoEzU7aBr/3H+6LdSq26BOuDXU1OvPNq
         OoSxF61aiN36W6RjnAjgX9OyhGMAzC5cPXaBOEf3igtdfW8ckm2wqunNespgB9s0ZEVW
         CL+Q==
X-Gm-Message-State: AOAM530O5hb8zqDNsTyPOfkEL+sFOLsv8n6cIe9RUy/qu9ers3G+OyRd
        ShoUgNX/ENE5BhJ+jF1rvg++wgaztGJwTA1sxuM=
X-Google-Smtp-Source: ABdhPJyoSvRai7WivE4J/Ol31LE/1HteTqbcl165XwAYy2hIY65ljItWLFTHl0kJNRuoGwxlxIin/w==
X-Received: by 2002:a63:4041:0:b0:37f:8077:e0de with SMTP id n62-20020a634041000000b0037f8077e0demr2843965pga.138.1648578117893;
        Tue, 29 Mar 2022 11:21:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18-20020a056a00081200b004faeae3a291sm20063167pfk.26.2022.03.29.11.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 11:21:57 -0700 (PDT)
Message-ID: <62434e45.1c69fb81.3d3f9.42a6@mx.google.com>
Date:   Tue, 29 Mar 2022 11:21:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-11-g78bedb4f64a3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 92 runs,
 1 regressions (v4.19.237-11-g78bedb4f64a3)
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

stable-rc/queue/4.19 baseline: 92 runs, 1 regressions (v4.19.237-11-g78bedb=
4f64a3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-11-g78bedb4f64a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-11-g78bedb4f64a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78bedb4f64a3d54f455b457d5fc92426df7d40cf =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62431e9b44bdd93134ae0681

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g78bedb4f64a3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g78bedb4f64a3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62431e9c44bdd93134ae06a3
        failing since 23 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-29T14:58:30.137602  /lava-5969810/1/../bin/lava-test-case
    2022-03-29T14:58:30.146017  <8>[   36.976879] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
