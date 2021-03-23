Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E253453A0
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 01:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCWAIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 20:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCWAIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 20:08:50 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7297C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 17:08:49 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o11so9931286pgs.4
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 17:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7H7JQd6YJ1ppdwsKkUp22SW/Bp7pACSo7BFq6GkLBXY=;
        b=oPtIa+RmXrf1kupZiHwYB+wytw5ooS/Cg1/E9uGqaIO1c+do3k1/KWUkfIZr5C0+iE
         bB7kINf/RwVH3cBgs4t+qIcniBVsLohKJbDV8ksnJrOQEEg6wjeEiU64HK4vIBslABBp
         YmuHivs3D5j77+JlbTLq8bvUYspCeN1VV4Q5WAKmzrzac1JFVWSa9unxdkhmULqNvwbI
         Y1gLHbP5qbOJ1V92kgG9nMvxP/qJgTdoe5rPOqPjNwruB0YdWUUim1AjfBUaroPH5XMZ
         nTVZzQ6uAOLvHagbgwtGcPF1dHM5gLQiv2ryG5N6SxZiFc6nxPKV5pD410LLrCIgX9Ee
         3inQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7H7JQd6YJ1ppdwsKkUp22SW/Bp7pACSo7BFq6GkLBXY=;
        b=A8R9ZLfLTEzQwrZ1LmY7Ws2KnbWkcELg5Xdsq6ZP7jVoGcFlHjeaLf1g8OyibqgXlQ
         ft2GxbRg+RfkFAZJ4o1uVfUeAWHFEHWaVoHpIb8+CMLjczRXjNNEHnnZOKLObgF1NcYf
         krxV9AaITcs/JqUhxCYybm/6mcGfQ86jWtqTjCUYajG84dpZITkv4eNmnV94ToWGyzeG
         WDYO72tGLQOOVZc8OYrusNEvSRuDQG0Pvs364kQWfau+nbX6aSwNJPRrS+GICZFLRxQf
         n3Ivc+SdRQ/jTkqLmel0y67AiKkaphix5XthWg1TX8zYmxfs1zJdC4q9VCyBEveYEPzx
         ZQRg==
X-Gm-Message-State: AOAM532TImtePxxBhSnA3aMF4wUt6OA/zqS3uKt/wtgZORZq3Io7ZUX2
        8xNgIxFhCCYrxb0qXrPnrIXqeNt1VF+oPQ==
X-Google-Smtp-Source: ABdhPJyx9Xwln+dkY3aLoHi04PIfKvI8l8uSbu9gNl5Vsrog8rwr5VKvaFnAgSKkrsZaXDU68neEvg==
X-Received: by 2002:a62:824c:0:b029:21b:66f5:c813 with SMTP id w73-20020a62824c0000b029021b66f5c813mr2237248pfd.32.1616458129158;
        Mon, 22 Mar 2021 17:08:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm14173578pfh.132.2021.03.22.17.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:08:48 -0700 (PDT)
Message-ID: <60593190.1c69fb81.7b5c3.2cf5@mx.google.com>
Date:   Mon, 22 Mar 2021 17:08:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-157-gdeabac90f9192
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 182 runs,
 1 regressions (v5.10.25-157-gdeabac90f9192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 182 runs, 1 regressions (v5.10.25-157-gdea=
bac90f9192)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.25-157-gdeabac90f9192/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.25-157-gdeabac90f9192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      deabac90f919203307e6eee2606366bdb19bbe93 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605915fe6411b3bb85addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
5-157-gdeabac90f9192/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
5-157-gdeabac90f9192/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605915fe6411b3bb85add=
cbe
        new failure (last pass: v5.10.25) =

 =20
