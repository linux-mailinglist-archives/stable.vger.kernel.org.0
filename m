Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D6D4D2AA4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 09:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiCIIa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 03:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiCIIa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 03:30:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592C0CEA35
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 00:29:29 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b8so1674979pjb.4
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 00:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TH2ub+8zxKtRTL6iKUoOOZaWuGVty74FOsmfFTC9y4s=;
        b=s8xpT432TeYR1XQEHLmQYMgUp9KLFcLOd+9C7V158SBNAqssIVSyHZutNsrVW3axgR
         gUHlRoF7ehmeiGwZYAM8q8tITWEO2PUuGfBCeN3rX81MzfLBUkHhAJXFVvDadra5ojBJ
         ++trJ0rk9G9JCyZ9FhV4eWsDPnKB3XavTNgYnXAcUNveITBX3RfyqvR6DgGg8cRI+k+d
         0kuYAe5OYH860lo1p387DVKC5BKxjQ7UpNRb2EhmtMAZ3S36V8gIvDS+B+4hravH4qKE
         Z+cU5UT8DcMYy5peHaHpzzrBLrGzhv9II9wYvSSERYY8CpBgJUc8SEpjA4o/ZMEOP3PO
         M45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TH2ub+8zxKtRTL6iKUoOOZaWuGVty74FOsmfFTC9y4s=;
        b=s7B0guFsForI1d3sFQryAjQhTLrbGnswH5ZQYkPASBdg/eCl8HhSzSiuakZg3d6sAd
         aS66yWqtCO76UKMuM5UkxK8eX47MiEIRixkl8MnTRRLXY8ogs/wXKVgFbmgZj/RNvOFp
         wM4vXHqBPduMFVcSr3TtlateMiPjY/kuOu7qpF4vVrVPGh3piLrAbqYS73HfNbChrv8P
         taoCAXSjvHoqpmE46ah2/hd2yzL65CgQLOzR36rWGudJk0otkYJUUfYkR1zd76PWZAug
         NpurFy9JTygJFHEyNSOL1tT9ttRpu5TU5WSCwy3dvmQKR9yXAwonipypMcsDSYRzWKvC
         yW1w==
X-Gm-Message-State: AOAM531Z+bEbtmsCt8sB26Z+rH2RgJlML/oK75Ari4BpzHfx8p6n42wA
        2brTDNLfzc4D7L9iWC3Sn+iOSU7kKWn3sxn/AB4=
X-Google-Smtp-Source: ABdhPJxtJ5fJL865QJ6oqry6zFJ7As9cSAgDR6tthVR9fXqc8JPARAc8k9Q2aF07NoMLLtCZa/fsOQ==
X-Received: by 2002:a17:90a:c984:b0:1bf:aee2:3503 with SMTP id w4-20020a17090ac98400b001bfaee23503mr1767339pjt.28.1646814568414;
        Wed, 09 Mar 2022 00:29:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l4-20020a639844000000b003806f93fd57sm1520894pgo.42.2022.03.09.00.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 00:29:28 -0800 (PST)
Message-ID: <62286568.1c69fb81.8fe62.3e52@mx.google.com>
Date:   Wed, 09 Mar 2022 00:29:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.270-19-g6111ef539d72
Subject: stable-rc/queue/4.14 baseline: 45 runs,
 1 regressions (v4.14.270-19-g6111ef539d72)
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

stable-rc/queue/4.14 baseline: 45 runs, 1 regressions (v4.14.270-19-g6111ef=
539d72)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.270-19-g6111ef539d72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.270-19-g6111ef539d72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6111ef539d729e9067b0af3c72e5fddeab0f9477 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62282ee017daa62593c6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-19-g6111ef539d72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-19-g6111ef539d72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62282ee017daa62593c62=
96e
        failing since 23 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
