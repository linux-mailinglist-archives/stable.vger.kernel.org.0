Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A4F4D7696
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 16:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiCMPzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiCMPzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 11:55:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451A14DF5F
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 08:54:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx5so12368868pjb.1
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 08:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D/yJzU4JDXXyh9zVX7ZdQiCHAGQI73NcvbuEvGyVEd8=;
        b=llrwdqLGMAp9lTVOAytKi7t4zNZ+GAmcp22I4hC1t27G2MtoUu2rkjZLliAdmGr7lI
         1ijJJ6SM49QPv23VTb6g4p5/0xKFFtTvPEWE7sxkQu6PHZr3lDETU+m9FnfIPDLM3KPi
         JRXWWYXJDt8mDQQd0VzgpTcX11gUsiLJgfIHBVavyIOdSdsTkLURR4f28s+kzOaq4L56
         IMk4QN8fpoeuA+d28yu8HmBnV7fyYbr085yCrGT+1kkrdbDYSUfUk1B8pp5tXln+wApd
         zK+7xRODE7kUqtYaiSY9Hy27g7IgRKI/mSikmfkYQC9/1xsI73/p4VrfXlR9MaKT5NmL
         e0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D/yJzU4JDXXyh9zVX7ZdQiCHAGQI73NcvbuEvGyVEd8=;
        b=CIXRafdOhnMwNr6oedg1/ppngC9AL/0KXiedZHTddy5w/DuQySyRAtQT6XEqrjt0yt
         BruZwCY0JcLgjDX8Qng+AntnzCRIDCzbqCN2SbZYxULBKToE/V4pxx/UOYX9ufxzOsk0
         zmkFd8f9QhlK+bO+NAy3g81cPR0Iji0+Ljv4wkchcsd0JOSk65HJMf6hw7PgmpaGXU71
         jx1j/5lKiu7Ri5HsciSUMVIEYUGYzl3yIj5EczrZNJYGJ7j/pXQXfU7VFITF5pwWllJ+
         QHWCi/S8aVFZ6AJ9hXuLovZxzIU+6OBdghzgcIbkLw3pYhiSzsMrBx98lojNFNN6tLkW
         O58Q==
X-Gm-Message-State: AOAM531AcUl0dPCZSYl3CR8VyoC9QMfKb2UBBwOEkgMyC71tiRQNRT+h
        xd/e9KdG4CNHGTrmPWXshNnC5NdWbU/wgMlmNTc=
X-Google-Smtp-Source: ABdhPJwRozi3Vdxwpy/iEPd0WUBcnSNnKZ7WxljXO9+N1IuTyjlMXsh2VMse4um33mhhVofoufs9yA==
X-Received: by 2002:a17:90b:38cf:b0:1bf:42ee:6fa with SMTP id nn15-20020a17090b38cf00b001bf42ee06famr31547960pjb.9.1647186875657;
        Sun, 13 Mar 2022 08:54:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4-20020a056a00150400b004f78d4821a0sm9185252pfu.204.2022.03.13.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 08:54:35 -0700 (PDT)
Message-ID: <622e13bb.1c69fb81.1320a.652f@mx.google.com>
Date:   Sun, 13 Mar 2022 08:54:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.234
Subject: stable/linux-4.19.y baseline: 87 runs, 2 regressions (v4.19.234)
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

stable/linux-4.19.y baseline: 87 runs, 2 regressions (v4.19.234)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.234/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.234
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2c2c7e4a12c7e274adda3b334d912169c515efe7 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/622dd9c17b60e73a9bc629a2

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.234/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.234/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/622dd9c17b60e73=
a9bc629a6
        new failure (last pass: v4.19.233)
        6 lines

    2022-03-13T11:46:50.812477  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-03-13T11:46:50.812726  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-13T11:46:50.812859  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-13T11:46:50.812975  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-03-13T11:46:50.813084  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-13T11:46:50.813191  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-13T11:46:50.853800  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/622dd9c17b60e73=
a9bc629a7
        new failure (last pass: v4.19.233)
        4 lines

    2022-03-13T11:46:50.991590  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-13T11:46:50.991855  kern  :emerg : flags: 0x0()
    2022-03-13T11:46:50.992035  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-13T11:46:50.992187  kern  :emerg : flags: 0x0()
    2022-03-13T11:46:51.059535  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-03-13T11:46:51.059784  + set +x
    2022-03-13T11:46:51.059964  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1689480_1.5.=
2.4.1>   =

 =20
