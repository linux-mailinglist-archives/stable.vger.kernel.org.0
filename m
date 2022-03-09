Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB64D3CE4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiCIW2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiCIW2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:28:34 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E8BC95
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 14:27:33 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o8so3123091pgf.9
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hKh3ogpUqEBrLFKK7dSwotXeO1BMvNoP4FshlcrGvAo=;
        b=bnIUfEmB1+dh4SpwrEiFpd7/3nuQnepiSXpmYX+U+iw1V6Q3nGTmMXONYG36g1bzPf
         c7Kbgn+xgC4bd9efrwlle/35YkZQKjRb6MVXl3PZTEQmRhxdnk09NwBoBc4qkdvlhb9o
         07E6uZuPwRL/68ms6UP/zXLyStDVmuCuiui1SLdhfwxDduZJ+vAR8jppoKC+RYdOIYzp
         GFncywXe2ceJSQjxOATQPdoA7Z6Nbd0XoYP/C2dzojSnIxQrc8WiBiL4i/D5oqITyJt0
         2kRZza6T36bPVqUS/5xP7BSuC38ai+h/T44BHzRBiYADoXDn7Oe2ZaC5MRLnMBvF2Ujx
         Gprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hKh3ogpUqEBrLFKK7dSwotXeO1BMvNoP4FshlcrGvAo=;
        b=ojk8WSBTXSnPFj+fVoJQ2k92pnEZa/A780Al20AYW0jnWxY67Gd1tktW82oUFTmQ21
         ERq+QIyggjs3kpad63GuDvwEPNPn4HZFuGa8ltfBDS5QhwjK5dT1sKAH6z0TR0ywTxKQ
         ISCp4+lUOBYVd1jL+hP8jvEKOCkgpRkA0wMx3OhiKd6/WU4ENonEidR85qA9oYvCYKXs
         aJP37n30CTFIN7aA40GhidnxgxHRZHH7SkLSzhrAcEzpoDpXnayQ820/pmZcBgjc3od1
         vIQQVVxddyKiQe9W9LnhfcLyDC7fgL20H/0ephqtMVUigWzENGZ80taY/4TFn6h6K+7R
         6Kog==
X-Gm-Message-State: AOAM533LTJO8cPGfOaMvYipYLswc9FjgWeW6V2ur65IAxYHbbBaS/yxS
        MD3uy17ZZe/Hd+hIk+vgw0RNYH9h2iu1pDNqIFs=
X-Google-Smtp-Source: ABdhPJzA/jr5M6p32G90TqZC+E0kifIorAf9/CFqtgsCtjEh70LqZ+/Tsx0TgObkptmzUl3Am+9FCQ==
X-Received: by 2002:a65:6643:0:b0:37c:94b6:f77b with SMTP id z3-20020a656643000000b0037c94b6f77bmr1508867pgv.345.1646864853110;
        Wed, 09 Mar 2022 14:27:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm4113209pfu.56.2022.03.09.14.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 14:27:32 -0800 (PST)
Message-ID: <622929d4.1c69fb81.d2d2f.af94@mx.google.com>
Date:   Wed, 09 Mar 2022 14:27:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-18-g1df0eeb4908a
Subject: stable-rc/queue/4.19 baseline: 16 runs,
 1 regressions (v4.19.233-18-g1df0eeb4908a)
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

stable-rc/queue/4.19 baseline: 16 runs, 1 regressions (v4.19.233-18-g1df0ee=
b4908a)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-18-g1df0eeb4908a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-18-g1df0eeb4908a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1df0eeb4908a2b1a92f1284b0e71bb20e42abaf3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228ef889a8a84a919c6297c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-g1df0eeb4908a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-g1df0eeb4908a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228ef889a8a84a919c629a2
        failing since 3 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-09T18:18:28.341183  <8>[   35.630369] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T18:18:29.364406  /lava-5847049/1/../bin/lava-test-case<8>[  =
 36.654850] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>
    2022-03-09T18:18:29.364545     =

 =20
