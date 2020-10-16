Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4436828FC72
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 04:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393799AbgJPCjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 22:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393798AbgJPCjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 22:39:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B8DC061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 19:39:41 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d6so433655plo.13
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 19:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lK03114vn5XS0EHevDmyfAEeMRdiGGgtX0xG8r8lSq0=;
        b=dwSRLQyFXxa3OTGkiTjDOZQ37EwwDs287oJwpxu44b9BQGPd/540nNTVr9jSUmHLBG
         IxejCtp/2hF5d7kJJMdY7zd7j0hjjPeGPIIJoHQPwi2DoYzIPYSfK2bMvMIX8qMcUfu6
         Hg/103TWnCIEgxSW9huD2UgSxel75Pn7OlhNCpY67keHZgGLx9nLmOiGR8ABBkaAIaH4
         cbUIyaR4haPhYVFnrOWbAtR+3L9HwZ9CcBur0do38eXuED6OTrRTTCjTJdNGIJBcii+E
         aZI8ZZC+SD4W4NMhz4WI/lT4JWeZdHt78MDyseINzVuG75hDnT/8+V9cibJNoRhRmG2J
         PE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lK03114vn5XS0EHevDmyfAEeMRdiGGgtX0xG8r8lSq0=;
        b=lgJHd8CbvNAVjRqEFP9pPT6a8zbG0WfLrNHl24GYO71PvwP6ejHMeyfvSopPQ6dhk8
         EMZtk/zsOqq9tu4j2dSbOYZ1OTbuIYspUR5IyNcPTvabm7irkYv7PeQpdjIDVRUT9vyp
         RuSblZa/pckVNAM09m9XuSrmf2vthW+Obdim6fa8kqkIVR8NAankphmFxG6umO/2ezj9
         tQbFE0wikRjcdioTdscP01Ytzoaon89GhyC/BOg0u5sh/2pacBBqVhx+Xjo1qccmRS01
         6f4ePYgKOumIBOWteBXQTeKLUydzbH4cpKjDq/UzWga6c7vIuWxH5t/kUvagQar7TAgX
         b2Yw==
X-Gm-Message-State: AOAM530EMXAzZ7zxpC5Xefq23AOitXyOS4A+0lWrSsDWK00aNwDVwc1a
        JX7z1kDQnGzL1XMKxo1DRhyAslWxFHEZEg==
X-Google-Smtp-Source: ABdhPJysF4hAnX0bqnotLWWdquYKN310YxwEiAPHNT3k0ThdqlYXzgperX/UNetR/+iwy5W2TOhDwQ==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr1831122pjo.82.1602815980866;
        Thu, 15 Oct 2020 19:39:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5sm690125pfp.113.2020.10.15.19.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:39:40 -0700 (PDT)
Message-ID: <5f8907ec.1c69fb81.83779.24b9@mx.google.com>
Date:   Thu, 15 Oct 2020 19:39:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.71-5-gb8377737c2ee
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 197 runs,
 3 regressions (v5.4.71-5-gb8377737c2ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 197 runs, 3 regressions (v5.4.71-5-gb8377737c=
2ee)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.71-5-gb8377737c2ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.71-5-gb8377737c2ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8377737c2ee169bb108a0fc38e9f02cdae81a82 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f88cc45cc0b2266e84ff3ff

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-5-=
gb8377737c2ee/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.71-5-=
gb8377737c2ee/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f88cc45cc0b2266e84ff413
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-15 22:24:59.621000  /lava-2724354/1/../bin/lava-test-case
    2020-10-15 22:24:59.630000  <8>[   23.253201] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f88cc45cc0b2266e84ff414
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-15 22:25:00.652000  <8>[   24.275378] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f88cc45cc0b2266e84ff415
      failing since 16 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-15 22:25:01.674000  <8>[   25.296928] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
