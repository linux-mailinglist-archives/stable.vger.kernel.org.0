Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D7D50AC0A
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442600AbiDUXlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 19:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390904AbiDUXlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 19:41:03 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE264706A
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:38:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j17so6368635pfi.9
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CL49lyk3ufoiiSEhFTgv4ujgy3fuUsUgJBDaZRYErHs=;
        b=JklFKfeyXEZ4Ot4HAmcxqBG3Hy5Kp0NpXx8JQEwUorIfNHzvV/ZFqcRE/lATfM4Rzy
         cxS8iAsYVGBPWhAKGBApwf7w+oqPwWJlCCfhfWKiPasuSKNNxLnY5bMGcySHFMF1FL6B
         TKESSTMs/abVCfS6sH0tXjLZNvcYaDc64y01UBrAiQ1Mh9+tjmNS5UvuK1JTZUtvBav0
         nCNMUIjx9t3d61JB+f63iBXKjHkXoMPzmqCuL1pa9b5W7sOpS9SermR2zi2y2eE678dT
         zc4Lj/pnCMaaTagiwkMez9tg0IuuQI1IcrByouf+Wh6igXKnnmy7hPUVVZY4SR/VVbqr
         bzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CL49lyk3ufoiiSEhFTgv4ujgy3fuUsUgJBDaZRYErHs=;
        b=Dx+Kfj/XdyV1wsSuq5B7MQcklxpwYcl3+4XnyK2U57hv55v2hAZCoCyYjmsbgFHv8k
         vBmgs4huCLQNQ9j+vdI6vNfv1U4vHKWcqwY36/oBk2hLf8E+Fcuh1k76FlnZmgtkl5yk
         4rjyfDVrofU2HoJg4+Cl5pQquLrIPH/Q7KkksvKW1DWJxT0FkzqMdsJn1O/tyrWn+9SJ
         Z8tEe/RxajO2KdeadtSTBv+yAmIpDBTEkcFOUrKODorTp9YTcnJ650xRf28JVFFGRHhw
         Zw1M1ruZs6UvTlIJ5I+bSpAihPvvx0lrGZ6yYwF3MMURPkqfn9GPwr6SGg68EJP2iP6O
         5cyQ==
X-Gm-Message-State: AOAM531kAPfy+9u8QVXmL52z0oNklUbLiQMfwzul7E0DidUS9nfhRYot
        skQwm1f0hZj6Xej33tE3rm3U45khWvH05IeLpto=
X-Google-Smtp-Source: ABdhPJzLSk2oiJMl2rvDOeo+sIWZwTenfU36tYzizQtsIBILppqQdOUgCQt0ANEjOgTDqhiuY6+aRw==
X-Received: by 2002:a05:6a00:1988:b0:4fa:c15d:190d with SMTP id d8-20020a056a00198800b004fac15d190dmr2010712pfl.44.1650584291511;
        Thu, 21 Apr 2022 16:38:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r29-20020a63441d000000b003a97e8f71e7sm223771pga.88.2022.04.21.16.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 16:38:11 -0700 (PDT)
Message-ID: <6261eae3.1c69fb81.4ba54.0ce5@mx.google.com>
Date:   Thu, 21 Apr 2022 16:38:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-5-g3b8fa2d70abc7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 88 runs,
 1 regressions (v5.10.112-5-g3b8fa2d70abc7)
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

stable-rc/queue/5.10 baseline: 88 runs, 1 regressions (v5.10.112-5-g3b8fa2d=
70abc7)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-5-g3b8fa2d70abc7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-5-g3b8fa2d70abc7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b8fa2d70abc7c74178c97e122617294df934a9d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6261c29babb02cf79eff948e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-5-g3b8fa2d70abc7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-5-g3b8fa2d70abc7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6261c29babb02cf79eff94b4
        failing since 44 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-21T20:45:56.139507  <8>[   59.668895] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-21T20:45:57.161688  /lava-6143620/1/../bin/lava-test-case
    2022-04-21T20:45:57.172839  <8>[   60.703531] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
