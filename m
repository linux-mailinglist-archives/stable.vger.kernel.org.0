Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38D6612AD2
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 14:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJ3Nvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 09:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJ3Nvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 09:51:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7CA6310
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 06:51:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k5so809618pjo.5
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 06:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=f4jZNGfRkexp/Y/onHrVSboiYlgBVQUYiIY+wVIcnGk=;
        b=GxVDfG0M6LAxJy7CQRB+xQWZHe48czwT6EOoeeSCTcPD5VutkrjuPrzOAAaqMiQwZ/
         aIicaXb3QTIGtkQrOftK7/SawW2UoWH6oxdxTr8D1bJcuWCcEWxMHcG3UrMBPPIKDOzg
         hGFdQTuOU7CVA5EHyc10mQlw3U8WjLzw5Yq2Nm3TxUFxzD9/G8r2Qt+uaXhbZeHo5qks
         6efbjxVWFtAqxs4exAf01O6b5SSR4n8sCg+/8/wwcPLtlt6rVBnmCFxtSPR7FZh6uID4
         bpmz8F0u6p8lrx4Cwf61Xh8cIXTu+7njGJ4Rknh/8uwNuAR1Chbr9un/JoBxmaGmiv+2
         SDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4jZNGfRkexp/Y/onHrVSboiYlgBVQUYiIY+wVIcnGk=;
        b=2AHWzL2x20oG+T1reynP7ZtU70GdQ7/SIB6V5T+/LIg1WKF/tkTeeQlGLFcxbbMT24
         sZVsM/fj1SaQjbdVXCY5MRr1unv178n7oSwncwjkvV7ncY7e7PoxRWlXQg0eXPC1JFU5
         aNPveszjf07Drv56M0x5JKe4h9YMg9f7gViKsLrgsC5KjHekc4Pd9vVO4IHBf97V0ui7
         987leteYsY8wNpIGkbYGpkSa/qrr4cJHvh9Wka03OZiOXfpACRY28p1bYs/NMPMk7XTJ
         d6SnyxFO9JnuDvgGJE+LwC5dLlNOhjry7zBDWZHkbgFOqLjf9YQaktkGAgVhkCsxUnhi
         k3Lg==
X-Gm-Message-State: ACrzQf02cLEn2cbJwYd64cHTABPSypx1P4+ru7nk/2sYTwrDdQCOcabd
        LHCC5pCutsXGH+b2fSoGjvNpV6Z7XBmT9lr/
X-Google-Smtp-Source: AMsMyM5hTs5wDbrFBAsZK9rsDaf/U40xHx19F2EIWXgCcFvyRjTZZ8A8azG591v38JFDpHlAYR4T2g==
X-Received: by 2002:a17:902:dad1:b0:183:243c:d0d0 with SMTP id q17-20020a170902dad100b00183243cd0d0mr9360828plx.157.1667137895531;
        Sun, 30 Oct 2022 06:51:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10-20020a62f90a000000b005625d5ae760sm2736148pfh.11.2022.10.30.06.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 06:51:35 -0700 (PDT)
Message-ID: <635e8167.620a0220.bd2e5.43fd@mx.google.com>
Date:   Sun, 30 Oct 2022 06:51:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 159 runs, 1 regressions (v5.15.76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 159 runs, 1 regressions (v5.15.76)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f5365f77018349d64386b202b37e8b737236556 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e4e6c8d14825735e7db6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e4e6c8d14825735e7d=
b6f
        new failure (last pass: v5.15.75-79-g5a0236b27f28) =

 =20
