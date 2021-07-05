Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2FC3BC37E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhGEVAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 17:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhGEVAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 17:00:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36181C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 13:57:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e17so1530315plh.8
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 13:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dWdaWa+X33R5sIGcA3SN0n3g01fy6uVZK5bowonxdq4=;
        b=hs/NY/sXxPG02i9EgcfuNabEaSAKE5dpxWgLa3gNum62Luv8hwRsV7H0ZJi9Xyms4w
         bv4k92yYJsPHq8kDoaW6yvO6862RLrAxcvWIJNwTYmx+uO1r644iFHfjx9Fj5XC/IoVb
         sIQ6SztOGdCdHGPJkXpbngTZDCVQGVTgkL5L0vCxNitqM8FqlM5+MjMD7+w+24ykf2mJ
         juCVZ+dOSCUES4bMu8qJeonpNHAgTGep8nwej1VGqNJx5nkGI+8bmdui4dOwYUdzKPQH
         7VRmD5t+y/2ntek82EW5WwsZ76dDr8mE3OWMrgDpjyCEPFDw4R+3RCyx1ghvu1TCdWxA
         S26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dWdaWa+X33R5sIGcA3SN0n3g01fy6uVZK5bowonxdq4=;
        b=JU6B1aEDFaLMQKzSB7K422JjGXqhNwkmMd0bkUnbYqtLZbJq4jMQ0r+tGyZkVQSedV
         +D//crMOPY3vwJR645SVZ+bOLiTuhO86lZ4Zk1nad3rHK07abyOHITrEBLGElUhnva5h
         gFvbA6enq8fxFTlpVzt36jAFS/a5rqwwNcA3YB3gOxCveNnIVNu0btJzLgMNSG+Znw6J
         zM/w150PAhw59UjNHrsq8QdTtlXOgh5FH3BJCAJZsYExptIztZDNL1qw7WSpombheE38
         Eh7zPamtbOEOWwoybCadp3JIlw3jEgRm9wRHHKaQhS02lgIKxy/SfYrDu1Ll06Y5Pobe
         pFpQ==
X-Gm-Message-State: AOAM531VeiaHapuQePKa+4nomRhAul2OEf8hKiVpNclm1ZhQNsy8ZvrL
        MHCO2aFlBfTPAUrQ2R3w7dFLrDCzNuL4c5Fm
X-Google-Smtp-Source: ABdhPJzVF/OD/0efnpqHSm+AqI3l1HdAki6G/5JA9WvQwZsIKNsKN/ir8Dc18MbMYElNO6DPfPJQdA==
X-Received: by 2002:a17:902:267:b029:129:6928:7e56 with SMTP id 94-20020a1709020267b029012969287e56mr11707259plc.77.1625518665669;
        Mon, 05 Jul 2021 13:57:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ep10sm345559pjb.41.2021.07.05.13.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:57:45 -0700 (PDT)
Message-ID: <60e37249.1c69fb81.dc93e.1d45@mx.google.com>
Date:   Mon, 05 Jul 2021 13:57:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.47-7-gdd50b7327ff6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 164 runs,
 1 regressions (v5.10.47-7-gdd50b7327ff6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 164 runs, 1 regressions (v5.10.47-7-gdd50b=
7327ff6)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.47-7-gdd50b7327ff6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.47-7-gdd50b7327ff6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd50b7327ff62c603651aef64089569dd293b34d =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e34f7399ebc179cf117982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gdd50b7327ff6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gdd50b7327ff6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e34f7399ebc179cf117=
983
        failing since 4 days (last pass: v5.10.46-101-ga41d5119dc1e, first =
fail: v5.10.47) =

 =20
