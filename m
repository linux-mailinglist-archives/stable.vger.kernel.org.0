Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424D855203A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbiFTPTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244907AbiFTPSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:18:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBED20BC3
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:10:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d13so9984049plh.13
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PmJ0y3lL8NNXO6hFpKCRzxsEQCJedBODeiOISuf2UgY=;
        b=twCbP1k2/Ms83m1zqCdD0Bjx9CgpwnwkTJ3vGGpkuVzsLERdy6XEll5EGN1/B3hF1x
         Ge/OnBgp8DPp3dNSjMLZZA/4bz3stdLMghbyrFfJZjJOgYqZcbi5QmAD6JpJohXM7m94
         A5JBncHduFJvePIYcdCn0oeIn0U/fyEc8DzG/AeFSQiIHkAYbJz9Vq0L2smT0bjghnYc
         fuNhpBvQctHdy7ral7EiEW9nVIlbuwvAxVFHAab2Om9Tr59TE9DUzhF1PnqE15qz+vy0
         ydBreKdRVDNsLBjBGkvNOqwxXUVSzQ/mJ/pzOe4tEr8hJ4GiD1bBDmGSCJUbIuODNevY
         SBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PmJ0y3lL8NNXO6hFpKCRzxsEQCJedBODeiOISuf2UgY=;
        b=x/SRRouNji2HIWRAWktHSul0/qP/hepl3EuX4E4AwxV9dEzRm7WxHvCqP5iHd3ZQ+s
         uM+7TrcsnaEsMy6yRHgjpcEXtRZrk/m7SDVIieGFF0hKd333zITqQfSIG/MwKtW+j0bt
         3C8upahC04JmFvb58NRGF5jg38gCwMXfF76yMhV8+QFddsMfUym991MYAAKwxbJehqhC
         jT2nhwbcBOX0YDDnwiY30tJye7eB7nG2S20rnt0kdqiODtKfnACLW8AGnuran/yR+yji
         4Dp2mKWZ1fCESmGsvh3YDvkgNmLBM/rW4WcwRkiLngqXzdXYT5O8Dt0MGkLq4d5Iw84O
         Jcyw==
X-Gm-Message-State: AJIora9xtP1WrU/TVLZj66i2Cv+89yjN0Hi5IbhXVcWsw6CGrkFXuL9G
        8EwXTkEGMFRCgmtZcybOJXMBUe5Gn5hp+cRNwGg=
X-Google-Smtp-Source: AGRyM1sFvpCFo7lBtN9wqRdWx5gQ0m9lzcZsWpt2kNJFg37OVGCRu5CPOrzifHGVzzeDqloIKJwdUw==
X-Received: by 2002:a17:902:ef4c:b0:16a:1e2b:e96 with SMTP id e12-20020a170902ef4c00b0016a1e2b0e96mr7702751plx.27.1655737820961;
        Mon, 20 Jun 2022 08:10:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o12-20020a63a80c000000b003db822e2170sm9188481pgf.23.2022.06.20.08.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:10:20 -0700 (PDT)
Message-ID: <62b08ddc.1c69fb81.36c4d.cd3a@mx.google.com>
Date:   Mon, 20 Jun 2022 08:10:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48-102-g239d588d7e556
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 128 runs,
 2 regressions (v5.15.48-102-g239d588d7e556)
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

stable-rc/queue/5.15 baseline: 128 runs, 2 regressions (v5.15.48-102-g239d5=
88d7e556)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.48-102-g239d588d7e556/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.48-102-g239d588d7e556
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      239d588d7e556eeef28f79a75e252e3992fb8b85 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0611743556aa902a39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
102-g239d588d7e556/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
102-g239d588d7e556/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0611743556aa902a39=
c02
        failing since 9 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b056b7147a27369ca39bd1

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
102-g239d588d7e556/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.48-=
102-g239d588d7e556/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b056b7147a27369ca39bf3
        failing since 104 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-20T11:14:39.533597  <8>[   32.619007] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-20T11:14:40.561483  /lava-6651275/1/../bin/lava-test-case   =

 =20
