Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE6618C80
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 00:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiKCXG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 19:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKCXFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 19:05:55 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0275822B14
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 16:05:52 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f63so2965660pgc.2
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yJgy+sF1j2K5llWQWZjch9Nj5j+TGHUP1fhGoW1sEhc=;
        b=rWXa7kxiVf//c3Bh6oya74bw6SZIJRpFJYyEMYnFgl24yujNB7p808dIfMsGDLP7WJ
         20HU9qFWDDNKCitOsO71rbZQin/03jaBEgpka5unqg5VBQX2sQeHAm4GjOoJUKqQmy2e
         TfPGvmM2PXA+PqVleNo5lv55SBKRrz7rP5KToUBDnYcekV0LNsE99ypzWb5Yk8lHXMKx
         oMGtbig1NnoNkp0HODoebRHOr14oh3wlbS9e1sivYtzZX/SQ8gN5hFc/zbRWNR5dC3fr
         sUBwfdoIr7SE0pS7t2a/FatwOCRSHOyFzXJPMyt8rN3Yaq1sDgdwnQpN39xvRGCR07mB
         +TJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yJgy+sF1j2K5llWQWZjch9Nj5j+TGHUP1fhGoW1sEhc=;
        b=bmGGaTRQeQJ4l0NX7PohlkKwGrhOsn2nzD5K4lUNv2OTvIZ9wpdfNEw2wrSiExaBDa
         xvEolYtlOXt19B/KluI+kglpQlfrsZEQdlbCoWlx/YTbLqM+DJ1ACLXQdja3SwYHz0qt
         s/QddSis4aOf3lqnPIyiaKyLwL0caHtngevVlhTN9hAxaUX34DtCtA1aT9xt1bGE2x7n
         W7sGIBKQeeObZJHqYlEx/CeyE8kjpStkdGCI/n7L9r+AnS83kjXWZZOAir37AQNdts35
         Vb3M2qqMk+POfnvASAPWeXK9s8maQtIsPfmEX7CEdTTXCItw5ToBo2nFeC2jmYVwzyi3
         MFYw==
X-Gm-Message-State: ACrzQf1zhTjFFj+W6pxpahXm4LVt9mt9WIQr+v/APDTbXPLAK1S0m2pd
        cUYcTvxUjLvt6s+ypyxM5ogSW8ZggyVAuQoQ
X-Google-Smtp-Source: AMsMyM7jQQVnaVJFmEb9s2dix1zXq4WHv8SMi9cUm/H3Ly5oB3GXWza9sWqogOYVA6vexaf/A4Qayw==
X-Received: by 2002:a05:6a00:cc6:b0:56d:3028:23ea with SMTP id b6-20020a056a000cc600b0056d302823eamr28841271pfv.19.1667516752399;
        Thu, 03 Nov 2022 16:05:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78e89000000b005633a06ad67sm1291972pfr.64.2022.11.03.16.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 16:05:52 -0700 (PDT)
Message-ID: <63644950.a70a0220.56a0b.2979@mx.google.com>
Date:   Thu, 03 Nov 2022 16:05:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76-132-ged6793a62468b
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 1 regressions (v5.15.76-132-ged6793a62468b)
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

stable-rc/queue/5.15 baseline: 143 runs, 1 regressions (v5.15.76-132-ged679=
3a62468b)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.76-132-ged6793a62468b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.76-132-ged6793a62468b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed6793a62468b01e093062e733ae4ee0ae60346f =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/63640fcf890f464783e7db7c

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
132-ged6793a62468b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
132-ged6793a62468b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/636=
40fcf890f464783e7db8f
        new failure (last pass: v5.15.76-126-gf1f82287ab82)

    2022-11-03T19:00:08.278430  /lava-197428/1/../bin/lava-test-case
    2022-11-03T19:00:08.279035  <8>[   14.452545] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-11-03T19:00:08.279346  /lava-197428/1/../bin/lava-test-case
    2022-11-03T19:00:08.279603  <8>[   14.472182] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-11-03T19:00:08.279876  /lava-197428/1/../bin/lava-test-case
    2022-11-03T19:00:08.280137  <8>[   14.493275] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-11-03T19:00:08.280402  /lava-197428/1/../bin/lava-test-case   =

 =20
