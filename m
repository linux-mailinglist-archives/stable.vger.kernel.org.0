Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8A512B38
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 07:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiD1GCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 02:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiD1GCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 02:02:35 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA1D52B3C
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 22:59:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c23so3484013plo.0
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 22:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6VKrD9fP10nq/aEHEE4WTiT/q9oIAXUe9qY+LOJBLhc=;
        b=Pmo70M6CeZ0xycCz3a2t36Lb8HjzqYzkfHF/WK60EV4ZAZdfdf3jeSthQBnobIr82L
         njaLncAHs99L5c1I6QcazN77ijVdweuFH4PJ449fHPC4QaJe+2NsUbkDD/vWtvnI44m4
         5xxeZe0+3JmcqzBQWzDUnjXb6vBBXBkHhk9uDHQeieqFOfwLmSGM9Wg8FiAvComg42ES
         Cgy0lXsYYUsfjnrOWvAk+nAvgJSskh+LWs+1DK2ZKv2I+JNah+esDnl3oI4h+XLyHrVO
         FAApEDAwE3l+Zfbt7wAJRwZIAhg2fE+DHwAx0SmG2QcQ+sKKNSFLORUHZbpXhjla1tVP
         XLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6VKrD9fP10nq/aEHEE4WTiT/q9oIAXUe9qY+LOJBLhc=;
        b=ehEzKm7et7rv74PvbXY7Eo55nxzGgDCNvOISFxM0JO/6I0AfkBvrF5h6DdYTtqAiWg
         Zpn0iBsdZJiyBBr+kQ0+OFuc0+DrBLu+6HdmXbZOgKGnQItYAFA8j6LsHY7KYnikv2Or
         drLpqem4tnxdvOwNz+g+51Mc+/aaq92PxtakUZhPcFWeCFYkQZv6j2ahs9Q4AyPdviDx
         tO7bbLkdMQkx141M6JStYUtPW9FISnteVTvMaIRBrBBLJhSz0yaxZL1cbK8sfF/womm8
         t6LTKL8jHRUSzed3OcgK/zDEWaTUZ4WAOdvNM59GSPN5rYzfqghjoKmR6s+DD7ND0n2g
         SUjg==
X-Gm-Message-State: AOAM531kB1kVhJSijGx7J+4aXT4VRAMPZInQ1RQq8Ou96bNDJNoh3s0B
        klO+dMjCZuPCfS9VDVMTr9olKMzJRzOxev6rYkw=
X-Google-Smtp-Source: ABdhPJyiH25R9yLBUbTJ5QN63Jeb3akAY1ZCyJLqvHVId9UWnMucQhteuOMVSW9ycgeLmqePk+kC/w==
X-Received: by 2002:a17:902:70c8:b0:156:509b:68e3 with SMTP id l8-20020a17090270c800b00156509b68e3mr32346962plt.113.1651125561404;
        Wed, 27 Apr 2022 22:59:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6-20020a63e106000000b003c14af5061bsm1288364pgh.51.2022.04.27.22.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 22:59:21 -0700 (PDT)
Message-ID: <626a2d39.1c69fb81.11063.3b70@mx.google.com>
Date:   Wed, 27 Apr 2022 22:59:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.36
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 84 runs, 1 regressions (v5.15.36)
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

stable/linux-5.15.y baseline: 84 runs, 1 regressions (v5.15.36)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.36/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      45451e8015a91de5d1a512c3e3d7373bbcb58fb0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6269fae9b9537ae73dff9462

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.36/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.36/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6269fae9b9537ae73dff9488
        failing since 50 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-04-28T02:24:04.244402  <8>[   32.678856] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-28T02:24:05.269927  /lava-6195905/1/../bin/lava-test-case
    2022-04-28T02:24:05.280910  <8>[   33.717219] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
