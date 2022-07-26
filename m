Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9D58094A
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 04:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGZCLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 22:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiGZCLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 22:11:02 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0A427CF8
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:11:01 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 6so11915221pgb.13
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QrLvPxfYih8KqaVeI4melTSjLuv5juwo7MOQT3lbLiw=;
        b=aOAmyeu+hq47fBx5bfQfC8FCbE8ZBYQU1pU32ryu0j3D1ZoG58nwNXJzhtGQDQvzdJ
         706PYVX+3SihOVj9udDolkEPGgUdXsZ3IAeLp5PK0cx/kp+F6Ehu5AFpqxaYOec2uv5w
         7zQV2jfl4EVbziQzmBOKf0bF1nJ0r57m/Pc3CAftkweAN9BvaJ9aRp+ypyRbRA/EnBUz
         HrAX3crNjSwfyT6bMK6dZ7L77xvF0PDw0W50pOk1RYe8Vl6JA6suCY9UCmthXXy9nHOR
         1sxC2bJpVHvvpGAhssSbuZKx6TkrLlpT/389+X2dcMFuooOwwr6YgAluinsEs1DCuZo4
         0GrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QrLvPxfYih8KqaVeI4melTSjLuv5juwo7MOQT3lbLiw=;
        b=G9bis99anDOo0Val8CRFhPPUWBleVn9yC842ozfBkaj5RlN8XWel3S0FWz1O8FM+ac
         PNlu5LpLugzTdLUBqwPpRZyLB6DIcBUZP0f2cUXcGx5U9EmCWro1CP0+YAyWFpU8GUfp
         MXtw6cNYgkNzJ4kuTwERFA9LjcELG3zuLDpxFHn+qalplE/9PDN5O7VbH08p7zjE4qT8
         ML8ZRmdTyJXSYntHxtlyls/k1FYht2QzarhOUYiMQMwbY6ktEPOsHlX0+i3Gh2WS/YTN
         zkNc2n/GXtpPWlPkaG5xmJhja1B11+X7Z6qCNGdC/HHjojTdbXDRZblGuoaE7VE3qmfX
         +ikg==
X-Gm-Message-State: AJIora9J/T9g6Hnl7rFI3ZJHjJro/9/LgBGPncUZ6n6+JwAHHU0m3e0z
        0aU+FXsGtf2lFwI6nG5BE+zJ3tPrg5MqsYJc
X-Google-Smtp-Source: AGRyM1veXMRcYaSOPwffWWWPcLDgDaQfsYH15z/8h7ZjyvRuEsEmWCjX3xxjUcEG8zOiNTMJjRBRrA==
X-Received: by 2002:a65:678c:0:b0:41a:d6c9:d542 with SMTP id e12-20020a65678c000000b0041ad6c9d542mr9722247pgr.346.1658801461104;
        Mon, 25 Jul 2022 19:11:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0015e8d4eb1d3sm10028126plg.29.2022.07.25.19.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 19:11:00 -0700 (PDT)
Message-ID: <62df4d34.1c69fb81.474bc.fda8@mx.google.com>
Date:   Mon, 25 Jul 2022 19:11:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-176-g9780829ed8d15
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 1 regressions (v5.15.57-176-g9780829ed8d15)
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

stable-rc/queue/5.15 baseline: 170 runs, 1 regressions (v5.15.57-176-g97808=
29ed8d15)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-176-g9780829ed8d15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-176-g9780829ed8d15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9780829ed8d15de556424bed96704c95dfc357f6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62df1b53927a6115d0daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-g9780829ed8d15/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-g9780829ed8d15/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1b53927a6115d0daf=
057
        failing since 117 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
