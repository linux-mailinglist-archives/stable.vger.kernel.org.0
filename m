Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40DD32AED3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhCCAGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836815AbhCBHVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 02:21:03 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29DEC061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 23:11:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s7so4292284plg.5
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 23:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=51Cv8tYHfI7aWxUBFCSQewKBma9iA2ESe/IadW8S13c=;
        b=u4muL2mvtSCHTtVvKgV7KZ7DiOXqBeVh9yzn2A1S/M6iGOpwXs+BmpMWnoPWXNuVjq
         0d2X+ddoI35HQ9m4OezpMKqr1frIuj3qr8f7bbH2CI3AwOvTi15q2GQv6xc1BW4sfEHg
         sj8VxGIf4tk9AHSYHG/Jj51Vmz6bJ7/gWpo/ijffkpYbRqFlFWv3/IU/gliHzhIGSTE0
         fc7LL1qLHtxoofTz2Xq5pI+v6vVJgeLzacwxrzdIqdyXqRTAriaYBdTNZ3WCOFolZ5mX
         m752xWaPM56bTNycLgTuTWx6p1pDfTv2wrbmOvseWG5JHv9kzGj4v+tidu1PZLUreYCQ
         ziig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=51Cv8tYHfI7aWxUBFCSQewKBma9iA2ESe/IadW8S13c=;
        b=l8UDsQgm2hvzK8sGs/DBEuuOQN0Cjh03Xjel/eQMRcSzbED+kbLxDTeNwVkgTvl1M0
         5RwUr/9sXSsFWR15uav3uHCLs0IEOjmWYyQ9zQyueeqIM9uiLcY+NfuJAB5KKrvISvHQ
         3Y3pf+Ywx5hOp4VPty8iNIYbsYfCocu4tnawIsR9b6FYbM59TYtzCwQpnYOrM5OslJzD
         MohjMwKMmm53cATpLdAFqGWVPLy8MfZFb+ukGBGAydkuVFDcMc/iJFcgWkj5c0vN/WXr
         jOZ3flRhL/+/K02Kxqajosi8VqO0SJD6crj+uJ6uQJlUpO026VTCSNA1mb1xKKKdJXBg
         HdVQ==
X-Gm-Message-State: AOAM531szj04FmjmGlh4u7jGfjxSYyMQSgBH0b9cvrM1edwyuf4PMhVN
        N5DjY5jhgdfA4ngsodXaeYSRpwg781jxUg==
X-Google-Smtp-Source: ABdhPJxDZD3nGFbK17m4oS+g7oCt+U/uz1/lID1v6otBYtmD+YWYu8TLdBVkhP+Bp+kdPA7NwLi76Q==
X-Received: by 2002:a17:90b:508:: with SMTP id r8mr3003907pjz.83.1614669075083;
        Mon, 01 Mar 2021 23:11:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d124sm19779447pfa.149.2021.03.01.23.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 23:11:14 -0800 (PST)
Message-ID: <603de512.1c69fb81.5200f.eb8c@mx.google.com>
Date:   Mon, 01 Mar 2021 23:11:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-247-g0e2d946bd3c89
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 90 runs,
 1 regressions (v4.19.177-247-g0e2d946bd3c89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 90 runs, 1 regressions (v4.19.177-247-g0e2=
d946bd3c89)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.177-247-g0e2d946bd3c89/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.177-247-g0e2d946bd3c89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e2d946bd3c89bee5a98375b218dcf9c2d3d5f50 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603db3a2afabad5847addcc2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g0e2d946bd3c89/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-247-g0e2d946bd3c89/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603db3a2afabad5=
847addcc7
        new failure (last pass: v4.19.177-24-g44c7eca98a48c)
        2 lines

    2021-03-02 03:40:07.919000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
