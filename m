Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883EB4CEBBA
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 14:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiCFNcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 08:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCFNcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 08:32:22 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B925F257
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 05:31:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so5039193pjb.5
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 05:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p5fksoWhzDaAJqS2Gt6Bqk5/UbESFYjQqraO/8FInLI=;
        b=pqD11JdYN6vB+e0T74TxytvIwmfqlVHHGz7KWNQ/M6US1gbTVC8ofb2YVdoDHC3Bzy
         kRztfBDzCvmJOZmjWCD2Nn5TMVZabsvf053xqHplcLRyCVrJpZZi2OKiMEQOodWfWZ1h
         a7147L6rEh5tbJBcjIefC+9T9dTfkDhzhfT0u/gf72eTupmKdt5vPFi79LASBHOH7xnd
         Otj8FPzPTk5i7E4Upm5AaGLoBi6btvw4ugDOhZ+3YyvU86MPX61mLj0hHytAE3gFlvcO
         5XX8YMR4Q263VKGzQewP5LAN3MluJHMIAO6zpZ2Wo3dwPQfq+iswdgXWZSEtkmhW+z2f
         eM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p5fksoWhzDaAJqS2Gt6Bqk5/UbESFYjQqraO/8FInLI=;
        b=x9c7YYGGQaBBJhrSJmjzTkwGwR5t+VpGzdA8KJUQ54PLdK/sgLdwx78mLO2YXBG7Cn
         B32rJGYMY6CH1p2QjAf15brFQBGa+dWiZPWD9bgzudFVRCxhBp4eNeuIDfQ/IXpv5lFi
         fOF8nvR4KuMGacQ7UAto6j6eKBpjNduquiRcKC2yXEyq4vjmDa1mgdGM4Z7FeRTJop39
         FigIz6Phd+axfiBVNUTIJkuPW4ms5bfgBvLTcIGcewmOSylTTUpFtPLnpvSrRF6DGJcP
         aj/0JjACUszakaMQ/orzaGWxaj7AhSTAluFKFMhXlVPHbD7oCrcUPuTbR/2qkHVcja5K
         kcJQ==
X-Gm-Message-State: AOAM530YslaHifrlscyfZGMpNV7zfEPUk5kr+RLcFZCl3HY9drj+Y+PL
        sIr9bdsh0bK/ph3/m9pfK7fKs9Uguxqom786KBE=
X-Google-Smtp-Source: ABdhPJx4egrPvIXkwfvAJBAcrVlgtK2pYKj5DEMoiPPhBtuHqqAc/FSTgTX53XRbhrGaFvWXAe8b2w==
X-Received: by 2002:a17:90a:2e08:b0:1bd:59c2:3df5 with SMTP id q8-20020a17090a2e0800b001bd59c23df5mr8213616pjd.235.1646573489943;
        Sun, 06 Mar 2022 05:31:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a7f9100b001b9e4d62ed0sm15850741pjl.13.2022.03.06.05.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 05:31:29 -0800 (PST)
Message-ID: <6224b7b1.1c69fb81.61d57.ad28@mx.google.com>
Date:   Sun, 06 Mar 2022 05:31:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.232-44-gfd65e02206f4
Subject: stable-rc/queue/4.19 baseline: 57 runs,
 1 regressions (v4.19.232-44-gfd65e02206f4)
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

stable-rc/queue/4.19 baseline: 57 runs, 1 regressions (v4.19.232-44-gfd65e0=
2206f4)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.232-44-gfd65e02206f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.232-44-gfd65e02206f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd65e02206f4ce793169b773f329b503a2986ff1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622481738753989271c629b4

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-44-gfd65e02206f4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-44-gfd65e02206f4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622481738753989271c629da
        new failure (last pass: v4.19.232-31-g5cf846953aa2)

    2022-03-06T09:39:39.099014  <8>[   35.832484] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-06T09:39:40.114502  /lava-5825593/1/../bin/lava-test-case
    2022-03-06T09:39:40.122608  <8>[   36.857117] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
