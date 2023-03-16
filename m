Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CB76BD5D0
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCPQe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjCPQeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:34:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDC8E6D9B
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:33:34 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso2145420pjb.2
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678984412;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v7aXcPnK8BGjCpsOCAN9KlPRa7aTI9WJmB7S2VxbcgY=;
        b=sGeOImusqilnmOE3BCc61J/jHSGbIWzyOEanhcZIqthKcyMLg3yBrdUHuYD/L43fkN
         dPz1fgambHojYxp+3ZLqWGAVJlOghrfid3KThXkUj3NIgflzacmYlVMGfGiu7vsy/kaa
         yFYDKhIuLvt5d08SieFvFOkWUgtG6rmeM1DuLiELDl2MAP76Hx806KKLXTGUnt8krlBJ
         sRNUUCBtxrGp0OoMhbuUKct3FS37wkISMBNEdo9/jqaxzm7/PW+Vt0y9iufsiCp2Ui0M
         vOznZRTHDm4At8CpujTcWe62b1yL0ToF/08CJXRvVDdnX6pOBfDd650mGig2pCHfh3b6
         8xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678984412;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7aXcPnK8BGjCpsOCAN9KlPRa7aTI9WJmB7S2VxbcgY=;
        b=6F/ERQWMR5h95c/MTCJKz6KoE3fuZK1eK2+yVDbwyWa0BTbnGbhiddmUtQUwWH7zy0
         VeCi4OETSI/qQH+QtzOZQigQ4EH7KP5kTPKJzU9d3IAUCBjUNCoG8+5wgpLBhpvDZp6P
         NTs+JNMtTRmSSMwf3HR5Ra4VPoENMUFG2lYVL3WOWQ392ioOJrQVMBc7U6egfwP6nRjf
         dNSySoBacK3Ba7KA7pWLbpQQQDpYNQKSp74v1/Xtgg3K6Tmha8Lcu2NIK+XmiRo9X/dn
         yw+J5DN4WUtIEeNdTiMGHxxETt/ocrwlKU5lYzfk26LovMAfF2AA2HhXZr0vB4POJO7S
         dTkg==
X-Gm-Message-State: AO0yUKUPuBhYVDy4+U4ybB1sQOC2URUA9S8HARzDpokw3YBG6UEqZaGp
        Jcb63t5ukjkdBbA7HA3ies9WOtxK9jVXcva1HnjvEd3X
X-Google-Smtp-Source: AK7set/EeXzQadCi3iDefxkG1W+UKw/xsjmDqz+eygXI1Kc9Neh/NoUXv1nCvHf7G3MMcBfsTcoIZg==
X-Received: by 2002:a17:902:e0c3:b0:1a0:4b9a:bae6 with SMTP id e3-20020a170902e0c300b001a04b9abae6mr3350740pla.30.1678984412151;
        Thu, 16 Mar 2023 09:33:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jo8-20020a170903054800b001a178e6d5efsm3556852plb.267.2023.03.16.09.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 09:33:31 -0700 (PDT)
Message-ID: <641344db.170a0220.30e6d.6ced@mx.google.com>
Date:   Thu, 16 Mar 2023 09:33:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-140-ga504d90cfaa8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 111 runs,
 1 regressions (v5.15.101-140-ga504d90cfaa8)
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

stable-rc/queue/5.15 baseline: 111 runs, 1 regressions (v5.15.101-140-ga504=
d90cfaa8)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.101-140-ga504d90cfaa8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.101-140-ga504d90cfaa8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a504d90cfaa8ffed52e417fb62184b8ab990b634 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/64130e46f92cc5d3628c8669

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-140-ga504d90cfaa8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-140-ga504d90cfaa8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64130e46f92cc5d3628c8672
        failing since 58 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-16T12:40:17.309002  + set +x<8>[    9.965416] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3417052_1.5.2.4.1>
    2023-03-16T12:40:17.309325  =

    2023-03-16T12:40:17.416794  / # #
    2023-03-16T12:40:17.518485  export SHELL=3D/bin/sh
    2023-03-16T12:40:17.518874  #
    2023-03-16T12:40:17.620065  / # export SHELL=3D/bin/sh. /lava-3417052/e=
nvironment
    2023-03-16T12:40:17.620477  =

    2023-03-16T12:40:17.620671  / # . /lava-3417052/environment<3>[   10.27=
2940] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-16T12:40:17.721863  /lava-3417052/bin/lava-test-runner /lava-34=
17052/1
    2023-03-16T12:40:17.722570   =

    ... (13 line(s) more)  =

 =20
