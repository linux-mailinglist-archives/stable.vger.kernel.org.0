Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7141542CCC8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 23:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJMV2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhJMV2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 17:28:06 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC83C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 14:26:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m14so3608263pfc.9
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 14:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qxdhrHxo53Wa07NJR1mgOWX8iHe0kkOLg89N7VOkZ8M=;
        b=6v+gutgHBYOebkYw8IaIpHoeOj/P1Myc/MTKncwPRqhs8S0cUXUPxre552nyluaM5N
         9opNubv4ITZEQr4If9OiFepXtqXpIk+9RBnDUwzdy4bUGUlTXfDczZUFAgBhxOVpJs/2
         0mceRkOkR1exWtw0/AxloHZtJiSUZkz8ugPB71NE2m5XljGkbWFsdaN7s/e4HlSnnZjD
         PLcr9Jqpg5C+m78w57NRalTIF5aswpT3pU9JE1QFwNwI9rjH9mzEXzG5HVSpX1mxlWH/
         PXElcMWdTvzuvpyeZyOl7gN2zgUWcsmEPB2tz0Yn9tNKLa1TEsUq2j5VjezeA4taCH+z
         OhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qxdhrHxo53Wa07NJR1mgOWX8iHe0kkOLg89N7VOkZ8M=;
        b=OaKdb2iIatkD+RHBATBwNINAwAIvlnDwzoLYcwu/UjJkSjZ2eIdyB3pKc1O+oBwv2p
         L4yTMXYtKBvXYUhPfRIbymLv92O14LJz6BAV8+vhlAQdrWEPXtFPXMPe8CuZFzYrtwt4
         dxX7vxvKKp4jMyzY8+voTioD91ypojQ44//ENXkkRSP8UHgxGMiJQMxTNplA9Jq6OAb6
         CXEn1lxMgHwfRH/nszZEKmNTnJXu/QQeIPJOJKkKqP+b6ggU8ysuOdAq3kaQSseCTLG9
         cw20nPH7PFC5OSUoHo3/zJFPtBMOBtigHlUNBRoZSRwO4GCFdrXf5wY65As5sqt5PeR2
         mu6g==
X-Gm-Message-State: AOAM5305FxP4WTAWa8SrVvogFWJmKEK+o8/K0g/13iRgsu7tA8K8OoOX
        NtAlbv23O4A3ADF2REsWjQYZmK5pqJUsA0OHIqE=
X-Google-Smtp-Source: ABdhPJwZLDqZ3eF7V0irBK/Yz5aaluLXlMc3XmSsW3+9ZoEPLFapSD5Wt6UFgQC6vNX+KMsqQ2fP0Q==
X-Received: by 2002:a65:6aa3:: with SMTP id x3mr1208447pgu.253.1634160361971;
        Wed, 13 Oct 2021 14:26:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22sm396507pfg.61.2021.10.13.14.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 14:26:01 -0700 (PDT)
Message-ID: <61674ee9.1c69fb81.c101d.1c70@mx.google.com>
Date:   Wed, 13 Oct 2021 14:26:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.73
Subject: stable/linux-5.10.y baseline: 67 runs, 1 regressions (v5.10.73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 67 runs, 1 regressions (v5.10.73)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.73/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0268aa579b1f741b12300bc7f084ffe990cfde5f =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61671c327af37355ab08fab2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.73/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.73/a=
rm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61671c327af37355ab08f=
ab3
        new failure (last pass: v5.10.72) =

 =20
