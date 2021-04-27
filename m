Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE5536C772
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhD0OB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbhD0OB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 10:01:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF486C061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:01:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so7144892pjj.3
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lcYBx+LlDVOrUv2MzKvBTLbMJ3TTATp7OqGFFjZb/RI=;
        b=US6bj50kMLGRyRrsEE8AM3AATndr/jPPXlzCA9/WVBmdOD3byF3kQ1eyu0J/2BqYVb
         6T8Mj3sOxdPoNmHQjB1RpVR/snRME0nHVC1cy5gs+Cj9iPzW5LflykUYMlt2X+t0TA4J
         DcxiAB1WqDD/Z5RhHfLs6v8JHvAVGrK8N/wQBl2m49oEopHy1yDxAXWvxZIRruyKdsTN
         uo0yYXCtOtrVsgDDBLUOGZ78cGsOw0JKroD4v84CYMY1edOZKehPfZ7SdSkGrB+5oB5Y
         AtgTG62GqXouPaqOpfjq6Bv8qIHnvOmY95zAzI2Gl3FDQ4XSPxIzkSM3xuuGSM7jjZyw
         GsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lcYBx+LlDVOrUv2MzKvBTLbMJ3TTATp7OqGFFjZb/RI=;
        b=r+Xi7CoMEb7qYjziQyhoYsLfJZRWsU84lLhdXqEFXFR9X0jelHFRmHfSaRv7jwQuS5
         gGJQikR6YcEMD4lVhm5DbaMAn8T1TCID6XaoPLW94v+M+9jaapFxMZ904QCjaVHFHqQL
         fspdb4XPJmy5IjPo0kWToXNjCG5D1gsskJcMnciR6E4D+jEm6B66Ub6eblOAR89vrL6j
         +wLe4bL7jvuFzK1e4rsi1NHtGKKrT0ymHeG251VYo9BSbJkWtZrsRQIU60fgzHJdVpY2
         R4Om8KT74aOO+qkqUFD7JMhcJkpEHAhHRwqmg+o0LRXcfrkbnjzUXJUMa29uULVbRsfO
         710g==
X-Gm-Message-State: AOAM531vQJnkXOq14DNAPtqzvW1Ww5Bk26L5ZoAQbvgM71eDrajKbXNt
        ViaLp9tOX2VOgQuqnBqGIoqFX3jE2ScV8ABb
X-Google-Smtp-Source: ABdhPJx9p22rklv6XbL3yIMZcw8TlA6xnlTVc14RoJNPbpo//qAIFuMHgkbcOhNH7Q8zLIcMb81qLw==
X-Received: by 2002:a17:902:f284:b029:ed:1840:5cad with SMTP id k4-20020a170902f284b02900ed18405cadmr14072978plc.34.1619532071075;
        Tue, 27 Apr 2021 07:01:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm22504pgd.34.2021.04.27.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 07:01:10 -0700 (PDT)
Message-ID: <60881926.1c69fb81.6417.011b@mx.google.com>
Date:   Tue, 27 Apr 2021 07:01:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-38-g6794b7417781
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 150 runs,
 1 regressions (v5.10.32-38-g6794b7417781)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 150 runs, 1 regressions (v5.10.32-38-g6794b7=
417781)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-38-g6794b7417781/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-38-g6794b7417781
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6794b741778164ea568ecc3278d3deb84f860019 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087e4e758c7082a2b9b77bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g6794b7417781/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
38-g6794b7417781/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087e4e758c7082a2b9b7=
7c0
        failing since 1 day (last pass: v5.10.32-12-gd2a706aabb95, first fa=
il: v5.10.32-35-g413e8e76f9149) =

 =20
