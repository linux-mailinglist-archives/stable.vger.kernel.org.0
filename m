Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B924924EFA0
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 21:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgHWT6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 15:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgHWT6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 15:58:19 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71117C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:58:19 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u128so3704137pfb.6
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kKpqVnrN9dm98KP6ersmpdRRzTnOs+81yOimG+3IqkQ=;
        b=WllMynYxCDZiMzQc8iUEphIqgIsWMTX7NDiWONLRRL77Jqpbfv6m/NN0aEvtxZFbCq
         l1UkX/1JrWYGoIYs6D+knQCWCdOQDIjS5pvvNQwvXGWB7t0nplJtQnPa0mliKHg84Hfr
         faWyeYvsswGqGS4yQZx1YuU9odsrpOFSk/9huH8Cq6S5Lc+RZEQIrOt0H8YJMlgrvrSr
         juDVkFyDUK9UDIBgQiaHvCIBlpKOLcnbpzOThWQtnCiv70DrkVVapioRV7fm7XkuP0Ql
         pcyMd7bRhV+zWATwgn2UCc2V+a/HOMKzKDKEDB2UfHjwnuylAaypw8L1FUaIgFHGcAY2
         ZhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kKpqVnrN9dm98KP6ersmpdRRzTnOs+81yOimG+3IqkQ=;
        b=pCDKF5d22wNZ8EHsqPeBalUMPWH6HTOvbmWTqrGl5rfCTjivUNbQxKcopNwUZLD7R+
         VcM5MkVM6RSf9JR6tL8nIXK2teRv0Ix9OAS387lKmMVp2XnJEg3+0OpH8lcj+rlAtCDN
         AF8uv9wgOOjIPRiO61IUg+G+5i/5I8zbbJxVJLAgp4EgSaEAzVod7bK+8ROc1CtODsmF
         mKme634hfLpV8bb3ekCT+Rzs9X46khHQHBkRCjHspfLkKtFm40rY/7n8dX8EsuvTdMuZ
         D51TjYC8MpTO3pBPwA9SJ14bUPDSqW+EMhceOlEnJ7oCTAz/KAetL7IuYlvHxO+Pgt69
         NCbg==
X-Gm-Message-State: AOAM530ED9ivN1uMkxWrQgXNv2cd07BmD0ehJyXjxPW8tn78zTak+2mP
        fYnHgd7c/YeSSo0q+B3xRPmxfcex5KyLCw==
X-Google-Smtp-Source: ABdhPJwhNzY7OxwGzY3dn3KKdJyw8Xkj/xRwY6io/wOb3R4lu0VJwP1jsXqFJ9T4QDntNOMrdzypAw==
X-Received: by 2002:a63:220a:: with SMTP id i10mr1451034pgi.88.1598212697105;
        Sun, 23 Aug 2020 12:58:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm9142909pfw.25.2020.08.23.12.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 12:58:16 -0700 (PDT)
Message-ID: <5f42ca58.1c69fb81.050d.bdb1@mx.google.com>
Date:   Sun, 23 Aug 2020 12:58:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.60-39-g6ba0cb3c0b4a
Subject: stable-rc/linux-5.4.y baseline: 168 runs,
 1 regressions (v5.4.60-39-g6ba0cb3c0b4a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 168 runs, 1 regressions (v5.4.60-39-g6ba0cb=
3c0b4a)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.60-39-g6ba0cb3c0b4a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.60-39-g6ba0cb3c0b4a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ba0cb3c0b4a76216b617b5d6d4cf50208c96ba6 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f42988c49164b4afd9fb435

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
39-g6ba0cb3c0b4a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
39-g6ba0cb3c0b4a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f42988c49164b4afd9fb=
436
      failing since 133 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
