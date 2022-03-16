Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886FA4DB2CB
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356626AbiCPOUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356746AbiCPOUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:20:18 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA8E205EF
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:18:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s11so4002171pfu.13
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dF1NxzE03VviIPEQXqZuNqgjYoCUPk1rjxQr4eHanLc=;
        b=3rI6J80sy5uBxB7ICWcPJVwvNUQMLx3iD9XGppGunggNyhdsqsPi4bkPGyOH+pjVPq
         iBQMQPE25CuBRAVe32+KKbVl9GVsTJS64cI50dWWLlA0tKKFNidPI/OFsYUdJ1e9eWIm
         O0njHmH9s5lv26BhNOe8R4tJCPFDphptN8Yf2UJ0m7UdvJdMpsAD8oaI7p/el43EbbVt
         0zY9gQkGqSnfK94rItyBRibQv9uIupH2rgCHz+IT0JaDt/5m46ltIxJZEVkjuK2GSP0c
         M5cEBgTvtALVueZjxivfPMoh56fUZ7t12XPXKzVZIdM+Yef/AS9ELh/4l/IoFVNuoqIW
         ct8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dF1NxzE03VviIPEQXqZuNqgjYoCUPk1rjxQr4eHanLc=;
        b=Xew5hrLxuZp8JxIDT6ZDsy2DaM02G5AYVV8YURJOFMqk+GwGvWxGfIdufS2AOtkWZS
         Dau2Vs7XUfn9FKpOg5BGR50L8MhemTNlyxCHF9GlD8Oj4M/z7YoFV9aoAGQlL3ASK+6a
         QVbaUZYpcEN7GwJy78+eXu3ghJK4aQZhfnAqJvEvSYb3qQEwd4+uzwo7yk2P3KcPY8C4
         7aaj1WaDVx6aPKYzJKllbEM3+tVTYV9SKQwFXRT0JDHF+T7tlYn6wco28klwcleDjP5f
         hWTnasDicK5187m4d5qAnsql1qPpafS9nrPm0uh83lOZbVQ0VgP0PgC+FRbAvzIcA0+E
         uraw==
X-Gm-Message-State: AOAM533FXEEQ/oUJ8IkD8xRwltb2k82I1F8ksEGkrb8IIYEE4unkAdXV
        htt04sVaQCHS18DUtRu5xIA2CtU4oGozH0Rfs9w=
X-Google-Smtp-Source: ABdhPJxrTSjuRJrwU9woWTVS/YiM7yH1Gn0xTMpXjJljWFVmpXkWZAdnNr8snOOa8cRw8fWMoY/XCw==
X-Received: by 2002:a63:1a56:0:b0:381:ede3:979d with SMTP id a22-20020a631a56000000b00381ede3979dmr2130307pgm.372.1647440289592;
        Wed, 16 Mar 2022 07:18:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4-20020aa78e44000000b004f6aaa184c9sm3066241pfr.71.2022.03.16.07.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:18:09 -0700 (PDT)
Message-ID: <6231f1a1.1c69fb81.8ddd4.7129@mx.google.com>
Date:   Wed, 16 Mar 2022 07:18:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.14-122-g77c201fb262c
Subject: stable-rc/queue/5.16 baseline: 97 runs,
 3 regressions (v5.16.14-122-g77c201fb262c)
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

stable-rc/queue/5.16 baseline: 97 runs, 3 regressions (v5.16.14-122-g77c201=
fb262c)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
hp-x360-12b-n4000-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

kontron-pitx-imx8m        | arm64  | lab-kontron   | gcc-10   | defconfig  =
                  | 1          =

rk3399-gru-kevin          | arm64  | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.14-122-g77c201fb262c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.14-122-g77c201fb262c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77c201fb262ccee449ab9b08b874ea9ea1f9b0f5 =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
hp-x360-12b-n4000-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231bcb3ee0b5b268dc62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6231bcb3ee0b5b268dc62=
982
        new failure (last pass: v5.16.14-122-g74c6b0438c08) =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
kontron-pitx-imx8m        | arm64  | lab-kontron   | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6231bdc954325db7c8c62991

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/623=
1bdc954325db7c8c629a8
        new failure (last pass: v5.16.14-112-gba4f1fffbebe)

    2022-03-16T10:36:38.323574  /lava-99515/1/../bin/lava-test-case
    2022-03-16T10:36:38.323902  <8>[   11.327373] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-16T10:36:38.324082  /lava-99515/1/../bin/lava-test-case
    2022-03-16T10:36:38.324268  <8>[   11.347243] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-03-16T10:36:38.324526  /lava-99515/1/../bin/lava-test-case
    2022-03-16T10:36:38.324761  <8>[   11.368553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-03-16T10:36:38.324939  /lava-99515/1/../bin/lava-test-case   =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
rk3399-gru-kevin          | arm64  | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6231bd8c23c3e7b6e9c62970

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
122-g77c201fb262c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231bd8c23c3e7b6e9c62996
        failing since 8 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-16T10:35:35.613096  <8>[   32.143755] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T10:35:36.634580  /lava-5889695/1/../bin/lava-test-case   =

 =20
