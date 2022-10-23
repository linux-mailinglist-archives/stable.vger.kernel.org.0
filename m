Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2A609653
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 22:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJWUyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 16:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJWUyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 16:54:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675406158
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 13:54:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g28so7445936pfk.8
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 13:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9JC6yl2ICE5P6dfWVxTFDfVAUa6zZ129ukEADIrckbQ=;
        b=7aopaMSocZJ2oV2bfi7DrsAKg4D17eeJePL7qpKlLzQ0lidTkBnfPSpsnsI7JvEmEt
         KNSW4zYtGa7eNuTujsTYGZXURGb/QgITlddAzZIPDfRiBOdMgD6bRf/tvbV4+iLQDInF
         HzTEQRLAPFC+gmz3K2GbkWqEeWEpH1F38c/keLqSmBT/1ov7MbbNcSivfjKsp9VKGjh9
         /TAKUNk4htg9PW7mMIdCQ6rxcc0rAi3D2Uj2Xl1Q8CNZS+Z7hbwoP5Wojk2nqxB3hD/3
         15fcE6bMwL9MgXDqOpOCD/4YZvoA3eTOQ6z52VICqJ93QB1xnHzn9P54ft8W20sO/4l2
         5heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9JC6yl2ICE5P6dfWVxTFDfVAUa6zZ129ukEADIrckbQ=;
        b=XhP9rEEvLkybBnW45T09VbtdFOR9Ap2d0LyHVGwo4RKlBSk3F/8NtJOJjqQ4dZJEP3
         64m3LrGNkZeTysRT0pRXtLBn/NLiSefVcuFAPkYBGL3Lq53owdI1XWtJbsKfR1fpdBBN
         yZKvOtHlbEtwpALIr6GWAntX0qGT+5OWBceZyvZ7eZjK8vzS6BioDs2uIuvpMHpJPaTE
         TM1Qg0jIMUCrxwcvXtp6IyTJ32BLQy4S2DydYVQeIoVWcaAbVPg1X5haTxYsGr+5UrP9
         ck18DCMgvHZWCOxtQCudhoy/2CWXlLfGH79bugermZ3dWA15XiQ8PSmY443txHUuZ/wY
         EO/w==
X-Gm-Message-State: ACrzQf0ldsyYeRr1a728FjIJt8CXO91O6Gk+YnGO/8g5gwXxS2OWEIg8
        cNXkVC9xK0uEY/5CxUh/8G6UHjnQXntLeMbI
X-Google-Smtp-Source: AMsMyM73ZEv9VwBRslpB/F0IPHq3NTd+oPBAmElV7cPCYQ7o4Iod1/PK6Ryjxner1t96Ld3VanEpNg==
X-Received: by 2002:a63:1d1:0:b0:43a:348b:63fd with SMTP id 200-20020a6301d1000000b0043a348b63fdmr25885833pgb.52.1666558471567;
        Sun, 23 Oct 2022 13:54:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj17-20020a17090b4d9100b00205d85cfb30sm3076220pjb.20.2022.10.23.13.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Oct 2022 13:54:31 -0700 (PDT)
Message-ID: <6355aa07.170a0220.427d9.4cc2@mx.google.com>
Date:   Sun, 23 Oct 2022 13:54:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-716-g7c7af9c1d7808
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 166 runs,
 1 regressions (v5.19.16-716-g7c7af9c1d7808)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 166 runs, 1 regressions (v5.19.16-716-g7c7af=
9c1d7808)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.16-716-g7c7af9c1d7808/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.16-716-g7c7af9c1d7808
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c7af9c1d78081148efdab89684d24be8dc38491 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635578f85fcc7c00ec5e5b3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
716-g7c7af9c1d7808/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
716-g7c7af9c1d7808/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635578f85fcc7c00ec5e5=
b3c
        new failure (last pass: v5.19.16-717-g7ded7ba8ae295) =

 =20
