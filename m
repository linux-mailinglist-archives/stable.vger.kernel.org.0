Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3B5365A3
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353726AbiE0QDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354370AbiE0QDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:03:18 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1005B1498E6
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:03:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e66so4261454pgc.8
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Afw2nqrS9H6dwYnAaaczO+r34UgH2hVXTTXZBHoHNgw=;
        b=i2/WgQlvq+lMkiu34HwIkIqtZxhrPfv2YzocJ3QPhHlp3hvZ6zwtHcDbBEasPfg6kM
         IxPPr5QUhQutCzvlfpjQnAeoatJGIXHIKBOPM05Zy5uS/1xhHVdyO2ImcnQSCEvgOmXK
         E9kJHlYZk4Amc3ognWMpNPdNRDoxvBgXlRxWE6NDLDkCRH3Qaa5cNosIuJ0GvsgLGSNs
         SV0ebpFEQ2pJpHAUZyrO3dCprj09EJiC8/AlCmDDhFxT6NGYDSTBlc+VXGu1JU8ZHFJX
         1v+3S23T6PuQLAJLJBcWjSxDIHpeFOfIRBg27ZUaYwGquRj6pqqscFFY9U4xNttZ0D0H
         0DEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Afw2nqrS9H6dwYnAaaczO+r34UgH2hVXTTXZBHoHNgw=;
        b=X1np/YTuely73R/7/YCArt4cFDGyv4vYUuUIpqYkdPtP2eJfpYk/pp/WNEohXy5IoA
         F7xDRk88EwTAIegKT/DHYWeypguXidxq95vAQSYBxP+ug4Nq8753xbiZcYd0fjfs8Dy6
         Q8Le93FonQ9uWEVpihMpLC+6YKZ//9dIczEtTfD4r7OoCq2ncooYeQJ6Ph7VDv38b8Cs
         K0IBmQjzZvf4IYXySVw91y9Hwq0056j8PItyDF/F/TuUjEr/zt9jGsSsn6uRmH6nYiDw
         3npm29Vctybx+qU13Bb+bP3qIO4Y2rcTX3UsZQad4MfVO8VYGB1KGHRFHqsszY94l4iV
         h+eQ==
X-Gm-Message-State: AOAM532z/oGRlP3arJs6HzrZsPxCdGYPJsD+fCEmj1RKBd37h77kVF1x
        VbANMPH65/d8XgDspKqeJzrD8Y04q5B+KoWf+IE=
X-Google-Smtp-Source: ABdhPJxbPz9p2oRIm30jXIqZgS2HzVrV4znS5jXG6kHJLTs00Tq8CopCqkX8PXrtWvk88WQ8XNDZfg==
X-Received: by 2002:a63:87c1:0:b0:3fb:9d17:72ed with SMTP id i184-20020a6387c1000000b003fb9d1772edmr4914404pge.597.1653667379397;
        Fri, 27 May 2022 09:02:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pt18-20020a17090b3d1200b001df239bab14sm1729134pjb.46.2022.05.27.09.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 09:02:58 -0700 (PDT)
Message-ID: <6290f632.1c69fb81.d48cf.3f43@mx.google.com>
Date:   Fri, 27 May 2022 09:02:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-146-g510d04da560c
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 101 runs,
 1 regressions (v5.15.43-146-g510d04da560c)
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

stable-rc/linux-5.15.y baseline: 101 runs, 1 regressions (v5.15.43-146-g510=
d04da560c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.43-146-g510d04da560c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.43-146-g510d04da560c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      510d04da560ccd2e08230967864dfdd47b9b74a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290c7b4332ae55245a39be7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-146-g510d04da560c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
3-146-g510d04da560c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6290c7b5332ae55245a39c09
        failing since 80 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-27T12:44:20.846759  <8>[   59.448004] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-27T12:44:21.868672  /lava-6487772/1/../bin/lava-test-case   =

 =20
