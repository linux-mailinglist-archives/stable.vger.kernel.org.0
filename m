Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FE44F74F7
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 06:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiDGEtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 00:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiDGEto (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 00:49:44 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDE17DE39
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 21:47:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b13so4459532pfv.0
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 21:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uwB37TBHECMZNdiCdmiuhzdIYlYvoVJ3gQdCAD5c27I=;
        b=1VHtq9xL25WGgJ/4AxGivVzPU9eNqBUKdVm91MMnDqCqm+03TB5PNtgOv1+/DcGwo7
         HQ338fltbofegCORPccOj6o0LbKcH/aF5EVjF5Zt83uqsyDpOscEoHkYtoQ+gAO66tCq
         1NHov2gG3coSt6tXPRsuj6e49niGjtKBTu34wNKtl4DWS7vrGiERYF/KZxk48VfA8UeB
         GiNMcmKFrdHjlyt8A6iYQEAY1YAXI9mBozg4nBG5HaO1UOFTxS/ljIPaRtdLLrZN5AhM
         JopAZ8YGwHWYE8tCB4T0H56JaaYXjLpE7OdonwWW2vPCOrS4qpZdyXrY7syZJSCYxZs7
         CLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uwB37TBHECMZNdiCdmiuhzdIYlYvoVJ3gQdCAD5c27I=;
        b=mAWlZ+GxHo8p8mrL8oy42kRx5LWz+BULIzALyxp3syt5QB+8o2VAXkODmCbCg4TdJr
         juhwdWrqsyZMTcMKwySLPJD+hqjlAyrXeTQh91uhi8QBNus9Q4r5QHDNTsZ4v0+2Hj8f
         N1eJpMhXwJhFGptUC5OUqu4oQ4pdNtH+GSGTRgWXgf5y7HK6nF2AyfVr7+FiR1zxBRK2
         zeX0bQ5nTYXINmVraFn2WHmErVJZgJ+3aHJEKTUfuTrCjBY3GXLaXUF9mHgtw0+FMHiS
         2cBAyrLtd9FLCVudeFPfcutPZHivHuY2K2ZEp/j1xfEt23Tx51kqXuJMWSxAj66yMcIV
         fh2A==
X-Gm-Message-State: AOAM532XoWkpS+t5KJA6MmgfwdzACvJ+fs3LuVbngLz7IzBW+8K+S/sV
        vs8AkkY1ORtQAj0tCVV4sQRrnngvnFeM9qGfqG0=
X-Google-Smtp-Source: ABdhPJwqEsvVbyT+Goy4Vb0hoxiip/MQhB689/sJ+aq5s4qJh1iZFfMqGngG2rAfg2OmIw0zV+O/eA==
X-Received: by 2002:a63:d905:0:b0:399:370e:eee1 with SMTP id r5-20020a63d905000000b00399370eeee1mr10042130pgg.53.1649306863561;
        Wed, 06 Apr 2022 21:47:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k20-20020aa788d4000000b004fb07f819c1sm21191536pff.50.2022.04.06.21.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 21:47:43 -0700 (PDT)
Message-ID: <624e6cef.1c69fb81.88f26.9274@mx.google.com>
Date:   Wed, 06 Apr 2022 21:47:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-1014-ga681f52ca8bb0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 112 runs,
 2 regressions (v5.16.18-1014-ga681f52ca8bb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 112 runs, 2 regressions (v5.16.18-1014-ga681=
f52ca8bb0)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
at91sam9g20ek       | arm   | lab-broonie  | gcc-10   | at91_dt_defconfig |=
 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-1014-ga681f52ca8bb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-1014-ga681f52ca8bb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a681f52ca8bb04fc0662f7fa8399a9ae3e4cb809 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
at91sam9g20ek       | arm   | lab-broonie  | gcc-10   | at91_dt_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/624e39056c9cb50a4fae068a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1014-ga681f52ca8bb0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1014-ga681f52ca8bb0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e39056c9cb50a4fae0=
68b
        new failure (last pass: v5.16.18-1014-gb0ab89badc238) =

 =



platform            | arch  | lab          | compiler | defconfig         |=
 regressions
--------------------+-------+--------------+----------+-------------------+=
------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/624e3b5593321bd513ae068d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1014-ga681f52ca8bb0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1014-ga681f52ca8bb0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e3b5593321bd513ae0=
68e
        new failure (last pass: v5.16.18-1014-gb0ab89badc238) =

 =20
