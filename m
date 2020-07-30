Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D123334A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgG3Nq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 09:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3Nq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 09:46:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC2BC061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 06:46:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e22so4552086pjt.3
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E4JLOZ+c6jc+E7iNZqWY/eoY3NQqD6ENP7u9E/pE2gs=;
        b=k2FWWZTkoxqcH0TqkWe2QKQ2G9r/ardWbroRSSd0aPchxgH7nHK2TQ3ZKsKQnJCtRh
         VFFgo1Oza0tzFegA/Kp0N+r5FfWm57Oc4U/sN/QrtqHxxfXchgx2Mr/DwG7YX7uvh28A
         c4NZRV5uZs77WNNWC/wwm6m6AZhIBi7nBQARN10zxf1if8klrDYeFLlHUIk4cgGTruJX
         +N4DIALO4vsG0iLyH9HBF/TCYhSvYUF0Ftm7DyGhoMp/mekhuuvrX7y8vJ5iSoVrJ9cK
         fPt5aeZfs70U1XAlk340X0woHmQywUydZH/5pEwWY7fl8MDUpZLVQU/dwKGJvbhcAJAC
         v8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E4JLOZ+c6jc+E7iNZqWY/eoY3NQqD6ENP7u9E/pE2gs=;
        b=UJRD/HbLLWh9SDXCvQuokyiTw+aWy6sY42ej9cWgFRPyJmPhYmiC0wE8eVlBK/OQsj
         kZGSO8rdyO/4bRJRXTN3/CJzu18r3advKbv6Y/cRZu7YfCGG7bPKKCRARB334HUCxkZC
         Pw4tai1nJ/eQ/ZfglRyzsp3+nxlyzfYNWgnqrLDxCsmwEqg0H+acHM24H45m2XZuBglx
         7IHoBDKZ3pLq4t+QpvM5hsfhIhPkYM3WSJ/k974gE0LE3by2riVZdnch/Q6EJyItLyvd
         OWN/yWPSnoDdUgEpm308WE27z0EZ+GMfoaCT7tzPLNfKg49KjzG2H063xD4jpti2//uW
         xRkw==
X-Gm-Message-State: AOAM532XIe4WjAFEBLZQhGg9MqrsJqsj/S5uM12AgfiZHHqWt1F8za4V
        WBmiAclBKN/7iqx1rpcd2RwwfamhmpI=
X-Google-Smtp-Source: ABdhPJwbKV6Ufw7pqsWSWtpdcBQj6QyBxPb1x4oefTPDsH/5iAgXJDOIWuC5V5zhN7BWtvmElx2uUA==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr11962207plb.82.1596116782651;
        Thu, 30 Jul 2020 06:46:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a17sm6017044pgw.60.2020.07.30.06.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 06:46:21 -0700 (PDT)
Message-ID: <5f22cf2d.1c69fb81.70486.103c@mx.google.com>
Date:   Thu, 30 Jul 2020 06:46:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.54
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 201 runs, 1 regressions (v5.4.54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 201 runs, 1 regressions (v5.4.54)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.54/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      58a12e3368dbcadc57c6b3f5fcbecce757426f02 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f226893131aaa5e0752c1e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.54/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.54/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f226893131aaa5e0752c=
1e8
      failing since 42 days (last pass: v5.4.46, first fail: v5.4.47) =20
