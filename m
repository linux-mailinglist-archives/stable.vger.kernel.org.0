Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3F34A5762
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 07:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiBAGyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 01:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiBAGyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 01:54:14 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34CC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 22:54:14 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so1696545pjt.5
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 22:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D3GPspi+rlry77BHDkrC8nRC6tbp4S6kmhUln1lYVXg=;
        b=DDfTkeH7WxIv5IaiQkSnGDxRqLVb1llo0oO4CS6r07KcgN2o8YgAm1Bc5u7An5k9Yh
         Qsjoay3H7aOYZg+cLBl8C6F7JpVfT2O2/jfOxOV/b3Ko+8NdueKnYfgAA72LdDEVIbUv
         OMv6w7F1UaPNrdZgUE13s9UuZBjngYqHVFuUSZXJrzFgHugtZ1JET+rDOqGEPBw3KIh4
         6LVlm3a1MdsnJYLh/rtB8E8+wOX3r5GklW5V+nGwr+bTEkNg6AR0HTJ+UtK6sFJzAnBj
         y+viGlcsmVwYzVWHAmd+WLmAUjFaAJl4WEE0mnhjsx7B3YTf+wnng14hqBdCSMAmLN/0
         1Tmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D3GPspi+rlry77BHDkrC8nRC6tbp4S6kmhUln1lYVXg=;
        b=0atavFCJTT6g1WTSStWrBEs5dO6/nTUBdTY405E4NLVV9jgR2pDzN5FAozwnNGUNmd
         WPXhfnYkz6Huy0jpi9bWGZ/woF3q6RJ0MCfQV7ZUUEsrarMMWnatA6A4mCQ9VZh4pXFj
         ZhRscxGSXvBtVEHnishpxFo2e03KFINmdlhL2QL1s0EmqWZaJNGWIRHugySHxEO5MlgE
         1rKsN6lNoG0nvepZKwzVuvGnT7gAeO48PxQL84iIisxMZAsroiNLozx5xL1iqD73lcU7
         ZZhIfUfV1lhPA/B2NCz5CmR+5+FUin7eAHVBcoscOwtwSOdL1LVPLdxqP0+FzqmeCNji
         Iv7Q==
X-Gm-Message-State: AOAM533tPXDavNhgZbomgRaAzZ9LpKOy4XXUlNuIpCu7DA1utzAtgwzt
        7ZFsnDc+qo8mUUUtDSEcT7lTQVDOIbpuwe4E
X-Google-Smtp-Source: ABdhPJx05ub9JalAjOXj0Ih/eGB5Klitbf+djPHHAUr2IE177TfEYOmGNlDQ5m+m63rtoaq5CqXMTg==
X-Received: by 2002:a17:90b:3b8d:: with SMTP id pc13mr735011pjb.54.1643698453807;
        Mon, 31 Jan 2022 22:54:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm1386430pji.4.2022.01.31.22.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 22:54:13 -0800 (PST)
Message-ID: <61f8d915.1c69fb81.3db0f.4785@mx.google.com>
Date:   Mon, 31 Jan 2022 22:54:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-21-g9a634735145a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 71 runs,
 1 regressions (v4.4.301-21-g9a634735145a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 71 runs, 1 regressions (v4.4.301-21-g9a634735=
145a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-21-g9a634735145a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-21-g9a634735145a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a634735145a79d988148becf900bdb12644b8d3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f89f90a4266b68315d6eeb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g9a634735145a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g9a634735145a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f89f90a4266b6=
8315d6ef1
        new failure (last pass: v4.4.301-19-gee241a8478be8)
        2 lines

    2022-02-01T02:48:28.458232  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-02-01T02:48:28.467242  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
