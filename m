Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B5254277C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 09:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiFHHFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 03:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiFHGKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 02:10:16 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5422E49507B
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 22:20:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f9so6215061plg.0
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 22:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dhi6XcSugwSK/PFZJTupe27TouZn/aEQ8FY4svXS9c8=;
        b=M7BwvARrOJx8gT1+w3GfLCHR1fnwCwDeJSUeoDeVQz/ReyGY+k/Q7GWVZ/nQzB1mJG
         Zs+YwDr05OJi79L8ya53rBozLG1gcXQXTlrj0tjIaE1KWmacDH0MRtb0NHABy6xN9WBZ
         XRQO5pMAWamRux+UklaCt84i22o8sU1suOLW+r2K07FjBktyyliYmn7zhWBbUfF2E/5G
         eWavKuMDW0UIYwggDkXxkgsmo9Z2iQPWmA6hmgkvNNe3lwyBNlbd0gS9sH9zfgcLAj3/
         p7l0pukdUWwrZSVnJT0NDsU9pvlr+40ja2D427QNU3FC2Lm+CSUt35W3IZBUYfExWav2
         LCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dhi6XcSugwSK/PFZJTupe27TouZn/aEQ8FY4svXS9c8=;
        b=hETms7KGjpmaxUlcZyFg5aR9S7kmTVuZ35vPG8vDtkIyNpnr3j/0RKdeaggXgKkgGH
         J4SgzICSlwtyQfy5AhHrctaK4vMDkcI6WsbmiRnTQn/PUev4wgR3uVrpyWICm29cqZdK
         h/9M/qh+3Eh+/LQmK9LfeHV65KgVZIBAkMQDEbN8vfbWouosHdoKuggNGPA2KnzRyjXp
         9HvKTXFQS6yZF32NqX30bUSPHpMkliJyQ0mgmtjhiltGigyKVnJXyRzlLtfFZTmYL2Ce
         zu/PU7X8zMccLmmqhRGpvvcq17GCCWwqkCS/Vd/jLe5yJNw6PEaG5ewPGx5pIQeXmeUc
         /ASQ==
X-Gm-Message-State: AOAM530/ESLrOOS2CwA/c7X6CwnZKY8fnhh5CLol9fHk86Bv44XQ/rPB
        nU8CVomxa101k4UKusYOZLMmQayGB4fi83JlULs=
X-Google-Smtp-Source: ABdhPJwN8xyJ1ReDEC/7jspxD4UKgkf6fcuhbEOIIAkn9v7dBkhVS4hmEaNSTjpuJBJmihTtgnGKbw==
X-Received: by 2002:a17:90b:17c7:b0:1e8:5136:c32a with SMTP id me7-20020a17090b17c700b001e85136c32amr23911214pjb.43.1654665585611;
        Tue, 07 Jun 2022 22:19:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23-20020a056a00181700b00518c68872b9sm6819320pfa.216.2022.06.07.22.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 22:19:45 -0700 (PDT)
Message-ID: <62a03171.1c69fb81.a76d0.e43d@mx.google.com>
Date:   Tue, 07 Jun 2022 22:19:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2-880-g09bf95a7c28a7
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 151 runs,
 1 regressions (v5.18.2-880-g09bf95a7c28a7)
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

stable-rc/linux-5.18.y baseline: 151 runs, 1 regressions (v5.18.2-880-g09bf=
95a7c28a7)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.2-880-g09bf95a7c28a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.2-880-g09bf95a7c28a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09bf95a7c28a7069eb8bb958d434a575a0c63454 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a023c5f93121aa3ba39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-880-g09bf95a7c28a7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-880-g09bf95a7c28a7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a023c5f93121aa3ba39=
bd1
        new failure (last pass: v5.18-116-g20fa00749a26c) =

 =20
