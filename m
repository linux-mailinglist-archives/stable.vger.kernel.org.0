Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D04C7B06
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiB1UyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiB1UyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:54:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19438286E2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:53:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id bx5so12219432pjb.3
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D8VNOAPwOMxMJCLWd3mDtTtl1lO1xybpXeNZ8wQw4dU=;
        b=UMvkjpgZKb7BkVrTP4RZWSgD77FzBemPueo+2ArnE+h1ZUEM08QB0kZvf42MlLRR0T
         X+e2pAEcCn7DTf+rBe6oVzcZSi/o2yBIPTf83+QGl8tCTXDnJ4cYsArBmHJRRb1o2aqv
         f98Kab2J0ADRVKGh8fTPgSe7BnUa8N7WBmSqiInE4X1V7ytZHR2hsb8WJy9cccRQSuMY
         8HnWN6ZZL7nk4cXIvzwSPVxTgjhXd5HHvw0lP0lN+xozQfUNQefhbcO9jaF9miefmMaw
         Aj0Ow6udLmmmZ2HhgiuhKOZX2qordb5etGiyHs0zYGqMbqICcYQntb2HzuWPWskPmw6O
         kYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D8VNOAPwOMxMJCLWd3mDtTtl1lO1xybpXeNZ8wQw4dU=;
        b=irPVDgoM/Xd4iB14fq+bXsz9eASGC9IoivqKgU7DMr6W6+6mEEtmKZKwz7XmbdMRnp
         A0M75Mkr0sew4sFeZ5odN0rbOKs2P9MI35RgVOvI2up10MPPQLlpRR6gDyKfApVAZ5wX
         GqYtzE2r2WJm/51pwORanHI2CZ8BirXtxGoDRgL/HWR4cHsfg0aV9hpN93IHHXPmB8sI
         lWTQE+o8/0534LWWiwj9r778kXI9BAe7JCWg6NWyyVIFjtPsH+qdvmQvO8Mmh4HIQQLJ
         dRh5fgn0FHTfdO+qk9JJLXklMJwMRBiHb0dirpeIjJ2A5F32PaNCDxQE7hk1a4RZjndh
         Hx1Q==
X-Gm-Message-State: AOAM532EFDbIS/wEtdOvXigO5ZWz5cwUyGFEqXT84QM2grIzoTl3dbBj
        Lm/qKKAxzVx3WTgLCXSPKdfVvU1NzWrIMUyc618=
X-Google-Smtp-Source: ABdhPJwfJCpBvpqm/2HXDXwrS8n4oGaOX0RaSms4bj9TRHvoKr0f5DeVIJtQPTYkrIXTA/n+qwlQSw==
X-Received: by 2002:a17:902:da88:b0:150:f47:24ac with SMTP id j8-20020a170902da8800b001500f4724acmr22323487plx.73.1646081608297;
        Mon, 28 Feb 2022 12:53:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f31-20020a631f1f000000b003742e45f7d7sm11134584pgf.32.2022.02.28.12.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:53:27 -0800 (PST)
Message-ID: <621d3647.1c69fb81.3cd82.bf9f@mx.google.com>
Date:   Mon, 28 Feb 2022 12:53:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.181-51-gb77a12b8d613
Subject: stable-rc/linux-5.4.y baseline: 100 runs,
 2 regressions (v5.4.181-51-gb77a12b8d613)
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

stable-rc/linux-5.4.y baseline: 100 runs, 2 regressions (v5.4.181-51-gb77a1=
2b8d613)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.181-51-gb77a12b8d613/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.181-51-gb77a12b8d613
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b77a12b8d61311504f44ad2458e742bc5c69aa96 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621cffc70e47282752c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-51-gb77a12b8d613/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-51-gb77a12b8d613/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621cffc70e47282752c62=
976
        failing since 74 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621cffe0de92ae9c72c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-51-gb77a12b8d613/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.181=
-51-gb77a12b8d613/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621cffe0de92ae9c72c62=
96c
        failing since 74 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
