Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AD14D2795
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiCIDOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiCIDOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:14:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E42F31227
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 19:13:46 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b8so1122632pjb.4
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 19:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lBsf0Fydom9RQq0aIpsW0IZOJzdi+ErorGGi9ieLMmA=;
        b=X7EzZwYug0Y/iDiZRgm0CNgCwyGjKU3n7PDQwQ3sH2jaBp7Dxe2mdVp6jy3gwfuh1O
         NGd8Ex0ymB+9gZrMm9EwkJwBllr6vMNPiPzRBurYLiNIpTv4UOWGb4LSE+rlLiC1H818
         ggHn7MibhKWoEuCYWobqK/f8mPPAVrWCVETpFDi5fqbd/5Wga369AJ4vMPkRDEf1sJjD
         yoReuzxzEQv8n3MO2kKohPEZLdduuWL3JkNOBJyHAxTCqxRnYuX0XJpak6thH5gy2NeA
         YsWtCmFJTv8N8bwqKh9QCbxTYJXAdZFDjI1Qhe7Rl8lFoRi8u3ybZjbrfsjz+5QGV0H+
         bmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lBsf0Fydom9RQq0aIpsW0IZOJzdi+ErorGGi9ieLMmA=;
        b=spf+qXLsvr4aUSHLnKT2qObBYo8al1Xsi82AuV2ujeWzDh8/CM9oMAZBfUeQQWQKQJ
         ZMDP6rb1QeJd7sSGj7rc7XCYTTmCJsz8VHPEHAIFPuf77Tkcyk2/Xbtgk7lbx7bZgyUm
         FwrMexuRmqylycfgtwpAXHxsGGqoHMS0P+y01KQs1Ek+cxmlEs4o2AHmtd2UH3fWpzT2
         +Y3ilGGL8mhgBZj6mU08OJ8vNpbIxlTFZzjnNmNF93URONe4VTc8daULMLYywNgoTyyt
         H3mFHYzDeHs7iS1Rnu036kmUEwiAW0krrjB38IBpaWQgfQoWBc3vJ1REHQ1LFjUMtVv0
         x/uw==
X-Gm-Message-State: AOAM531/DalqXrMnutrPx9ogaRWOA3udgEp/OEaPoRLzsMYgc88vv9BF
        jGisZFFWErh7KOlmo3wPEs2ALSREj5i2pIvFDM0=
X-Google-Smtp-Source: ABdhPJzLTKoXmu8qgCo2AVNzUdekHciWMUXiMZ3fWQqHjsJvDmJtpERaqSrrmgLpOjHjyu1ZD5M2Eg==
X-Received: by 2002:a17:90a:f186:b0:1bf:285a:2731 with SMTP id bv6-20020a17090af18600b001bf285a2731mr8073049pjb.22.1646795625914;
        Tue, 08 Mar 2022 19:13:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c138-20020a624e90000000b004f6de403b90sm504202pfb.162.2022.03.08.19.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:13:45 -0800 (PST)
Message-ID: <62281b69.1c69fb81.aec2d.21af@mx.google.com>
Date:   Tue, 08 Mar 2022 19:13:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-19-g16e3738d2db5
Subject: stable-rc/queue/4.19 baseline: 61 runs,
 1 regressions (v4.19.233-19-g16e3738d2db5)
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

stable-rc/queue/4.19 baseline: 61 runs, 1 regressions (v4.19.233-19-g16e373=
8d2db5)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-19-g16e3738d2db5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-19-g16e3738d2db5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16e3738d2db5b9e8b16d88ea5cca79b4882822e7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227e165eb9b24c4e9c629bc

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-19-g16e3738d2db5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-19-g16e3738d2db5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227e165eb9b24c4e9c629e2
        failing since 2 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-08T23:05:57.962712  /lava-5841359/1/../bin/lava-test-case<8>[  =
 36.826214] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>   =

 =20
