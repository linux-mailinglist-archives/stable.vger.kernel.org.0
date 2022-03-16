Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6805D4DB4C6
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiCPPZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiCPPZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:25:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BF114017
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:23:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l8so4277965pfu.1
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1etiftb/bXZlsKNCiJ39o6UCEW5nVZcWIeI2dftbdTc=;
        b=wWOGY6enRzYKILXT6iyNshhRNXRQIAaUn5g5quaarRFK+JnPYtvwKnkeLuKPBNbBZY
         aZpiGgEYEAOW9wp+bVLE/mrUiDF1bIThb+HH2oLJDzyJ0uerupVSSQCGHyC2JtydCi8I
         ZJeZ0FsXHGWOcqXKzo6gzhRG1Hw1NLM5U6tRcnWKkioI16qYbeDzV1c+q5PP+rR4Yyut
         YNMJeNdQM6YRMfBzmtDqJAeb0uFZCqdQOfDmnHJHJu/UHqOzDDZDbyQIOQdpt7lAZrtU
         1GiKXyNHkFDMbPhdPlSuibbn+8jCHxCgfrr64W99IQlrW+IY/7qMfq3eaS7Y2sHBZkMW
         a1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1etiftb/bXZlsKNCiJ39o6UCEW5nVZcWIeI2dftbdTc=;
        b=oIhSPKq2TnVRUDDQPuOUtGf30Mqmuteav7t501lD7op2VKe77AfysBa5iuaObYVCOM
         1cX9ptc8o5seyoLq0xES8lK5BjIBJ8ft0T3BQ+98B++zIs65Tq/OHWKbWMWVpow5aSbl
         wV+SL642xaej2iTbjwdIUVjIAt0yfQxKew6FYRk+vz4xKErgxTuFKD2Y86jK3oEn5zLy
         NKT/4jU36V73Ws3FWUsH+NpOfPYKfBBA9g637jA05pyqNGe11sFW6bhCVAcWdbYhgEOI
         wE05i1XE5c9uskqcQZkhJ2E2tkt6kzRwqiMj7Lm/kSd3euwf/0MQRf0GVuRbF6AYq3ea
         bh7Q==
X-Gm-Message-State: AOAM531TzFyvZDO2Y9cT7ec9m7KGi3cPqjCX8mGittSx2PHbH6lEufUf
        wMsx4gEipiw51eyIy41hpb1DRIXld7IaftWRRnk=
X-Google-Smtp-Source: ABdhPJw99ybe/kIFhpoNPf2VuAap9lYUw07zjHJJPU757EPe25zlTaT4BfV6GegZ3zYu5HqEvRsAkg==
X-Received: by 2002:a05:6a00:309c:b0:4f7:a5ca:4e20 with SMTP id bh28-20020a056a00309c00b004f7a5ca4e20mr233658pfb.26.1647444233438;
        Wed, 16 Mar 2022 08:23:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a0022d500b004f7a420c330sm4025029pfj.12.2022.03.16.08.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:23:53 -0700 (PDT)
Message-ID: <62320109.1c69fb81.14d6.8d99@mx.google.com>
Date:   Wed, 16 Mar 2022 08:23:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.28-111-gadbed68f083b
Subject: stable-rc/queue/5.15 baseline: 109 runs,
 1 regressions (v5.15.28-111-gadbed68f083b)
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

stable-rc/queue/5.15 baseline: 109 runs, 1 regressions (v5.15.28-111-gadbed=
68f083b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.28-111-gadbed68f083b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.28-111-gadbed68f083b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      adbed68f083b55b7dfae23f2edf4995c43510ba7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231c9aec0b8ab5589c62971

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
111-gadbed68f083b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
111-gadbed68f083b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231c9aec0b8ab5589c62997
        failing since 8 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-16T11:27:31.811978  <8>[   32.572942] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T11:27:32.833330  /lava-5889934/1/../bin/lava-test-case   =

 =20
