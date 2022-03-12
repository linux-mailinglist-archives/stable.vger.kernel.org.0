Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D224D7122
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 22:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiCLVxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 16:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCLVxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 16:53:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838E636B65
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 13:52:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p17so10558887plo.9
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 13:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KIe/XBMlLoaG8w19VgUOkbOiLqpjl1ux+MdwnaIopWc=;
        b=puLEJO1cpqjA7CbZPXbkEGfqu526IUdiusUJJ3GN3KLznf6CS7pagRvXCCEKmYC9OF
         LRDRa7Z2sCEzQGc+gya3huCJPfBMcW+qxMk6Neu+kg9ZJkiK6Y/QG7cLTg7Nnk2MUBZ9
         0z7Yy9f2STaWO8x6siVnqhgh+75mASnIV1OS0mCliP7/Q1QBEZA4uBxZ3qpNsinZsAZM
         BldZyhdIWvRONPcsK6LOLR2IkB2P9mCe2efdJQ59v8WTKC38u2ilGfF613ot+UsuN6cR
         MgR38CeTO1krD7a9j9apwO4lbrXz0y8DIUBmroUmNCo9VVDJQByDwfve1d+A2Vf/qYw4
         l98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KIe/XBMlLoaG8w19VgUOkbOiLqpjl1ux+MdwnaIopWc=;
        b=60q3TmecvUrHJu/hGu4Ro2sCr0gULi+rY6FBrdoPLlOjurK6I9SNfsZLAdlR14rDt+
         KNzTfCbevR5ws37hpczoa14ovEQ9O1pg2pTtjDQNuZPLiPbFkC9O8I5ahQB+AV/TTADb
         uisY0FQaHk455ohTNEMolpOoiy3+bhcmRATwxcMNctjZ9+t4gNF2w9dhztJSIhGrzr+i
         TJ5JASnmX2tPC/PCFgLLD8d16GIKwmX/67+IUrSW9Zaa5sSH1Moxdngw8MFkFmMBoz75
         ynSg02+7WYfAaKrtZnJcawYFZI917OdKBnuuEfnklj1i79jAcqYSwM3x0vHL/6xVfXDX
         lwIA==
X-Gm-Message-State: AOAM530CDaSnHAVGuvE9IRsvug7yt+BD8KCLOpr6zG9RIIAif/96arBs
        joaBGcvsf4h1vGkrTj6i1fSxJoHKMVtMUgF6fh0=
X-Google-Smtp-Source: ABdhPJwqlc/WXZpQmLbWpP59dGwNmFby5VyWDNF0rk3yGqWGowIOX/XLUX1q8eU3gfFd3QPYLitCPQ==
X-Received: by 2002:a17:903:22cb:b0:151:9f41:8738 with SMTP id y11-20020a17090322cb00b001519f418738mr17074173plg.46.1647121931641;
        Sat, 12 Mar 2022 13:52:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14-20020a056a00248e00b004f77e0fbfc0sm10396849pfv.185.2022.03.12.13.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 13:52:11 -0800 (PST)
Message-ID: <622d160b.1c69fb81.4808b.9243@mx.google.com>
Date:   Sat, 12 Mar 2022 13:52:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.28
Subject: stable-rc/linux-5.15.y baseline: 62 runs, 2 regressions (v5.15.28)
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

stable-rc/linux-5.15.y baseline: 62 runs, 2 regressions (v5.15.28)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa79753319d8b2361631438c609901c3e4cd5a12 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/622cde820963b4faf9c6297a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622cde820963b4faf9c62=
97b
        failing since 51 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622ce061a2c09add80c629b8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622ce061a2c09add80c629de
        failing since 4 days (last pass: v5.15.26, first fail: v5.15.26-258=
-g7b9aacd770fa)

    2022-03-12T18:02:51.121255  /lava-5867009/1/../bin/lava-test-case   =

 =20
