Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B584C7B12
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiB1U5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiB1U5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:57:14 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E77A29835
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:56:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so235887pjb.5
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=faR931eMWnEtEMtBR7rAAMTdXGKUVYvUVRzlRbLbS4I=;
        b=bN8dSngNd2Ahasr/rCaURXUQdH+AGEWUFTw92P70+LOPp8K1ZaBW7fPKHpt0gFPhk2
         C0D0qM3AV2iO9cusGkTK/BHTTou7QLSZD6laA2ndCshE0Uje4Yad/cZYIZlf6GnQ7BZJ
         1boahrc4wUB0cXGw/VlmNWBYxH3QY/t4CTQXZSDaHlHb8vwCF7AF0zZrf1L4vCYOk/bC
         ogUhhfD0V2GNW7W6W+ggKrpU7+O6kKHu/8AXbhumENAju2hW95C1rXGsbO3IYwC+XBA9
         6qGvq4acqse77sTz2Fz7w3kbttcjerNqvo1bqxte6Zqnl++3vxYc45Td2DuzncvdF8Es
         HTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=faR931eMWnEtEMtBR7rAAMTdXGKUVYvUVRzlRbLbS4I=;
        b=0Lxa6BTzWDzoWtVRyc6WXB6PKVnNWN6BE6Lp3wYrwBPDozCEsWftstz8ZCoPdsj/BD
         RCxfH3CX0jNVzUGT6N8/F++GYZLo4VYs/CPQo8eziEskqgy6vOBxIRjw6Ib5l25gxP42
         ULivMPlMLZbIOiMbhAORsOHG+cy2c0oniWma6Cw8+5KMdBZClh7GzFiP4KOhRQWNkSiW
         K3cSRRq3WhEbRysn2tmmFr/tcTR3R6e5EpVSDwIWDVRhZIzpfOlx5JMum/BFAeLDWmD1
         x1IgxTYFSfrDUhgLL9CUUrJqKigZn8ZoHwE+Aq8G/vgQau6jFy6iWo1AKhbVPHH19J0j
         zqqw==
X-Gm-Message-State: AOAM530IuR8q7+EjU8sVB91N1WSSEZBTZwYgPq7/uX35RmkjiMlWADYU
        QDc+R30wBtDRbcZYKcY+HZGTN8rKbf3MYi5sXfw=
X-Google-Smtp-Source: ABdhPJzng6huG5FGf18EqBhj3QCNpW1iEIDWytDLOw97tlALyzyCEAKAcCFspXGUnnzPeDgkJhJAAw==
X-Received: by 2002:a17:90a:de89:b0:1bc:8441:ffc9 with SMTP id n9-20020a17090ade8900b001bc8441ffc9mr18634181pjv.236.1646081793385;
        Mon, 28 Feb 2022 12:56:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm215674pjv.57.2022.02.28.12.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:56:33 -0800 (PST)
Message-ID: <621d3701.1c69fb81.bf058.0f26@mx.google.com>
Date:   Mon, 28 Feb 2022 12:56:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.231-32-g703fd9abe200
Subject: stable-rc/linux-4.19.y baseline: 91 runs,
 3 regressions (v4.19.231-32-g703fd9abe200)
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

stable-rc/linux-4.19.y baseline: 91 runs, 3 regressions (v4.19.231-32-g703f=
d9abe200)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =

odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig      | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.231-32-g703fd9abe200/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.231-32-g703fd9abe200
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      703fd9abe2008be8088c4d787974ed4708a02545 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/621cf2b099a2c397b0c62978

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31-32-g703fd9abe200/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31-32-g703fd9abe200/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/621cf2b099a2c39=
7b0c6297c
        new failure (last pass: v4.19.231)
        6 lines

    2022-02-28T16:04:55.719163  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-02-28T16:04:55.719388  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-02-28T16:04:55.719534  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-02-28T16:04:55.719656  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-02-28T16:04:55.719772  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-02-28T16:04:55.719885  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-02-28T16:04:55.750992  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/621cf2b099a2c39=
7b0c6297d
        new failure (last pass: v4.19.231)
        4 lines

    2022-02-28T16:04:55.894744  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-02-28T16:04:55.895027  kern  :emerg : flags: 0x0()
    2022-02-28T16:04:55.895206  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-02-28T16:04:55.895367  kern  :emerg : flags: 0x0()
    2022-02-28T16:04:55.961662  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-02-28T16:04:55.961908  + set +x
    2022-02-28T16:04:55.962086  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1629734_1.5.=
2.4.1>   =

 =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig      | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/621d05fc33ea280283c6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31-32-g703fd9abe200/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31-32-g703fd9abe200/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d05fc33ea280283c62=
97f
        new failure (last pass: v4.19.231) =

 =20
