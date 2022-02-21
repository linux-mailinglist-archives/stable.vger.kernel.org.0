Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD94BEB0D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiBUS1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:27:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiBUSWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:22:46 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5BD13E83
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:14:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so97848pjb.1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wJ7ODhRN5+Xkym6bVq2uKOF4+Asvvk4FqahYQDDmlLY=;
        b=UN87W/QOKUYnawxnQ1a+uZ+V06Mn73+9XHmUbS69Px8TSB/PwwuOWFilzXTGZLrBuG
         ZWNhQzQ8yg8n7GwPW5Q4EC6BbntTPqwgwLxz09MeFCbSveQdQmXvh8TZi4uensfZC/KW
         gh3Pg4lwy3gG0ApyCvMvvqlmgsRVJv/zt2guctxHtQXL10fXRdvqlCdUiL7wagvugMef
         eFNunhx9oVpfIGxWVv5N1rad2dbEF81Q1vtGxNocWaVC50EAgaE3D74Wud5kutGyYZtE
         Y4i8YevYUi+zB99uO+xw561jho57Iu0ChlKkJFyEDXwee0L2/mw4rnyzcla4WnK0fjp+
         ckxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wJ7ODhRN5+Xkym6bVq2uKOF4+Asvvk4FqahYQDDmlLY=;
        b=MD0VMM+8V6Bc8r174OdWUB1w2uKdeB7lee1RmWr3JsSWClyWIKWfkaUR4uw540cUlc
         OuUT2O0xnbnxWSA9df393ugG+lhzrE+ULUSJLsthIOYWUkTCb0nQ2wungNlUsqiILzYM
         fpvH+ASFCOjR13eU6XDk5b5faRs2wZJB/jVQe8Ok488bklqvJN0onVXYwxFsXaTHye9h
         WsN1ep2syx53dtXTN6wbZ+eHuqSwzV8qH/OBTPM+2L6wdnUCyyeUwibfq7avcaGuk0Xe
         K3BtEpFRz5VR6/qM7uoQSiELgrY+PlgSC9Hg+eKnRMgK30B6YgKLLfrRIe07XIXn28pT
         rwXA==
X-Gm-Message-State: AOAM533eNytP3KTov6qMoo3meegemZ/MGCwZro6PUfLwUd6CH3k8lPgC
        r3pF9ESn/wi4cMOuFSaLRpEZ76JtE4Zpqkzq
X-Google-Smtp-Source: ABdhPJzikpRNtZgjHJcQpmhOvpzjHTvs2fhiSVssg78hqT93pxdlnUCPLOGgKpLxAC2pgukxzgsrCg==
X-Received: by 2002:a17:90a:5291:b0:1bb:ef4d:947d with SMTP id w17-20020a17090a529100b001bbef4d947dmr165099pjh.243.1645467264806;
        Mon, 21 Feb 2022 10:14:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm45174pjm.45.2022.02.21.10.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:14:24 -0800 (PST)
Message-ID: <6213d680.1c69fb81.c3a51.02a7@mx.google.com>
Date:   Mon, 21 Feb 2022 10:14:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.267-46-g94b121cc896a
Subject: stable-rc/linux-4.14.y baseline: 51 runs,
 2 regressions (v4.14.267-46-g94b121cc896a)
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

stable-rc/linux-4.14.y baseline: 51 runs, 2 regressions (v4.14.267-46-g94b1=
21cc896a)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.267-46-g94b121cc896a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.267-46-g94b121cc896a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94b121cc896af77a7f03efce5e404bb61bd913db =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/62139d1e303a3eb229c62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67-46-g94b121cc896a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67-46-g94b121cc896a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62139d1e303a3eb229c62=
996
        failing since 7 days (last pass: v4.14.266, first fail: v4.14.266-4=
5-gce409501ca5f) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62139dec54a5fbdc52c6297d

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67-46-g94b121cc896a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67-46-g94b121cc896a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62139dec54a5fbd=
c52c62980
        failing since 11 days (last pass: v4.14.264-70-g1d3edcc1650d, first=
 fail: v4.14.264-74-g11dfe0b41849)
        2 lines

    2022-02-21T14:12:45.231293  [   20.435424] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-21T14:12:45.273754  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-02-21T14:12:45.283389  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
