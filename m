Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CFA584552
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiG1SFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 14:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiG1SFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 14:05:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CE7C1
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 11:05:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso2924947pjd.3
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 11:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=23mPkEJpM/qYAcx5VWvyXaV7HmnjJncS2tOx/q3cM+g=;
        b=qClh5opr7MDpisc4QvWZUykRDmNZm3Q7+56GU7fwS2urx3CQCJoawdGkth3m/BNOb4
         Lhy1J5MhYtXUX2jQImwHmuThdjALDN7qqqN0gFKD/7oS0MGyxHSrtO5OD7fpxwU8eANC
         DixwcF9giBCygiEvtRdcD4gFFKPHPxH+dFx6OycRp1RhxiO4qm1BrnwKor3oEYu5aHP6
         VO+M8zOWDRc/DQj4gEddV/MOd6JiJBYK8aFAuEzqxUGsSqfDhwPyxm45YB1oSrAL2Hff
         wrJkJmsKK1C1A9dGjPEL1xqmjpZxIP4G0zk44sJg1g3/qLZuEeNeEeOPuC6wpE7gqT1c
         AyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=23mPkEJpM/qYAcx5VWvyXaV7HmnjJncS2tOx/q3cM+g=;
        b=xyPQwpqEZ1aTWWj9h8K0GPSxGuAJj/xkYqVJKVzSnUjKtwQFcouIieCnd0jNMsrkAh
         jwt1Z473/SoNU39llU3NZxErqgNvAbDLyWv9mfkSyBLMTg8vP/psr2EuML6fdo7EyX9R
         9v8+mF4FiU+e/IlUekXGKRhFbd3XQ4hmS0Ugaa1bflq/mX/ta0GVoaWaYB4Bf1B/zdJG
         rfnQT4I8lYc1eVA9mbe/DFLY/ZDeuW7k6t9aIDW7TqN/UW2MudnGtbxCsMIi3Z8SpdHf
         qY5BSF1ynnRjWgfV8pjWxAReXdxbt+VEqe5J1W4BOszSn1tapW00MU2e6eKkzMzTWm/s
         PUfg==
X-Gm-Message-State: ACgBeo0YTBJkhvbIr4C/2W3c3kXj2nsP+7ML1C55mOozbvjHdWIEI6lU
        7pkAGpmHBtKDa+Dy77o5Qw4YjQdvjD8P/gyL
X-Google-Smtp-Source: AA6agR6c6TUjNmclIvgHrR0CETIfQ7se7s17ZTbbKg1pj0LKPOau+nE3at1C5SHFXjiWBv3sOg7hvw==
X-Received: by 2002:a17:902:b494:b0:16d:2f8b:6f76 with SMTP id y20-20020a170902b49400b0016d2f8b6f76mr62679plr.48.1659031520508;
        Thu, 28 Jul 2022 11:05:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902e84500b0016d9cd4bbafsm1676103plg.96.2022.07.28.11.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 11:05:18 -0700 (PDT)
Message-ID: <62e2cfde.170a0220.42c7.21d7@mx.google.com>
Date:   Thu, 28 Jul 2022 11:05:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-158-g52bab9058646
Subject: stable-rc/queue/5.18 baseline: 96 runs,
 2 regressions (v5.18.14-158-g52bab9058646)
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

stable-rc/queue/5.18 baseline: 96 runs, 2 regressions (v5.18.14-158-g52bab9=
058646)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig          | regressions
-----------------------------+-------+-----------------+----------+--------=
------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-158-g52bab9058646/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-158-g52bab9058646
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52bab9058646e56441312389996ddd797a24e5d3 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig          | regressions
-----------------------------+-------+-----------------+----------+--------=
------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2a9ae5903977960daf07d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g52bab9058646/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g52bab9058646/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2a9ae5903977960daf=
07e
        failing since 22 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig          | regressions
-----------------------------+-------+-----------------+----------+--------=
------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62e29f3a4930fbe1f5daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g52bab9058646/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g52bab9058646/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e29f3a4930fbe1f5daf=
05b
        new failure (last pass: v5.18.14-150-gea55d06a53af) =

 =20
