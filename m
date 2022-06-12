Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ACA547BDE
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 21:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiFLTlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiFLTls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 15:41:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6FB42490
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 12:41:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d5so851736plo.12
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 12:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mi9+wdUdxq307+m6aRMoOgmT2SHh5N3fhTI+utemz6o=;
        b=AfRdK3LFdT5zKBb0IjhxyXNpb50jwVedNbPq3FhRJeQhu2+3nu+wSXOxj09QXjYKCM
         rs4U7ShK3IP/FZNxPbjl0qdWenYGeBhhZ65iCobjUplMxKa69aPHhTNmJpj7VPOVj5dD
         oNxAycUDzld8s9A2FZ+vj819GBHUne1VYDjGY0R5QJM4ARXHsYCl5Eu7u0wuSeqEXhex
         Qymhta9gJ+6FXDHBgJHlvfmpWYkzFssY4J2pGIraAcnKYcZqQ/H7tmfSxnbXyJ3TF/Nh
         z5TZcQ57lwMd4aiCnz4MF701uM9Z5tR/AM/zp/vwncHcd++udMBeZt5ZnT5tNgL5W1XZ
         GitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mi9+wdUdxq307+m6aRMoOgmT2SHh5N3fhTI+utemz6o=;
        b=j29w1b4tiq/uW+U7gV+a6wSXD9pKHG/9njiM/qo9AoTcGGaBIjDQcOWgw3dbJpYXp0
         yGolcOGDvsICH6dzE1EeFTOiObO4WpZ+yc051z3rUoRlm6zEMUpk8qJkwUAcPwhZxsfR
         SfvGqWgwmHRoz7YagLLs8nmAgye0fX8iOKoIbX3wzY7UZXQAxNpqdhjN0ZjMB7t7oMrj
         aB/Qq6meAc3Ilk0bFXJuOHySXptkFSjPLGgrmg0ORoadk+ydzjtu1Akq3PhYLMDyjQRC
         Q7SFvTPo68V/DU3u/DJj7+Zwhziw6/thQU4CKLosVW6qpq4KKS0b0hMKrnGhAomVh9oG
         44Hg==
X-Gm-Message-State: AOAM531+cYUAiJJDaf0yuVIebjgs5Z50XG9CARcTTquvQZb3RAJcdAIN
        r6XED/0lY+X54INaBqjleBK60eMa0iWcwu4yvVg=
X-Google-Smtp-Source: ABdhPJzAkosr9PXn+/7YNPHr6ypaoyjfz7vvrDd0wqDKFQe5LEqT+iOwJRwkdWKLDmEmvRzsFZi5Uw==
X-Received: by 2002:a17:903:25c1:b0:167:93c0:ce04 with SMTP id jc1-20020a17090325c100b0016793c0ce04mr29271240plb.171.1655062906873;
        Sun, 12 Jun 2022 12:41:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij11-20020a170902ab4b00b0015e8d4eb1f9sm3417096plb.67.2022.06.12.12.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 12:41:46 -0700 (PDT)
Message-ID: <62a6417a.1c69fb81.30d2e.3bbd@mx.google.com>
Date:   Sun, 12 Jun 2022 12:41:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-833-g04983d84c84ee
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 91 runs,
 1 regressions (v5.15.45-833-g04983d84c84ee)
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

stable-rc/queue/5.15 baseline: 91 runs, 1 regressions (v5.15.45-833-g04983d=
84c84ee)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-833-g04983d84c84ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-833-g04983d84c84ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04983d84c84ee97abcab8bd9e6488790086cb082 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a60d06a0d46466f5a39be2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
833-g04983d84c84ee/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
833-g04983d84c84ee/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a60d06a0d46466f5a39c08
        failing since 96 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-12T15:57:37.403695  <8>[   32.278154] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-12T15:57:38.431360  /lava-6599053/1/../bin/lava-test-case
    2022-06-12T15:57:38.441601  <8>[   33.316788] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
