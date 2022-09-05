Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DFC5AD89E
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiIERyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 13:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbiIERxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 13:53:53 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0E05F132
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 10:53:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q15so9139867pfn.11
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=8PN2KWmb3eVjmp/cfpgpU8rtFIXjSizTnjYeOkVGF3s=;
        b=XdO+PfWS6zCaeLd7HRviFtA5CPLUluTxiAtnoqaC6rxbnfi67e2LuGj245qoFWqU/W
         vRjamJt9mOMdsAE86ecYj7zdBzpvKYUgYr8Qx26ZFrRs7Pxjtn4v3y2v0msJi14NWW/W
         tQKRZM969HFDQNb9QlkwgQhiDDckdRz6cGPfG4p9nXeZ5J0+08WCE/K+kFoqWji4+YHR
         pcbpOq4yNhrtxGJzy6eNjwRnOnSeJ8uDlaMJEpN3CKV2POh+2NsE8H4N+N4/eh4fQTTM
         wfLy+fIByU4SW2XvrieWEGUqur+9L1bEZF/LatlBsViqyVd/62h8iqb/4zbfLEjPjc+j
         aOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=8PN2KWmb3eVjmp/cfpgpU8rtFIXjSizTnjYeOkVGF3s=;
        b=GEE1svziONtQGhtowzJARdOwpnarUSbh0fzU6qo7xa0G6O/VieJXXaRTXNrR+6PUzE
         6KOXabewXFw7jQc2BRX7IgDXeXlGeKmLNTfT9MwemtN1UeAVMC44LdZkhiDfWQyklCBS
         0qZmSq0g+L+9pxeDxwMbcF6s8CXlp/YXLpaXou3qOF8YUtHxDMUWCHx+0/Q/0ftIHJTw
         AqmojZcLyxDiyiqdaU1YPL0odh5HzrDHZ9bwlMUHs6SISbWbS84kVhmvhg9ayVoLxk+K
         3HRG27s/GpVNuLpVlWgy3lqEhVFDilopog9/j8hpVPfUf3KOVplx6RUkqVDwxXw+x8Yb
         x/gQ==
X-Gm-Message-State: ACgBeo0gxqMsoIhMqzfvUebB9gv5aAOu6i+GBlwiZrH4/DIfdgWdv6el
        9Ls72NsUt5BQgZKje+AwRS9Nj/VTDbAYzIhelCk=
X-Google-Smtp-Source: AA6agR689Z5ng5pEM9Zd2MbsarOz3eBj4r648zlrKjPCGYF2GzjLRziG8TjhcBtvfsPUd8dz6AuWkw==
X-Received: by 2002:aa7:8b52:0:b0:537:c6c7:3ef4 with SMTP id i18-20020aa78b52000000b00537c6c73ef4mr49448870pfd.48.1662400431777;
        Mon, 05 Sep 2022 10:53:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7-20020aa79687000000b0052e7debb8desm8053300pfk.121.2022.09.05.10.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:53:51 -0700 (PDT)
Message-ID: <631637af.a70a0220.77356.c56d@mx.google.com>
Date:   Mon, 05 Sep 2022 10:53:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.211-92-g78ace360feb7
Subject: stable-rc/queue/5.4 baseline: 123 runs,
 3 regressions (v5.4.211-92-g78ace360feb7)
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

stable-rc/queue/5.4 baseline: 123 runs, 3 regressions (v5.4.211-92-g78ace36=
0feb7)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
at91sam9g20ek        | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig=
 | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
 | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.211-92-g78ace360feb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.211-92-g78ace360feb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78ace360feb77b715e2b588f42e0c69f9216f01a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
at91sam9g20ek        | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6316031603d4eb5931355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-9=
2-g78ace360feb7/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-9=
2-g78ace360feb7/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6316031603d4eb5931355=
648
        new failure (last pass: v5.4.211-77-gbfe4f884ae26) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6316014ea8febeabb4355660

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-9=
2-g78ace360feb7/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.211-9=
2-g78ace360feb7/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6316014ea8febeab=
b4355665
        failing since 0 day (last pass: v5.4.211-77-g94f1a2a7be33, first fa=
il: v5.4.211-77-gbfe4f884ae26)
        3 lines

    2022-09-05T14:01:32.439367  / # =

    2022-09-05T14:01:32.444331  =

    2022-09-05T14:01:32.566653  / # #
    2022-09-05T14:01:32.572697  #
    2022-09-05T14:01:32.676479  / # export SHELL=3D/bin/sh
    2022-09-05T14:01:32.684113  export SHELL=3D/bin/sh
    2022-09-05T14:01:32.785435  / # . /lava-2458934/environment
    2022-09-05T14:01:32.796180  . /lava-2458934/environment
    2022-09-05T14:01:32.897586  / # /lava-2458934/bin/lava-test-runner /lav=
a-2458934/0
    2022-09-05T14:01:32.908358  /lava-2458934/bin/lava-test-runner /lava-24=
58934/0 =

    ... (10 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
6316014ea8febeabb4355668
        failing since 0 day (last pass: v5.4.211-77-g94f1a2a7be33, first fa=
il: v5.4.211-77-gbfe4f884ae26)

    2022-09-05T14:01:33.513409  + cd /opt/bootrr
    2022-09-05T14:01:33.513987  + sh helpers/bootrr-auto
    2022-09-05T14:01:33.516716  /lava-2458934/1/../bin/lava-test-case
    2022-09-05T14:01:34.521648  /lava-2458934/1/../bin/lava-test-case
    2022-09-05T14:01:34.524932  <8>[   11.850393] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =

 =20
