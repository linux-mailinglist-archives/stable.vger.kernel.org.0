Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA516781A0
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 17:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjAWQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 11:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjAWQiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 11:38:11 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F811163
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 08:38:10 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 20so9205471pfu.13
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 08:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wIKBN6hrvRpEOxppO1Kd/bduFIEydDQ170bEQlo8klg=;
        b=Oxqzhusb5O8TUOUpRk/xUgQYe3aBrNcz0q8L5cjn1DQ4R5+NuRHP1u1cXp8XItZ48g
         kwH44ofBjcZTe2mJh6ALs0PiSklHZAqp9lBlGTHLQy0jl9GMlNFK+/AxwvZx60aw0Ukr
         OzNraBrQO8oN7qR1aTDs5R7a0AmXoUdkJf6+4iVypQI9kDHgbEFAZxeL7B3oaYfvcbPK
         KIVLYmI3U5ONr3b2X5OLAhmbZOzOWh9RkmYTUeA+giNsSQ8zqnGyfBgI5AtdgxreoRns
         7O1bkiZg6X8MBweO3PV56aZ7TIGGscIkbJArpP5q7gJrMcSQPsNakhqFevgI4ztJXhQx
         2pPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIKBN6hrvRpEOxppO1Kd/bduFIEydDQ170bEQlo8klg=;
        b=CdR7674IK+FC6iHQ3pkX5oTX0kFxu0SHK6UUFWTSIBbdSlWfyI1sSNX+KNHu+P+rtl
         yk/HfjIAd4yxK+8OriNPCDIO+YDbFWSGG54l7DHm4Z4ZJ38o7tGWKjLgZSQe0u9fdYI1
         T3sTKS5sxvtI6/DhCEbOSNJLa7Zsfc0sxo8TeCA6CABz2QVvLrk/oWs2j35285UXIAOq
         6TvMCXBQ4orcb1dhaOCZbzPDqcpqKdSnCWYXVrCnqBCPGfLaLY/r27MN28dWuKQ0vmvc
         AS6sWGM1CpDzslBGI6H/8bJWaJD8iNmFAaRnyncum7smscCitTC2q7ZvUnAst2vTD7AT
         gRPQ==
X-Gm-Message-State: AFqh2kqIzXOZqwS2P16pQ45jK0vjHMHnTR721TELazam8Ih8LorP+mYe
        XGrHYzIerIOFIPyBIDEqgQ5rP5QZKoWl2uiNRO4=
X-Google-Smtp-Source: AMrXdXumosGBN4WHv1vREMmH8hZNdO/qMnrWPJ+Jail/r6FcPtB433Am+GrShZtH0RdH3FJ5Qcxemg==
X-Received: by 2002:a62:3684:0:b0:574:3cde:385a with SMTP id d126-20020a623684000000b005743cde385amr24422982pfa.32.1674491889282;
        Mon, 23 Jan 2023 08:38:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w67-20020a628246000000b005892ea4f092sm27512472pfd.95.2023.01.23.08.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 08:38:08 -0800 (PST)
Message-ID: <63ceb7f0.620a0220.4449d.d522@mx.google.com>
Date:   Mon, 23 Jan 2023 08:38:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.162-951-g9096aabfe9e0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 165 runs,
 1 regressions (v5.10.162-951-g9096aabfe9e0)
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

stable-rc/linux-5.10.y baseline: 165 runs, 1 regressions (v5.10.162-951-g90=
96aabfe9e0)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-951-g9096aabfe9e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-951-g9096aabfe9e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9096aabfe9e099a5af5d13bb0fb36e98bb623398 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63ce837b1ddad2c1fb915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-951-g9096aabfe9e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-951-g9096aabfe9e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ce837b1ddad2c1fb915ecb
        failing since 5 days (last pass: v5.10.158-107-gd2432186ff47, first=
 fail: v5.10.162-852-geeaac3cf2eb3)

    2023-01-23T12:53:59.744100  <8>[   10.993899] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3190306_1.5.2.4.1>
    2023-01-23T12:53:59.850534  / # #
    2023-01-23T12:53:59.952158  export SHELL=3D/bin/sh
    2023-01-23T12:53:59.952509  #
    2023-01-23T12:54:00.053666  / # export SHELL=3D/bin/sh. /lava-3190306/e=
nvironment
    2023-01-23T12:54:00.054036  =

    2023-01-23T12:54:00.054198  / # . /lava-3190306/environment<3>[   11.29=
0352] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-23T12:54:00.155343  /lava-3190306/bin/lava-test-runner /lava-31=
90306/1
    2023-01-23T12:54:00.155886  =

    2023-01-23T12:54:00.160858  / # /lava-3190306/bin/lava-test-runner /lav=
a-3190306/1 =

    ... (12 line(s) more)  =

 =20
