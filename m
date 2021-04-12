Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A5935C752
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbhDLNQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238203AbhDLNQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 09:16:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA064C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:16:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w8so4009056plg.9
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/EvHPW/i15oMNGiMx4xnK/hVoQ4O2GPPzisNOb7jeS8=;
        b=drLZA2Eok8slafEJpLfDbbhNRI1NbVDZehLEwDkOePQSFNL4jfhZDYIsSbmKAY8N+V
         H9c1AoXnhuEvQJ1XvKGjfY5uxB1klpqeB/EzCCySl8iosvLJ4Pv6GW1F+j6XqfDeOi2P
         vIsXCBckRQAZ7KNhTtNaELG649+9ptp99r7AH9/ct8kqRS7xFnYVIC0ofjQh1VYoqjFO
         99Mt+uTeZq1w6TscTeZcuv4p8YhDeRxMav/g0Ax92tdQehtLK9UiigQQi1tM/zF6oY6N
         BiScuBa7PnnXHFECoVT7W0dNqeEEOnzTgw4M9TWeea+SXIfeTx4bfESW807wAWwwYjFR
         C/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/EvHPW/i15oMNGiMx4xnK/hVoQ4O2GPPzisNOb7jeS8=;
        b=Z/TYSBvR+GOuX6/OY2714qAjV0hUutuLZHnpkGEQ0K5HScDM1JrmiBTgacu/d8OsMI
         vM21VKI76zc5Vd61lBSCIqnumsSaI6fKZs+HJiXgcm8hgVW7BcWCCjLVRjfSR/OKM6n7
         3p30oymBXwWyzmpOhyZ1l1U43H2ynwNNnqXj9OQqeGS73LoDiQQI55pi2ppdwvJsVHGv
         fK125X1gLJTGGcu2lfQwXxC0b0JUMGpabC5T9Da8a9Hwr/j9tuuYekHhcDxYRCIlDf3J
         4yX/ssZyUCI3Dn8oGBORKrVTYekdabD1yvZ0QxX54abimDlkTn0+IWRn4KA1XTJVSI7w
         n2Vg==
X-Gm-Message-State: AOAM531YNiRBuvVGzR5z+N+eY41FUxD0Mkj/iPft8/OcmNIzzOot/8lT
        1zFxPlXBghl5/OlDtL9wuV1gcxun/JGX8pQu
X-Google-Smtp-Source: ABdhPJzmInhhn8zTLD7Hxlru0ud/3vDeOKQLp3xH453CRL7T/fTlfvUwLZ7g5faSVOHGBwlZIb+PXw==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr12960309pjr.159.1618233373317;
        Mon, 12 Apr 2021 06:16:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 129sm1826718pfv.159.2021.04.12.06.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:16:13 -0700 (PDT)
Message-ID: <6074481d.1c69fb81.ab3f1.347e@mx.google.com>
Date:   Mon, 12 Apr 2021 06:16:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.266-34-gae2056ab4809
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 44 runs,
 1 regressions (v4.4.266-34-gae2056ab4809)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 44 runs, 1 regressions (v4.4.266-34-gae2056ab=
4809)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.266-34-gae2056ab4809/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.266-34-gae2056ab4809
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae2056ab480911780f35b8d536dcb0168be33caa =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60740cbdcd68e0984adac6c1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.266-3=
4-gae2056ab4809/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.266-3=
4-gae2056ab4809/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60740cbdcd68e09=
84adac6c8
        new failure (last pass: v4.4.266-34-g8b19e7faa41b2)
        2 lines

    2021-04-12 09:02:49.230000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
