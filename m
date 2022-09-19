Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2725BD4E8
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiISSp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 14:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiISSp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 14:45:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AE441D19
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 11:45:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a80so474919pfa.4
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 11:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=yzqlhDeOZKIEpijbm3aF7k4B5sTscz3WzeHvk4XlEOg=;
        b=xlvUQ8dFoP5SuQo/dlLYOU+4eSs22oJknS00b4cxgdDEa3PcnzLkzQ30F5UiMzjMK6
         gezGV9QOIm6ha+pkOM/Ll426eThpG/RCZXSCSVC5kjX8E+nTkpt43jELAzHikHPNqep7
         h+z3P1vuhMerUo8pGX2tTvq1QTQFB2kVqQ9tOk8n9ToLGqsVfgML8nyDKsf4IVXwda6T
         bB0esyVWbyhHIhzPNFQ9ZBFNEkK51OLHJ85l+mZmMGCA+LXt9SozvZHMGVFfoaJI0BVf
         n3jAsszRKLTLM5jiihKu0g0KuXV5nj/Cs2dGOVWcv4sHXRUo2eTrWterOFtTkiqeCA3+
         rykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=yzqlhDeOZKIEpijbm3aF7k4B5sTscz3WzeHvk4XlEOg=;
        b=kPDoj2pnFogtYgmHtuEuAziNsGgi2zf0UXG2OIIXYWV48+RM2ZJ0aouzIgjoiYq6Kc
         Ph/ow0nOGD8pkSTqM5SSq9x7py1kWfpr4hMMceEWZg0IYJpiHqTItrD5sB1wVu97R+fK
         vHZiXKaW8HNbsdMNOvOnRmaLGWz8yZePeodvMlnq6p6UaaTBwoCocaBwn/R2lPQ44rS8
         dPH/QTSRkcxVhJBw8jtCCa5bXMA/YLM1U63iwbrQQ8Si68qAxP/qTBJ4uCtSvNFQ9c5S
         Z8IJm3FdSzFwVGjbDMcpEBnywOl9pMSzBXUWyxWT3nTNPi6KzadHRqbawnG+UuXUBGdu
         8L/w==
X-Gm-Message-State: ACrzQf01QhMRYhDK7sJg+7lv+k7XO2iVhFLm9qiQvLc5SWgAWjwmEwLF
        tCaRp+ItblCKxTMmIWLQf8wiwuDhQPN0u7xign4=
X-Google-Smtp-Source: AMsMyM4KaEOH0j+TFB8XkJaSij1ACCD84PPaU9ue5qmLNrQrhkjhkJ9Dgq+NJiFdIWEnXuhdYoLMdQ==
X-Received: by 2002:a63:f313:0:b0:434:346b:d074 with SMTP id l19-20020a63f313000000b00434346bd074mr17125940pgh.298.1663613127001;
        Mon, 19 Sep 2022 11:45:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2-20020aa79d02000000b0053e8368ec34sm4485188pfp.32.2022.09.19.11.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 11:45:26 -0700 (PDT)
Message-ID: <6328b8c6.a70a0220.49d62.760c@mx.google.com>
Date:   Mon, 19 Sep 2022 11:45:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.68-34-gb4f486b4ff9c
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 2 regressions (v5.15.68-34-gb4f486b4ff9c)
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

stable-rc/queue/5.15 baseline: 174 runs, 2 regressions (v5.15.68-34-gb4f486=
b4ff9c)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =

hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.68-34-gb4f486b4ff9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.68-34-gb4f486b4ff9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4f486b4ff9ce7e707f50807a519c6d6954f330b =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/6328867d65f17200a5355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
34-gb4f486b4ff9c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
34-gb4f486b4ff9c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6328867d65f17200a5355=
645
        failing since 172 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6328839b8a7e2a858635567c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
34-gb4f486b4ff9c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
34-gb4f486b4ff9c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6328839b8a7e2a8586355=
67d
        new failure (last pass: v5.15.68-50-gad0a589ec3ba) =

 =20
