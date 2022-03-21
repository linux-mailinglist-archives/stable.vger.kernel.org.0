Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4354E326B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiCUVsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 17:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCUVsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 17:48:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC8C3AA994
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n15so13885681plh.2
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zj0AaFvYKIh1OQoqVqu6m1jXg0SNhul+6a6G2ep1RFE=;
        b=HYIKOvr6YMBPkAvwQVoIY10OwGVr0Fp2VpsjcfKGt5oElLfKCZf8cFelB8U0MiUPWP
         xuq4vJ0RAm5mvJnMpDAifDS81rgUTmxyameU+1X28XVSHYLlsng6O0cm1gBoBdK9JAHk
         mS5ruBdbyrhQOtupA5Gy9VFGsRUJk9V8vQnfUJiOIFXga1ZwYJL89T2FKKmdtsKYdQ/U
         xS5VVx4hSySVwQiTB8UUi9XAuQeB56B/ElvqfXz5NUxfmMRQK4NbSaq4T7QDOvwQWqdk
         MMeZzjIuQh4NSRI9vjMSiuxkVjKegWvgwAjBgKg5x7hSHphP4fO1VUsZL5L8Yqo7Q6Hc
         9MAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zj0AaFvYKIh1OQoqVqu6m1jXg0SNhul+6a6G2ep1RFE=;
        b=ZOI/Sq/9mz2pJu/2i1l4/kx7VrxEmp/hhsqJFRjj442fJ+uFL9wzE0XObOrXFadkNl
         N8eBhSGe2TypRH+jn/9L+nG2RNIz0Y7+y245smlG4KarrfzEa5EOrWskApsryWtyUfMg
         LiRL2c++HZrTOcbDuNtVpwVD71FP/jNm4kpq/QY7CNWjOee2ZifXHuGZTD0yzko5QmYh
         T00m/VqDJH0qMLFLB0HkAMliuYqYLfA1Be0gI3lh+OUfwRzflQnzNHayr0o/h57NaFYT
         Z+8gvloRO6uVgPXULiWqULA0ANXnSBDsjHYuMGdWGxrw45snpM6edQe6toYDJZeDkoOG
         aXUg==
X-Gm-Message-State: AOAM530dStHI+h0p3evXsI7N0jN+N0946zJeUv6D7n0lXSo2wmuyMSc9
        wlCRqfO8ziE6aMYMxwpLW7YWsZSi8OZ4aTZ6c+8=
X-Google-Smtp-Source: ABdhPJy/IpMk1/8fGUztwFkQfqpPIoV0GY3QGvQShZyfryOgMS5PRNVYjt+GBk9j0djnvoPixDKjJQ==
X-Received: by 2002:a17:902:7045:b0:153:95da:fcee with SMTP id h5-20020a170902704500b0015395dafceemr15185605plt.49.1647898990460;
        Mon, 21 Mar 2022 14:43:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lj7-20020a17090b344700b001c7032eba5fsm369612pjb.4.2022.03.21.14.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:43:10 -0700 (PDT)
Message-ID: <6238f16e.1c69fb81.7fa15.19a9@mx.google.com>
Date:   Mon, 21 Mar 2022 14:43:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.107-31-g9d7b0ced5647
Subject: stable-rc/linux-5.10.y baseline: 77 runs,
 2 regressions (v5.10.107-31-g9d7b0ced5647)
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

stable-rc/linux-5.10.y baseline: 77 runs, 2 regressions (v5.10.107-31-g9d7b=
0ced5647)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.107-31-g9d7b0ced5647/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.107-31-g9d7b0ced5647
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d7b0ced5647e0df1b200ee29119cb58ff958339 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6238bcba73f71dac692172bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
07-31-g9d7b0ced5647/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
07-31-g9d7b0ced5647/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238bcba73f71dac69217=
2c0
        new failure (last pass: v5.10.105-72-g1ef0e2b31490) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b4a4435a27c0372172d9

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
07-31-g9d7b0ced5647/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
07-31-g9d7b0ced5647/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238b4a4435a27c0372172fb
        failing since 13 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-03-21T17:23:27.419795  /lava-5915286/1/../bin/lava-test-case
    2022-03-21T17:23:27.429971  <8>[   61.049512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
