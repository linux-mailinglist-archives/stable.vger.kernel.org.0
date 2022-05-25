Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062F253427C
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343609AbiEYRwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 13:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiEYRwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 13:52:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EAB60F7
        for <stable@vger.kernel.org>; Wed, 25 May 2022 10:52:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so5780980pjf.5
        for <stable@vger.kernel.org>; Wed, 25 May 2022 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0+StqvrMs7o5CihzfHXmm7RcFh01eXjSq7QNW2zLMIs=;
        b=cW9ev0VtFKX0bDhBIyL+iUql7KYuL6SMEnbKfItJ8jPJeNGnVzUDtjeHlpMNwBFSnE
         ocgzToG/g4v8Txxz+lHljL7eVIMUThiFxE/BqdiQtXeH3oaHrqzonFVs9bA6Z9YL9YHf
         PdLclofgCBQHwFQ1fwVOxNqa65LG3JNEXWZyX9w+FD6qVrMkF9qgQ69lhIOIEaHEHmzj
         GSCtclI7MPE064IXCJISpYGSJAfkhrfWzoNvoGwiI83hnkM4Pxw9MSWUpXq6IH33SAtw
         jfUEHlMmz1MOqiF24s3reg9cDD9j20EiYQEnFYIIb3RqSzl+3zsovstvPunJPhSvzRus
         ygnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0+StqvrMs7o5CihzfHXmm7RcFh01eXjSq7QNW2zLMIs=;
        b=TW92bwgXZV9Ee2iMiFK+vlvXy46NssIrYMs3VsDegsoCRgHfT5OctEsau7EAueN5JY
         MjbqahnFDaSl56PMe5GRnhhdQRFMC8a7453E19tKB53mYvDKLmibXAUVa7YY7UPbfRq2
         JGz5OGBQPR0Yyvwktg1toHF2QEPQLGKiGfhYir528O5//OOMynxSwNoMn19jX/ocAsve
         Pa3bPDN8DSBT8+gUaXCVdMwGcU2sATN9WBnBrjvclfncP11v/kwft5PBbHlyq2DhKNzK
         HEvw5epj49B9Hiiz9LlEROyyZiNGETb7tF4HkCXda28r78tAPobG07EH1MwBgQmC1hkl
         GizA==
X-Gm-Message-State: AOAM532nB3nZtqYGdUjGqIHnW5Tnbd2crWCxNY+Pv1WDsNNwriVhQ8Hl
        vADsu4mIVBy21aGR/UCaqVOSorw7UYrdvZt6yPU=
X-Google-Smtp-Source: ABdhPJx1kjAMX7r0AsqN0A0Fb/rGCUWdSvEUtsLrQeb4L2VUAjJXsRFJdSvplEaeS1/i7W/gcoJZcw==
X-Received: by 2002:a17:902:da89:b0:162:47dc:681d with SMTP id j9-20020a170902da8900b0016247dc681dmr8565247plx.85.1653501156277;
        Wed, 25 May 2022 10:52:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r9-20020a170903020900b0015e8d4eb276sm9618706plh.192.2022.05.25.10.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:52:35 -0700 (PDT)
Message-ID: <628e6ce3.1c69fb81.68838.6fcb@mx.google.com>
Date:   Wed, 25 May 2022 10:52:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.10-1-g9160974af883
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 86 runs,
 1 regressions (v5.17.10-1-g9160974af883)
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

stable-rc/queue/5.17 baseline: 86 runs, 1 regressions (v5.17.10-1-g9160974a=
f883)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.10-1-g9160974af883/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.10-1-g9160974af883
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9160974af8833c7bf07a135daa34082db261d690 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/628e3dc8a8339e4303a39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.10-=
1-g9160974af883/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.10-=
1-g9160974af883/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e3dc8a8339e4303a39=
c0a
        failing since 1 day (last pass: v5.17.7-12-g470ab13d43837, first fa=
il: v5.17.9-158-g0fff55a57433d) =

 =20
