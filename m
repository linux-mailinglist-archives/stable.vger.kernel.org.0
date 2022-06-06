Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8065053E890
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbiFFMfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiFFMfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:35:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5102A5D70
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:35:20 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r71so12829203pgr.0
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 05:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TT0X+aohwKgku46gkaQIaiS6NGo7O65IWWc6xliJ4MU=;
        b=PkmPxGDuLXVFI+mItaUXCFqmwY/WtJACBG1/G9+UckTkYF7avMDFZXVQJi8UzQgWCn
         h1ZT76VIltk19oiwsNez1AGGjLErNIH6veij9BnPthTwfeaELQ2nobLLZgEAqRGx84DT
         XSdIWuLK967Gdjy+pm1eB6afacW0W8GGLDzmX3Q8+hilvGbF1h7Y7Fk/dEx+4kbT/SKD
         raKLwbvzRaoZ4xehgEiN0r2exUMyJbrD8MSEn6IGq9ZBNVI6X1i+wNxWJoFF08SIrIxO
         Zcu4E2n316+eQSoWOx2hUfH/0EO9H72HiUONUHTZTdfqQcRfO9egjUE6vaEMX2ojD2In
         4Iog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TT0X+aohwKgku46gkaQIaiS6NGo7O65IWWc6xliJ4MU=;
        b=MKO4LaP4fFSUH6Uc0pOunUPPswbt2PgMse6abtl9CmHtD20QkJcumZerw0ubcbTgTF
         fr/6zwkQKvXu5g41py9GaK2ikdRDwE0wED4M0GEaQfr1S5lXmynFHkYjexsJDTgoJwUf
         qnN/K7gIqCnsqj+Bs5zix43kvtFAcVrVAILY03TvLgZTnqeKd7vFtP55y3Daeig5Ois3
         fDfRlBC9gxCr+vqZREtLWAxRTVT1Pz8wbPERA1QRbDgFeTSIvUbIMigOqylc2viUZP2i
         GEG/jGvJInziyowo+5WTPgYUkwH3dmHuZPGG4d+Jd/mqFWPXFNuUiNM2hKKZn7E8pKA8
         Bwaw==
X-Gm-Message-State: AOAM530Yff3pQKO4VvHAtt5c6jq6IkrSv1tQHn9YqlIrXKaA2blfINSr
        m5oAfHbcHrlAPVvQDVX+XiNQQ4UeU04+8n/d
X-Google-Smtp-Source: ABdhPJx/i8LP3MWT5j5HHhf4YZobEJ11JVJitp4DHRU/MMpHYitn/CHXppOvLkwHXcFMG3uxJq17ow==
X-Received: by 2002:a05:6a00:c89:b0:51c:2ad8:47ad with SMTP id a9-20020a056a000c8900b0051c2ad847admr1464164pfv.42.1654518919599;
        Mon, 06 Jun 2022 05:35:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a0c8900b001e0899052f1sm12565124pja.3.2022.06.06.05.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 05:35:19 -0700 (PDT)
Message-ID: <629df487.1c69fb81.5b189.cde0@mx.google.com>
Date:   Mon, 06 Jun 2022 05:35:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 105 runs, 2 regressions (v5.18.2)
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

stable/linux-5.18.y baseline: 105 runs, 2 regressions (v5.18.2)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.2/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      25405d5eecac69622a155752bb8b0e1ed5071e36 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/629dbf08220f31a25ba39c31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.2/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.2/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629dbf09220f31a25ba39=
c32
        new failure (last pass: v5.18.1) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/629dbf35b469c29bb9a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.2/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.2/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629dbf36b469c29bb9a39=
be3
        new failure (last pass: v5.18.1) =

 =20
