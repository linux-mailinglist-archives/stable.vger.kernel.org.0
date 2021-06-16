Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F1F3AA144
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhFPQ37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhFPQ37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 12:29:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3BC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:27:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a127so2602462pfa.10
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tJDaU2OJiOTOPnVywSgY471KMdJTNcuojf7M2LmdfsI=;
        b=lDMm9E8UPxOfpvAIwR49UO0wfedj/9AY1saukWA9r/WTEcCmMM0YhdYGbPFdytW9x+
         3suo0xEWNceS+Ec629h7fTN4/LjI0BqONYt/V40mTtD1B6ABktfkUzz5Q4B/2iTvhFWN
         F3xljcji0wvka0PsWw3Ct9YlWW4su3sEKhWbxlEZtXo8b3V0S3Po0DQRLWEO3vgDeDjX
         A92ZDwlGPACrmIEL/7kJsaZ45tF5DlTnPPy4M1tw9qFAxkG7LPuC5DCStNI8QhBEvjYK
         Sszq8088b+iUwg69oztrAhIVxwbMG0th9DYK5rOsAfiWMVcEUH09ih/AXr+4DdLafXES
         kY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tJDaU2OJiOTOPnVywSgY471KMdJTNcuojf7M2LmdfsI=;
        b=Xdekp5RfGTXdHk9y1Pv39+FhMiQtTB9GLZtYFxaL/mbMyDMQrBY5Q3AIGVVqo0sa21
         +0TjXiQXhL0ALyBASYzqpj40HIEhoRrXZRZ5pgTEqol4t4TPg1AcUQKBBgV2OreTDBhF
         ZHNiLq+Q8Ko1hODeLitT6kPmL+AVuvU3QIaQ8Q/ssWp/6/6fCNlbn9eNZSmhGINelRia
         vvrDuISVr5xYlabzIZmk/qr7J8SrRUMq68AQUyUsF3qxppI8vlD4kIuawYeEnj8YAc+x
         ayF83uv/PHFs4lfFKTSAZi2VoJLbt+uUrYgd10v1EwDRdQm5hCP90vEgf/1NbETO9mbZ
         ibmw==
X-Gm-Message-State: AOAM533Gllpv+phwuYalDZ2eHzKH/Ka29D3q5jS5ZJouJHKJ9YEiG3OL
        RbB4UI+HpmfQaIRgJWg8DwxCwR2ZBHUyM8Ey
X-Google-Smtp-Source: ABdhPJwxB4HxvtGRxZHgOJ89tu6eYvwi20x2cU0Apq4oZ+lef9WU+6UYa3z0SMZpttDQ/SWcVDqqRQ==
X-Received: by 2002:a63:1a4f:: with SMTP id a15mr368071pgm.313.1623860871677;
        Wed, 16 Jun 2021 09:27:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9sm2544638pjy.25.2021.06.16.09.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 09:27:51 -0700 (PDT)
Message-ID: <60ca2687.1c69fb81.55c7f.6d13@mx.google.com>
Date:   Wed, 16 Jun 2021 09:27:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-17-gbbcb93d5f8ac
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 105 runs,
 1 regressions (v4.14.237-17-gbbcb93d5f8ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 105 runs, 1 regressions (v4.14.237-17-gbbcb9=
3d5f8ac)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-17-gbbcb93d5f8ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-17-gbbcb93d5f8ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbcb93d5f8ac50ab60b67f354393bbf983819ff0 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fa1e5072f4b81441326d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-17-gbbcb93d5f8ac/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-17-gbbcb93d5f8ac/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9fa1e5072f4b814413=
26e
        failing since 107 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
