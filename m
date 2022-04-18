Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D05504EE8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbiDRKmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbiDRKmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:42:20 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC24815FD3
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:41 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j71so4661363pge.11
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2s9F4I9bJ1PB4JCZZfIXrSylHJ7EM79UV6KQThFuhn0=;
        b=vQshbjuHUk0z0zsNsUjR3AgbU64whu50+567dph0fNk5niSQfic9dVjWy9ua89ezWK
         Piv5QpNOS2p+vYQaT0Qu74hJZ4m74xd84PWJEXDFVihVJ0TJg9U610N9Odjz1RWnVABl
         v5Xw+3GIF2H4QnH814z0yQ0T6Qqw3iqIGuNIdMCmEWquoYgrOFtk6g0xbPiUSr+BH0a9
         iZS7+xq/wyrMFIGjbGx8viR4EeC5KSi6V8zE0txHNAFMkK4gw+AzWfI0pkB/sESaCQNz
         IzPvnFbggcSSx00MZdJRxlTOdmoRMtlCCmfTA9QNpgdIlMIOtUjApzTKyWtjQEGsXwxB
         /Utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2s9F4I9bJ1PB4JCZZfIXrSylHJ7EM79UV6KQThFuhn0=;
        b=Sg2oHhtXOJrH9tKeYZEDLbtuju4jcKawYKpTMRXWPDfmB2bnGZ8MEufHUNDborYJAl
         g1a+ppru94F9qdnMIYWqINuNv80c7Hig86wTQanIFT5Tg4hSnGHeY3ZZ6R8rr8u4uGMs
         FBpIYyQgXvIigSIV788p0BzzAQCrGWLYm/PpW+3HQr4y7gQYzTVvq8BvEL+ZSkdr8Foe
         tgPMMXU/wM8oXkQ0GEQ/WsaW4JNiYV2V5nvxGb8uEh5huc5dmEQZ9eeOZUe3jGdfkOMS
         YjiSyREMDqnvjcWjn7VJTNS1US7mjAryaJwrGric5GGcjLpsZx9YMuC6zgcsVI0NQC1u
         9Leg==
X-Gm-Message-State: AOAM530P8HQ9iVnkR1ctKKI9o+hMb07GyrXAUG2jhoF5RfMDt29wInzL
        G/h9oBU/fyqQ3K0J77uACGHT2RvbqcWvRT6d
X-Google-Smtp-Source: ABdhPJwG1XRvee6U5383VSdy3XCCLVa0cmnaqWQl6Ao/1YR3EXcCflfzCkkrdU2EUkjTCWKZ/qzDKA==
X-Received: by 2002:a62:1548:0:b0:505:fd84:33f1 with SMTP id 69-20020a621548000000b00505fd8433f1mr11574880pfv.66.1650278381009;
        Mon, 18 Apr 2022 03:39:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79574000000b005061f4782c5sm11872573pfq.183.2022.04.18.03.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:39:40 -0700 (PDT)
Message-ID: <625d3fec.1c69fb81.97fcf.be9d@mx.google.com>
Date:   Mon, 18 Apr 2022 03:39:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-260-gb53755698ee18
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 53 runs,
 1 regressions (v4.14.275-260-gb53755698ee18)
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

stable-rc/queue/4.14 baseline: 53 runs, 1 regressions (v4.14.275-260-gb5375=
5698ee18)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-260-gb53755698ee18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-260-gb53755698ee18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b53755698ee18d8ff6dfa9cb35d69cb02acaaeac =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6259677629a7bb77c1ae06a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-gb53755698ee18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-gb53755698ee18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259677629a7bb77c1ae0=
6a7
        failing since 9 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =20
