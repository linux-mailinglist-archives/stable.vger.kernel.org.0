Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91FD4FDDF6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345483AbiDLLZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347403AbiDLLYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:24:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B81A9D4EA
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:05:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso2318459pju.1
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QoGYLz4ME16BWCDSIkT8YgpkP2N0wUCi7BxSq31pM6A=;
        b=f8eCMf30rov4ZnWxRhNb4Qu/qacuu9WzumflGqlPdfCHGgAt3+zfzOL8VP/4Ic/sph
         9sZbTSW7tUhYsgiGY1Adb9cwOhmO4bv4DapbPRrLwV/rzbGOYYqKzWZv5OBvniOG3qE7
         3UK0tcYVW78btTkqpuyN0upLWIkVBW8nilGUIYTbDHK7WQg3CciSbNxocwKNeilkqYXP
         fU2Qbln8vhkUdj9iBoWdev9y21qWt72xjHgSUq9OM6XNbH3+V2jrLb14nuq1ssFZZ3Pj
         I3osBqKhKk5HILiVCNWyHwVIOX77IzUIke8fAoqi+bxKouB7WX5EZVDo8SMRBg99MgTk
         pMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QoGYLz4ME16BWCDSIkT8YgpkP2N0wUCi7BxSq31pM6A=;
        b=gVZciSKkCkexp+6di25EOokR6wQIpsDJxL2DW/mnuGiF5V61VvPbbqIX6h5C1WioNx
         w56PU0/pK6xPSE8Wv1zb21qPXAqKKk9ANEFMdBSOSAqnOvpeNwxpmxpyaWuyMg7MbOso
         jU9L6V33jCdRNIHYSQyOJ64f6oW7sNnXTXau6lEtpEEVn3W8aVrb+F5x/Y17RoDUvlP4
         LZumZf42EOiSVj/1MYPTE0gK/F2oettHmtarXWAdzTOoqn/QT7nj/wp/h9qNNwXtmx3E
         ZHpmRWhQgICHMWy5oOlTOkTiHtzDy0FFBwNX2Rd8oRu3zDzFKKM+TaKIpV9u/Owv8J4w
         KbWw==
X-Gm-Message-State: AOAM533mX5Mpd6wEke4CX9CENGXfmMFcpiQM9Apwd8sk3+4iRjXK/Gjn
        g3gva6FkrWm3i8jdOkQ/rts+3/EhyIpdpiEO
X-Google-Smtp-Source: ABdhPJxr9uqEPS8vkVx/mHd97ezgWySpACaUWYF5OSHTSZ+kaU73i1JZ/+7d5xIOGUVGvkBAeV+r7w==
X-Received: by 2002:a17:902:ec83:b0:154:7cee:7722 with SMTP id x3-20020a170902ec8300b001547cee7722mr36893224plg.96.1649757933762;
        Tue, 12 Apr 2022 03:05:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5-20020a17090a2a0500b001cba3ac9366sm2403009pjd.10.2022.04.12.03.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:05:33 -0700 (PDT)
Message-ID: <62554eed.1c69fb81.c11e1.6868@mx.google.com>
Date:   Tue, 12 Apr 2022 03:05:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-330-gbdfbd5df0daf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 99 runs,
 1 regressions (v4.19.237-330-gbdfbd5df0daf)
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

stable-rc/queue/4.19 baseline: 99 runs, 1 regressions (v4.19.237-330-gbdfbd=
5df0daf)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-330-gbdfbd5df0daf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-330-gbdfbd5df0daf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bdfbd5df0daf1748bef4501ce255ce594ee8d55f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62551de10e45c95be7ae0683

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-330-gbdfbd5df0daf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-330-gbdfbd5df0daf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62551de10e45c95be7ae06a5
        failing since 36 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-12T06:36:09.674067  <8>[   35.855659] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-12T06:36:10.685904  /lava-6070605/1/../bin/lava-test-case
    2022-04-12T06:36:10.694128  <8>[   36.876328] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
