Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944724B5DED
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiBNWxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiBNWxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:53:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6AA171875
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:53:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso831332pjh.0
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qtdpN2b0L4h8uMmYsNAhUUoh/1LNjTb6CYzyLXV4Lxg=;
        b=4qLjvFX0eqNH+/867r4VUbXKFS2dI55QKwqdIRvGfoNjPFwY10QldeneAvmd1e+//J
         UwXpL38Jvc5q2uZAfT+HdAYh3NGgZeYzxg5BNoPyKSpwPiVIdDPTH9BlRXRcfHjWeXmI
         F61A7rL6zvijwkwptWiy9lG852enu1jbzNmUQ1Qchy8lJ1OQjOdRJIjJowVEvQ7oyE6L
         ububZcnKZXP/t68WWmVra36sMNC8TcpdgrUSmJ6IhWf0q1w2/Dncs7QVVkUq+MOFGdao
         Rrnw5ItLb3Pe9zg7G3MPDwEs86Wuu1joGo4PpQnRTKdm/7bkKmJDQltOvYtyjiYDJiPM
         Ndww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qtdpN2b0L4h8uMmYsNAhUUoh/1LNjTb6CYzyLXV4Lxg=;
        b=1xVW7gznWRzLWbLD8wj6gFopwd5KZVxYcwmoHd7qVrb9FHwwxUTRDW9Vm9M+0JLV7N
         CwtvZ0UBOOPnRzazk8V3Lbt49PTnOclm0r4ITJRiSo69PPIuO2mflsNTOuTD2SIcr+eG
         SWh075bpgtD0+G32RIZ2to5iA425YtreWYvutCVsTdKF/PP+uSCiAMrRYDDJEgQHwl97
         0VPzMqfuhf/4xF/yn8hVIX3v7TuuGl+lMnFZZHdWjYZOI9YWGIQr5uYJZDHLzzOw/69c
         su9QGGgrrV3P9NSCrUe2ADCQg7ZC06sp+ymhCkbx1Z0L2JaZYNWhwhD+jb/dtN9v/zLa
         SN0w==
X-Gm-Message-State: AOAM530cZzyZ5K0E4vsLVDTjXqYAkf92wGfT5W8/aJ+eFq58aDsKG95Q
        Ff59HVBivhxfqpxTWAbj0XYaSjdiAu3O6Dop
X-Google-Smtp-Source: ABdhPJxjHajYUg3+8Wfflxx8EAeYBJmL3dWhbp8D5wJV55g7zU32h2ESeCd4073XwmR4zq9nuq3Yfg==
X-Received: by 2002:a17:90a:7a82:: with SMTP id q2mr1047935pjf.40.1644879187516;
        Mon, 14 Feb 2022 14:53:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm6153503pfq.162.2022.02.14.14.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 14:53:07 -0800 (PST)
Message-ID: <620add53.1c69fb81.7fd04.ff5e@mx.google.com>
Date:   Mon, 14 Feb 2022 14:53:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.100-116-g8338670d2992
Subject: stable-rc/queue/5.10 baseline: 88 runs,
 2 regressions (v5.10.100-116-g8338670d2992)
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

stable-rc/queue/5.10 baseline: 88 runs, 2 regressions (v5.10.100-116-g83386=
70d2992)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.100-116-g8338670d2992/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.100-116-g8338670d2992
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8338670d2992b3dfbbef527dc66f6f165b459697 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/620aa9a7c3df5f6b01c6298a

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.100=
-116-g8338670d2992/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.100=
-116-g8338670d2992/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/620aa9a7c3df5f6=
b01c6298e
        new failure (last pass: v5.10.100-115-gf2747447e689)
        4 lines

    2022-02-14T19:12:15.153544  kern  :alert : 8<--- cut here ---
    2022-02-14T19:12:15.184660  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2022-02-14T19:12:15.185873  kern  :alert : pgd =3D (ptrval)<8>[   42.82=
6472] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2022-02-14T19:12:15.186145  =

    2022-02-14T19:12:15.186386  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620aa9a7c3df5f6=
b01c6298f
        new failure (last pass: v5.10.100-115-gf2747447e689)
        46 lines

    2022-02-14T19:12:15.201543  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-02-14T19:12:15.243581  kern  :emerg : Process kworker/1:5 (pid: 89=
, stack limit =3D 0x(ptrval))
    2022-02-14T19:12:15.243853  kern  :emerg : Stack: (0xc36d1d68 to 0xc36d=
2000)
    2022-02-14T19:12:15.244339  kern  :emerg : 1d60:                   c3be=
69b0 c3be69b4 c3be6800 c3be6800 c1445f18 c09e35ec
    2022-02-14T19:12:15.244584  kern  :emerg : 1d80: c36d0000 c1445f18 0000=
000c c3be6800 000002f3 c3782c00 c2001d80 ef867040
    2022-02-14T19:12:15.244816  kern  :emerg : 1da0: c09f0d54 c1445f18 0000=
000c c234a440 c19c7a10 3c468545 00000001 c3d4eec0
    2022-02-14T19:12:15.286581  kern  :emerg : 1dc0: c3d4d080 c3be6800 c3be=
6814 c1445f18 0000000c c234a440 c19c7a10 c09f0d28
    2022-02-14T19:12:15.286852  kern  :emerg : 1de0: c1443c3c 00000000 c3be=
6800 fffffdfb bf026000 c22d8c10 00000120 c09c6d10
    2022-02-14T19:12:15.287362  kern  :emerg : 1e00: c3be6800 bf022120 c3d4=
e200 c3961d08 c3a544c0 c19c7a2c 00000120 c0a23740
    2022-02-14T19:12:15.287606  kern  :emerg : 1e20: c3d4e200 c3d4e200 c223=
2c00 c3a544c0 00000000 c3d4e200 c19c7a24 bf0820a8 =

    ... (36 line(s) more)  =

 =20
