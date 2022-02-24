Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D26A4C23BD
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 06:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiBXFxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 00:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiBXFxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 00:53:48 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6609120C187
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 21:53:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v4so1092213pjh.2
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 21:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HN0BoHGE758sI1mR1iM3NuCpHrIXeGyffkxVw26aUA8=;
        b=aL0dOruFPclmCIj3JhZnZRA7Or0+tZMH/tUWDuWPsD4X9F2U3nELhvBKe7nVLYkax2
         aTV7XvDWYUmh7QQFPLJAwHeQIlBhe6ejfSfYJFvAHNEDLoYhGZbTyKIoHcCEVN5VcLYW
         kACJ6U2swduUYGsGxgbnIic5JUl9wkshPsMkJXKijr+r1OWynKXahJICFAMwhcglTUMZ
         RhFjX3VZ2Sgq3kMaYkq0izKzCF+//aWgcH5ixAbJlLAGQpnFDsb78TI8mTiQglR+zOAB
         1vds/gv3VsUczBdx8vR34GLNYOZzHsrHJJWxTdEJa5uwhqiGOJRZsakE0qkARGCnGij1
         aTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HN0BoHGE758sI1mR1iM3NuCpHrIXeGyffkxVw26aUA8=;
        b=h3KGfY9rgo0D/7uxyWt4adwHz7+dzttv/HKY6vWf/o5ctCPu9ZuOJsznBgppYoP5Qr
         SDaoYab9GAVZlI7TcbBavn4XXyXpU3oIdY2mJQpY626oGsGc7ikamBdRb99kMynF+6nn
         xEJ4U/vhWp1yquoQ+XH61tkg/KslEkrsz1QA17HnJmXQEmN9qfSItPiuRvp+RLvXY3pv
         SXAoEMOs8SgJFQh6YiKDedjgMXxnnaLH6MxB2oNWfykTsP2gxiNzvZ7YFTfgGrBBWA+Y
         qO7eIYDJTCl5uJxOSMcAZM7F2FWAFK7UL757b8WDhaGAwSJnzfqVFpjTR5poQwrlXkj4
         18sQ==
X-Gm-Message-State: AOAM532XgK5WSBv7/ozB79cux36S80g1GsuiQmzNBRG6xSDePHDjSid0
        3zZQApgmET1DLCAlJJChMfkHEhDrEETZiUPke4o=
X-Google-Smtp-Source: ABdhPJx1Kq5ejfPG66bbXwD3IixMEfNIKC9vz2YsSvcXUxm/QgnPKfjPAMLNFhqzp4cFdS+fVZdrHg==
X-Received: by 2002:a17:90b:1642:b0:1b9:6b34:b68 with SMTP id il2-20020a17090b164200b001b96b340b68mr12896828pjb.99.1645681997826;
        Wed, 23 Feb 2022 21:53:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19-20020a17090ab29300b001bc13b4bf91sm4731585pjr.43.2022.02.23.21.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 21:53:17 -0800 (PST)
Message-ID: <62171d4d.1c69fb81.d3bd.c6a2@mx.google.com>
Date:   Wed, 23 Feb 2022 21:53:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.231-1-g6c9f0f48e748
Subject: stable-rc/queue/4.19 baseline: 84 runs,
 1 regressions (v4.19.231-1-g6c9f0f48e748)
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

stable-rc/queue/4.19 baseline: 84 runs, 1 regressions (v4.19.231-1-g6c9f0f4=
8e748)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.231-1-g6c9f0f48e748/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.231-1-g6c9f0f48e748
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c9f0f48e748fc581dae39e3ad45ebe3749870c9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6216e221038732d307c6296b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.231=
-1-g6c9f0f48e748/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.231=
-1-g6c9f0f48e748/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6216e221038732d=
307c6296e
        failing since 2 days (last pass: v4.19.230-54-g25a309390ae3, first =
fail: v4.19.230-58-gbd840138c177)
        2 lines

    2022-02-24T01:40:35.923521  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, w1_bus_master1/115
    2022-02-24T01:40:35.932945  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
