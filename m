Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B104FE07D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346418AbiDLMkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350691AbiDLMhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:37:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB44A2C664
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 04:57:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a21so2373028pfv.10
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 04:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ohNoPODnjy+t9Kh1qYbEk7s8/0TKTu0YDlbun0iJa1E=;
        b=WTm6L7XP3YrJ8+0ypWe9YOgYScW02s06x35/fAJvVHyVrnNX9T0TraqTSeVs2IYFad
         n7x8wWSpPow4PrZvpA8CbaWteoJVW7+ah6X3XN6nHfsxISMXtVwjJx7KTwNceF9aHSj9
         HD/fjbLPNprcpNUQ6yAnKzdhAbFB84KwfxNCw3nbYmtDw+YDhqr5JzwTNlOHgjLYkHpJ
         lnyaAljNP3px9H1PuX61XbD6NRIE5sflBMMGGES51KX4xkxeqTyjSGKturGbPAECuKtC
         awOqC1//bdJkTqwBnNDj5yyvdJPl1bGGaNAHjPQn7LopxwV/uXN3HSJrAfDM86P/RByW
         GXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ohNoPODnjy+t9Kh1qYbEk7s8/0TKTu0YDlbun0iJa1E=;
        b=pce4aSFATGV/cfQwGTZO8HG+IW1oIgRZt93Gl8ldCkd7j0YI4E5tyJMCaJSIyiJQVH
         z2rasjt07+KR2zGMSGFQSQ6n2ACy5OCODtZadthDbVXV8Elptrj3N3VBuZO6Inf5Cfvg
         O6allqRcHjc4S1IFNLSYcxgb8bBN/DPHQOL+hr+b2GDwCAta0Ig/ZBZGWBGGGabV1k0z
         x6Fuz1Jg4eZCCx8gEw5i45POhUmeBpUTvX4W9NVBjf2pnh2B8GUrdK37Gm2ZlY9vx0gW
         7WVpPs+E4wcbZR+WxZY8MqEfAdjMxv6Old+DLwxcpGkOavA5ZLiNmPvgQF/SHBYv7+50
         zChg==
X-Gm-Message-State: AOAM531MgB/TlWN/GF3mcks2wWpmDBKGx5GrrDXHOyRmKE4HQftBjo7R
        38ivAU7g3+qc3XNX1RKjKgANrDGcxUlufwCa
X-Google-Smtp-Source: ABdhPJwV832MC0u+n8+6eEHaOF+M3ZLwi8WkGjOGTXNFr8jR4hx7i97TIQDniLQ8j7waw3/tuimkHQ==
X-Received: by 2002:a63:4a55:0:b0:399:5a4d:8606 with SMTP id j21-20020a634a55000000b003995a4d8606mr30143326pgl.19.1649764622329;
        Tue, 12 Apr 2022 04:57:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn18-20020a17090b189200b001cac1781bb4sm2755924pjb.35.2022.04.12.04.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 04:57:01 -0700 (PDT)
Message-ID: <6255690d.1c69fb81.4a670.6fd1@mx.google.com>
Date:   Tue, 12 Apr 2022 04:57:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.110-171-g3f868052db86
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 1 regressions (v5.10.110-171-g3f868052db86)
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

stable-rc/queue/5.10 baseline: 132 runs, 1 regressions (v5.10.110-171-g3f86=
8052db86)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.110-171-g3f868052db86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.110-171-g3f868052db86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f868052db86f68d42741cfd3e018b7fe74d7b9d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62553ccc7de0d15b35ae0695

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-171-g3f868052db86/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-171-g3f868052db86/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62553ccd7de0d15b35ae06b7
        failing since 35 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-12T08:47:59.466361  /lava-6071388/1/../bin/lava-test-case
    2022-04-12T08:47:59.477285  <8>[   34.277193] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
