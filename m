Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028B25209BB
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 01:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiEJABx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 20:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiEJABw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 20:01:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2824D2BD0F0
        for <stable@vger.kernel.org>; Mon,  9 May 2022 16:57:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so651969pjv.4
        for <stable@vger.kernel.org>; Mon, 09 May 2022 16:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=svuCa6HivCBC+ysX7I3btIgTeqBqlWwzO0GJZDW/X5U=;
        b=Jro2O/FsTCzNwPqVjBWnbiYaU4OmY9pYoHTwU8BVXnT/vES5Nud4WoRYXrxMs5gLP7
         0/rCZXRA2EUunP9jyZJWTM66M7TkoVUKDyhsmbOehMX13HhbtKapmliKVw9GCDiin/y5
         t8Lrd+WFxcNI0XtbBNBS9/1XH70ludcCs+vIlsHlYMKjLKjIF/zEK2kCYuOiz2yxR0VY
         sdzD9hkAVlqrn5DcwfWf6NXKRUOieHXahsI2RN3X0vqD0Rm5NH5VWyvknXzLvkHLkvgV
         8AZyR+ow4rjzKMiKgzioeiQ6D7gtYgYle6wZ1ZL98oriMaKLfV/nFybuVzFrWrFl7nUj
         MV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=svuCa6HivCBC+ysX7I3btIgTeqBqlWwzO0GJZDW/X5U=;
        b=uCkwJoNilkC3/sH/o3URKqXxb1DUGQGYLTK7/738UEFfxPr7bwt1Y57MrFavc+ngpx
         3p1QJnxIzA/g9rjGU+43RiXlDUSmwjmZ2nfl94yPFh1k11KmG+1y7JBmJEXMZZf1H8sy
         kck633MVqTwtbjOXgSmQqz/hXrMh8PMbDju4D1dBoOuQJKRJx6ysOPPG+pJMDJHpaFRV
         r68es4jszSdOvnyV4Gd3FxwpyClC+P0DhefXmzrZs1BY92xEM2DOTs4ccIU+emhJJ+Zu
         rtdeNQNLT23BssmIJ5fOAvCxs+HeDlkU4Eya5AwI/L4pcnHoud9pmqNG3h8z8R9ohYzV
         1oeQ==
X-Gm-Message-State: AOAM532WHv/4ZU8e8v/Q6nmnswwKeyhBUmnZR10pukjychmQVupNAnKx
        +vVOUwEkBYGJQQ+beMhgJdbZ/es42d3k2hhVt+o=
X-Google-Smtp-Source: ABdhPJxAeEW5HCQKBjUQ3QbR/m4DNtjHjC7QXLgr9Fzi5D4xn6BkEZoT8B0bn3BFVpYV9J2yV+UuQA==
X-Received: by 2002:a17:902:ecd1:b0:15e:850b:c2d with SMTP id a17-20020a170902ecd100b0015e850b0c2dmr18151170plh.75.1652140676476;
        Mon, 09 May 2022 16:57:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020a63060d000000b003c14af5062fsm9153603pgg.71.2022.05.09.16.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 16:57:56 -0700 (PDT)
Message-ID: <6279aa84.1c69fb81.73000.4e70@mx.google.com>
Date:   Mon, 09 May 2022 16:57:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.37-259-gab77581473a3
Subject: stable-rc/linux-5.15.y baseline: 163 runs,
 1 regressions (v5.15.37-259-gab77581473a3)
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

stable-rc/linux-5.15.y baseline: 163 runs, 1 regressions (v5.15.37-259-gab7=
7581473a3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.37-259-gab77581473a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.37-259-gab77581473a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab77581473a372e8dcdbaa16ab60feee37c26563 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627989535cfb9ed1af8f5751

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-259-gab77581473a3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-259-gab77581473a3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627989535cfb9ed1af8f5772
        failing since 63 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-09T21:36:09.314569  <8>[   59.794077] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-09T21:36:10.338318  /lava-6313532/1/../bin/lava-test-case   =

 =20
