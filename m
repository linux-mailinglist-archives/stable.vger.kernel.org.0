Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF844423B3
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhKAXHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhKAXHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:07:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E140C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 16:04:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p18so9733274plf.13
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 16:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7ZTRQw2VQVNifZKE9O8y+a7Q3bLhHuKpoat53qHv8FY=;
        b=AfwdfhXWkMrZzhRtSGVwTUilAK7hZ8fGs5zAlr8VAikGv6+X9waVwYgC5h9cz/8euH
         YPKhV5Ge1/u4GS7Pg5i5NRZEjvyrk5hHmXBoKplo5zgd7Umn4h8Nq1QG5NZxVSQH4AUN
         BeZBlI1NYz9bTck6ufee7YdwUFgfJvZQP0au8p1fwmcLap6+Muss7dIIhYe7MglLLcV5
         IoMs3Eso42oZBiwgvUPrVQRMwEPATskeX1o1cDVde1mlJsrjNm9u1IB2bRD3xxvOqUcn
         2nDNzcapobsUB175YCFXRkocN+qMMBHNnAPQR1JQtmHrPoRvY/VqO6t33w6XaBL+ly5+
         Z63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7ZTRQw2VQVNifZKE9O8y+a7Q3bLhHuKpoat53qHv8FY=;
        b=S2ffJrLyxsyV32/Dz3mkRqeUOnydAdZaBgbyUtWyqvTi5W07AgsCRFIzZq9YUTVpcV
         cJ6Kmd8C6q21smyaEDvF7KNVBGRTDJJAE99Z2+iCeFZ6TSwSvNRPjTVSxyZi6dZFUo3T
         zVXoGM1++boVGc5FlhMKHhfD7UJ7f4BiSirNLnSnNRgzkaxAesMlGRnkvUto0tal1kR+
         j4QXsg/f57n49mxF73jdkkbXZUFuXmQOP9YJTqYGUV5fGtFahTr3NbLASzEzsyevRc9Z
         YlOUQ/VJyG+lZZl5zYQJzIOMDwJj63q1njJ+fJ1MzI9FzBJzqBQrim8hWzV5XTzcGeqO
         viHQ==
X-Gm-Message-State: AOAM532zS10lGAPO6dCdSPKWPPEIG4Tx3gh/PRL3hGltZD/gu5A0BSkE
        1Vp11DDt1iS2jJP21PwILzxrmKpMJ+jTeZLH
X-Google-Smtp-Source: ABdhPJxQn7pJGkTIG4RQpIgaFbU5BBlV6IyMggS1pOP74ulsrsH83QCjO3u3YP3/4hEEMYBtDe2hiw==
X-Received: by 2002:a17:902:c401:b0:140:5cab:869 with SMTP id k1-20020a170902c40100b001405cab0869mr28268519plk.61.1635807877067;
        Mon, 01 Nov 2021 16:04:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w21sm17699743pfu.68.2021.11.01.16.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:04:36 -0700 (PDT)
Message-ID: <61807284.1c69fb81.b2372.1590@mx.google.com>
Date:   Mon, 01 Nov 2021 16:04:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.214-35-gb67ebb9cba84
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 1 regressions (v4.19.214-35-gb67ebb9cba84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 1 regressions (v4.19.214-35-gb67eb=
b9cba84)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.214-35-gb67ebb9cba84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.214-35-gb67ebb9cba84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b67ebb9cba84e5d505036f1377028f9d07633274 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618040b07208f60e383358ed

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-gb67ebb9cba84/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-gb67ebb9cba84/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618040b07208f60=
e383358f0
        failing since 1 day (last pass: v4.19.214-30-gc41b589f35b5, first f=
ail: v4.19.214-35-g60f0264e8c0f)
        2 lines

    2021-11-01T19:31:44.479931  <8>[   21.199005] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T19:31:44.527075  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-01T19:31:44.536438  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
