Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9DD49A9F5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323879AbiAYD3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3409735AbiAYA1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:27:17 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE453C046E02
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:09:24 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 133so16642307pgb.0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DwFbIsdlufg/866v7ofBj5lggIXATYauANYwRUudiEI=;
        b=pkzpM/KzI0C5Z1jWVloqFoJ594THqltPX3D6OO+NbjrjMJ3CVH3FnGvd2c8kyp9VLm
         rD577+TD7WLlH3q05D1aQb68YhfX/scrlkl0c5VokjmWN54TkQ8Zhei8kVR8RTg2e2Fm
         93sg1cvr3Bk9loIz8duR6yNuZyOgYVbzIzj002hwRaZbiRnRdSwCWIw1M1yZZ/3JozmI
         QQ6T94uV1Gtc+u+83lx8wu0BcK55s7byUpwohDHPR6/Q65ddBUQEgW85BotYCv7tLc9t
         2kqg4yA4Rj9O5D6xfn0SsatTA5tfLqB9qLgAlzExEZSajhdS5ZkE2VZFhM5No5Cl70Uz
         V0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DwFbIsdlufg/866v7ofBj5lggIXATYauANYwRUudiEI=;
        b=7EABmwhzWEKjIJPrpsX5tQ4EJfEtLeI2EAjql54171PqGQKGPeDCVmgAWkeTwh0KKt
         E7w6K7ia7DE8VgDgSytr9rFIjuYfnWdzB0Dwobax85/XauBcZ9/pdfKplo3/A6bdiFqi
         NEepZQDbCwaFyBKCiB/lkwoUM1VGmP++Ndi1W/vuG6oNW+EVSrsX3qOx54yK+U92mClT
         YMhkZTuivpiLWhYX5+Zeubj5+kRT5lkQBX8cuqovv4fJAh8OL+4RZ9ndjdgcnFjrIWa2
         fujsNgjgMXm2wq2lJBsfR8/7Skw9VWmHPZgxzdC/VtSITtIqQx2X7nQ5IfG3qpvSLCUu
         vZAQ==
X-Gm-Message-State: AOAM531gMGqbN0CTq30An7WmbCNhcHkFXBv5QyXL9rrh4fTXdAf844Kf
        7hJdsf5ID8d76APpxBuLrNDjh/VqfDEAxwjG
X-Google-Smtp-Source: ABdhPJw5prPNz41dOLHuSXE3VDhKRZuPo9Iai0FTQDcGS7BtYjst9SuUL3bg9karBsoOOSxQjqzLCA==
X-Received: by 2002:a63:7f12:: with SMTP id a18mr4279269pgd.453.1643062164177;
        Mon, 24 Jan 2022 14:09:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x25sm16740265pfu.91.2022.01.24.14.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 14:09:23 -0800 (PST)
Message-ID: <61ef2393.1c69fb81.da6f2.f6f6@mx.google.com>
Date:   Mon, 24 Jan 2022 14:09:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1040-g92d36370370e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 59 runs,
 1 regressions (v5.16.2-1040-g92d36370370e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 59 runs, 1 regressions (v5.16.2-1040-g92d363=
70370e)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-1040-g92d36370370e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-1040-g92d36370370e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92d36370370e96206925d6c7f716fc58330eafa7 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61eeef57d661b40299abbd3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
040-g92d36370370e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
040-g92d36370370e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eeef57d661b40299abb=
d3d
        failing since 1 day (last pass: v5.16-66-ge6abef275919, first fail:=
 v5.16.2-847-g4e4ea5113e47) =

 =20
