Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DD48F114
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 21:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244322AbiANUb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 15:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244314AbiANUb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 15:31:57 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE097C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 12:31:56 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n185so3753589pfd.2
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 12:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lByAVlrmjSTjoQ+Olp4WGNQWS6yf2kkzAgYkg1E2+t8=;
        b=RH/o4wtmmhkJprMraw0sNPafti89PE7AHCcjnq7N/gnO3Rim1KV3EMTENnyUzIUhaA
         B6BydqvDvUOXQ5OzzGqG7qw2LEHqfsMOkENrt5qHoC9xwGi9ZaQf98REzhIzWjDCktNV
         IZPy55fPeX35G7nGub5Nv+qjzqhD+xF3fYXrDLXnU2NwxeLUk5kA/XhVhMZt+HmuA5IR
         T3uGON0sPkZy7r6jD1vJG4PJJPWAG3synGme3GQ7W16D03YJE1vNo2vKSarnUHDez0uu
         21LXNa/MiXU+t37ZgkmCeX+UPDAtobsT8ZBon7FrdFpaWbUfCslS8+tF5pMqx66Fgn0V
         azmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lByAVlrmjSTjoQ+Olp4WGNQWS6yf2kkzAgYkg1E2+t8=;
        b=c2OZ9L7i5vjblEKx6km1QlvLU8IAC62zCKBsjKLOAky5YuEFn+CBvvg82Mr8Xgp4gE
         HnU06b2rwCFr04Z4rbr3HK876NVigfRvVC2RgKk16poZZHBJ5VmcoerU0qDOczlcLQ3P
         G/7+zXEIPPhx4GpgNu/DOe912JDKGU2HlgFlVfHhQJVw1pWlvd12VOdwQvAhcrl2vegH
         zNqeNzh62aZUZLs61m/8Z2Q14qYIIb2mkeap0zexYNWPwZSfwc4BYF/9ZkzhBMDLrFSi
         lG5kKXkpZxAXB+lLzQihYzSUwzhdDVoqHNpPBDG8E5r+rc+CpcxVxcwvn8s91PmaZiKP
         n6Lw==
X-Gm-Message-State: AOAM531HWvAvVILh2SQWqGkaRwg4X3m8bmPxX+UuUYI/H9cgv+3Z3OiZ
        xDFcViWTihd2G1yFfYgQ6PdivyjVnq9tXrQ4
X-Google-Smtp-Source: ABdhPJwoUdgNYfD+OiskdZzAsqMfrDHk7pChrY8/P+L9aZmyWZrj1UDNghvqK+uiQICio5yJyMoeKQ==
X-Received: by 2002:a05:6a00:234e:b0:4ae:2e0d:cc68 with SMTP id j14-20020a056a00234e00b004ae2e0dcc68mr10473579pfj.60.1642192316045;
        Fri, 14 Jan 2022 12:31:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm11924351pjg.43.2022.01.14.12.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 12:31:55 -0800 (PST)
Message-ID: <61e1ddbb.1c69fb81.88206.f893@mx.google.com>
Date:   Fri, 14 Jan 2022 12:31:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-13-g6fa3b0cde32c
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 144 runs,
 1 regressions (v4.19.225-13-g6fa3b0cde32c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 1 regressions (v4.19.225-13-g6fa=
3b0cde32c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225-13-g6fa3b0cde32c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225-13-g6fa3b0cde32c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fa3b0cde32c1487867ecce7f61192276ade6768 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e1a552b644cc71e6ef6742

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-13-g6fa3b0cde32c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-13-g6fa3b0cde32c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1a552b644cc7=
1e6ef6745
        failing since 11 days (last pass: v4.19.223, first fail: v4.19.223-=
28-g8a19682a2687)
        2 lines

    2022-01-14T16:30:52.863743  <8>[   21.114593] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T16:30:52.869512  <6>[   21.125640] [drm] Cannot find any crt=
c or sizes
    2022-01-14T16:30:52.912515  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-14T16:30:52.921950  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
