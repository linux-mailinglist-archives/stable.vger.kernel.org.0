Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097F43F5971
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhHXHye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 03:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhHXHye (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 03:54:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7314AC061575
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 00:53:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j2so7326207pll.1
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 00:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bdg8Wbxeligjm4eIHLt/fyjoLufcgtKJUxgN+40s8FE=;
        b=hN+Mt+knepd2b0+CkTYC3mcqq4iOEXl8DIQgaIYkFWkv1Ak+aO5bsYNRSXUFNSyYj3
         IcB60ied0TIDguxikI/HWi/e+Z7XnUac+S36ek8w8u3pRGU0I8udSSUhfHURXGyaMnfh
         fiWIjOpzoqIjuA+PTWDPP9D+icO+ObZIeVbyrZJRYPlEqfm1b0VyHB1ztbhzeN8Td6Ap
         cYvq22PuqnxuR3N58f5L4NSzmy3J/SS7CDc/yDy6HGUflCR4QeGsdRWCs7u4ymeiwWM2
         IUQrtSn6Wt83AI93Sh8x1J0iqpO35wlb5pz814R7Mwp8OIQqJkcsiyuL8xep9o6yUiQr
         DCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bdg8Wbxeligjm4eIHLt/fyjoLufcgtKJUxgN+40s8FE=;
        b=EBt2TPA9G+/v7DAkUzyM6RRPAX3uE9mD5/7y8ug0DykrtxfkeTPmWyorl8HI7XVDWW
         z7DuNlT3XxIhRTkR+PQ7ixyCXIYBSya2JJ7QfYJFgaPHbcxZM9OVl3zxT0XSZHkRUD63
         22ed9ysTXTxEuIIFtSq5jbaB2uJ3rSpvmALCqSnAGvFbk5UA4U0hqbZwPGTSGS9Gj4Cx
         UY/olZJdEoig/YEcn8V2xdGH5cpF1ApXdV1LV2F7iXH3/pMHpD8TL7u8HUN4B9MKlrca
         Nq2fxBR7uD+x0tv0TQVdcig0YjUI6hck+To45PZn6PIpfuq+AIiUsf4/y9lAZd+tb0Tm
         D3MA==
X-Gm-Message-State: AOAM531bxU+sSa7ziV5L81ZDEyQ5pL7e6EK4Q8S+Zg1juDcFeKcKo7q+
        2/J8M80cFh43FKsN4Z62Y8ud1xOIXAPOEnIA
X-Google-Smtp-Source: ABdhPJz2bRpadxEqDmHAtl1WUUy6fwcYAJiLxnJh8XNQm2wYFOKLeooP2QuuztVgC0SJE2vgBPZphw==
X-Received: by 2002:a17:902:6949:b029:12c:591a:2ed7 with SMTP id k9-20020a1709026949b029012c591a2ed7mr32362442plt.14.1629791629803;
        Tue, 24 Aug 2021 00:53:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm19354663pfm.81.2021.08.24.00.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 00:53:49 -0700 (PDT)
Message-ID: <6124a58d.1c69fb81.5e87b.8474@mx.google.com>
Date:   Tue, 24 Aug 2021 00:53:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.60-95-g7e1be9cb3c48
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 1 regressions (v5.10.60-95-g7e1be9cb3c48)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 1 regressions (v5.10.60-95-g7e1be9=
cb3c48)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-95-g7e1be9cb3c48/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-95-g7e1be9cb3c48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e1be9cb3c4843a1797400f6c46eb11998109fb4 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6124757d3659f715b68e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
95-g7e1be9cb3c48/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
95-g7e1be9cb3c48/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6124757d3659f715b68e2=
c7d
        failing since 53 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20
