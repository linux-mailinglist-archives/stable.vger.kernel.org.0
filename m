Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3784ED321
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiCaFAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 01:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiCaFAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 01:00:18 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD62F2D1EC
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 21:58:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id t2so20857761pfj.10
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 21:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WXmY+9cIEIZiIBQhpzzj+aXDg8HdAykNDgXAvGUcTD8=;
        b=Ed7YeMdUkzDpeiUNL5xUKA+75mhLqxPLFn0rfg6Q6yDOoAUULmbgkGx9ptLWlmS8sn
         KgCsyUCyci5EkxMoAd/SPju+2hdV/8Qmjc8QNwEicFkZSi2DVzQl1Cbs2UoD2mjzhQVD
         mMhzG6YIGLJvV53Uh2qReMjMrggXFFcLJ6+7fXXTzENhBsfijRnIk5/SB/EfRVf1h8vh
         QtUe9cMtCRy/T8Ejdsro9Zzi5zuv9q7L0LpqewVjPnaZgFdMn7FOdapkFHJZrBEiMq2N
         1rlIaLFpdlmk191yWLgrN2J6tfVqNkvbU8Hwdo8NY04ph10haayxp0GiWs8rBaRMTW/1
         Jqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WXmY+9cIEIZiIBQhpzzj+aXDg8HdAykNDgXAvGUcTD8=;
        b=X0TripQFE/DyD5DLL4ygcnPDEfuiyGGBNM+gdgnvJuG7WiyKVYK8KMFnhP1q1HRRy3
         YrJtKqZXpkcgfW/l1xQmzLPzt6iaXdg5urQrg2TS2LyGEmADw44XZMHgd50pItaMy9FS
         8qeXszizZnQWoik2cSeajoBSEo9l2hJC97WjTlbSnL3YQgchqWUOQGenhTLaejv6jXC9
         T7NDvxj7dowN10e2BLuQFnL/X2T6k88dEXXAVv3yRILO8YOsj3mynNprzjaai4iV8o7z
         ISjrpcaW683QLI+Rp5g8busr4o9VS3PMvTK1dlGBC+3LqWB110G/NqW7b7rINuZaVLZm
         8m1w==
X-Gm-Message-State: AOAM531XHVTdRWdLLonD2uC6Y48jR77bNNIDjV5fk9EPxNekHI8Xqap4
        woqf8FVp/RtBB0/vgyvWHHCaERH+Is0XH1CMRKA=
X-Google-Smtp-Source: ABdhPJxfxFs/R9Zio8HJ/o1bxzckmTNziOG5l6W37lfjb17xnU5xtFDjvZzrxCDx8YZ0sKodFFBetQ==
X-Received: by 2002:a65:6093:0:b0:373:9c75:19ec with SMTP id t19-20020a656093000000b003739c7519ecmr9571282pgu.539.1648702712026;
        Wed, 30 Mar 2022 21:58:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15-20020a638c0f000000b003827bfe1f5csm20467118pgd.7.2022.03.30.21.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 21:58:31 -0700 (PDT)
Message-ID: <624534f7.1c69fb81.aa64e.60f7@mx.google.com>
Date:   Wed, 30 Mar 2022 21:58:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.32-30-g5ad2919962c8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 120 runs,
 1 regressions (v5.15.32-30-g5ad2919962c8)
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

stable-rc/linux-5.15.y baseline: 120 runs, 1 regressions (v5.15.32-30-g5ad2=
919962c8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.32-30-g5ad2919962c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.32-30-g5ad2919962c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ad2919962c839a6e54010d4c07ffece674ab514 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6245060112b22e52f0ae0695

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2-30-g5ad2919962c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2-30-g5ad2919962c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6245060112b22e52f0ae06b7
        failing since 23 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-03-31T01:37:57.250458  /lava-5984702/1/../bin/lava-test-case
    2022-03-31T01:37:57.261391  <8>[   33.629541] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
