Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31A565D34
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiGDRu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGDRu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 13:50:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B894E64F9
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 10:50:57 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g7so4726556pfb.10
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 10:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rxvgVZfkKprAN7RFbD7XnVSiVoovotgPmedAWk7GGSU=;
        b=b15lG7r15d1cA5OvBkOTA1v2QhEUrS7s4akErj4OO1pQvS7qTd7JP9JG30gIYlv8gd
         vVnVef2JHGrdNPcHhwrRyWu2si2phvn0bZsXUmLVSm6GfhZDjPRLh58sN/gCFNffTwi7
         /JuqecORUGjfO1AjGATKefxAN+Tbp42FCxG/5vPoh2GRq/jdogC9CJ5cmoCa9Ms6NXP0
         IIo4ZriL7xgqU0HKgARVr+qWICKuqkPqUZJNXhoixiB6O0OTwpzQMKjJ+yZ8D9pqedwp
         srFJIz5LIaNLDEstGpbiScBJaxpmPxNhVnWjcRtHcMQuiLdfPnqMNckxONJ0dZPBFV3y
         C+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rxvgVZfkKprAN7RFbD7XnVSiVoovotgPmedAWk7GGSU=;
        b=X/qIes7pup9kN1+xkZRl3+A/x+nOF2Qo5dkxgdG+lZ97uIsdLO7IgbDV9HXU4Q83n1
         HI5YifaVHziJH5cKxrhkrHZxgOUwA2uCXYqIrTrXsUP2JHXQvstnh+NwvmADPk9tMuwH
         BQNcbRYleF3hasQ7gqxA3CMxRZ7nR85BXKzE/ZBh+NI7NfjiGruVV90Wx0dV1+0wBQkY
         bWCIvoebafWK8g0bagxI7sVjfg6dz48egCwTB61glW5lERCSOz4GXLKKX+gJlyyYgJDX
         P4/OobUXUIyFBgrTRX7g7z04EOuVf3ewG6ZOMotgxKQz/8Qyl8LVWdPA8V0sI304K6hj
         DtjQ==
X-Gm-Message-State: AJIora8dytNGan7kGTLsyLNFFmpeRJrn0N7oYRfzQPxGY/LIGfiZnxJJ
        IhGE5kOdvnzymzxx1Z27KeTYunzB+u3hmIWw
X-Google-Smtp-Source: AGRyM1vaJdZsp5g0FY4fWlDbfCjmZqJd40JaS6Sk2sq7tVOOmiviuTFUMxsUHl2cqvvKk4271MgGYA==
X-Received: by 2002:a05:6a00:15d6:b0:525:3757:4b98 with SMTP id o22-20020a056a0015d600b0052537574b98mr37692579pfu.64.1656957057108;
        Mon, 04 Jul 2022 10:50:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a384800b001ecd954f3b6sm10631436pjf.7.2022.07.04.10.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 10:50:56 -0700 (PDT)
Message-ID: <62c32880.1c69fb81.cb8e8.eca4@mx.google.com>
Date:   Mon, 04 Jul 2022 10:50:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.127-38-g1e517ffd4729
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 79 runs,
 1 regressions (v5.10.127-38-g1e517ffd4729)
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

stable-rc/queue/5.10 baseline: 79 runs, 1 regressions (v5.10.127-38-g1e517f=
fd4729)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.127-38-g1e517ffd4729/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.127-38-g1e517ffd4729
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e517ffd47299a9d72be2bd1255d45ef02484093 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2f7bcdb7cca12e2a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.127=
-38-g1e517ffd4729/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.127=
-38-g1e517ffd4729/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2f7bcdb7cca12e2a39=
bce
        failing since 15 days (last pass: v5.10.123-4-gc586992bf6805, first=
 fail: v5.10.123-34-g2f9d93aa50b2b) =

 =20
