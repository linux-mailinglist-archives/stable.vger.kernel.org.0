Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0215A4D6E60
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 12:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiCLLSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 06:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiCLLSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 06:18:09 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD1F108546
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 03:17:04 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 9so9750142pll.6
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 03:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Exg2jCwXUobyL0mgWMM//dcOyVJO5Tg4H3teLqO2EqI=;
        b=suFlGSqjUb3oZpPuRcchv9og9jMgo3jfAko+jL86OwSZ4ei7YIhMMbZlQfBG5AYPWn
         sGUtZB3VX0cfHyi3DOKP2O0Te/IOHAecjFlejrUdjQU2eJ2WbWSKpbkFT+3MGIMvQ1TR
         YKtjE3inkQtrVkov4k2L5UrVxcFcOULBkTnCiCZk1ADjWtE/PYJeZOHMPncv4zRmMk8z
         5irPZIyrcbnf9fziECDcfxO++ueM+75PB4Tp8/LcXolHneph0YACjDHS+2XQgk9duKXS
         SH9GiWd3BLZp7TO+aWJZ2FObx4H4wVi7jlALXL0PBwDJ4shCApyz7WCn8gYmwRqgel/i
         SeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Exg2jCwXUobyL0mgWMM//dcOyVJO5Tg4H3teLqO2EqI=;
        b=MOvVcn5GVT4sAHpUIXjr7kEXVAnvwqsKhH5s0cDhpDL/eEqe3hAXGQXu2zgpPrDzno
         TSEzSmvcyW6VCNGph3u2+63vvZ8raj34YM7nKgbnDp2K3fBs/FdM/b5s2gpoFL8IWllg
         aKp0S0h9S4au5Qy/hFMjungOYF1KKgxqxGEhrik9po0UJfWplayB+RhFrVl2m2Qdr7hz
         T+TzZYpPKUGwR5kxfVYXkQDHtZPsSUYotsIbU9cTpNvqkQOkrVI0kzVgLdAH1kJ+i/k9
         Y/yH3h7EsPLMSkA6ZuNyHc2v81Y6fW2fXrzJpO2/NcAt9TJHKw0yiw/Yys/Lg6E/0Jmh
         hHtQ==
X-Gm-Message-State: AOAM532yiCk73FAeGDPmtICi23me14Nf979NcIPp/v1o/seHlnLcr7rf
        uSYABv+NuvvOTJ1KoxlfS3EQry19KpYVwHy3x0A=
X-Google-Smtp-Source: ABdhPJyxQz+LSJ27EboazIUUeRLX5ufqH3XJvsNSFOmwUBaJZODPQj4QKpH++Nwk75JhzLbWB7qUoA==
X-Received: by 2002:a17:903:2288:b0:153:4103:5436 with SMTP id b8-20020a170903228800b0015341035436mr5179726plh.62.1647083823791;
        Sat, 12 Mar 2022 03:17:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5-20020a056a001a4500b004f731e23491sm14557369pfv.7.2022.03.12.03.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 03:17:03 -0800 (PST)
Message-ID: <622c812f.1c69fb81.affac.4d29@mx.google.com>
Date:   Sat, 12 Mar 2022 03:17:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.13-54-g8a3839d7a6f3
Subject: stable-rc/linux-5.16.y baseline: 84 runs,
 1 regressions (v5.16.13-54-g8a3839d7a6f3)
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

stable-rc/linux-5.16.y baseline: 84 runs, 1 regressions (v5.16.13-54-g8a383=
9d7a6f3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.13-54-g8a3839d7a6f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.13-54-g8a3839d7a6f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a3839d7a6f38d700fead63c3976116e5172ba62 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622c4e97f81263e8e3c629d6

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-54-g8a3839d7a6f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-54-g8a3839d7a6f3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622c4e97f81263e8e3c629fb
        failing since 5 days (last pass: v5.16.12, first fail: v5.16.12-166=
-g373826da847f)

    2022-03-12T07:40:51.874866  <8>[   32.621217] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-12T07:40:52.898118  /lava-5864366/1/../bin/lava-test-case
    2022-03-12T07:40:52.908814  <8>[   33.656455] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
