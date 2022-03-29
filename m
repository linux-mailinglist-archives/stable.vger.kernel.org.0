Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD44EB440
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiC2TuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 15:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbiC2TuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 15:50:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF8913DE2
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 12:48:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so18576008plg.5
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 12:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=diz2/wo0fyNOlVXxrteR+i3HSOT/Hq4wpFxTdwDbhYU=;
        b=3ZUGGSazL6Og0UxjvLegfxKnLC8NUgdTHZ2qE/d0jtwy10VQq+WEbVfQ8lftpwVsXD
         ylV7vzBjoHQxVETclTf4dshKUBQc3ESgxaXBgQ5uqmPjK0fhhgpyajGybdouQ1edlZrE
         cJ2V50h2F/PsPYebciMK+ju5YEnb52A4zH9Ww0QzbwRieQytbczmtRdBro6cvQPCmgIl
         bNan4cR0WJZHGN7WW1ucpPm0atfgphWaFa0X86amYTjf1skCTQH8rh4c6yv+SmAKVa7Z
         Du03Y1DN2n6phajBXzTHM+svgjrPsyj7vvLLhIg3z0ZSSBvKwXGdWjZCTAqMkmGboNgR
         IIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=diz2/wo0fyNOlVXxrteR+i3HSOT/Hq4wpFxTdwDbhYU=;
        b=VcqpLHX2KX4MnA67RJiMyVPfWxmE87gcyGWdQxiUkqHZUeTdD+4olcnA6J9efd7rJS
         TMeGDRYVoA3VEeeqdJ9XClz4tTFuP5sK7gBWOJPHv1FoPkAVRLPujtJ/ncIF2GuJQBMV
         qcBI1zcGHZSg+IN3sOSni3jsHSo9J3wcwY9JX7g4HUzxkjIbDt1GtDBlxG/kt3LECxEs
         IRPuOKYKSXpaI2FUhFAidmU9xkzlpt8/JKwHy0RQb1i7QVP39/ovTnqLs6tqVXNpNdTk
         Y+JXwyy21QbRgICYc7FcdiSmNA3YLmzhwqr8ZKJGhnb9zHWIVcgQsh8C3mfnSUHR/h3Y
         Ot/Q==
X-Gm-Message-State: AOAM532JeKYdG/s3JePbPk9DsyEIhE+l6QyvFHx9n0fJ3DHpicwioyzx
        +TLdoUhwTNIPZ8okAlf/hk+ViePmCIv+7evEp/s=
X-Google-Smtp-Source: ABdhPJwHJQoP/7wcMqadJoKFwv3Gckw2uokwGKwXPSaTSYM00f3lCpQoGykIeZxy1EJXSBwuUpvazQ==
X-Received: by 2002:a17:902:684e:b0:154:3b94:e30c with SMTP id f14-20020a170902684e00b001543b94e30cmr31707485pln.89.1648583314382;
        Tue, 29 Mar 2022 12:48:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090a588600b001c699d77503sm3615229pji.2.2022.03.29.12.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 12:48:33 -0700 (PDT)
Message-ID: <62436291.1c69fb81.b0277.9e8b@mx.google.com>
Date:   Tue, 29 Mar 2022 12:48:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-21-gc5ab4afe121a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 1 regressions (v5.10.109-21-gc5ab4afe121a)
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

stable-rc/queue/5.10 baseline: 118 runs, 1 regressions (v5.10.109-21-gc5ab4=
afe121a)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-21-gc5ab4afe121a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-21-gc5ab4afe121a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5ab4afe121a3ad2ad4f41873f9dd9da324b92ae =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6243321f6e1cbeecefae06c2

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-21-gc5ab4afe121a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-21-gc5ab4afe121a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6243321f6e1cbeecefae06e4
        failing since 21 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-29T16:21:30.216897  /lava-5970369/1/../bin/lava-test-case
    2022-03-29T16:21:30.227460  <8>[   34.156044] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
