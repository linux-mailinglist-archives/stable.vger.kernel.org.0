Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3C29EC53
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJ2M6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgJ2M6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:58:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE85C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 05:58:52 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k9so573395pgt.9
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 05:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CXKWD3Oji34cYFykiSJbxFmVxgsVvUg9IBuESXI4Jp4=;
        b=R3fTCvDCFnC8/GzHy7lx6LGQF6epIsy2Nw7c/0ruDkmR7jV+NLlns3lr2G+zEfHazn
         mQN/sr+Lbc64E2ZKc/fRnSjRv1dTHiEgAoWujjqrP5RJbScxy6O58wi1ASPxCdsb/La7
         9oBi0D9mTixFNrqgvtiGcdgtyvTQZS4fHEWu0ie8KriL0pGrMeHp5Wz/l5o0D0GXG6EZ
         c9iz6ocPUxiFPu6b6XELd5OCNirwdDfyjKO9ypyJYVCQJgUHwTaYLEB7rsBYP8zV5ZSI
         aDdwz1/qWGST7i1/0cEPdzlB8N22atsOOTe3kMDBTVHZO/duxKa4qC53t/mwtC7fv/5C
         HrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CXKWD3Oji34cYFykiSJbxFmVxgsVvUg9IBuESXI4Jp4=;
        b=Lt8qQvtt2qPDrgnBiRGcvQ98sHvbJvXv9wXMTXW9axjBX5we4IWqae9fC7WZ5JV2eN
         I1bIEH6D4xG4sXkg46yMsRktSIKljwDgvtnpXSiOp+GTyl/9521QD+z+Yvq+KG2DeZ33
         8VQzMTFty7rRez9HoFWaHNlUkLp+/ODWVoKOCZ8AEP7EK+EU+GhzJMyzn6shLpbjlIqb
         XAmIqAKOfVFetHRP3KwY0Wd6FsmXJ7XmHSxs9fzpYN2BdVVRDlHC1x+el9oGF7hq95GK
         UFXMFnYoIodPGMgZ2k+Nur1PnzQjtWD8bDhSPRG2ausy1fQXvyCJU9lyoGHlSjGTOH3b
         HqCg==
X-Gm-Message-State: AOAM5313UHs0o5C5P2YjFaeDn3SgNp/asuJuvleXjtLA66IEes9oVbAW
        BoAw9cojXzTkWHcH2bvFjSCp03xkaMJS3g==
X-Google-Smtp-Source: ABdhPJyXT87Sf6wdF0hvqpLM9cUDhAO9H1ff1PRCrVD7qo0sJC/3AsD3ApyQhLMD+xRTGLxFpNhwdA==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr3933617pgm.126.1603976331989;
        Thu, 29 Oct 2020 05:58:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm2596244pgb.94.2020.10.29.05.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 05:58:51 -0700 (PDT)
Message-ID: <5f9abc8b.1c69fb81.38383.57ff@mx.google.com>
Date:   Thu, 29 Oct 2020 05:58:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-632-g35e3ec0c7174
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 205 runs,
 2 regressions (v5.8.16-632-g35e3ec0c7174)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 205 runs, 2 regressions (v5.8.16-632-g35e3ec0=
c7174)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-632-g35e3ec0c7174/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-632-g35e3ec0c7174
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35e3ec0c7174453dd4892c5edafb86b2db216ddd =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9a902f505558bcf738102d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-g35e3ec0c7174/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-g35e3ec0c7174/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a902f505558bcf7381=
02e
        failing since 2 days (last pass: v5.8.16-626-gbc7f19da4ffe, first f=
ail: v5.8.16-627-ga9047ecdbcb4) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9a8c870b532f6d7b381028

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-g35e3ec0c7174/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-g35e3ec0c7174/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a8c870b532f6d7b381=
029
        failing since 3 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
