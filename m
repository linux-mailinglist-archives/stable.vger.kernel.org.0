Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF22337E3
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 19:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgG3Rsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 13:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgG3Rsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 13:48:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BC8C061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 10:48:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m16so14826132pls.5
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PQA9qiixdjE4SdHhnCQyFCMw2pDkRiPlhqdlEEWI0kE=;
        b=WqHpCjB8qyk8yDPoCFDwPzvV8/bIQ8GwXTCqfEOnSfz5TFdSTgseCeEZVG/2JqNIKt
         S0Y8P+JGb4r+47XqjM0lragsWMFeHrKr/aDv2XQzIQy2se5fKwHi0/Ubka6QL+cmZ67J
         fPcr3mpoK2tMZV0qzk0eMdvFz1ypb93g5bqIOHAkkMf6WtVIPHQs2HRIrZlS4vOygisc
         R7kfJRL7d7i6NgJOi+ZeRCnHN0cWop4AvtqA8mTmOQ9H2GOtLhqzDi9cSr61wu78lQpE
         H1AxLVBogKUBWOB1vP+WtnIw/T/sx0UsskkXQ+X29ghH5RXNd8t2mr4syXrNqaMHnqTD
         ON1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PQA9qiixdjE4SdHhnCQyFCMw2pDkRiPlhqdlEEWI0kE=;
        b=IXVklMKLjiNkKc5IpB5PWjPfNCdJIHd6lPdMDt+i+9Ih1E8/P9xk11ZQWMlvr0zY8t
         S0n+NFfSLyUuK6aGaTgoWU+6VgsWiXAG1ZfSt6lXyk2yjfIn0fFXXqh57M6RAV0cFH0l
         LN3i185fx5Nuu6c11eo3AVrdOKpb64WIDT7AT1QDnAvREz5Vw/Gze83t3sz0g0bQv3a/
         pESLZXr0JBujtUzLOqyeibRVZV5IKWAsnAzS8h0ZgyQgzLgNg3jRlTqzovS0wGtQ6rL7
         XaDpvtIOKZbxDgYeiC7Ww+tdntG1Vaug2FvgHsUF/zdSnhaBZpQFzTz9czwX9lwrL2+9
         OfLA==
X-Gm-Message-State: AOAM533qF3seHk8UKFNgNmhW3EZWFH4fS0EJxI6nEaeJ1PWPLlKqw0Z2
        OM5Ilpe5MQwg4lM3pjN0ONks78FFuMw=
X-Google-Smtp-Source: ABdhPJy8WegrPdjKCFkwR+M57u1PmNduHlfeW348QZj1lOL6bAKDYrGZvDkb4iWDYkVeVA8KMgDROQ==
X-Received: by 2002:a17:90a:6983:: with SMTP id s3mr225491pjj.55.1596131314550;
        Thu, 30 Jul 2020 10:48:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm7125238pgc.77.2020.07.30.10.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 10:48:33 -0700 (PDT)
Message-ID: <5f2307f1.1c69fb81.f909b.2d3c@mx.google.com>
Date:   Thu, 30 Jul 2020 10:48:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.134-105-g62c048b85133
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 177 runs,
 1 regressions (v4.19.134-105-g62c048b85133)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 177 runs, 1 regressions (v4.19.134-105-g62=
c048b85133)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.134-105-g62c048b85133/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.134-105-g62c048b85133
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62c048b85133b227b3af4b3d3c52853b2ea1f1d5 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f22d706c5488508c752c1d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-105-g62c048b85133/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-105-g62c048b85133/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f22d706c5488508c752c=
1d3
      failing since 44 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =20
