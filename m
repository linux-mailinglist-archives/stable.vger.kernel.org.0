Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACD4E6D83
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 06:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357871AbiCYFEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 01:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiCYFEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 01:04:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A55B821C
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 22:02:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m22so6597514pja.0
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 22:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZKz7x7hp3/0oPnseesz/fDo6196HnhSX5vH+dOIJlsc=;
        b=5lszbIOl+2DeXZ0aC+2K/ebM6gpMZ/xNo3lp5TF90V6aW7yoIhAqZ+WNtR21qalXC/
         zaaPFkHovesNVlXgo6kQYEZ5RXaq/zkZfK5zOo7kpgiLGEfGd9GIERZEpMXXX2IFj7UP
         SvELudreuHo4FZDSEEz41xlFxPqVZoI1W72g/CmU/nO0F++BTaqXbDeVdT0CyXR6vsGR
         Txt7SK23NMC1Xt15YE4n5VCfZI8IFlCISFyzJ7DcRMEOM5KixPHYcFkSDMSzDafdpSlr
         q9qzgxey49DTn8Kq1ISkQYUO4ZJwIsASrHdLCODud40JEo54KFZpnNikj7SFqQtc9C2Q
         zmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZKz7x7hp3/0oPnseesz/fDo6196HnhSX5vH+dOIJlsc=;
        b=4jpl1hYrrebHqkonSamraqPhlZ1wWwodsV2S0au7Gfb56vq13FDOZFZ4YKMTjS7suV
         EBz8twA/4eHat4m+tBdgFeQhCFCUkGGp5sAHCCBNq+GychyJfoMZ3nnbalSHYALQLQe8
         aXcAE5Sk/dZG6yr/1Lyit7rS462gICysfk8FUoxD7Luxp5ExSTtAjYY2AqsjTjy2b73l
         mzeQerRPhMMflxEH6RCd+IZvsDDbLa8UDwcPcVd5UTx6IeLXcNCFJWJMZYgv+Qgpaltq
         srVZsxX8NSFq+tQf2SUQMtoeVgi3DtSbOKOfZ7YUgv3CFXrQSX9FSuWp5yhGmU0yqjay
         hvog==
X-Gm-Message-State: AOAM532zEweVt/hQ6i9KUvquwnr36oH2UxQfAqBwhZ15JZ2eu2rczmlF
        5AT+dwgG8pu3RuTLa6UVKfLgkMIar2FVLSke86E=
X-Google-Smtp-Source: ABdhPJzeDL3fC18UCFJFGMNHLgMtqnJQn6PgXTDr8Eckwyy+UqxeydvRJJ+9RfaqRjllc0SPWisI8g==
X-Received: by 2002:a17:902:7209:b0:154:19c1:c884 with SMTP id ba9-20020a170902720900b0015419c1c884mr9704201plb.19.1648184568178;
        Thu, 24 Mar 2022 22:02:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090ad08300b001c6d797ee13sm4372480pju.56.2022.03.24.22.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 22:02:47 -0700 (PDT)
Message-ID: <623d4cf7.1c69fb81.678a2.dec6@mx.google.com>
Date:   Thu, 24 Mar 2022 22:02:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108-8-g9ffc2a65afb5
Subject: stable-rc/queue/5.10 baseline: 56 runs,
 1 regressions (v5.10.108-8-g9ffc2a65afb5)
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

stable-rc/queue/5.10 baseline: 56 runs, 1 regressions (v5.10.108-8-g9ffc2a6=
5afb5)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.108-8-g9ffc2a65afb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.108-8-g9ffc2a65afb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ffc2a65afb59461abc3144cf353ee1ac732c4f6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623d1ebae736c58bb5772502

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-8-g9ffc2a65afb5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-8-g9ffc2a65afb5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623d1ebae736c58bb5772524
        failing since 17 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-25T01:45:21.037950  <8>[   32.530337] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-25T01:45:22.063719  /lava-5943936/1/../bin/lava-test-case
    2022-03-25T01:45:22.074655  <8>[   33.568326] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
