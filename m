Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5860D6C2330
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCTU4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCTUz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:55:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5491446B9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:55:43 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c18so13867670ple.11
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679345742;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xCnqiK+ebsaKZB8w/R2IBv5X75wqtaeccx/S61g9Pck=;
        b=1sQ0GMBl60gAfzPKkNcmz3hcqnQrHhfoSBLIIphi1RYUqncwm5TqNJwXnbVpf7UIEg
         7X07W5ZURxQfVwX2MRXwSCPrQKII/XP2D7ddGiaD55rfIcXl0V/qA4Rw9lsD1XmhXV0/
         b2/PEiJ+cuhJlJhgit30aH2Q4kVVc/EDVEFlyf3qN6n0ssNFScxre77gnQGqtfKXPGk0
         5ADxjAKMdKMcfxZcyn295ipLi8eg6fUuKsW/eXOXZupCwsoIg8ld374NWfZCPU7TYYZ2
         WgyZWFnq7ev5fu8Mrn9TdolM5MB5MsgB83bkd5SXPBHnOu+Eew4DtrCBi136zlpDkhk2
         hj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679345742;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCnqiK+ebsaKZB8w/R2IBv5X75wqtaeccx/S61g9Pck=;
        b=xUM6h44kYN29QtfqBL2iOez0ZSUu1tU5OsLJGIabm+PIQYrHrNq4ZtK6aWdnEhTMci
         G7WiKq+mt4DuNAzwpAhzkmHPt/4rJxVA9CPN8yMBQLom6tDOdYRbx88YhdwDLAuwMpB8
         a48CrFWOo8u+rmPOoBxNJ51AGJzX9JOxJJSVNGFFPJt7s7dbkZMzkmTU+6gjTBzYeTpN
         SdsfWL112I9tb7rvu0CBlZ2VQs8oHm7yrzOQ4UFh5fEPyVpGwUxb/58VnB7LAPFNX7Xs
         A2wHyWRZjfQFV1CHQZ61ch4HKYeBXO79ihUoRsXb7BZgAIu0u+za4xp1Bf+65Ip7buoV
         /s6Q==
X-Gm-Message-State: AO0yUKXL4BM5JXgshiqeLevFc9sRqDON7t36e+keCgFgUQBPt3C2nEJL
        oPe0sd2JqFcC952KGRZ507ZN7Bo3OqhYUyDbYjY=
X-Google-Smtp-Source: AK7set+v8z985tYHb9J8IvQdQAsyo5F2cK8BRtjWSBLpyvpyO3/ELK8XXDdzHoM4mSkdMUDuJplRgA==
X-Received: by 2002:a17:902:fb10:b0:1a0:450d:a469 with SMTP id le16-20020a170902fb1000b001a0450da469mr15956848plb.65.1679345742485;
        Mon, 20 Mar 2023 13:55:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709028a8800b001a1d553de0fsm2040277plo.271.2023.03.20.13.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:55:42 -0700 (PDT)
Message-ID: <6418c84e.170a0220.1779.3ead@mx.google.com>
Date:   Mon, 20 Mar 2023 13:55:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-199-ga6e5071b9d96
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 149 runs,
 1 regressions (v6.1.20-199-ga6e5071b9d96)
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

stable-rc/linux-6.1.y baseline: 149 runs, 1 regressions (v6.1.20-199-ga6e50=
71b9d96)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.20-199-ga6e5071b9d96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.20-199-ga6e5071b9d96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e5071b9d9695aff2af02541729d911d9b89024 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/641891b9c2e21c6e718c8673

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-ga6e5071b9d96/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-ga6e5071b9d96/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641891b9c2e21c6e718c86a8
        new failure (last pass: v6.1.20)

    2023-03-20T17:02:26.840347  + set +x
    2023-03-20T17:02:26.844530  <8>[   17.811745] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 195186_1.5.2.4.1>
    2023-03-20T17:02:26.959376  / # #
    2023-03-20T17:02:27.061571  export SHELL=3D/bin/sh
    2023-03-20T17:02:27.062312  #
    2023-03-20T17:02:27.164003  / # export SHELL=3D/bin/sh. /lava-195186/en=
vironment
    2023-03-20T17:02:27.164655  =

    2023-03-20T17:02:27.266653  / # . /lava-195186/environment/lava-195186/=
bin/lava-test-runner /lava-195186/1
    2023-03-20T17:02:27.267453  =

    2023-03-20T17:02:27.273613  / # /lava-195186/bin/lava-test-runner /lava=
-195186/1 =

    ... (14 line(s) more)  =

 =20
