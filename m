Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8824DA3B6
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 21:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351510AbiCOUJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 16:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiCOUJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 16:09:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AA9BBA
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:07:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4so426890pjh.2
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j6aNDfN+KOPesZWLZLGe9QZXLQldnFWbOSh5X4OcBFs=;
        b=J0KTDgr9byOwKv8h4NZ0cIo8npL8zukQgWXlon1NvgNCHuWC5MU2hqbpW4clBmDRNl
         L9g4rdVFCQI2ox3fTJ/hBpqsHyRaRrvGM7WeDsuKeFx2j5bLwGDqRMSqBIL4s4SngbJj
         Yxs2O1iVZumFCD6NhLPeFIpY+BQjvuUUcRK5L/shJkTrTpLQRe/Cu4Xb47dDm9BhbtdG
         ZR6u1paXcLRHgjx1qDWs3+taO0sNmY6zI+/J4KOEMkFPwHWYN4loNAu04vVkukYqEjZ3
         5lHPZ5d2/mFmahMNqwzOvAif/ylOaui+mJhbol/O/ZiJQWS8QX7eE9S+i56zLlS5EaEh
         MIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j6aNDfN+KOPesZWLZLGe9QZXLQldnFWbOSh5X4OcBFs=;
        b=uLF/JUPh5ZmRY+NBfK0emfZ5nYJ7aLgHjdE3tMmNTq9UYBcKCWzhlu8EnOftpKA7Im
         tHf1o/389fdijd+iYdsR7IC/tWtfPLuHfxWJJcax2SaIFiYbnsQnF1AmNFvjxistTbQs
         vtL0dPa/S1rqQ5LZdHUFWnEIIWcMIjLWi94qBFUGrwxhINB4QIe/PIG9E06Rzmwn6P4W
         VqcZWmbzSoUKT0G2/GrIxvu9Zgb4SYwYZG2VvkxOmp2mj7/jRfHw4CP38wcP5x+e0ssm
         6ymzDFw1StXkFc94OAf+CULHfYQQzcXVYYBY4xrIkWcAFkYTxuFWhuofopBHFEQQ/HkK
         lBqg==
X-Gm-Message-State: AOAM532FMjNFcxCvAPUIOe6kOUiQZAy43aeZrFFoBb3TBMiN4YNtvahW
        XNFm1Xw6pDUMvS//qMQx7vFQmUbRWDtd19Hmf/M=
X-Google-Smtp-Source: ABdhPJxoYWUhf+1R2beFK/zLjVRowan8fATNa6qZz/4gNc0hDnYaMDEkdryZOiD23SzvWq06grUfSA==
X-Received: by 2002:a17:902:db0b:b0:151:fa8c:d6cd with SMTP id m11-20020a170902db0b00b00151fa8cd6cdmr30000261plx.147.1647374867618;
        Tue, 15 Mar 2022 13:07:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o7-20020a056a00214700b004c169d45699sm25022903pfk.184.2022.03.15.13.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 13:07:47 -0700 (PDT)
Message-ID: <6230f213.1c69fb81.fea7.fd6b@mx.google.com>
Date:   Tue, 15 Mar 2022 13:07:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.271-22-g242724a52a3e
Subject: stable-rc/queue/4.14 baseline: 66 runs,
 1 regressions (v4.14.271-22-g242724a52a3e)
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

stable-rc/queue/4.14 baseline: 66 runs, 1 regressions (v4.14.271-22-g242724=
a52a3e)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.271-22-g242724a52a3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.271-22-g242724a52a3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      242724a52a3e2f5a0b871c01b813308ceae302ef =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6230b9c26518566e49c6297f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-g242724a52a3e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-g242724a52a3e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6230b9c26518566e49c62=
980
        failing since 30 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
