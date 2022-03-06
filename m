Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F114CEED1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiCFXyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 18:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiCFXyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 18:54:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383EB3ED25
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 15:53:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so11476200pju.2
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 15:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rdrIKukitQabjey3VOpV69mZS/Uik9LfS3FK9ag7VLM=;
        b=rJ/iG+385/lN2mvcTyfp6KlP3O63LjrD8KzPeqgRnnn7ODNYiMbbvoMNCN0sR2915f
         WI0Tkc47UCjj2Btz5Ea0i0cOO5onoqOzPfHolI7K2ChDYXu+Xu1siE+1RSf8drECopIw
         mNbswAeLYaxSDcuVBOyuaSj29dYU92YQzO6ymeYRpA+CKnWPY/MZGBHl2RVWtH3wM4yO
         lVePiSB3mtZ7Hq3lZ4m++p1jyd3r9WzncF5XDiLapYXSzqeRGTG7z8ZphRLIXvMT4RZ+
         KW0jUYEhDDFdNW5aiXJ4zTMD0WDg+4cMmi7VxPoF/ll3OL8tbaBrh88xSa1wyoZtt3nE
         mZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rdrIKukitQabjey3VOpV69mZS/Uik9LfS3FK9ag7VLM=;
        b=jOBPVUNCVnW8yIzXVnj5TZlIhP4C3Qyy05fkRufjTodBAWfZ0zN4FFWkp2H2kXWKd2
         6w9rdksNJupqKWzyRfCOmVrpv/DDzc6zZ/mIPsFTzPljv1LBTwOfoQyp3+HjrtvE5eI7
         3Uq9SaFVtKQrwdaLpS4BE0yoxkEy/aCOGvXl2kk9WwMVJyczozoDFpUANp84nPgciJf8
         uxECN2+H6+5q4g4NKRtMWuMMY8Nr0YiRlm4eB0bBuNMLathaD85J8moJVOrY1pmjew2P
         pzT4FxQ7TLP4hIKMHdIjDIAckCIQI7LSNg7+iSgy3ETfhA7TaknDYjy1PL3jmpmJf+XJ
         JdNQ==
X-Gm-Message-State: AOAM531L8aZ1lUvFhbykdkb3DyWxCpQvDGSoJZqr9lSE2dC+VlJZf2ly
        MfcIP0OvwGZf+605HrK87h19BEDeCIunyzeLU4I=
X-Google-Smtp-Source: ABdhPJwNYvc2vRCzwlHd2V1niNGplNoSUZLVnsFjPqXCev9R/S8XNR+Ri1uJUMCyulRaEWbKs/m6sg==
X-Received: by 2002:a17:90a:9292:b0:1bd:1bf0:30e6 with SMTP id n18-20020a17090a929200b001bd1bf030e6mr22084411pjo.73.1646610803498;
        Sun, 06 Mar 2022 15:53:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm1318125pfm.207.2022.03.06.15.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:53:23 -0800 (PST)
Message-ID: <62254973.1c69fb81.e451d.327e@mx.google.com>
Date:   Sun, 06 Mar 2022 15:53:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.232-48-g569a74d08a4e
Subject: stable-rc/queue/4.19 baseline: 31 runs,
 1 regressions (v4.19.232-48-g569a74d08a4e)
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

stable-rc/queue/4.19 baseline: 31 runs, 1 regressions (v4.19.232-48-g569a74=
d08a4e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.232-48-g569a74d08a4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.232-48-g569a74d08a4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      569a74d08a4ef4602637fe1ba243e54e05ef1daa =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6225114369847cd9dfc6296c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-48-g569a74d08a4e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-48-g569a74d08a4e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6225114469847cd9dfc629be
        failing since 0 day (last pass: v4.19.232-31-g5cf846953aa2, first f=
ail: v4.19.232-44-gfd65e02206f4)

    2022-03-06T19:53:17.091980  /lava-5826542/1/../bin/lava-test-case<8>[  =
 37.121956] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>
    2022-03-06T19:53:17.092111     =

 =20
