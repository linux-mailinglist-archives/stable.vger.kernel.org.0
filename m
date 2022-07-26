Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE7581B6F
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 22:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbiGZU7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 16:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiGZU7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 16:59:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBB139BB9
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 13:59:34 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b9so14282108pfp.10
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 13:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ipUzV7r6qSWFVi7VrwuBogfj/Lw1dSkJbVgxJyNaFU=;
        b=yRORKFMzvvsuKYPWCvq9JHtZM+w/fFkukjAF7SZYuvHD8JRdIWBSjauTFzXdwHcK66
         pIZ6LjK1x/WWct2EA4SUCqjjIIvynHv8RDED6wC91rHOHnin/zJW3HwLOUuaZybbpZVk
         5gVnYS4/96eDek8Y6wx16k0jMZQmqES2TXlnOPjHAWIHaLT0+eZSyP6oaU+lX6hCU3bn
         j32YsHX3a7AfARWx5tT+0goYULtItfTxXJH/h8jspqZihu6EfKhCwFR6/U03zTB+9gCZ
         c7UDkCcEc53zdA5fy6p5sWGvqhBXThchln+V1jfbk4XETDHVyAoxoXvb8SMGzkwstlGg
         6OMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ipUzV7r6qSWFVi7VrwuBogfj/Lw1dSkJbVgxJyNaFU=;
        b=msdPjRMFAhqbVmy+R6o9RWwraVSlSrXUU6uSl3Az+rogvmFkdFLNYASP5rNvF+c8pa
         5+ayMPZwnMAw9iEr5OBFV/KHwh2zNKDwMPuYzlc2925SUyo1BNSrxVMDC6XcsUVwYaes
         YjBCyyM9qbeWKIEgS+oWOVXFDAzkERtog7pWIJqZM9vfKpGontEPbaD/fTqZqntCREPD
         /E6yml7+4v+VqYQ1goDvgLqtzoCNPxpaJ/u31ujuBxW2BHTpyRM1WNHHmL51YPW/rieA
         S8PJzFAckF9SjHrO3KyrsxhvrQoC3HTD5rz4wcL764RSVNuWGfyReAZKgylcJDwhUwJL
         PIyQ==
X-Gm-Message-State: AJIora+mARolJS0Ydmd9XkaWl8x+GAZVAP/NqkhzY6htovLwvVLZHtjj
        4uLrRJuUpCborPvzPJp7xPsHSqfwBXpWSwUJ
X-Google-Smtp-Source: AGRyM1vbPCM48LKPMPXB6CvjcZlH3IMac2jt9aM4W/OVk+QjFm+QzBLj3ebGHQmUBfBbwe9CkVQS7w==
X-Received: by 2002:a63:607:0:b0:41a:93e7:9006 with SMTP id 7-20020a630607000000b0041a93e79006mr16277187pgg.334.1658869173686;
        Tue, 26 Jul 2022 13:59:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d11-20020a63d64b000000b00416212f8da7sm10627605pgj.44.2022.07.26.13.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:59:33 -0700 (PDT)
Message-ID: <62e055b5.1c69fb81.b4e2b.0f3b@mx.google.com>
Date:   Tue, 26 Jul 2022 13:59:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-176-g1bb44bd5f12d5
Subject: stable-rc/queue/5.15 baseline: 59 runs,
 1 regressions (v5.15.57-176-g1bb44bd5f12d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 59 runs, 1 regressions (v5.15.57-176-g1bb44b=
d5f12d5)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-176-g1bb44bd5f12d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-176-g1bb44bd5f12d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bb44bd5f12d55660a720d557bd16188f73d3857 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62e020123c4cf3c2aadaf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-g1bb44bd5f12d5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-g1bb44bd5f12d5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e020123c4cf3c2aadaf=
07c
        failing since 117 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
