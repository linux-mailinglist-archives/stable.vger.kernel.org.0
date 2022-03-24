Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88954E695E
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 20:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352962AbiCXTfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 15:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345103AbiCXTfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 15:35:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B9A41F8B
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:33:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so6122022pjm.0
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B1+101Ksnm9z0amKajmr1863IrIEuFIFwuSRIlIS8Y8=;
        b=DCUftJuH0QF4NGDAClqS67NLheWz8YvK1qdCVX0iMYtFNTBYSB/ee93+z9K4XHuais
         Pg32pYu3NC4Hj07lRT46h07ditIjhj0cIZBoVjgRr4xtFiVCtxwXU1zWK0GkTVhYhYq3
         FKMHp5NOb6u2wVFSxjl8sl2ixgn3wsqai+iCjI9KhfAyJpLlhNs+Mw1Cr39SadT8F8Ae
         /sDF0z9eqe1bF61PJRj8YbjUYaEhPry+/UQJCS1/n81pFFS6+LKf7bJTae38bz/PNpdo
         tmofaGO2S5QIpyMBVSZG3eYu1u9NwvyAkj2tP1pGPPz83IYMyFp5/00s3aJevlVzyrFw
         8Vyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B1+101Ksnm9z0amKajmr1863IrIEuFIFwuSRIlIS8Y8=;
        b=7KkyvlaVnpIrISXdUVyI5PD4e8HrcEsgmQmFi+y0xYic8kTCVQ+uc5b7jY0x/sPBxj
         aVbvBw6Ka+dZGTmn+yAKnr20fnA6icTlQx77LXWa/OxGicPGNyBKu6V2DtjKSCuZIn3w
         FjNh6Avt/tXj4NWSC8CxYITM9spK536GTrt9kzgCoktcWPx0omf7yHo7fbTKFWVdSpOF
         FyzCxkNurjsbGsyhi+WfwmY9A0bSqcK1+hWqbPjVuCyjD9giqeaXOfVhvvYwMAjxPknE
         vgeY1GowihIFAE804i0Bol9GbxJRoGT+4e9ZJ8Coe71AwRRpziQYabmCPlA7GGPYVBSu
         OoJA==
X-Gm-Message-State: AOAM533vy1cvCkDDZcZUHsNd++vGNkHFGF/mLj+JTHi+nEWdR94Kocjx
        /QYh9CqQVHAh8InLIyI5LeWkoBV6raqdnjpKmVg=
X-Google-Smtp-Source: ABdhPJy2WdSOK4YWLxqr68qrAaf1ZNANGOAS3tX1hXXDk7QJdkJnsgLpQOhHfYFTVjESXk+cbY643w==
X-Received: by 2002:a17:902:f690:b0:154:2ceb:f18a with SMTP id l16-20020a170902f69000b001542cebf18amr7591595plg.4.1648150429659;
        Thu, 24 Mar 2022 12:33:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm210765pfn.183.2022.03.24.12.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:33:49 -0700 (PDT)
Message-ID: <623cc79d.1c69fb81.4d040.0fc4@mx.google.com>
Date:   Thu, 24 Mar 2022 12:33:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.236-3-gca5d91f4bb42
Subject: stable-rc/queue/4.19 baseline: 75 runs,
 2 regressions (v4.19.236-3-gca5d91f4bb42)
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

stable-rc/queue/4.19 baseline: 75 runs, 2 regressions (v4.19.236-3-gca5d91f=
4bb42)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.236-3-gca5d91f4bb42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.236-3-gca5d91f4bb42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca5d91f4bb42790a0a3102d4ce0db1af3bdbb650 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623c972b5236b24946772531

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-3-gca5d91f4bb42/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-3-gca5d91f4bb42/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623c972b5236b24946772=
532
        new failure (last pass: v4.19.235-57-gd1f635cdf587) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/623c9a1981605aefda77253e

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-3-gca5d91f4bb42/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-3-gca5d91f4bb42/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623c9a1981605aefda772560
        failing since 18 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-24T16:19:27.310675  <8>[   35.718987] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-24T16:19:28.322411  /lava-5940769/1/../bin/lava-test-case   =

 =20
