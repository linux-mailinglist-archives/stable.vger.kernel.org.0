Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A665C6048D4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiJSOKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiJSOJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:09:56 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB0C1CF563
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 06:52:03 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s196so15005790pgs.3
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 06:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cR3ldDCzRkx2nfgQPhvv5VI6+b2t9W1+3mgke6zCHBg=;
        b=MihuUFlxEeCpDxJLplEXcPHztNjHdahW3nq3Lnv/wopdlPDhBcgc0M0RhKsdd4J3j7
         IBMyFkcqT3MLCgqkYB2Gw4tmXOFjiCkrm3/FkScdfi94X2vfR+cvLSPzWMcBCLCisN7r
         uUNSx/imQcONmS31gGZeoAm4mENSihL1DSt4aJMIvpeOKTUN1XCcXjg1horx0gI6UZS/
         2C3R9k0QrZ01ASXAM3f13cNLD0j1z4h6TannuVKuh8MmnzCGjxnKr2soFXCWaPZaa/JA
         pw+Ss2Y1kCiuS8w9psuQTIpLpsBLYvvFde5WTaS4zG83J2zGLEmlpMQpmqIofMItm8XK
         I1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cR3ldDCzRkx2nfgQPhvv5VI6+b2t9W1+3mgke6zCHBg=;
        b=QtXtHeY9PGUIdsU4I26baUQ/MLFDc/AoT8KA2P1xmGqnRwLqZRyqe2aG+VzZX5eyOM
         XTOOqWlWn4CpCZxB9yC2qpAC/BRvpOETo0I9bNhv/wgUMCSrt9RYDb6G2H3yArYu1EM8
         4LhtL5ZPo+38X9Bsudqhdxe9dz69X3gIQHkHDz+Ym4Z4yw6vBHKuq21e8/ft/TIVaqjh
         nd6h+NU4G8WLECwIrhpXB/t79e2kCUIi5A1oQAA3Uqnaqp3GC9tqK2OqL6xwFdTv+rgx
         9WCy45EJgstehXpSYnEiJTKZQ/sWvDe9RwqqxgrGWo11x68tvYcR6H8uP1k1OK1SxNL8
         zzdQ==
X-Gm-Message-State: ACrzQf07h0rnepT5cRY59I3ISpUMe3zGBmn9DclXF0KnzrPZgu4YcDXg
        i7SnjuZKviCsAQPDLEMa4Ps/qV77bXcuN3UQ
X-Google-Smtp-Source: AMsMyM5jfey7x693TXIv7y391oLRptcny48p+iaw58xH7gDVc4qPr743maQmHWmDBIg83FQxR4TpSw==
X-Received: by 2002:a65:6d86:0:b0:438:f775:b45d with SMTP id bc6-20020a656d86000000b00438f775b45dmr7359218pgb.291.1666186790557;
        Wed, 19 Oct 2022 06:39:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7988a000000b0054cd16c9f6bsm11316002pfl.200.2022.10.19.06.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:39:50 -0700 (PDT)
Message-ID: <634ffe26.a70a0220.f4914.4ffd@mx.google.com>
Date:   Wed, 19 Oct 2022 06:39:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-800-gfadb31f400c7
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.19.y baseline: 119 runs,
 1 regressions (v5.19.16-800-gfadb31f400c7)
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

stable-rc/linux-5.19.y baseline: 119 runs, 1 regressions (v5.19.16-800-gfad=
b31f400c7)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.16-800-gfadb31f400c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.16-800-gfadb31f400c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fadb31f400c769a7b4144a5996ec0812b2bf98d2 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634fc92ddc6c1b70bf5e5b3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-800-gfadb31f400c7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu=
_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-800-gfadb31f400c7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu=
_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634fc92ddc6c1b70bf5e5=
b3f
        new failure (last pass: v5.19.16-839-g28b57a08d7fd) =

 =20
