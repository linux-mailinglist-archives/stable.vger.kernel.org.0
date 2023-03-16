Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67D16BD1C5
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 15:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCPOHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 10:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPOHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 10:07:48 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B81D5A70
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:07:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a2so1878278plm.4
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678975656;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wuNVPC/zKFhY9UtZMqUl14jzDDBE+wvNo7w6r8VS+PY=;
        b=tiOaKLVzzvf9VcsRxMa6SqDrNLLKPRMbTc2V2SM1+6cPOG+Fa+G1kwR7s/FeRhcjqz
         qZgZfN7agvoF5XbmnwuM18NAiuvUMqpc1ECEojdw69HDiTmicWDuUh2EaAaWiSPfeKoq
         c52+Cr5cESYWtCDTGipFySckZVWGqwQWKKve3B/rVji3Y2OTaBdFX9tGKxS1U+R4uYPq
         pt5Q3FWzZySU+SoWMjPBmSw5jJJ8YPAixi6EZl+q2hwvw2IVrXKc0Gy8hLnFDS71P6o8
         taP4ML/9YFMLtQK30IoT8Iutf65x4/I5sDswxEXddnQXFj0dlICVVAf+Harbq+GXDslS
         R8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678975656;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuNVPC/zKFhY9UtZMqUl14jzDDBE+wvNo7w6r8VS+PY=;
        b=2+qV2YW9iOSZmC6709BRD3IVbBF6yYSCoiPe1eQvBOu9AQifUdrHDf1xsVDkSNwldc
         FySKQ7uT43aXJjwb2R83gjWVqVXzjNC6KvH3ro4MPwxHRczheSth7YrZmy12M3SW90hd
         vq1j/+pbk10QEhCpgxBuuYdLqhIv2uIlzrWKvdz9oATNEWfVtGQNSI3gA3ksfopF5GRb
         OJJTmwhsN8k/XHPX6TZRDlVK8Pl7Mb/U0IjQb7x87nc5sDP502MsmHgRKJ2rhfi3Da07
         FYdmN+TmWn4mhcUpPvukcTOl9Cqa5aMYSSZVq17St2fsXWalypWBDmzbIxx82ThQFp/I
         tFHA==
X-Gm-Message-State: AO0yUKUs0Ljv7fpNFfA6ZhD+D/p/LqQNxUnMjzc/l4hYBjUkDNvszTXb
        FMO80WuFsD0o11vZVCyKSpWUrT4FMXmmM0jc/gKywOXT
X-Google-Smtp-Source: AK7set8ilw72oLvbymn8OCg+lLd+OfPLSu7utz6g9MHGzvlSyKKFdg3uQ3B2oUMJ3LNGJbswKV9Idw==
X-Received: by 2002:a17:902:f681:b0:1a0:42c0:b2a6 with SMTP id l1-20020a170902f68100b001a042c0b2a6mr3880427plg.19.1678975656005;
        Thu, 16 Mar 2023 07:07:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jo8-20020a170903054800b001a178e6d5efsm3387514plb.267.2023.03.16.07.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:07:35 -0700 (PDT)
Message-ID: <641322a7.170a0220.30e6d.62d0@mx.google.com>
Date:   Thu, 16 Mar 2023 07:07:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-146-g7887563347ee
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 190 runs,
 1 regressions (v6.1.18-146-g7887563347ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 190 runs, 1 regressions (v6.1.18-146-g78875=
63347ee)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.18-146-g7887563347ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.18-146-g7887563347ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7887563347ee26d8ffb29c637246e923d4d71a0e =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6412edc7df9dbef49f8c8662

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.18-=
146-g7887563347ee/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.18-=
146-g7887563347ee/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412edc7df9dbef49f8c8699
        new failure (last pass: v6.1.18-149-g4b77c9dc7cd4)

    2023-03-16T10:21:37.953145  + set +x
    2023-03-16T10:21:37.957035  <8>[   17.082492] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 171233_1.5.2.4.1>
    2023-03-16T10:21:38.071863  / # #
    2023-03-16T10:21:38.173760  export SHELL=3D/bin/sh
    2023-03-16T10:21:38.174188  #
    2023-03-16T10:21:38.275619  / # export SHELL=3D/bin/sh. /lava-171233/en=
vironment
    2023-03-16T10:21:38.276068  =

    2023-03-16T10:21:38.377690  / # . /lava-171233/environment/lava-171233/=
bin/lava-test-runner /lava-171233/1
    2023-03-16T10:21:38.378488  =

    2023-03-16T10:21:38.385037  / # /lava-171233/bin/lava-test-runner /lava=
-171233/1 =

    ... (13 line(s) more)  =

 =20
