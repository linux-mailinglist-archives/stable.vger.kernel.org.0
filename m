Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28779471F40
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 03:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhLMCF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 21:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhLMCF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 21:05:26 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB135C06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 18:05:26 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f125so13313941pgc.0
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 18:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YV9PSIzQNTi7Ja6tZhtHluK+7UFLrxCQ1zJOxlaYqsE=;
        b=K+JhqBTo6uNemyPyQjkf79YpAnnYtq45krUKCAGHrAkEp9qTaIRz7a1tSzUc4XfQjU
         xDLC+4EHD3C/u5Axaqk+F66ZDDSXF2QM++elW4iVjkZz16Xsg0Iabnw0d92ehjhMr5Jk
         8nelNXSuc2hvHsIZyNa4y3EQ7MySDEIS8ZbGla1qpPuIrbe6PAd8NDUAqfdMSjIocHu5
         NJlhLO913v8gpNBMkIvg5tEJqSc8ZCVzyxSH/2c+YibMEAkc1W9u8lOUu9qUAfJNM7rQ
         875CTVumF5vn5yT1OpzSUGtOBnh27iR5sQK3TYCYtwCOtnCXtXQ8Oxx059NPx+Uz4/Gc
         u6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YV9PSIzQNTi7Ja6tZhtHluK+7UFLrxCQ1zJOxlaYqsE=;
        b=FfaO2CVV60Q6B83U5Xif6ulmxZE7RUCie8+932HIs5l1kndrvQmusWl3WdakM1Z2xy
         VSNlqEipFRAITWbt+FnEsEcI8WlpYWKxGvFlLdzB6XSrijyniVQoThPcXzuiD/jUtG4Z
         eA4V4re25HvwDQKOz8g5BmhAi9v19Paxs7223N8DyZNz9gJQtUdggRhbXfN9vSYIK2x4
         ZKf7CTVrrP18obW9ZkbGcnmY1wW+cFSN7LohJF9DkjrAy1/MfqL8DfoTsBhqatvXOuqb
         l8sNaRO6FEDqE5ZHbMB6uN5cfIVN2DGF0ITnem2wG6SaLlFe0niZ7wMNBjpNrHUJqsis
         cvmg==
X-Gm-Message-State: AOAM53322cIc4mZMV1yk/5SSpl5Wm4U8UEPIlaBL7uTxYHJ/vqhLELuC
        spguA+FgwALzxW49liho36NlpnGmwE/clw4e
X-Google-Smtp-Source: ABdhPJxTdagI+SWqhVnYk2igJlAhCoSKKU5rpcqECP6pC1KcoPCPdm1H2NJMy+ubDTZgM1sO6nNHLw==
X-Received: by 2002:aa7:8717:0:b0:4a2:967c:96b with SMTP id b23-20020aa78717000000b004a2967c096bmr30989026pfo.14.1639361126184;
        Sun, 12 Dec 2021 18:05:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm8227225pgm.23.2021.12.12.18.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 18:05:25 -0800 (PST)
Message-ID: <61b6aa65.1c69fb81.efa9a.7fa7@mx.google.com>
Date:   Sun, 12 Dec 2021 18:05:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-64-gdfb803983fdf
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 193 runs,
 2 regressions (v5.4.164-64-gdfb803983fdf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 193 runs, 2 regressions (v5.4.164-64-gdfb80=
3983fdf)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.164-64-gdfb803983fdf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.164-64-gdfb803983fdf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfb803983fdf0074c076ee3e47e8aedc864f00dd =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b670354dc2e33e90397120

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-64-gdfb803983fdf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-64-gdfb803983fdf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b670354dc2e33e90397=
121
        new failure (last pass: v5.4.163-71-g5d289daa9fc2) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b671c6862fd738133971cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-64-gdfb803983fdf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
-64-gdfb803983fdf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b671c6862fd73813397=
1ce
        new failure (last pass: v5.4.164) =

 =20
