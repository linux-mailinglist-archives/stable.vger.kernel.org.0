Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C54FF94E
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiDMOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiDMOss (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:48:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763CF6351F
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:46:27 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id n22so1867322pfa.0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=12j+utaOaBizkAPZM31+/rB6J377vNBAQ6g87eCio5Y=;
        b=Kq769Y5z5pV4lnUNXbCoWIeu3A0SIwvEhynoDEJb1GtOMHKtvY/YH804LLJT3e+sUS
         R4mzlmfKASAMeF+uZFRqwpWPMPc+hxFPovtxVXD+eDcuQnwhER8CIpfnEUEKdktalddu
         DvkwAxuR+p3BmbG1hAq6/yvzwUQB9yAzPY2CqRcvaX1ieHSGWDQFaM1ri+OdsckAJeKF
         +0G0ORbjPhKpWSzT4x64p3MwZp6bUdmQIlv4zeOU6k44q+jVecdhWVkktm3+ri2GuyrN
         6tmPRThEP99hJg9B+P/LkVcgRRp0MCVfcW9nhC35Ykb6Ei8QFUhpHCL/yFdpNl0e4Jqf
         Zzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=12j+utaOaBizkAPZM31+/rB6J377vNBAQ6g87eCio5Y=;
        b=0kYrWbdbQTcCCKS4im3Ttz1EjIfX39V6THxO6eE5YAscR6/LyGIOBkpH20SW4WVwF8
         /WFFDmNHyfiDyz5eAst13V0UEB+rCsgZ7l11b1q96ddTxHxVWnOyCNodO/42BvgmkC9p
         vAyGO6fTKjnU92jm/cQZXp4KiHLU1yC7RoYMKVv7voGj/5Jias5RW7h+t9sheII+MHZn
         /f+ch6uzmgOSYrBM9srtgylRMldUoBetwUsrBqj13nLB0xYWdea7DDmp5v2WB7oGZF/z
         h4o6M59uoY8ZLTN86LP5IwSbdVENwre+Os8xIpQX2Ed64AX5DsKoA4JK3Gy7Epat36IS
         VLRg==
X-Gm-Message-State: AOAM5336/PN3ZmNQ+dI7iFsHE3xhFDU8Ai0ke16GgDt869GdinSgaQt6
        fNOTi6of22X4/RDxflFQF2eP/BHaGgQJZbRF
X-Google-Smtp-Source: ABdhPJxrgLlIr8TqvniMRSiM5VIpEMBZg3TZJ28LZYUxLNHdy98yIwqwlwxZifQB02YePIeFb6TB4Q==
X-Received: by 2002:a63:a804:0:b0:398:e7d7:29ab with SMTP id o4-20020a63a804000000b00398e7d729abmr34613146pgf.138.1649861186831;
        Wed, 13 Apr 2022 07:46:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20-20020a056a00199400b005060849909esm5337479pfl.176.2022.04.13.07.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:46:26 -0700 (PDT)
Message-ID: <6256e242.1c69fb81.4e083.cf8b@mx.google.com>
Date:   Wed, 13 Apr 2022 07:46:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.110-171-gb82c8b005aaf
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 111 runs,
 1 regressions (v5.10.110-171-gb82c8b005aaf)
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

stable-rc/linux-5.10.y baseline: 111 runs, 1 regressions (v5.10.110-171-gb8=
2c8b005aaf)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.110-171-gb82c8b005aaf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.110-171-gb82c8b005aaf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b82c8b005aaf13b8aa97a4fea425ae4fb1f3fc8c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6256b1b58dd2b09c06ae069e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10-171-gb82c8b005aaf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10-171-gb82c8b005aaf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6256b1b58dd2b09c06ae06c0
        failing since 36 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-13T11:19:06.212994  <8>[   59.911141] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T11:19:07.233334  /lava-6075780/1/../bin/lava-test-case
    2022-04-13T11:19:07.244009  <8>[   60.943909] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
