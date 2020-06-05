Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B881F02A6
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 23:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgFEVvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 17:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgFEVvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 17:51:48 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC37C08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 14:51:48 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 64so5560108pfg.8
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 14:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PhUiBXs4Jg46ffbVDYGsSLSQ3NC1B5dzltk7+2GYTWQ=;
        b=cM+dmnGBX3gCM8enBVk/A5FmIXemzECMC7+eeDp56ytUINOHwK/H0lZ7cQ/jvo9L6j
         WOyBONVKuzJy5eEiBk0NRGVmav1CbEUgYWCalurax+GLieb1WEl80L2ZMcs1taWao65Y
         rVfAw+nJXSeTTlEBKdB7PrHkYiWyxp1tZjnqVPtLhk4z7h5xRGdescJC45aOfLtLoT0A
         dtgjVNHOVedoRmXB9LZCr2/pS9HTf5EhsAwIlvb+uctTbaCb/jhWGws3WsCF6fcZakri
         CMYM+DqKgGnZgcYffrrb2BHjSGYkK5n5rISUatYAEKL0LgHd9tf5xuFcN8nsz2ZDZfvl
         cJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PhUiBXs4Jg46ffbVDYGsSLSQ3NC1B5dzltk7+2GYTWQ=;
        b=Q9J64BZpyR17v1F97yNFPqsNZwoDQ4pgLLWlnCOWWCMH84rqjRPq0rHdZL/WIRUTcl
         eBjfOJjy0GuopVVrDVQ+JURihaJBhNsnooeYCnvWxrCbuzGf+2ZrFyq8sP1jgcjziOtP
         Jugf0XziaDeYHhbDRfGZuJq/x+tuZ6QnlrlhTLvxtdUwKgw9i95Cb7g8lLKag1qYqsXT
         zSMeeTxDfP0zEF4w3rDSARAmFwjJcpffpME6dKP6jN2Bk1LEBHXAfplr3aRn5Hxotyax
         h4seyJbP8ufQCE/3YFGAfo/v+NgLDgNLrn++MHgYny/oiLmRM/cKcT+DNMH68XLuSg3k
         jN0Q==
X-Gm-Message-State: AOAM532WFPnIPrYZkcJYe4THiN8ORl5bcfpdpRggljj4gRpvDHZDLf2o
        GTjL31p4/agVLZ4QFVHu/EjBPRGS4aw=
X-Google-Smtp-Source: ABdhPJyiW08X932VvhHOrRdwDvTH8gd2KO9DeY1MFuWh8RT0GpS0bqLdZhkp2irrRPfg5R+C8Hd2yQ==
X-Received: by 2002:a63:4b55:: with SMTP id k21mr11560357pgl.46.1591393907153;
        Fri, 05 Jun 2020 14:51:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y18sm490252pfn.177.2020.06.05.14.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 14:51:46 -0700 (PDT)
Message-ID: <5edabe72.1c69fb81.dd065.69cf@mx.google.com>
Date:   Fri, 05 Jun 2020 14:51:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-23-g6b882ea9cfe0
Subject: stable-rc/linux-4.14.y baseline: 53 runs,
 2 regressions (v4.14.183-23-g6b882ea9cfe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 53 runs, 2 regressions (v4.14.183-23-g6b88=
2ea9cfe0)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =

omap4-panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-23-g6b882ea9cfe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-23-g6b882ea9cfe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b882ea9cfe08d7ce31a834c3a2ef839e3f3094c =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5eda8c54b896a860da97bf10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-23-g6b882ea9cfe0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-23-g6b882ea9cfe0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eda8c54b896a860da97b=
f11
      failing since 66 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
omap4-panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:     https://kernelci.org/test/plan/id/5eda8d5608aae4c86a97bf1b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-23-g6b882ea9cfe0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-23-g6b882ea9cfe0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5eda8d5608aae4c=
86a97bf20
      new failure (last pass: v4.14.182-77-ge64996742439)
      2 lines =20
