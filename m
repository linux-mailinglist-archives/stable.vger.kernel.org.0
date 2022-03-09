Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD64D3D34
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiCIWmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiCIWmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:42:32 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF92D12221B
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 14:41:31 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q29so2180271pgn.7
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nozg4XL860miiuriY/WO/7JGKnWoIOFtgCMuO2CcIq0=;
        b=mSWIXnki5wo6+MfOUd0CLqOrBWy/eZzMbjoQMNDmH8vJUThx5MbZTfXyCs+J7A5oaJ
         4woSrJIo+iAuMWRAJaoDd8TIig8T+uutKA36wuzuvjpHp6FJkyUo0ESjfwiJukLOou2e
         9EhJeXZrPeDnk94vB2MKUP8ohISeuoJ+1HWErnC2c1/n263a3eVSIO/d/+Bp+t/NHNb7
         XF8L0u+FOzJCmeMhdD3is9AgJEHTuBi22jOgzczLcRKwtbs2kyW7NJqG8jeEq55yIv/4
         /yck21T9s5GNcSd2w4xztg80kze5DLITPH58GkjpyiiIs62lPhyfrGDBn6Df8O6D2nvO
         noxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nozg4XL860miiuriY/WO/7JGKnWoIOFtgCMuO2CcIq0=;
        b=aK2CepVMdthyDDPe909Zu0/2sbcrE2lCwrnmGzk+gZ0PD4Gu0MHlXYF25I/BhBil8Q
         2PWa4BqxjlQXT3Nj8tP7n6m+wKuvRY9MsYQvaiU+ldH2XK39xUmEdf1C4gqJwGLsrcaM
         1aYBah9dBTaWbptxGd8AuyvtSHHKrGf3W8RDOPo6Kuvtb0mGpXm4WQRi/lwqSqYmV0kc
         QwFMOi0DH21SYlIbOuDbHnb9pRjd+aUNfL3Y7+vQaYzUZ2hTjEq5emsZcJ7neT3NeFTf
         wSScDxKihK0OLxF14X+lf45HalSpNG9s6653BUX94gQilJ6dhWd0etnSmNzJoE5wazEP
         tbPg==
X-Gm-Message-State: AOAM532rtAQUMxwcktRo0pkTjPAG+5I0XazCdIYtNO2mypZw+hPDZSnd
        Bdn4ZNFWPyT7s15YtH5G2TjBruh0tz1ar4T8Xlk=
X-Google-Smtp-Source: ABdhPJyH1tP6qbWQTcR6d/YlxcnNjcSPcsMS4AB1XE8tP4X82SxxNlJsUFzOYhZQfxtJw+G5aODHng==
X-Received: by 2002:aa7:830d:0:b0:4f6:ad6b:5757 with SMTP id bk13-20020aa7830d000000b004f6ad6b5757mr1963233pfb.52.1646865691214;
        Wed, 09 Mar 2022 14:41:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b004f769d0c323sm659995pfl.100.2022.03.09.14.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 14:41:30 -0800 (PST)
Message-ID: <62292d1a.1c69fb81.41fee.2c4f@mx.google.com>
Date:   Wed, 09 Mar 2022 14:41:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-37-g9fad9a86a8b2
Subject: stable-rc/queue/5.16 baseline: 79 runs,
 1 regressions (v5.16.13-37-g9fad9a86a8b2)
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

stable-rc/queue/5.16 baseline: 79 runs, 1 regressions (v5.16.13-37-g9fad9a8=
6a8b2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-37-g9fad9a86a8b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-37-g9fad9a86a8b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fad9a86a8b2a64845d9dae4e30e0ad86ef970e4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228f89efd600f5299c62980

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9fad9a86a8b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9fad9a86a8b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228f89efd600f5299c629a6
        failing since 1 day (last pass: v5.16.12-85-g060a81f57a12, first fa=
il: v5.16.12-184-g8f38ca5a2a07)

    2022-03-09T18:57:15.322944  /lava-5847414/1/../bin/lava-test-case   =

 =20
