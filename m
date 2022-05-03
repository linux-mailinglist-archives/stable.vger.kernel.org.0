Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8F517F40
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 09:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiECIAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiECIAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:00:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663812B254
        for <stable@vger.kernel.org>; Tue,  3 May 2022 00:56:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fv2so14658145pjb.4
        for <stable@vger.kernel.org>; Tue, 03 May 2022 00:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VxHT9M5EDyTLY891OwOKYBieEBCZeBOhYbpQE8E/YUY=;
        b=WVPNEGmpo1WuMaxznIt1NxWLnMsojIS4vZeZJakQ5gRl96Zed6kH8K9tTQKYvXYNy9
         9gp1Sf2h/ZSTv82chqBJKljUO/FYmzD0JXBc0vEsTeOqyx3Hv8r0bTGEtJC4skirJ0kx
         NYes8o5JAWcsamVRyr2Yx4UzImJS9MzVeH+FGJxhn6DEREyq4xdclHLs/WpBhlnZvUOY
         j+aE1FHU9dE4Qh5G4gsKCyzWy/XDmAODT2f2CueILMYwFc8VALaABxz8XSUfQu8LehHF
         +y88ShgvDqb4UZ5/6/zRPBy5MP8vfF9mWfrK8cHMfCU64xI9M4o6DcVIvGgYBM8jus/Y
         GvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VxHT9M5EDyTLY891OwOKYBieEBCZeBOhYbpQE8E/YUY=;
        b=E9qKFuKl0Mw9SZ9cdZf2sQZNECJO/wLSk2a3OCTQd+tQG6UgW1cMSFalRT65LZW6a/
         9d0zxuG5mLGajijY1F4/T81x8TqYwi4pBhZmm4AG33B3RDPEO6hwQz1fErGifpbniFJ1
         rngDnCduDuZZTNgJ9SIBeY3Ege9VH/IgDbbX7sN+GFZxHk/PsZU+wXOiomxy8drVO7Co
         cJpKfkz0T+iWz54/BbKcBKy5WCTY/igb78P4oaNRC2t4CxIgj8klXo2F607SzyPJaLWf
         ByBM6XOACSdMo8RLwdN3PqZVEQ4IdCBKG3tyCPvdliHQLGnHvueOSg6lFqxVheroGb/W
         PvCw==
X-Gm-Message-State: AOAM531PUZF/A6kVrKGh/Q3+seawq69gcJMgn71yVTqtMJX14PymQwL6
        5v1j5iTTDSd2MWP4IGY2xN8ZKSQfINOrcaIbcrU=
X-Google-Smtp-Source: ABdhPJx4dMveqbYe/GeRS6M1U3bASVzHQfFmhY7kwdSMRdxQHtWEZvIW2Ee8t7rAr588o3xsLM83Hg==
X-Received: by 2002:a17:90b:4a90:b0:1dc:4122:6a70 with SMTP id lp16-20020a17090b4a9000b001dc41226a70mr3364133pjb.216.1651564598762;
        Tue, 03 May 2022 00:56:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18-20020a170902ef5200b0015e8d4eb1e2sm5823787plx.44.2022.05.03.00.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:56:38 -0700 (PDT)
Message-ID: <6270e036.1c69fb81.25797.eb6c@mx.google.com>
Date:   Tue, 03 May 2022 00:56:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 87 runs, 1 regressions (v5.10.113)
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

stable-rc/linux-5.10.y baseline: 87 runs, 1 regressions (v5.10.113)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.113/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.113
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54af9dd2b958096a25860b80d48a04cf59b53475 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627039c69e83b71e86dc7b95

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627039c69e83b71e86dc7bbb
        failing since 55 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-05-02T20:06:02.534928  <8>[   33.062622] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-02T20:06:03.558657  /lava-6238075/1/../bin/lava-test-case   =

 =20
