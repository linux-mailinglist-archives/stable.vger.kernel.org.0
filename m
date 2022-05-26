Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DE6535423
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 21:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345348AbiEZTyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 15:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiEZTyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 15:54:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3772880E5
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:54:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cs3-20020a17090af50300b001e0808b5838so2562474pjb.1
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JV6/a2weY9KRXXKTuxs3n+rmiNryCvVWxvIZWTYb7oU=;
        b=rbDIVZl40fNLW40GVdartjt+jA2tc0VvPhxpatYcrQSyDo2TTLPEw2joHw6XtZDC5M
         cNH03V8Jl5ljt3yLmiC5KCElT4b0ZGYMOBk71BgZqtzWij9oOtsl4OZrvWKgXL3RaWL7
         V2+YSEi+gv2IsR4soY6TXR8XljeOfn2dYhzeYgh5OXMH5RyGveIZ9GN0Dawhw0rr1MEP
         LbAsWSfFaeodpDucxmb+KdbjVvJ3D/9mRuTo/R7nJD2Dv/dXbISsJiasN40KPFm5UByA
         E/F9QJ/UFbqR5VC6MXtFk8x3gd1IbBrXw3QgFxXZpnZw4RDLrX8rMFK0x3h7HbcV7Sny
         Q8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JV6/a2weY9KRXXKTuxs3n+rmiNryCvVWxvIZWTYb7oU=;
        b=3liGfAWEzzAm7+t2NRk0RDqYn7OG1YbVVTKPKZ96CisCNhNLiOQcjoYRb7gZmCaB7f
         XuJRe8Zs5MElMHYZ9QpRINCF0O5gzYuomYleOwuL2qI7dBWZBteJ+px3/N6q+RdaXJBW
         EbagkGOqsPWWaV9yGjNhufmz9EX6XjvkSCfCcihajUyW7ObLz+n3el86cX3Qmd6yjC29
         7MhwSVl7gsV1l0wj36eQNBGXrK5VBcVuVw9iSFo/zgPcTLsEUUoGDAs9ernG7yMrP6wA
         AD6sfofBLClI0MjRBSsTpVdWKAmImR2biFfPhAeAiAbn/ZmiJtMpemi5hnqhBrc3pM14
         ZvxQ==
X-Gm-Message-State: AOAM531mJphLk69ZB2kEQ/yaaVMzm8wC56R3w7vk1QeSDOeGbGVGyte8
        lhGPuyuJNr2wPBFyyQysyDkSmzfwXFjvw0re3so=
X-Google-Smtp-Source: ABdhPJzaNK5Lu0S6TA7kUd8Oq4a5IU2Lfo8mXs/HJOUtMhvWATKgAmBtmshGNocWOUxmEMTyXXzZlw==
X-Received: by 2002:a17:902:8693:b0:161:e28f:f85f with SMTP id g19-20020a170902869300b00161e28ff85fmr36656225plo.17.1653594850028;
        Thu, 26 May 2022 12:54:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18-20020aa79852000000b0050dc7628195sm1916414pfq.111.2022.05.26.12.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 12:54:09 -0700 (PDT)
Message-ID: <628fdae1.1c69fb81.941c2.4599@mx.google.com>
Date:   Thu, 26 May 2022 12:54:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-4-gcd1decd79c79
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 71 runs,
 1 regressions (v5.15.43-4-gcd1decd79c79)
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

stable-rc/queue/5.15 baseline: 71 runs, 1 regressions (v5.15.43-4-gcd1decd7=
9c79)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-4-gcd1decd79c79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-4-gcd1decd79c79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd1decd79c791f32b932fbb7447a0c26cf209bb9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628fa38ad2613f2f00a39bdf

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
4-gcd1decd79c79/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
4-gcd1decd79c79/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628fa38ad2613f2f00a39c05
        failing since 79 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-26T15:57:49.192156  <8>[   59.788851] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-26T15:57:50.215310  /lava-6477936/1/../bin/lava-test-case   =

 =20
