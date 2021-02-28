Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD2327507
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 00:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhB1XC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 18:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhB1XCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 18:02:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9072C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 15:02:15 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so8726438plg.13
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 15:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T8xHofX3JMTL3It/ojI5HLcGBb/AFTFXPBaAnOJbeXw=;
        b=UcEpr0ZCs2EvZ5MhQ1oNDDnTiXoU3QPZfPZGJ5kMMebIU7XzdyiL2t6+VBGmmctOuU
         VrARtxlE195Zx2vleJMtzmCsIKOajudAPNQnjcyifVgPiS8jRM9YXwo6NycOV/347TgI
         3nmUqI4qb+3uB8tA6Jt8pMBBbgJmSaiFjRF6W8xo+xTxj+Ud4kWQ2RL85R++0t3OHYp2
         ot4dkSCmO4Qu9unMYHBg62MftwiFX6O1RGiZmsKyF6OKVWRZxLKywpsq9InF297qpeie
         KfZPwTp7ga1KQQmgPHPbj4nQWdY7d4ZdagU+mhDSsW8+hQg36lLH0uVNv6JaUhr3fIGh
         zfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T8xHofX3JMTL3It/ojI5HLcGBb/AFTFXPBaAnOJbeXw=;
        b=Co4T4CydJqlHtnOZGxbh+oysy8aeJBWxUbrbDdPYPqgrLAGLAU30RjsrWpHE1whZYT
         Q6V+Wj2JwXb/aHclHFcWsIUGjT9nV6I69Lh9uW5my9sCk7j6CpV5qVeu49SvFlNGlVJ5
         8oAiW8aFNkzqe74TvFtsLsl6vfE7AiNcI9QyEjr0fTFORfPajQXjZ4yWqHcgL6DF/vDu
         Ljv7q+ba9WuJUm4vgqOTFCYxfaBNDpqHA7o3EmGu4otkdKMQl8rHb3dDjcw/ciEOrcRO
         TEXfb8KjMPQH0+DQK31KQxY7aQ77htsEu0BnkFd6QfEJn6kDauKxusV/fRcupZKXNULW
         QvTA==
X-Gm-Message-State: AOAM533Y6Gys1RnT8zrYsopYr3cf7mjGIwUTSZTckRbzf0Y2YmmTtXl/
        DTyZPecM9hsSE2xsIoqlvBRi2aM/lfgwPQ==
X-Google-Smtp-Source: ABdhPJwuqmHAmcBB6TZjoSNAa34YfcrQyu+qse+SX9RRoDLTCrT7YYkqcepqZoWpjgMFUoO/Pot5cg==
X-Received: by 2002:a17:902:a985:b029:e3:8796:a128 with SMTP id bh5-20020a170902a985b02900e38796a128mr12585505plb.81.1614553335095;
        Sun, 28 Feb 2021 15:02:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm15346238pjf.26.2021.02.28.15.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 15:02:14 -0800 (PST)
Message-ID: <603c20f6.1c69fb81.536dd.3723@mx.google.com>
Date:   Sun, 28 Feb 2021 15:02:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-24-g44c7eca98a48c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 85 runs,
 1 regressions (v4.19.177-24-g44c7eca98a48c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 85 runs, 1 regressions (v4.19.177-24-g44c7=
eca98a48c)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.177-24-g44c7eca98a48c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.177-24-g44c7eca98a48c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44c7eca98a48cbe850dc8c5f80fa9cfa14808e52 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bee5fbfedad3d27addceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-24-g44c7eca98a48c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
77-24-g44c7eca98a48c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bee5fbfedad3d27add=
cec
        new failure (last pass: v4.19.177) =

 =20
