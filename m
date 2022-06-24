Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1655A1E2
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiFXTbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 15:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXTbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 15:31:47 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205B18173A
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 12:31:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 9so3273157pgd.7
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 12:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hWMtqRWSnsiscaSGwNFFgwQOprHHz23mQoo/rmoYQUg=;
        b=B9dhu5tfmskYTeZZgMOWROprzX72vVxsdecSVyZKNs2nLUjzCFAtnAdH7SRET9VuJP
         MvP/n/rpnXkxC7bMqXIuDDkigUjKYEXwa0Hu0cq71lYbSaz8sN5finlr3cu4hRePqsC/
         gD5W70P3si9vK9OgmPEaerBZKRxeD17Jj0rueqW5nci7ZL4SnBzQWod4M54dRLH/7L7V
         i/d2lKUmgAvkfuQkUKoa12gMSf1Py9Z8fv3E2RP2diPnwqUJR892AqaMkJI4OAVPFAkZ
         LtmU2KQD5aLadFSmtH0+QeTAsH9F12WWAOwCuK2zkERpl8Q4dHWW35rz0EMm0XQzpiyR
         sbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hWMtqRWSnsiscaSGwNFFgwQOprHHz23mQoo/rmoYQUg=;
        b=GOvqdPwHMFrp8eeenVZ3DOaK6neQddGwtd2pS6SejJYx4q7P+lo9IOXJcpdM1Wl0P8
         YZf6WyECdXHMo/FHZHqwUNBF6kn88lrnkqmgB4hIJiJ3vETVNJ5O66uFfDG+wxTNAEd3
         JXvXk4uoXAlJC0D+tPDYUNYF6pGGOl+VU1hMsg2dkxaPAggJyOmoWKvHvX2P6yfRhZ2t
         OU55B3ElHjcm09xwMQ7B0C4uhud982XvLN9/UXOm0+hsJraMNvpHibyWzyi/efzxdm90
         w0uNTFeYqGt2ZvRbbeD4XTKiCC5djR0it8YJK357e3sclAmY5UWyf80GlGk1OoTx3N8q
         Pp9Q==
X-Gm-Message-State: AJIora+H39hVwcxHYZmCSV2Lyhs97CHABGNQiuUlqr3yEZ1DiQrGYVH/
        l1TsVfCTFraii/NHzwSUmRvJfXrRMNTgGZ+N
X-Google-Smtp-Source: AGRyM1trhHSxTO+oBjMqUFAdWesLj8cDcMB5RXFjQaOwwG5Csp7C2yZXO37GAjey6PZQxQdMb8nfOA==
X-Received: by 2002:aa7:838c:0:b0:525:3816:2340 with SMTP id u12-20020aa7838c000000b0052538162340mr690488pfm.35.1656099105453;
        Fri, 24 Jun 2022 12:31:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bo7-20020a056a000e8700b0052515a79b78sm2067019pfb.189.2022.06.24.12.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 12:31:44 -0700 (PDT)
Message-ID: <62b61120.1c69fb81.4674a.315d@mx.google.com>
Date:   Fri, 24 Jun 2022 12:31:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.6
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 192 runs, 1 regressions (v5.18.6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.18.y baseline: 192 runs, 1 regressions (v5.18.6)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.6/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5f112b51a0a0a929874234f967b91f83689c4edb =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62b5dc88002030fc2ba39fb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.6/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.6/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b5dc88002030fc2ba39=
fb4
        failing since 18 days (last pass: v5.18.1, first fail: v5.18.2) =

 =20
