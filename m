Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFAA4DE47F
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 00:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiCRX3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 19:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiCRX3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 19:29:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FE5190595
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:28:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so8273627plg.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OTVtXGmgQ13ykjGf4lLwkrIq1i3TTVvFaBVZ1Ap5iaE=;
        b=RxaJaPY1uaaa5/twDC2lJHNvWGZDfMHUnQWkNkTTy9UHyVmHPth2IsFf3FeGYJ1mR2
         gaWtXFzccpicS6qLU+BUTU/qMgGZtrumnrv4tIJXDOzIEenKXq+XhAtrHwoIfWtdIdPd
         XObu1lgBSwncTXOoVnuygI0vj0m/iNOVG93+dYGmQTtHYSWAq52bjXkTdC0wHskvs3b+
         P9tJ7nCqxSEotYHzzkLxxavUKeHy8D+iJN5s1QxE4Nrwxqm1MDPG3xZUH8V+LVftqcER
         cLfjkSuqK8w4ZSY8zeHxFqylezkaWz5yCuHF3v2EHIOzMRMQQEU/LvO2VUHNlJ27Dlrj
         IkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OTVtXGmgQ13ykjGf4lLwkrIq1i3TTVvFaBVZ1Ap5iaE=;
        b=1+WRD7faa9h+UdLMTvjdQPvDWVWg41IL82t0GV/qacxfApM1AlqDwBcBVCLgaxTaSr
         stMzbsKF54naQCVTuXkMKPjLeQdBc1t3sn9j7dtVYApbCQwATiGrCNlUi+U8cWxLBisc
         LVAs2tRT27sQKPuLLASmx3D7SbW82XD04SCsrwOKb7nhSwi2+hxyHPB63QY3fZ3d9tHu
         CcZx+tv8oU/5wizRCcUXwMye80Ang1p/wDRTsMiCQqTKNg2kL/hGqTL+85EmhcnV8raB
         xx6y7EBUIPm2dRzjnhrFIxt5p/1hwcyBZ1tOeuMFYAFtZykleJElO4dZ+nYIQ1CtrT6k
         N9QA==
X-Gm-Message-State: AOAM5328o2sv5pSPbB6bwEY1TGujis9rgk+pnx1ucdD9Pk+vGamdFfc6
        KWrOsV+jg8Uk8GgPQn06IqEjVPwPFcOKJeJTf9U=
X-Google-Smtp-Source: ABdhPJyx8eZp/OPJVhwSKnbjQUCVJcY0s5x/3RzR2Q0XRB8K9M5I4f9GrT+SYz0+P3T/jzSMMcD4CQ==
X-Received: by 2002:a17:90b:3846:b0:1c6:841b:7470 with SMTP id nl6-20020a17090b384600b001c6841b7470mr11907545pjb.193.1647646112123;
        Fri, 18 Mar 2022 16:28:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10-20020a056a00238a00b004f79504efc1sm10634105pfc.214.2022.03.18.16.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 16:28:31 -0700 (PDT)
Message-ID: <6235159f.1c69fb81.bd980.d78e@mx.google.com>
Date:   Fri, 18 Mar 2022 16:28:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.16.15-28-g1984a674b58a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 92 runs,
 2 regressions (v5.16.15-28-g1984a674b58a)
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

stable-rc/queue/5.16 baseline: 92 runs, 2 regressions (v5.16.15-28-g1984a67=
4b58a)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.15-28-g1984a674b58a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.15-28-g1984a674b58a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1984a674b58a3dd7364d58735cb324853edc3e37 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6234db8881db5cec45f800b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
28-g1984a674b58a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
28-g1984a674b58a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6234db8881db5cec45f80=
0ba
        new failure (last pass: v5.16.15-27-g644f2bed149d) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6234de9ec9d62d0aa4f8008f

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
28-g1984a674b58a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
28-g1984a674b58a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6234de9ec9d62d0aa4f800b0
        failing since 11 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-18T19:33:23.207452  <8>[   32.142340] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-18T19:33:24.236825  /lava-5910954/1/../bin/lava-test-case
    2022-03-18T19:33:24.247937  <8>[   33.183369] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
