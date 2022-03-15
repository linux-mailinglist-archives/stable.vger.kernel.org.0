Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E684D9123
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiCOATn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCOATm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:19:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3370426ACC
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:18:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e13so14926314plh.3
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i6VCtSR6d9MhtXYPrRVlj4jhhQ6nw3zTVMmgOpNufhY=;
        b=3wJe2Vj3ZpBqU2fQtxrAxjlQ8Tyo/YzBMjs1H5Z4exsYX7oGnpON6qYyz9bHZ1BuPW
         jx0Ob5uCxs/5IYcjIWgwVVw+bSBroWlz0onNV4CvKeqmbAh1pWtxLCbrwMvEJZid6BNj
         q8BPwniPbKDmxvhX1G6tdtCc/VXHSoMAyJba6ufVRWYJDDZbvD1zU1CMeKsUFq1AAWGv
         YhKjCqv/wb43WheL7JF/GPj9VFk7QHB2Yu1F/JInTWqkQNlHRnkmipoykLNMtROZwgeL
         PoMJ2ggvDdf8DQQAKV+8TGN1zHynbNLWN5Yrm0TlRCEmufUKkDUd6Yvw+pVsmWFyH3iB
         Qjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i6VCtSR6d9MhtXYPrRVlj4jhhQ6nw3zTVMmgOpNufhY=;
        b=uBOavHQx+VXBJO31UDn2PiMbNQ7B6/YO9JxACJ7lmkDts6rjGNv+MHIMjB7YMl1+r7
         jEvVpIeMD8PGAfPshiYmfitzhRwP2iz3Lz6VIsDu1LRFPxvTCmnwWMIAngPwRKydWZ6M
         FUG6+kJPTYCNJoxg+dHrhHMLlCBFDoa3rE0hvwzJoLK4zXOeWZHkc3UaHBxW5hV8+xs5
         mButJ9G2Wk259Nc4FHINc3+dj05pNfKONUgVfhdrXyMYAyrez7GTde07QgDtOf1Fn/it
         BqKmCqX/srANHGLZEiN9IVBl3ZlEfFjk6h7vbuwHaK4gjJMAcMXGkBgnDKf0hTRJJXlv
         0Jwg==
X-Gm-Message-State: AOAM5334Q5sZY/0TJ2juvLtqzVgJOK0TzR8VzH9+l97aNt2PFuLmXt0j
        05jIbZUBMnou5xFSETtGDntpLNfUbUVuOT6fq6w=
X-Google-Smtp-Source: ABdhPJyx8+qhBlUFt8SM68WsYrPuaSSZRP6iT6j5v8OVVWmjd0T4hEIfxeGRdceV/VYzIYoQXSPOzw==
X-Received: by 2002:a17:902:b202:b0:151:4f64:e516 with SMTP id t2-20020a170902b20200b001514f64e516mr26170283plr.16.1647303510559;
        Mon, 14 Mar 2022 17:18:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z64-20020a633343000000b00380fbb0ff9bsm12785588pgz.10.2022.03.14.17.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:18:30 -0700 (PDT)
Message-ID: <622fdb56.1c69fb81.74585.1370@mx.google.com>
Date:   Mon, 14 Mar 2022 17:18:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.14-121-g77376854c5c3
Subject: stable-rc/queue/5.16 baseline: 54 runs,
 1 regressions (v5.16.14-121-g77376854c5c3)
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

stable-rc/queue/5.16 baseline: 54 runs, 1 regressions (v5.16.14-121-g773768=
54c5c3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.14-121-g77376854c5c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.14-121-g77376854c5c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77376854c5c3f7f6c738a7399a7ce9b918dbb66b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622fa502bed702f954c62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
121-g77376854c5c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
121-g77376854c5c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622fa502bed702f954c6298e
        failing since 7 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-14T20:26:17.106886  <8>[   32.637964] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-14T20:26:18.130990  /lava-5878351/1/../bin/lava-test-case   =

 =20
