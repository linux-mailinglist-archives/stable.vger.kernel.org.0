Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2864DC47
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLONaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLONaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:30:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE61A807
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 05:30:12 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id js9so10484200pjb.2
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 05:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8ibHe7oHCyrlaP0epRGlpnKCobuBL0GufcdKYSdBCg0=;
        b=krMT+qCGToRN1Plcbek1Lc740wYRB3y3FXK5NzIZtks5x54slNIIlVySZx2WbHC+RL
         h01RthsywtPnnWoQ6n9pisDhIyQFJ/JNCqSjA+FTjQ1In/s+tV2zvdG6dG+rwe7GTvSG
         U7PLcQjknlu40RpW4+Fbr065ex9pjuYGM4lEwXofA4qpchYA2/Z6VPPdFlW22432qrun
         wqxFRYFAcV8RKUbkdZrnf10b8k43d7YbgR5losPAwFWNUHrmOE+Da57Cn4VA6tG281oh
         3I+K1v7/jTZsf/R5jn1753zzR0vqUj1XkVYO2qYuDd56QqNCcmMbK1uDHGl85gBVidT4
         cbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ibHe7oHCyrlaP0epRGlpnKCobuBL0GufcdKYSdBCg0=;
        b=w6mbPVHB1fUQ7KhX5P3DG2J46UG1C5oFNpRnIkXpLcbqR0kdV+kSw9Q2WWDZiyjkIf
         JoSFec6RxL2XPMVFEkpSL58r2PvgyFYK1183fuNusSiczFyWBdymm2oKBe9olcw3hNQg
         5Qp9suZKqQhUWf10TulX1wBgh0I8bmPPES7K+0SESZrYmlVWlLzL6OWxBRhZkZ3KHFNo
         9ZGANTgefwOlCCI0TpK7ueR2QayY2KYMVkF5Xn+MnIAIbE/TfBdYNyq5gQCTAc16+h9o
         LfhblZlUIeaXnJqQLufjBEY+vSD+U8Y9miRgQAKakT9zyXeCYdXu6r7acIfAvQWR63h4
         By1g==
X-Gm-Message-State: ANoB5pn/NFzNJopxrbbGY+WK5CzZkHE6zBl3gOFvqnVHr44J6vE3lEA1
        g7EdGBjDG7qFm79AMODPxoqQGFD/l36hfNhmB/N9xg==
X-Google-Smtp-Source: AA0mqf7eO4a6BU1YE2t6h7Dl+BWxPoJ1yINnUPzjeHo0o7SIRPJZSHUICAzClBqhgQlrdo3n+diMSg==
X-Received: by 2002:a17:902:ecc2:b0:18b:271e:5804 with SMTP id a2-20020a170902ecc200b0018b271e5804mr49116692plh.59.1671111011532;
        Thu, 15 Dec 2022 05:30:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709027ec800b0018968d1c6f3sm3826882plb.59.2022.12.15.05.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 05:30:11 -0800 (PST)
Message-ID: <639b2163.170a0220.a280d.8927@mx.google.com>
Date:   Thu, 15 Dec 2022 05:30:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.227-4-g75082311ba2a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 2 regressions (v5.4.227-4-g75082311ba2a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 102 runs, 2 regressions (v5.4.227-4-g75082311=
ba2a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.227-4-g75082311ba2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.227-4-g75082311ba2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      75082311ba2a77ac5ec029ac1a50f0f9e53295fb =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/639ae8c5ec43d363632abd1d

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.227-4=
-g75082311ba2a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.227-4=
-g75082311ba2a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/riscv/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
639ae8c5ec43d363632abd21
        failing since 57 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)

    2022-12-15T09:28:30.428004  /lava-3044413/1/../bin/lava-test-case
    2022-12-15T09:28:31.409572  /lava-3044413/1/../bin/lava-test-case
    2022-12-15T09:28:31.461914  <8>[   26.967216] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/639ae8c5ec43d363=
632abd26
        failing since 57 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2022-12-15T09:28:17.164868  / # =

    2022-12-15T09:28:17.166398  =

    2022-12-15T09:28:19.229892  / # #
    2022-12-15T09:28:19.230880  #
    2022-12-15T09:28:21.242644  / # export SHELL=3D/bin/sh
    2022-12-15T09:28:21.244092  export SHELL=3D/bin/sh
    2022-12-15T09:28:23.258346  / # . /lava-3044413/environment
    2022-12-15T09:28:23.259119  . /lava-3044413/environment
    2022-12-15T09:28:25.274558  / # /lava-3044413/bin/lava-test-runner /lav=
a-3044413/0
    2022-12-15T09:28:25.276159  /lava-3044413/bin/lava-test-runner /lava-30=
44413/0 =

    ... (9 line(s) more)  =

 =20
