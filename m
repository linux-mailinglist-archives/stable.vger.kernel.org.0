Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7D5846C2
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 22:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiG1UDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 16:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiG1UDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 16:03:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5843201AA
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 13:03:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ha11so2966645pjb.2
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 13:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ezJQR/g4slsnKZbZQg9ETeGcoBXS7y6veqw7NtgbaeE=;
        b=SaB8e2ncL3rbun2lDApdNCY1ezqsMZkmICJyq9tvh7KhTdrBfjsZ8ICvRm8kWUlbfF
         Rk6nWOAebCBoh8AqxcpYlglI+xb9CLm4W8auj37iszv0INocQIr1z3B4Fn5YsqlYMhEN
         NCmEClzmIyTmUkB31qrUngFIijCTI0f0HsxyB44C/n6DX9QhmFMKaM1xSUbOdaBpsjxq
         9/Trte0yedbzjVjgzNMOgZ+w/qcNTgieD0ZZXXBL6XXbctihILtavQqLA3LlsbofLny9
         G99PoLwDqczFUREPxgy26IlPM/o2fpkIHCLO0H7rAGaqbdGH+qfBmCJHmpyaEP+ND+gK
         n+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ezJQR/g4slsnKZbZQg9ETeGcoBXS7y6veqw7NtgbaeE=;
        b=BCEGAs73WrX3ntIWvW45VQ7nWqlHy0gvP+A308WRhR/XDote7njjlrk4XCK4y9tbVe
         q0sDB0Ce5Kln56JSH2CyjgOxznLfSLsTRRl/it/9MTOOrH0nyKzgqhnU5FgO3easzHjR
         oN8Cri2UQ1WN+dgfS1Cg5EJqvX2Jx2f3Y85OrhY45J451ony40dM5L+t1thenj0q7dnK
         moEW5OggkppA0hqAHVpCUoT4gkb3nEbOopaLespsClfCsUYWhLHzP2vgjE6xZRQH8z1b
         acK/eJr37upCHqRjxg6oIdoeTz11DvU1TJORsr2iU7O9PWY1CX60kITkiJ7xWcfYTwbc
         2t+A==
X-Gm-Message-State: ACgBeo0oczwdeAYymPHmsjXbFEeLgbFflLVC+l3yDGbGNo/hovyNeXAT
        A609zpQs5FCIQZsVB44hf/uYSfygvz2IXJ8B
X-Google-Smtp-Source: AA6agR7q5nsA3l1SYCJxh2jg4g0QSxCN4esSHI2rhWMnUJaqDeNISPl6WUDoIUhusiWWUyz7BUXDKQ==
X-Received: by 2002:a17:90a:1485:b0:1ec:788e:a053 with SMTP id k5-20020a17090a148500b001ec788ea053mr362808pja.16.1659038623877;
        Thu, 28 Jul 2022 13:03:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902650900b0016bffc59718sm1758756plk.58.2022.07.28.13.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 13:03:43 -0700 (PDT)
Message-ID: <62e2eb9f.170a0220.6344f.271a@mx.google.com>
Date:   Thu, 28 Jul 2022 13:03:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-203-g77a604df16d5
Subject: stable-rc/linux-5.15.y baseline: 110 runs,
 1 regressions (v5.15.57-203-g77a604df16d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 110 runs, 1 regressions (v5.15.57-203-g77a=
604df16d5)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.57-203-g77a604df16d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.57-203-g77a604df16d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77a604df16d58def44e0577eda0f18f8232f9a41 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2b9beba3932f77adaf056

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7-203-g77a604df16d5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7-203-g77a604df16d5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62e2b9beba3932f77adaf078
        failing since 142 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-28T16:30:28.071822  /lava-6907965/1/../bin/lava-test-case
    2022-07-28T16:30:28.082224  <8>[   33.615549] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
