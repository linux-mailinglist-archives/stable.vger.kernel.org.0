Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4194D40EF
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 06:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiCJFxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 00:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiCJFx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 00:53:29 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3AA3B026
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 21:52:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id h2so223685pfh.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 21:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f9tDqXg7KkWhBO7/IKHf0p0pXcG5pJp9dn5Of9C8mUw=;
        b=VmifBnGRmNhL4ovZix/eQ0qjDBVX4BjJMUPzQxMKcuukS9aEfVLpNaIDXBhp2a6eZx
         VHvqmQStI/Z6E9BDVG46+6NauBuxK7xezNc1jZOOxjmgL1JrPkbLGnBmhTjQ5FWmyr+0
         6hlS020a0V7xaXr26U8oXJCjDcx2kW1P0e2RIkz2rO2IB0emyeUmuFAiizYmdg9/WZwI
         gn/eJrAMu7/mFD9EOjMrx1Z/Mv1aVuJKoXsVl0a/JA7FJZme4z6ChZCHhvkSHkP4KgdZ
         eAwGCuOYaTz1MhS/M53ToYrrh4K80E50YZkDYtVKG1bmR3EmIIS2u3lWobFIoDoAytAb
         dB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f9tDqXg7KkWhBO7/IKHf0p0pXcG5pJp9dn5Of9C8mUw=;
        b=DyqS6thS7AGxeldK/MVgcENEh3ekEiwktUfj2s+z5JHg1kO4JyXYM679cK9A/Xsfw8
         ViDsk2PA7MonnW+nulqWI6A+yvL+VMBaaWNnNWIOM/D816q43CDTTjK/BDxoFIOwcfzT
         vyHno5PdtIrlCtDuK0ssvzELLNpPY3r7VT2ZFEA4qh7Jo/ujezfL7lkVHdXikrRyTXmV
         J5IGTvXLqAS3M0KA/KYg0wqaX4z4w8feqglFynU1riFRzCL9C2JYPdzsepomI8gfz2Of
         XciLjfl2SyJBwFLaJYS0K/TxrTPdPiTPgQ0IUPg1fX40z3svjyfgwgzkO2qQy5q/b98A
         KNPw==
X-Gm-Message-State: AOAM531ucUh9ihsXZHFvfg97MAjR86zHRj1zDEvSMdyfHTHEQXSCT6IP
        7S9YIayJ+ueUsgfpk7bnSyz5qe9btGr1DC+RR2g=
X-Google-Smtp-Source: ABdhPJxl8dxLbtycaJHzHyW1MlXi9gcEGzXnlr+dUN2xL6HvUOcc4m0oymlqs4CpyxEoSFmhBMkJjA==
X-Received: by 2002:a63:28d:0:b0:365:8e16:5c19 with SMTP id 135-20020a63028d000000b003658e165c19mr2733645pgc.579.1646891545926;
        Wed, 09 Mar 2022 21:52:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm4431835pjv.57.2022.03.09.21.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:52:25 -0800 (PST)
Message-ID: <62299219.1c69fb81.a6534.bb75@mx.google.com>
Date:   Wed, 09 Mar 2022 21:52:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-20-g3c2e6f1e27a7
Subject: stable-rc/queue/4.19 baseline: 53 runs,
 1 regressions (v4.19.233-20-g3c2e6f1e27a7)
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

stable-rc/queue/4.19 baseline: 53 runs, 1 regressions (v4.19.233-20-g3c2e6f=
1e27a7)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-20-g3c2e6f1e27a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-20-g3c2e6f1e27a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c2e6f1e27a75a881ea423b34a20bc6c337bc680 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62295a9c47808359ddc6299e

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-20-g3c2e6f1e27a7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-20-g3c2e6f1e27a7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62295a9c47808359ddc629c4
        failing since 3 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-10T01:55:23.895897  /lava-5849073/1/../bin/lava-test-case
    2022-03-10T01:55:23.904220  <8>[   36.918248] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
