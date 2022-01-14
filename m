Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEA448ED2C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbiANPdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 10:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiANPdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 10:33:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28D9C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:33:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso2128764pjh.3
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4e07mUcyAP2ZUv1uZe64rCPnTiHmIs2dCuTvuIb5RlM=;
        b=qy9gb2US2czjzOLK0+xZGUahpCNCfeMNkdgCpDE9DftwWV9VeoYEWnV9PT35FxCir5
         ko2OxeGhmC/c5rUde28t2EyQVW4UOe9Vb04RF7ox0mVumYzUCJhFbj4haN1VguWpgDIV
         c+DFPL4TsERLMeu5QZaqKIW/KraOWlxiiQNpn+nhLOx48B0gzvzNMEhzSmuX3ufG3GyH
         4o7QFYIBL5BNH7XgRtkTrfxnpTgKgi1+fmKyGxv/Ms++5Qg8FQ46+aAm49kEjoQmtrhG
         0I8IVOdZht5wqbcEx6pStT7MDg3s1ZNu5PDFItPwUtYbs1lIkNJ+UngZM3f/zXmIRlF4
         UcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4e07mUcyAP2ZUv1uZe64rCPnTiHmIs2dCuTvuIb5RlM=;
        b=jcyPDpoulZbHZbyP4fKwiM/lmGoZ+9jB1ecQutiXTA1SoyBNySwNwr25VzritKN0q9
         lnzRttmcme/rsFzUO/RUvkyHAovpiAlxomvyqw8eCdPZU4wH88mnIWQz+4sb7129ZGrU
         DulHhH0bUfCqo9KxAuodc45HI6goGLANwY1wFBz7KHqwDZ2WEqvgAd1+dKbb9qIxzvpL
         GXuQ/rqbR9UmKcWzPJQM/Eabkt+VAkXU24FGckBFawisJl5mEDUMOUvPPQK/9x6KSU67
         G0dGbNjrXhN0qA/L+jz9kbRTmUqUmRNgk06p3qgM1f18Ckz2rV8kC7cQ3tHettbcgpVL
         tDNw==
X-Gm-Message-State: AOAM531lbXA/EGKE3+W1K4STowbtanZJ2ho9FjSDmfHgiCIEj5zlo8fE
        Ve7rfnVRRNFKa30JXKAeyiziSbwTV4IMZJJ3
X-Google-Smtp-Source: ABdhPJwq0uk1ozJAeiBgP5+ICPQGKadPzEdwQS9hb/i1F/s5+bRvPs+ngRfyzsXSt2BjVyPup8IsoQ==
X-Received: by 2002:a17:902:ea85:b0:14a:3c49:f140 with SMTP id x5-20020a170902ea8500b0014a3c49f140mr9716314plb.31.1642174423036;
        Fri, 14 Jan 2022 07:33:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm3982782pfg.195.2022.01.14.07.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 07:33:42 -0800 (PST)
Message-ID: <61e197d6.1c69fb81.306b4.b026@mx.google.com>
Date:   Fri, 14 Jan 2022 07:33:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-12-gd1805ac262df
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 3 regressions (v4.19.225-12-gd1805ac262df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 3 regressions (v4.19.225-12-gd1805=
ac262df)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =

panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-12-gd1805ac262df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-12-gd1805ac262df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1805ac262df390b79dba3e56a87216650b95d4a =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/61e16697a3c6ddaf50ef675b

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-12-gd1805ac262df/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-12-gd1805ac262df/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61e16698a3c6dda=
f50ef675f
        new failure (last pass: v4.19.225-10-g46678d8a3ee9)
        6 lines

    2022-01-14T12:03:23.300483  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3000
    2022-01-14T12:03:23.301391  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-14T12:03:23.301933  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-14T12:03:23.302429  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-01-14T12:03:23.302960  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-14T12:03:23.303463  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-14T12:03:23.339268  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e16698a3c6dda=
f50ef6760
        new failure (last pass: v4.19.225-10-g46678d8a3ee9)
        4 lines

    2022-01-14T12:03:23.477424  kern  :emerg : page:c6f49000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-14T12:03:23.478237  kern  :emerg : flags: 0x0()
    2022-01-14T12:03:23.478823  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-14T12:03:23.479354  kern  :emerg : flags: 0x0()
    2022-01-14T12:03:23.546879  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-01-14T12:03:23.547711  + set +x
    2022-01-14T12:03:23.548262  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1399093_1.5.=
2.4.1>   =

 =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61e164bf20a80b2e29ef6759

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-12-gd1805ac262df/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-12-gd1805ac262df/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e164bf20a80b2=
e29ef675c
        failing since 1 day (last pass: v4.19.224-21-gaa8492ba4fad, first f=
ail: v4.19.225)
        2 lines

    2022-01-14T11:55:26.816219  <8>[   21.429595] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T11:55:26.864591  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-14T11:55:26.874764  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
