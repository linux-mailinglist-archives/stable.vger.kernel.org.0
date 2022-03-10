Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33C24D537D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 22:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbiCJVPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 16:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245511AbiCJVPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 16:15:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1962016AA69
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:14:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w4so5958152ply.13
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/qa1JWbYNWNEKy9y40yA9mv/lRXnDAhxiUkAYqbzEw8=;
        b=SiubaW4gOEPTYrRULY4J2xhe9eKP52zNk7q40D0Jwo+lNLmQNk7Pw9he5ZJZgqg+zt
         DDPs8+EsQ5rlK2OqlFmh6+1OvhASulZHk/kxkr4nYk+wORgXM5Ioo3s55pgZ8FBl2m6/
         SaqEAI7A2HXMN24XISb8W+Or6dTjaGXX4lyRMtndr7cq+f+lAkfrWTFw/fHbFkOXStRC
         IXfMSYGtGJANENwQjwOxc0QfPQ81UIvgUKtMMnGJQGRD2LY5wvkkY4an9ckdm24jkP8n
         FgfW17p9AO/xO8ZX9eUJHa28QkMar0Ax7yqx/hpYTt2VphsWZLMl1fzp25Jg7PQ+dqRy
         rx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/qa1JWbYNWNEKy9y40yA9mv/lRXnDAhxiUkAYqbzEw8=;
        b=OJRwWIkqiWg0Blglmy04huykyuZqTUk1DQoNuhCbK9WKRNPkj48ZCw4FfcB/EgYA5r
         6OpM+gMlZafTFz2Z5yGA2LpE4bjrgy+6HeKZWF5QLLYFQjrpkYsD0Yvps7gbDkHpDPgy
         MafmL5ByQj8/D+oOjieqKbFu6tpuFjqLLAwH13WNAl4uPfs4EFHnMbIrbDphPHduWtLF
         q4Uz8pf45s4hW+AGRCOO0gm/63SDmT7J7ZJW68/vptB1dDs8vmm+oRykDuUsh0Lbr0y4
         7W++XQLerojIu1F6asW6CXnTbP+Qo5xS0VpbdCcmy6779TUPSfXmFEc1oTETCyxafI6z
         6prQ==
X-Gm-Message-State: AOAM532K4EFF3SPkDxYA3kLCyrh7Nxy9gHE9bU+YPZHsVPmkoVxppf85
        FebUJgtMOV93I2vpsUVq9OPHXgmNqZAWFIjmrpY=
X-Google-Smtp-Source: ABdhPJzIVIY+cLpa74XGu9Xb6ogNV0gq0l9SsAAiI9IHNXdWnj7KRzkh8320hV+oSpZWwQEuPaV//w==
X-Received: by 2002:a17:90b:4b47:b0:1be:fccf:d1a8 with SMTP id mi7-20020a17090b4b4700b001befccfd1a8mr7022518pjb.33.1646946851480;
        Thu, 10 Mar 2022 13:14:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090aa00c00b001bc6f1baaaesm10678794pjp.39.2022.03.10.13.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 13:14:11 -0800 (PST)
Message-ID: <622a6a23.1c69fb81.de485.c082@mx.google.com>
Date:   Thu, 10 Mar 2022 13:14:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.270-31-g8028f7cf32b2
Subject: stable-rc/queue/4.14 baseline: 46 runs,
 1 regressions (v4.14.270-31-g8028f7cf32b2)
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

stable-rc/queue/4.14 baseline: 46 runs, 1 regressions (v4.14.270-31-g8028f7=
cf32b2)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.270-31-g8028f7cf32b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.270-31-g8028f7cf32b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8028f7cf32b2dfe76cec912749408d3f2cedeecb =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622a335307da8d262dc629d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-31-g8028f7cf32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-31-g8028f7cf32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622a335307da8d262dc62=
9d2
        failing since 25 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
