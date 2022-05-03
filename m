Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11FD517FEA
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 10:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiECIrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiECIrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:47:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D5B35253
        for <stable@vger.kernel.org>; Tue,  3 May 2022 01:43:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso1446301pjb.5
        for <stable@vger.kernel.org>; Tue, 03 May 2022 01:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1bNsEh1SjACZjMAGDs1bwieHXrpSGcsfQyvod2ejDOE=;
        b=1uIW/MZZ7fkbxk3gBg9sZjAlauGJYlCWwrETjW7/PhAF3eQyDnRAoKFSn4t+K66VNK
         FCHEshyDxwd6SvhDlLeF784p0tGle4+sB8D8AB93O9B+P2rJyXZ80Ih+dnwnzaut1a6E
         3nT04MIWe3cNxrxK8BiJz04YPsFW7kATeNxtf3uf/to6YG9DioSfRE70rErI2nkroB7x
         LSYKpdeHBCJLeY710YEiTiM5UlFqLlv5cYpBQJqbQmxiCMpEFhybWekcMwR9JMtTcwfr
         TfSNTdAnHg7pS2AdUnPID53P8V87z43pBF6L+3rCvYMDzPIe/p8CvUdOzqwgN3VtpBn6
         dyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1bNsEh1SjACZjMAGDs1bwieHXrpSGcsfQyvod2ejDOE=;
        b=Auh9llhLyOEB0taT0qLNrlpHmlGs478WrT04vDK9e2Bn0clhgHIF9B0HWQDfRBTmHA
         oIihYscn+A+PlUkVka7V1DNJAzbztK6sgJVTGQ1rNbT8X/ENokbHQycATm9DIzZRzAkj
         5dIPn8qig32PGK5rInHlzzlSDlusVQPlHvHgVI/oj8Fy9h3/JO5/V0CMhVPuboxUu3MR
         e4i/XFjpukfdcW2M/WXVGt1ILQM7IgcLd2uQbes2e8LaqKcARB7GkmQ/+qbvUyKUWqKa
         IkyYVXdXL9kgjzPxy0MU+bziSmDORhyjM4I8cFVYEvGNL/QwpU+uYBkUJMitb1ZZ/kxh
         hpqw==
X-Gm-Message-State: AOAM532NP7IgEvXiyFxxKkomlje+2hCo4J8DpPccOJMpZDIGR1qQPqmG
        ddsDor7rq2XEY+Rxh63TyQcV0IxD34ZFfmwWwjw=
X-Google-Smtp-Source: ABdhPJzzb5Ly0v7EpbuD0kmchW+6pFFqR4v0urJ0x2aTDUcNrB+R99TlKY8IGqruBlYokop0p1i52g==
X-Received: by 2002:a17:902:d2c5:b0:15d:4128:21d5 with SMTP id n5-20020a170902d2c500b0015d412821d5mr15363932plc.165.1651567425188;
        Tue, 03 May 2022 01:43:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14-20020a634b0e000000b003c14af50626sm12074487pga.62.2022.05.03.01.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 01:43:44 -0700 (PDT)
Message-ID: <6270eb40.1c69fb81.497cd.d7a7@mx.google.com>
Date:   Tue, 03 May 2022 01:43:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113-120-gc58ff00a6fb1f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 98 runs,
 1 regressions (v5.10.113-120-gc58ff00a6fb1f)
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

stable-rc/queue/5.10 baseline: 98 runs, 1 regressions (v5.10.113-120-gc58ff=
00a6fb1f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-120-gc58ff00a6fb1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-120-gc58ff00a6fb1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c58ff00a6fb1fa477a8588759b03c74addf9d219 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6270b8a0caefe8efe9dc7b74

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-120-gc58ff00a6fb1f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-120-gc58ff00a6fb1f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6270b8a0caefe8efe9dc7b98
        failing since 56 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-05-03T05:07:18.143118  /lava-6243099/1/../bin/lava-test-case   =

 =20
