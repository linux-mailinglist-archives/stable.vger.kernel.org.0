Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9A4D0BD4
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbiCGXPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343905AbiCGXPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:15:36 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C389F35273
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:14:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s1so15396088plg.12
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Ft6+faTvYjPU0LzeGwJfWFRrbhubR8nTlqlITf0ZAo=;
        b=hhVjARUHd7hEuLx17Rb39iRjPCiSCMp3FVeNehGNz0q2V1V4OCoA88GTBH5wvHrfyr
         rml8hiRX1fMgZARjqnKWjINygpNVQq487K9nqtiwhpR/VzE2uYiekb24KNr3XIman/M3
         48DPqVhwdMqB219cwjWCgj9RaqiooVG9+SZ6PtP5TWyfWG8Cyf3EmJd72gNyELw57LFs
         TTyuiBZGL7rRr9Mc2XpentZxrzr8tjPhXjcrM/Cgg4Havs2pKD5Kcdo1fX2MWY9f2CNx
         B3GfzVIsZZoOmK4OaHiv5/2w+A2EXwOCYaCeEq/eCaVUwjoMxWtOTG9vUQm5d0zoE1Oi
         xXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Ft6+faTvYjPU0LzeGwJfWFRrbhubR8nTlqlITf0ZAo=;
        b=UAKenvrQ1l5QCSrwHbsnM+njdhmGuyIVHqycctGCvcgosKDpRDAEEBab2wpK7nuLci
         5jPaxrgDQnpy9H6mD/B1VGW7IIWV9/PdzK9sYuFZuP6KTOgdZnnvoQhAvx106hKd498p
         LM3sFMTvXewcDC2s6kLwA2kGbjjfHHI1c+E5JimzLI6DwG3D1jFzpHPIRjj50wJdV8Al
         Cl57+6Fkfmf0L0FVnNqq+vt7A6i5DA1ODHPrUc8bxicdl7UbkHA9UqmX7eh0vqVdlqzk
         ykm8Up55qDez2pGBX5OqxwGM4YAFNGVLreyD9w+Lsy239B2U4DvO9akuBsdB36iFLXFf
         TUaw==
X-Gm-Message-State: AOAM533IvWBsfD1LcXHQzOnq0Cyc7MiFNDgvEW2R7VXBVq775dMxhDO1
        5wN38ZXXJAWjZwfd1OTc9steXlLBT78m9c4+pss=
X-Google-Smtp-Source: ABdhPJzy1wgurgqn3LTSuukv/5X4v8tDuGdjPVFXvf6JdrKwCtj2PFYkYMynP7mjuKqnA8sHMCYqvQ==
X-Received: by 2002:a17:90a:b393:b0:1bd:5400:cba9 with SMTP id e19-20020a17090ab39300b001bd5400cba9mr1455233pjr.232.1646694875211;
        Mon, 07 Mar 2022 15:14:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm392220pjh.19.2022.03.07.15.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 15:14:34 -0800 (PST)
Message-ID: <622691da.1c69fb81.8e270.1989@mx.google.com>
Date:   Mon, 07 Mar 2022 15:14:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.26-257-g2b9a22cd5eb8
Subject: stable-rc/queue/5.15 baseline: 50 runs,
 1 regressions (v5.15.26-257-g2b9a22cd5eb8)
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

stable-rc/queue/5.15 baseline: 50 runs, 1 regressions (v5.15.26-257-g2b9a22=
cd5eb8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.26-257-g2b9a22cd5eb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.26-257-g2b9a22cd5eb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b9a22cd5eb8da6f8b3d07afd4721a910cab05ef =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62265f54c33cc34452c62972

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.26-=
257-g2b9a22cd5eb8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.26-=
257-g2b9a22cd5eb8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62265f54c33cc34452c62998
        new failure (last pass: v5.15.26-42-gc89c0807b943)

    2022-03-07T19:38:33.941408  <8>[   32.622748] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-07T19:38:34.964512  /lava-5830424/1/../bin/lava-test-case   =

 =20
