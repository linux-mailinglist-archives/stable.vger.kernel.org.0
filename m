Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3654D3FB149
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 08:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhH3GjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 02:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhH3GjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 02:39:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097BAC061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:38:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so11477264pjb.1
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LcZ01pfJstYTulXUXsPQdsEkDK7N7hUbOxAWJdfHj4E=;
        b=Ya9k9nFZTi6lP3mVBGIcsa0JT1slNwi0khSNyNlXQJ+A04VGgmKzzKvObPH1OT8AV5
         P7vC2T9wQpvPM4TDgHp2nCcgdLHlRdPhVNHIDWekH4hGuLbD12SNsGdndwTde1er5Mq7
         YtrMiArxpPEBz8TCEum/GlEMaAfUhGB1SRVHww1z2uyi5L+p74UHeKRDw5fce8cnCveG
         7ybS/RVDB9fvwrTarfgyHSamkpHRH43MlfEBA9NWGMbtqmT89r1YMsXfjvQFdRMxXxcW
         tsUoYfCZKx5LltLoPYnQXpLryjIsErHv5NVSzmmYP8tc+HrreHhyO7WtZNZPjgY0aB0K
         30xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LcZ01pfJstYTulXUXsPQdsEkDK7N7hUbOxAWJdfHj4E=;
        b=qaP/ypbyrZOM0Az+ElAWknFW8mAZgOxd5IWcruZwWGG+qgUFyALkUQSL9ANSma7HC4
         4z9P8jTMAJwsgrA2QJrB6z5KPfUZx1Hr+MtXyZtTHlKJmMyM7BD7WDedqywgtQaR+tcd
         B8qBCzKIO4VW3fG5JY7ARj6WQ2SY5e28ldLmNIhqumwiNom/RoZdbxCfXqURSowiDtsS
         8Cp95iYAdRXjtbr7JTpe91gJ/7Hsopal7f/qmHCu9t5ciQANudYpOJ8sKm1NSGAtPC9E
         kB/8PCs2jAy/Y3UYn6SrW0QxoEcUlvJNaW0yZCYpzXps1EU1UFFcMX4u3NZg5jCDi3UH
         tYhQ==
X-Gm-Message-State: AOAM533fOex4T04dokQUfpdwq+6E/EGnYviIPIWVOOqoMmFSJcNdxRkx
        YeNQ8HFe5FDHjJYnb1QWcAbFBlGG2tfgvZ9A
X-Google-Smtp-Source: ABdhPJxIcUMX+JWONNmiyM4BMZzGaYsEgI2G6iLk1HRncNvt9proL491mxT76dMyEAqEOyoQhYQAtw==
X-Received: by 2002:a17:902:dac7:b0:138:cee7:6bbc with SMTP id q7-20020a170902dac700b00138cee76bbcmr6454342plx.0.1630305500232;
        Sun, 29 Aug 2021 23:38:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm2303202pfw.66.2021.08.29.23.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 23:38:19 -0700 (PDT)
Message-ID: <612c7cdb.1c69fb81.1b36.5967@mx.google.com>
Date:   Sun, 29 Aug 2021 23:38:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.61-53-g938272055897
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 1 regressions (v5.10.61-53-g938272055897)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 1 regressions (v5.10.61-53-g938272=
055897)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-53-g938272055897/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-53-g938272055897
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      938272055897d523686a9aa3cf6cf0e64a3e818e =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c4bbe3b02d7275f8e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
53-g938272055897/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
53-g938272055897/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c4bbe3b02d7275f8e2=
c8c
        new failure (last pass: v5.10.61-22-g87253edb385b) =

 =20
