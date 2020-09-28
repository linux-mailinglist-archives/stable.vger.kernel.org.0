Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A6727B841
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 01:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgI1Xdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 19:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgI1Xdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 19:33:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0543C0613E5
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 15:18:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b17so1520691pji.1
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yfHEiXO2ldg31zOZcY1P7R63OEZ7kQZlFTEgpSFh6Ug=;
        b=C/xw3smNZL4erjPxV8UiJw6c3tqsH992OayxqefND3/cyEuNmDFwR4aIwFCzBhvXkB
         o/Obp8Ou6u2bepeQzkcJefSkYpPdmxOHPFPj75qo6DnUxZucb85h18li2+zYwWb0kLtq
         hMmIU3eH3qIZbaLeCkcjficAFJL0jYiweIbjjX8V4SLCR/qyIqtRRYG/1CbkdXRe0a5t
         SOZiMevlnP8KPZ6kzTS4pq7H/VMx0uPZDLRYypUiLhoRpzcgkaVKKhPDk+gWhFESwwhj
         9JOuInq140FKg/DTGTKA2wpczv/Y3f4BKhTNleMLo8qrl7+zcqrYFJ80jhknPlhy3QQu
         fcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yfHEiXO2ldg31zOZcY1P7R63OEZ7kQZlFTEgpSFh6Ug=;
        b=o8TVMBKiT9ze6Ncio1UrLSl1yEKOTtUZsiuEciT5aoVveLWlgfcMyh0wx6ESyKTL0r
         kOVjwUK9Ke1HBnEkOv6g7Whf7fsEmUj9PP+2J5LJ1qP2izdqX+yODzixNzDLSuSpK8+X
         fcLTwkWA4vgqCY6BUyiPfVARzwbhq8cCCMSVRNc7Tl2GpT5zYRdCX55HVCJyfAbTFkTr
         O3CxArxhHZqZrfkyJEzukMk1SX62Nr8gPt8AUPZOmm1don+2uIsVbWL0dKsNb2doZwRE
         LNt+imViG7UcX6VuIBI9WjpMLyUr5nwf3kRsvWUexwNosQk7BV+P6oE6z1Yus3Tqhy2h
         Xsfg==
X-Gm-Message-State: AOAM530LR4Ak7oRhB1VWUKFNLslX4Mkpvlbe6yoRwmNy54G+FvTwi0Re
        6dnBkw+Tm7Hx+oZHDzYwu+6bQpyK5NT5bg==
X-Google-Smtp-Source: ABdhPJz3vfV85DpUhE6LMsNOE8V5aSrd4Fqr+S9Wq941CkIYw8nRA6tysdP1le1Ye/Dx4sd0WqZh3Q==
X-Received: by 2002:a17:90a:d914:: with SMTP id c20mr1223258pjv.34.1601331487203;
        Mon, 28 Sep 2020 15:18:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 190sm2846258pfy.22.2020.09.28.15.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 15:18:06 -0700 (PDT)
Message-ID: <5f72611e.1c69fb81.5630e.59d5@mx.google.com>
Date:   Mon, 28 Sep 2020 15:18:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.148-244-ga8c3c22706f1
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 1 regressions (v4.19.148-244-ga8c3c22706f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 1 regressions (v4.19.148-244-ga8c3=
c22706f1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.148-244-ga8c3c22706f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.148-244-ga8c3c22706f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8c3c22706f11f0c82bc7bb1856ce622c02f6bcb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f722d5f48c222a508bf9ddb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.148=
-244-ga8c3c22706f1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.148=
-244-ga8c3c22706f1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f722d5f48c222a=
508bf9de2
      new failure (last pass: v4.19.147-37-g6673b81907c0)
      2 lines  =20
