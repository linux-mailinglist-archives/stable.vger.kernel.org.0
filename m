Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9350FC4D
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiDZL4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 07:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiDZL4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 07:56:33 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFC66D39A
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 04:53:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j8so29933837pll.11
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 04:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9d3lCwwEolqX/K2dyZ6zVUP+yphMowmAWIM7OMpkMug=;
        b=ztxzZWWq2NoxYWrecawhCp/K//wT+KQnT9wvDnP3S8wNtv0QuAkaV/RfQgugWDYx0/
         7XtpDQotYdBzbn2N8RbK9Fn9eMEvbFMU2t/rldDIOzgU0HPHqJbNeg+vLWs+31+Op0uV
         QKXVBEapjd6qfhfrhN8H1IqqC79hjDq1YHF4ONY4jpKP5hoGynnnqVa13lsSFUGZlvM2
         OAW2b+eWACQ9pA8zPndQqTnOd2r1NF5P8B77+TIU8c+gnl31+AEawXdAQrtZTeYIzFHc
         0SxVMuBLWd+xDC3VXKooCH6M6wo40Z8HsegYgWxd3+yrAk2PeUd0vtKg7XAzYwqBSBnc
         ql4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9d3lCwwEolqX/K2dyZ6zVUP+yphMowmAWIM7OMpkMug=;
        b=u9hGG1Nw5hHsAb7sc+Y6jnIcyz2wrraXyMaSGIM5RQ754zoeejCLBQlE6r86gY2qZk
         HGV1OnZcYJGSb4UIJytjxfKq0EYLo1TnOzGmXSohKjEBRBGLe4IvzT5FrdLL4Os5DLts
         dpcXHtTQdsPCCPcyXIcQc2eg6P10aNtCt0fTiBzE3VhGuMX/vQkbqMpxed0HmA/FKLm1
         GiPagm7NSn/4gsYMqT9jwAGRY7jgLOQ/5KD10/wVYMFG7zbDU48hCUM58ioZArXASDJ8
         KHFlpw+ONsrDEqoRHLa87hME/7c/2HXDbauQakT0dMG2iWzaiG8FqnQ0uT21FxCrGfMO
         YoJw==
X-Gm-Message-State: AOAM5329LHzuVEqxV2y6Lsf1fIhCtkZZrPVD6I7EcBfP9IG5yx2+1y1c
        QgdVYLfgfhrAB/5CnIJv5MgY4rye0ZsoMW6kq4E=
X-Google-Smtp-Source: ABdhPJwROZyWZ+uJcUUJYyBinEm4PdZ/yEPjFdxlP3X2tVzJXQfzSB4YiUL59NlwEyZlg14v4t/CoA==
X-Received: by 2002:a17:902:eacd:b0:15c:17fc:31e with SMTP id p13-20020a170902eacd00b0015c17fc031emr21328331pld.4.1650974006209;
        Tue, 26 Apr 2022 04:53:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090ac71300b001cd4989fecbsm2813495pjt.23.2022.04.26.04.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 04:53:25 -0700 (PDT)
Message-ID: <6267dd35.1c69fb81.394fd.64b0@mx.google.com>
Date:   Tue, 26 Apr 2022 04:53:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-86-gee8f27e9c0bc3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 111 runs,
 1 regressions (v5.10.112-86-gee8f27e9c0bc3)
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

stable-rc/queue/5.10 baseline: 111 runs, 1 regressions (v5.10.112-86-gee8f2=
7e9c0bc3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-86-gee8f27e9c0bc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-86-gee8f27e9c0bc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee8f27e9c0bc38ca3a47f0884710f680037da4b0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6267aa21b285ea1169ff945e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-gee8f27e9c0bc3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-gee8f27e9c0bc3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6267aa21b285ea1169ff9484
        failing since 49 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-26T08:15:11.907428  /lava-6179912/1/../bin/lava-test-case   =

 =20
