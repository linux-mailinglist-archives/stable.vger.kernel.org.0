Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890824C05B3
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiBWADG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiBWADB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:03:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFC0377F8
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:02:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so8499713pll.6
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IOh9p8d3qxVvUUxC81YKVchc8opA6ke0MzXBOp6M60U=;
        b=DwKSoqA6R44ll5qfjGq6w8NcSWTMtsOqRtG8JByOEQPlGKCnQfqyoH/Eeo2kiUmkKT
         9rHfBh0c2Z9+0xZTzJ8/FdDePteAWy1qktRHOSMNRrr1qqaiZMQr1YfxzW2Y9TNc1Vmm
         lV2Kp7hmcAQ9VYAhNCq5aJ96//Sf978EONc1YAiNZtPDAnW1az7hD9fjViTCOQ8mMl+n
         IvUfdAsRQWDr22DBi5lDEUlotEsdsTEATIBUkpDjzzf8PLqlKeNjRQUeeigvk7SWPODK
         DUfcf+B8UbKjZxh815a5P+gPgMbHOJR9oqttyZcJCxps52lMG4DeIb9Yqg6eji7ClG8e
         jQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IOh9p8d3qxVvUUxC81YKVchc8opA6ke0MzXBOp6M60U=;
        b=luBqqdoWydB+JEGpwNpmNwR/mg71fL9nETTw+pwAn++RL/PlxYnT1Do8I4M1SOYXVs
         ROX6BpspoGPPn1uORHKJcwKZiAR+LbiTlWV3loaEFUloD1FBfxDhV5t/aWFbFMV5lLPG
         jLFG7D8j09pPBbg/QBJjevN7oNXefsy1qAj45QR5y6yivQP+Zqf3vMYnh+hrZ4lgl3Q1
         Xebw6Hj2Ovv9RrtHQXAxv/UEEkJoGSQz9jysFAJBe0c1/+GdjsKXJDr4gMMLA8IgoAKG
         5ZCWJMK2a9OF/8pj8EOaPJFnPqD6zcRQFLSE8hYCmddFwtyVb7eqezi1zVcHcltS6rIH
         93Jg==
X-Gm-Message-State: AOAM531HEEqGbuRJbx+8UA3EZQD1Mb2oNui+SQe9iBNX9rSWYSG7Dbb5
        M2AcEhjQs2G1PBFTtvEmbn0geG62R6FIBz9q
X-Google-Smtp-Source: ABdhPJy5FacsKirOMYuxWcauFLhePITabIu1Qy1zSidkXOLYfI0zcOdFijz9bcCX+SR3gPf+2AS6Hw==
X-Received: by 2002:a17:902:b189:b0:14d:6f87:7c25 with SMTP id s9-20020a170902b18900b0014d6f877c25mr25731150plr.31.1645574552942;
        Tue, 22 Feb 2022 16:02:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a29sm21846152pgl.24.2022.02.22.16.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 16:02:32 -0800 (PST)
Message-ID: <62157998.1c69fb81.f61bc.aa81@mx.google.com>
Date:   Tue, 22 Feb 2022 16:02:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.267-45-g5759e79797e0
Subject: stable-rc/queue/4.14 baseline: 63 runs,
 1 regressions (v4.14.267-45-g5759e79797e0)
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

stable-rc/queue/4.14 baseline: 63 runs, 1 regressions (v4.14.267-45-g5759e7=
9797e0)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.267-45-g5759e79797e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.267-45-g5759e79797e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5759e79797e0115540676e5051cffc913dc979cc =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/621542fa1a9478d2eac6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.267=
-45-g5759e79797e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.267=
-45-g5759e79797e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621542fa1a9478d2eac62=
98e
        failing since 9 days (last pass: v4.14.266-18-g18b83990eba9, first =
fail: v4.14.266-28-g7d44cfe0255d) =

 =20
