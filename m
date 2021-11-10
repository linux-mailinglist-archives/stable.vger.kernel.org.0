Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C3244CD9B
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhKJXGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhKJXGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:06:39 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B83C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:03:51 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id b4so3514493pgh.10
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ohv4zkiTK7qr+Ukun63gEpbo+u6Ej6IygAcexHHaI+c=;
        b=rQ9LtBYIG8K45QZFn5bl4GlpnG37QkkEDhutKLbgVf9lTvgnwKO2SirhHiqUgBS2mb
         jiThy8oDXWqVnUFfIyRmIJYjhMwF7+IWze7fHtBfOUzxpw5JL9HF81TpVESeueGmGsC+
         C0p+pDivE+PW5Em1EujL6sE3Z28DNjXr1rOLMAqgP9gAGNQT0PbdIRRvg77uKb5F9okB
         rBVnGyykxkpmnMbEMuARgHqQvEoEuIh1dN+nheDwnkEOK5vWByiddvIthyF8jx8uZzUj
         UpOTm8OFJCOpjFFQ8CKuSL5BgW1/6lSO8HlO49wG/ltLR0Q3iMwRLcxaGiXFpWv0c4uH
         YIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ohv4zkiTK7qr+Ukun63gEpbo+u6Ej6IygAcexHHaI+c=;
        b=4wkzKUrSqc4AdoCazmpi/ySjRqgB+yXV9U/NqbBEVZBZ+L5EbN1Oq7CTxKwb2+L36Z
         ewRT5MPzIktW7Ix5cwDE1tkgtHCJrBzj8K/TNcC7q0R4LxN/GAxt2xI1+wsQoQHSv5Tf
         bE2moTSGEJUFGmpw8vYmBcaR+ouUtnpa28IhitsusCgVHqtlWuOdtCwLgPTEddotL11G
         EWaSlm51DaSHSYwwSdVIyEOEAChH0iMbk9s4WUcU1N8yagXpl5sNxzI2MD8hFqEoTNDa
         Ce/X/kEDlfA9rcTrMc5hkQpc7EaY5aVpxL6hYCJRSyUq6E0GufxaUeTMMCivIffTIgtw
         W88Q==
X-Gm-Message-State: AOAM532rMYHaSUtnqcgjU/KoIVWupjtInZPQ3cu7XNjU8dJ5hFUOZqtw
        hUaKVclyia1opL4wAtFfTRiXBcOGUTNeQjf0Unc=
X-Google-Smtp-Source: ABdhPJz4rQnOdO1UE2+wdTDpVU490zDn7BOOfzTJ7+fH0j6DF3qmwlcLQBM4pStEYG/8EBwRqhvuWA==
X-Received: by 2002:a05:6a00:23cc:b0:49f:bfaa:e2f6 with SMTP id g12-20020a056a0023cc00b0049fbfaae2f6mr2594735pfc.35.1636585430244;
        Wed, 10 Nov 2021 15:03:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm661437pfq.163.2021.11.10.15.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 15:03:50 -0800 (PST)
Message-ID: <618c4fd6.1c69fb81.8b388.2bf4@mx.google.com>
Date:   Wed, 10 Nov 2021 15:03:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216-16-ge7c4b3bfd26d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 133 runs,
 1 regressions (v4.19.216-16-ge7c4b3bfd26d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 133 runs, 1 regressions (v4.19.216-16-ge7c4b=
3bfd26d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.216-16-ge7c4b3bfd26d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.216-16-ge7c4b3bfd26d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7c4b3bfd26df11501ea65ed8d0301751a4ee7b8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618c157e24115a376033590c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-16-ge7c4b3bfd26d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-16-ge7c4b3bfd26d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618c157e24115a3=
76033590f
        failing since 0 day (last pass: v4.19.216-7-ga721c571705e, first fa=
il: v4.19.216-7-g1cf3c1269574)
        2 lines

    2021-11-10T18:54:41.969963  <8>[   21.102233] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-10T18:54:42.017978  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2021-11-10T18:54:42.026526  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
