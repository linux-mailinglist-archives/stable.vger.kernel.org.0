Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA9693347
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 20:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBKTVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 14:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBKTVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 14:21:11 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A3C166CB
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 11:21:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id o8so7505657pls.11
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 11:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qrFIaAPA9hjwnJphEPzxfke/3f+fmtLJTWe2LluE3N8=;
        b=LSWBB+sV0lL24tB5/+MUhHRsXJUMIGM3Pa9hkFGIGoYCxRM8AJrNkPpcOyGNMYxhAd
         zG06NZ0TCgaYfq2EDX/5DEV6ZCplmXVoRbY8mTvjOlfI6Dwd0T/qk/VEAgu/GljMiyBE
         Ni4toGK7xSd7qrXcJ0/f4yRdDVgQigXk3GoAF64ARI/2BlNeAkR6qiCvfW8P2mvLVRoO
         LEss8WrsiLARINXQL1dqa0abfx+SKkIBF0J3Vi2e8vkxW3+EiMLC9uHEHYHzHTAL+57j
         wPteboc4xnDLdG78LWA49+04vw7FahLMJnEEY/uczE+lQcOmYrJMqIgHtmn1y1tOoA3m
         tPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qrFIaAPA9hjwnJphEPzxfke/3f+fmtLJTWe2LluE3N8=;
        b=StR1WQIo7DNfO4At3Wkid1rFzdNANrSK6rYcmYDA6Vk6uoKyUSWR+MvkKq245//BMJ
         LXBSmQm4h64yZzQCuigzA+8roikzjOXjmF0EnQJflGy52qy0aEoiu8g62HljeIaMOprt
         hEUcnDJNeCjN0i6mW9PZlS4PqsE+ykl7HuGhyk8v+EajcB+yNW3EHH5c292k7Gdx0Tml
         ZJyko0t3XDWwd0ycn11EDOo21TS4MYgc8ySKcTpCJHrWuaPC7x9ipO8Fys3gzaFqBldV
         WZ/2taHT/mVmqvSQZS1CxQF8VAWNMOnoEinyOCQRakmEaO9qk5eK+84Qc8ezDOYzmeDt
         n7JQ==
X-Gm-Message-State: AO0yUKXk/ZGSAAPao4WCC7UEG/Y0g6C/kdABq1zfTROclNKU4RvRrAsC
        d0SihixI4ti9riG/QE/Eqho7O+R5tP6RYynzZv9AMw==
X-Google-Smtp-Source: AK7set+63pG6oEhwt1vzFj3DGnOr9tKEtrpxDdMnvF7wcR7RYcso5FrHN4A+1UIGaMZqlw/2Fjx7Pw==
X-Received: by 2002:a17:902:e40d:b0:19a:6cd5:fcdc with SMTP id m13-20020a170902e40d00b0019a6cd5fcdcmr5635587ple.14.1676143269522;
        Sat, 11 Feb 2023 11:21:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jc18-20020a17090325d200b00194bf875ed8sm5329708plb.139.2023.02.11.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 11:21:09 -0800 (PST)
Message-ID: <63e7eaa5.170a0220.2e475.9e7a@mx.google.com>
Date:   Sat, 11 Feb 2023 11:21:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-14-g45de3a37c445
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 149 runs,
 1 regressions (v5.15.93-14-g45de3a37c445)
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

stable-rc/queue/5.15 baseline: 149 runs, 1 regressions (v5.15.93-14-g45de3a=
37c445)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-14-g45de3a37c445/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-14-g45de3a37c445
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45de3a37c445838bb380e3eb1ee4ce8696295128 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e7b76322e88369e38c8653

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
14-g45de3a37c445/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
14-g45de3a37c445/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e7b76322e88369e38c865c
        failing since 15 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-11T15:42:09.904055  + set +x
    2023-02-11T15:42:09.904302  [    9.361532] <LAVA_SIGNAL_ENDRUN 0_dmesg =
904180_1.5.2.3.1>
    2023-02-11T15:42:10.011454  / # #
    2023-02-11T15:42:10.113009  export SHELL=3D/bin/sh
    2023-02-11T15:42:10.113429  #
    2023-02-11T15:42:10.214786  / # export SHELL=3D/bin/sh. /lava-904180/en=
vironment
    2023-02-11T15:42:10.215172  =

    2023-02-11T15:42:10.316368  / # . /lava-904180/environment/lava-904180/=
bin/lava-test-runner /lava-904180/1
    2023-02-11T15:42:10.316998  =

    2023-02-11T15:42:10.319784  / # /lava-904180/bin/lava-test-runner /lava=
-904180/1 =

    ... (12 line(s) more)  =

 =20
