Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083CB23F589
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 02:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHHAfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 20:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgHHAfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 20:35:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A34C061A27
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 16:59:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y6so1965139plt.3
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 16:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t0vT/q9U/u7VgfX3zzS+aeyOa5wM53DGQP0yIStjx28=;
        b=kseGnxEiQaXDbV1j4lD8vnlnldabiGOIpkEE46Bfalp2qGp+1yrcOYqgq2kiQjiLMf
         GPBfqVb7niaAGrof64jtCaRCNTWKEmw/RR7pQd4mF4YtuA3NqD/WsPDQWqf41KCZnZzc
         2Tq3z47w03KaRm6JGhcxmlfgosDlYiUy2TZrQMS1IG1qRH8tL21hLcnajZm+mmihVG9S
         o8PEaE39J7xvvZ45wq03J4VxRlmZQYVPUE1ywY7ccorF26taGQ9SD1ifkUcA4GmGj1/p
         NExaITnLj1uj7kXIAytN5Xc6in+uspYayzIyb8xEVrUJToOhp0KP4kzxE8ANpksaxnlg
         SAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t0vT/q9U/u7VgfX3zzS+aeyOa5wM53DGQP0yIStjx28=;
        b=ih22RvAEu1mF56Xq2o0n+KLX39fol/4QBQH/HscH5bVkKi3DYhexATwN2Os3Qmb2wx
         Bz2BgrvlygBMtWCZss4qtZjBwd/lRpqUcBo6KSxHMAimTiMpQS1iTTAG1nJEwVpWf74K
         bXxH8QVgjkvfaXhQtmAbtZ2NFsNObvd6gnlKyaysusXYp5T6DhOlEWdKBN1+f+BbZ9JK
         EidfnsNBCFiH1ZSZoYkZ9uy982wZkQ1Mu1GxYD+ASqE2afAOpUoHy6SbYKKz+r3v6rKE
         UknUcRKHjnD7TRcLc6a051BDCR41JxMWiDttL3V6WmPNdTXcrUgXse1suUFdqIg/hBaN
         yOKQ==
X-Gm-Message-State: AOAM5325ABKZrOjoOfuCA7qK6o1s8pBWEtqDt2XhNfnA8WbeXZLtDkI/
        iAxCUWEzTUcVbQ2zIcph3VjZC61PA7Y=
X-Google-Smtp-Source: ABdhPJyNRtipCVSXeqFkW/fq7KfDWTjNPEk7JPt72upl1zgPpaf43Hv2/YxltpQ3XmgO4DH6TpEn1w==
X-Received: by 2002:a17:902:bd84:: with SMTP id q4mr15157332pls.29.1596844791570;
        Fri, 07 Aug 2020 16:59:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm11962145pgv.1.2020.08.07.16.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 16:59:50 -0700 (PDT)
Message-ID: <5f2deaf6.1c69fb81.138cf.a21c@mx.google.com>
Date:   Fri, 07 Aug 2020 16:59:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.14
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 130 runs, 1 regressions (v5.7.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 130 runs, 1 regressions (v5.7.14)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e66893c7de2a28de0c0671d8522e6617a907571 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2db3fb352b6165f052c1bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.14/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.14/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2db3fb352b6165f052c=
1c0
      failing since 22 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =20
