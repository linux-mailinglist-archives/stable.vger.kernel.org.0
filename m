Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9998F33FA3C
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhCQVAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbhCQVAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 17:00:48 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A23BC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:00:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b184so1978551pfa.11
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+QUhAC8J2C5344hDAhCW+UDUMM7HnpCUTVDkkAPQ7cI=;
        b=psFdMFFn1EgulzQaEvPSjRDJyH5/uczUoe/mkeGZctBsZSUvC3Umoyuxq6L79jc7X3
         VdOM5KF5da7wxHXm0kyNZXxA+AW0AHdrinH9jvhCmjhdxh6hxS1p1rt3lePjB5hv6yTi
         Ic7YOg6yczqBYPw5xy7G2c2gpJTU74i5xkwVlfce5oB3OwoAKXjwEWVh3PwPJgKGSWic
         yIi44PIH64i9SyiEqcm7fl7qI0xhY1G8qMF44yRBuIupVgWWCpC3E14rZ9xy3IV4oT7E
         aTYpCe46EDyQgbtxVVH6KMZCnAriVzuDSCq459kQ89BEnBrV2V8xq34ZGyFcXDSBPudB
         ht2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+QUhAC8J2C5344hDAhCW+UDUMM7HnpCUTVDkkAPQ7cI=;
        b=lOvsvjy1VYkfrHlPe55b/+3lnZ2wocp4y7pbuK14GsBwI5TF6uJ9y6C/NorXyILq8F
         PGz83kmQnsFZfTGCpS8pdKALOQYfZBS49CTg+I7sKAAZQrMI9bd6NmyymJr59zUdWWUH
         qFw1+M96eAq3gCWho9NMboTsIAVZ0jspT/OCGsqvyMbQJKGAAhZFdWkkuyQYeue1qzUX
         XXYokGoFDHzT1TzsfJNm0bAQZJiP3bcOiyZEB5fvdqSPplkHmQYwDl7selEF6ajYTHzS
         S/5a07O6/0di0RHxsKgGEBSKn5ceCU+WFBo2wMYHd2bj/70MhQk+xeER2ydLLRI1UrRy
         0EEQ==
X-Gm-Message-State: AOAM532Tc5Ngrrq6r8wOkuIjQ1NVBE1HSyUukb4Ncenxc09gFGznXuoi
        of2lOdf/BLTfIdRP4aRpw1gNRbiMjh+vdQ==
X-Google-Smtp-Source: ABdhPJzeD49rpWoF2x5DOS/cGVU1bV7JeTfCzJPZm6GAqXfrGmBl0y3s8b4yrJx6OFiwsL992k4nGQ==
X-Received: by 2002:a62:7708:0:b029:1ee:f656:51d5 with SMTP id s8-20020a6277080000b02901eef65651d5mr916233pfc.59.1616014845530;
        Wed, 17 Mar 2021 14:00:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s62sm15478pfb.148.2021.03.17.14.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 14:00:45 -0700 (PDT)
Message-ID: <60526dfd.1c69fb81.2146e.0105@mx.google.com>
Date:   Wed, 17 Mar 2021 14:00:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-167-g7ed1f7081b6f6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 184 runs,
 2 regressions (v5.4.105-167-g7ed1f7081b6f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 184 runs, 2 regressions (v5.4.105-167-g7ed1f7=
081b6f6)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.105-167-g7ed1f7081b6f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.105-167-g7ed1f7081b6f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ed1f7081b6f63315a2c3dc563cc1fa77fb1a706 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60523b5e2ae4437c15addd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
67-g7ed1f7081b6f6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
67-g7ed1f7081b6f6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60523b5e2ae4437c15add=
d1b
        new failure (last pass: v5.4.105-167-g3ee23c76a1508) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60523b5a2ae4437c15addcd0

  Results:     68 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
67-g7ed1f7081b6f6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
67-g7ed1f7081b6f6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
60523b5b2ae4437c15addcdd
        new failure (last pass: v5.4.105-167-g3ee23c76a1508)

    2021-03-17 17:24:38.064000+00:00  <8>[   14.516578] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =20
