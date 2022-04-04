Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949AB4F1EFD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 00:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiDDVxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381475AbiDDV0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 17:26:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEAA38D95
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 14:16:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so599509pjm.0
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 14:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y4EmaI4Ga48tyMSFvsWdnwoxaC/ztLtHDt52oKpaU4k=;
        b=eopQLuG2TR3lLPpwLVnXDBcvLJ8xA7aUeoMFKwqxu7DhXwOAzaSkyC2Aj8XlMAc20P
         LUNnZ+145MPDok7epBfs3oADHFPCQcvJvVWn8NXgRUZANj06euMh65EzmDuKg5iP3mXu
         92/a2Ds+jTVGDMQHT4cPKjBkG7TPCPbMWK4MZVHQ7ow2Xi46mBzcUVelNH4bOzOfYDVz
         74iVrfqW0awYLyAmYiJiOQX+BwEKTNDwaLr1VI8p4IPiyoyaFUoW3tdLH3LkvF0/1mxf
         Jcso01VWlJVKKtR8rRE/RXwzDKQjSZFTaEu0wVX/aNm9EALdNgTV+bPu/FCSHKCTPQgs
         UYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y4EmaI4Ga48tyMSFvsWdnwoxaC/ztLtHDt52oKpaU4k=;
        b=fR7EeujIAwtkhJQC2IAhZ9+vebyMhVg+e1y8oru0CURZ1e8QadNlrpwnJdoscVhtH2
         +TgPKYn3GZ2eRCsRNnTdy5dEC1sIhDw8x0WroRiyd4n2M2EMcjZ3vN8rI+VVVVP57OBA
         +Kmjml0v7wxRngOb7XDqohvV1g0DZsQT2PpUM0i81ETJ4zWIGAUUmbYHgYv+1Pn0qLCg
         OrCDlHEl1O6FEIxVQXRZBfMqnbJBL7UojDdLVX13QLH+5kSBnOjkJgk/7OmmZ1T341kq
         LX2zTK/3gjRyyBP8i75/NUk/Ey6Dx1G5J7oZohEe/KwnmkvWT1jUOSzc8rvdvCZhiJ41
         d6QQ==
X-Gm-Message-State: AOAM531eahJPuRrvheGuBqibvhPng/h25hdj3hTQ0H+FJwIfuwtXXWgS
        vnKvFaHR2VhufLIOsgX7dmEwMMgyHCf0EQohjzA=
X-Google-Smtp-Source: ABdhPJyhXCzipwqo1LEzqHIQebyVS/ZCW+mNpsPZvbiZxBdq6e4mOZAkjHDaYrujilWUdwmZtX74ag==
X-Received: by 2002:a17:90b:87:b0:1ca:a84b:37e with SMTP id bb7-20020a17090b008700b001caa84b037emr165780pjb.168.1649106991754;
        Mon, 04 Apr 2022 14:16:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00230c00b004faf2563bcasm13732771pfh.114.2022.04.04.14.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 14:16:31 -0700 (PDT)
Message-ID: <624b602f.1c69fb81.96e02.2f1f@mx.google.com>
Date:   Mon, 04 Apr 2022 14:16:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-904-geae0a322eec07
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 50 runs,
 2 regressions (v5.15.32-904-geae0a322eec07)
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

stable-rc/queue/5.15 baseline: 50 runs, 2 regressions (v5.15.32-904-geae0a3=
22eec07)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-904-geae0a322eec07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-904-geae0a322eec07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eae0a322eec07360d3e34f4ceba62ea28253d8df =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2ea47741acf3c4ae0687

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
904-geae0a322eec07/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
904-geae0a322eec07/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/624=
b2ea47741acf3c4ae069a
        new failure (last pass: v5.15.32-29-gfa2f2eb2bbe4)

    2022-04-04T17:44:57.626430  /lava-105549/1/../bin/lava-test-case
    2022-04-04T17:44:57.626812  <8>[   14.435005] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2fe8d58642ae31ae06b9

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
904-geae0a322eec07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
904-geae0a322eec07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b2fe8d58642ae31ae06d9
        failing since 27 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-04T17:50:21.870212  /lava-6019301/1/../bin/lava-test-case   =

 =20
