Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF40612BFE
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ3Rhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 13:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ3Rhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 13:37:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6189FC8
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 10:37:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so8549140pji.0
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 10:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=m4ZZ1lPhJ8BIgTPFJ9aAGCl+ot5MFoy+CnQ0dXW3gMo=;
        b=sd7E3sDb8pVGXRU5S4oSvdReaWL2nZb2n8tkwzpScZ8x3aU73c8A3OQwIj5X2bN7fA
         E5JAzOIpXMt896kMrvChMpzua7Asg9JpQQOp+/k3g59lLKPKVPl3TwyVLimoWpaZupcR
         YGdAI5wvE+OoWYsIWtb3sAMo/+yYD4tTc4mwowgv6vGpNpxYNHfR1GCLHTsxo8uqrjIt
         OCE+KWhzUaRc/iIzwCsUUxcKmsgDyUtdQIWT2sAu/TONberYSYZ6vq1v1iDznLOmm3NX
         EOpaOP4rQDgK8u2qoaR7PkFuILSae6Ey9Att2vFagXx7zRJT0pjwSEodowNWjQ2V8puD
         rSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4ZZ1lPhJ8BIgTPFJ9aAGCl+ot5MFoy+CnQ0dXW3gMo=;
        b=Mqua3/WIpBDsqBDszh0SP99w7G9BSO2XOWHU2y6C7Z+32FO20wddT16xhnEy3EmPzL
         hsixuklUE9RMmLBdSvRcr3rrShJMHhKsjq5gFw96fU4spiZgIpV7w3L8izW/1jWAssNu
         Qz8hGT6U30T92Fis1jBfvGkGgO4qEWLWyGIjl3yL9xLL6MEi7L9bjjl0IY5JggcNeAzf
         8KxYczIq81TA5cR/YmAasQwZ/i+ckd5ykbzw2wD3tHTQLADNyTvKtpVHz5atX1Qje6iF
         r5qwEFV8h6jJnghMmhyr0SBlspWcGANo7/aPWoSahkYLb3c2szLSeIxZkVYViwbXVxOw
         kKTg==
X-Gm-Message-State: ACrzQf0rTQNtgxXrZtLD4i7J2QEIv6ePuwUdCbHj8RbB+PdZASL/mO31
        GssLjbqPwQi8WcPB8ix/cBPX2TuuzmOSZoDz
X-Google-Smtp-Source: AMsMyM6tCTpUfMLy3Hgi8WnlmsFKxxMl6WdwWL2GLYQPVV3xbPXGHd3yIpR7369v9DLlwSvjj7Yo5A==
X-Received: by 2002:a17:902:dacf:b0:185:3735:ffc7 with SMTP id q15-20020a170902dacf00b001853735ffc7mr10025874plx.147.1667151448914;
        Sun, 30 Oct 2022 10:37:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v128-20020a626186000000b0056328e516f4sm2967414pfb.148.2022.10.30.10.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 10:37:28 -0700 (PDT)
Message-ID: <635eb658.620a0220.918ff.48a5@mx.google.com>
Date:   Sun, 30 Oct 2022 10:37:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76-2-ge48d39a364d8
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 140 runs,
 1 regressions (v5.15.76-2-ge48d39a364d8)
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

stable-rc/queue/5.15 baseline: 140 runs, 1 regressions (v5.15.76-2-ge48d39a=
364d8)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.76-2-ge48d39a364d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.76-2-ge48d39a364d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e48d39a364d8ac58fcdd272b89b05eb75ae806ea =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/635e7f904a63f8b2e1e7db6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
2-ge48d39a364d8/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
2-ge48d39a364d8/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e7f904a63f8b2e1e7d=
b6b
        new failure (last pass: v5.15.75-78-g222e1260d168) =

 =20
