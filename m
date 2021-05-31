Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79439694E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaV3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhEaV3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 17:29:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7874EC061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:28:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k22-20020a17090aef16b0290163512accedso513261pjz.0
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Wm/jGXkjPtEBzSjNl3w2XxpjaCKzEdwBqu3/LmRKww=;
        b=mod8QmDqbX6H0SxZGt6HgaxaAoMYDqfLJz2y1KU96EtHYUaeiiw7Su86JoW3S7ipQg
         RtL2we8U0DDODtFlxK4uiDyA7jAXFdLpz8yTudjScXTVUFZY9ZwMmmeX11xm8VXXNryI
         y8NuSmiVCw9KR8PNgAG1lHhKlF8WkQdKcIpz0jkE2lC1vYDc7NuMyLBKfWDNMQe7l9Ol
         MXEYWsz6zvpTRDkzyScbA2vcCA1Jr++hZupWuBJks+k7zKOWOfAaHNF9QDkPLRq9J/LP
         APISEmpcAZhOQMKptHlkc12jsi/8xyG1VbijI81DPg/a5cDbQbmb7aXuJGTnp8h5vevx
         5ErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Wm/jGXkjPtEBzSjNl3w2XxpjaCKzEdwBqu3/LmRKww=;
        b=SNasLiqPKgK2Fu79ZNgxsh7nHPD2K4/xaPh8t7L5pBQqDOwDYBDMAzETWQ7JtNbdUp
         vuJo39FgWC1NJ5YpMpTROBwpLaosQyfKHeGFth3Id0dl9sIL2/Bqdv+fntdvHz/UqBrw
         XJfJNs1Z3ZY/O+kgeql7NLtwvFWhyEOuQHXGu6G+f/HrxFs/vAUmZI2CpB8d5NrjGg5S
         qFdG9UVGZIWCAvq0jDu8yCWhlYEafIMwajqdCRu/gY2Xw992SNzEJ0N+Cd8a09xh+x0b
         pp7498oLCTfOC4WxHKjNT69f1jKuYBBPxKrBQS6gpE+ZLovnM+bq2m2Vv6bw2+gVu3U4
         i+LQ==
X-Gm-Message-State: AOAM532TeYpURmbSBOWnULAc0npyc1yEGxSWmtYpNZqSFmCegK9To63v
        XrL7q3QxzMQ4u36Qf65l9VGwiGnR4JmdQRX9
X-Google-Smtp-Source: ABdhPJxXVfNVER0cTb17YuqQKO/imdv2rD+xS8gH9DjSkgAUhI23Y7TYVE+8QEWP6wVW1zH/F06xFQ==
X-Received: by 2002:a17:902:b181:b029:fc:c069:865c with SMTP id s1-20020a170902b181b02900fcc069865cmr22553856plr.28.1622496479603;
        Mon, 31 May 2021 14:27:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z19sm12068551pjt.23.2021.05.31.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 14:27:59 -0700 (PDT)
Message-ID: <60b554df.1c69fb81.28997.7373@mx.google.com>
Date:   Mon, 31 May 2021 14:27:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-304-g7ade597cd7c1
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 123 runs,
 1 regressions (v5.12.7-304-g7ade597cd7c1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 123 runs, 1 regressions (v5.12.7-304-g7ade59=
7cd7c1)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-304-g7ade597cd7c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-304-g7ade597cd7c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ade597cd7c138a4bb7d8dfd07d676dec544e199 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60b51f39ddffa34fe3b3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
04-g7ade597cd7c1/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
04-g7ade597cd7c1/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b51f39ddffa34fe3b3a=
f9e
        new failure (last pass: v5.12.7-69-gd4f1b01eb53c) =

 =20
