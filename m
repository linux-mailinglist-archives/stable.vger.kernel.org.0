Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59104D3F34
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 03:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiCJCPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 21:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiCJCPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 21:15:32 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863AE11B5C5
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 18:14:32 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s42so3906935pfg.0
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 18:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zeN0UZQG45PWGBfMyvF0HGlo9VNlmejfkgmxAJ+G1LI=;
        b=xLzY97oLqJ5QEx1dbN8lwhhRVE60tUeNc3eTVJzeQoVIqP7ncEe0bGPeIA1Bk2NR3L
         SRrl+65+ZsEQ4Sbrg2fAqEbp/7GRy5dbwVeuxThmGGpoBBkjRWzzb84KSCZoFJd0MHnG
         XtFxnnFj5KIaIhMbXsjPrSGn8tU+O0V/CQS25kZK0OBRCRlYlF2gPYE+IQyftk8XbFgC
         Xgb8tDJYf16qeHg4ork7tTjBDm+xTkLsWpFNySh/UOKR9/CWFBPpY2rdMbWfjrpjcQ5a
         lo8ONpgNmrxDGmKBbK4ZN9EBBLyXEuYdNjEy6IJxR6O9LdryPVGo7coYr6UhbanvO7uj
         YPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zeN0UZQG45PWGBfMyvF0HGlo9VNlmejfkgmxAJ+G1LI=;
        b=AsUQXVj/Vj660ZwJNpP9Xo6r/OHEu6EiSqWjgO3PVv+OXMUJ6xlIXFihWnHTIgOx3m
         w+oibOUgyAYllB7ZnzRl3TgX5QvKb0HSmXiHgmU1zNmRp6ReDaHFnXWxKb7Jx3zRwvfz
         JyWuQSKOztuc3LKw04WCbG+i5dUD+08xG6MErVxEJUvbSXs1ul03zY5Cpbs2+5eqehSr
         FFaTLwnG+PnsewxOAEEcSZEw9nSzek9MBg3GswopBHwrIB7WBOgnd9TbTydwnBSZxI8y
         rZ+r58axJRLLC+bjISHqV+gx5znSSK+ZlMfdBgY0R4pWetusWSR0Ax+yav6D2nFzBWnd
         aU4A==
X-Gm-Message-State: AOAM530SbkTUP9wqJUEtb+4AD1UUJzoxGRZAI47koLLqSnSOrgqIn1Or
        M9hDRq7vjRsBdT3x+gvAKq/bdtrk1AdfBWvi3CI=
X-Google-Smtp-Source: ABdhPJxcjdnEoig1rukDtqfPrqu+LgttYAseC2a2A2jLocQW1Lpmu7GQVYwf0poJKDNyRHh2AGCUJA==
X-Received: by 2002:a63:2c4e:0:b0:373:6dfb:29e with SMTP id s75-20020a632c4e000000b003736dfb029emr2163058pgs.109.1646878471900;
        Wed, 09 Mar 2022 18:14:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090aaf8500b001bd4c825deesm7669118pjq.43.2022.03.09.18.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 18:14:31 -0800 (PST)
Message-ID: <62295f07.1c69fb81.7024c.49c7@mx.google.com>
Date:   Wed, 09 Mar 2022 18:14:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-38-ge6347addcf77
Subject: stable-rc/queue/5.16 baseline: 110 runs,
 1 regressions (v5.16.13-38-ge6347addcf77)
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

stable-rc/queue/5.16 baseline: 110 runs, 1 regressions (v5.16.13-38-ge6347a=
ddcf77)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-38-ge6347addcf77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-38-ge6347addcf77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6347addcf77484d927735194aa8ee0daf566759 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62292e66a120ea0ad4c62983

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
38-ge6347addcf77/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
38-ge6347addcf77/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62292e66a120ea0ad4c629a9
        failing since 2 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-09T22:46:44.194816  /lava-5848676/1/../bin/lava-test-case
    2022-03-09T22:46:44.206200  <8>[   33.642867] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
