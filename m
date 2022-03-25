Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF484E7950
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 17:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiCYQxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 12:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241225AbiCYQxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 12:53:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A2E38B9
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 09:51:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p17so8649972plo.9
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 09:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YGCfn5InYqHlx9AMADDw9DVpiPfzh0buR5MM5iQ6FpA=;
        b=wKGEKQZI1UPFT0yd/szxVU/91dxMS2nW50Wv6dvb6K1ckR3ub1+bmE2yEHR1xh5NWD
         eFch/csFzGROeSlhH4B4QqjLy7lfXFBf4aK2QQLhZksJ8Ws9j7p61yQ+hkU0uItEdypM
         gSB8MqsCKp05VN3fjLTNTsqs0jqxdXv0dzeugXe+/k7MiH9PsOxzbmve1qFF0eYy9rW9
         8DOJGqML/3XHQ5m/xxVaG9GrkoWESY1Zfc+pkKvUHCl6hswFJ5i1pfTZDyruVHzDWkJV
         +wzOmXUefWWzQtLOXrZKOPA3Nvvcbp/OnLT8Y5l+I0DMUbzagfIYMeMHYPw4FHONi7Di
         0W9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YGCfn5InYqHlx9AMADDw9DVpiPfzh0buR5MM5iQ6FpA=;
        b=C/IreTzw8FnUdKj8J/bhw1nsaM2NweB9pW7H2lmKF7Y7PAO8UtB2OCUiMaAKtyJ9R3
         8bz+Odz7doxpXWU9IRxSgGLjzr6JgRGQzOQUYwjiMQhDoUMi4pdlyJb7+hgK0KSya7e9
         u2IVJKoNrpp+wtWGhyq5t/VHP0IUcrD6SqQ4zqdrevte9umWXg4fE1nAybFZmbgcZFD5
         ZadE+Y4EJwsVHZSx2F5cQmBd6yLTC/2PwL6A9E8dYxkinZvnHxvpVPau2fZMD4ApZkbC
         3joD/7EWVchGw0vHNMjWJbYNA6Lfh8W5BH3YHOcJ1CUhSIKzS15kgZ1igIgDPYuRKPyB
         g8GQ==
X-Gm-Message-State: AOAM5319L9ihk1wck7plcjV/2y/6l1X/RsA3rMGAvtaOOc+ovmdV72ck
        XSAUHoAGLfYxusUdSvO2If0oGIYDPYFJYrq+gRU=
X-Google-Smtp-Source: ABdhPJyR7SyUVz5bpWavTpN/NAMgxLCQH1dTGxfnz9tjRUv30KByU195pZ0S+YRbwqPlFzJih9udhg==
X-Received: by 2002:a17:90a:5291:b0:1bb:ef4d:947d with SMTP id w17-20020a17090a529100b001bbef4d947dmr25879976pjh.243.1648227093972;
        Fri, 25 Mar 2022 09:51:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o22-20020a056a0015d600b004fb03c903c3sm4191593pfu.71.2022.03.25.09.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:51:33 -0700 (PDT)
Message-ID: <623df315.1c69fb81.4cb48.bc57@mx.google.com>
Date:   Fri, 25 Mar 2022 09:51:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108
Subject: stable/linux-5.10.y baseline: 106 runs, 1 regressions (v5.10.108)
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

stable/linux-5.10.y baseline: 106 runs, 1 regressions (v5.10.108)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.108/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9940314ebfc61cb7bc7fca4a0deed2f27fdefd11 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b076e1b6329a1e2bd91a9

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.108/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.108/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b076e1b6329a1e2bd91cb
        failing since 14 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-03-23T11:41:10.501560  <8>[   32.592163] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-23T11:41:11.524228  /lava-5931776/1/../bin/lava-test-case
    2022-03-23T11:41:11.535372  <8>[   33.627191] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
