Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD835FD96
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 00:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhDNWME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 18:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhDNWMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 18:12:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6F9C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 15:11:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id p12so15443737pgj.10
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 15:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZZmo9XMke7AF1XQ0553PH5xdT0iD3FHUk0Dhm6A6Wv4=;
        b=iU1WTRWgSKjLdB/6W28IwD+dajvw/zk6q2OYOe8QrCuxPZeB1P2XqDqkmdjWBGgn7n
         qx9UKwsjX4xGprDVg3tvXu+7HQbH+rR+O/kbV+D0v+HfYKWWOVDmR1MnSwfPnAxQ2K72
         ZLuTitp5AnG1DIfvOh1w+ednbElNm6kMB5pAl3cNkixzkJF/XheKCxGlGbNXHw34dWm3
         Vf75x6F636PlS6Y2UDQ/UsVF99C49F7r9YsPtiMaeCqTwpL+lgM8J/0AtEOBgfUzZG6p
         iTW8hpY1E27tbHZE/14Ok54RP0vkSJg7YuDGK+nMj7Rh+ta3QfikmemWlKLLoAhUOkN+
         2KFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZZmo9XMke7AF1XQ0553PH5xdT0iD3FHUk0Dhm6A6Wv4=;
        b=AQrgWe424TOcw1QOtAWtOT6DiBrrUQEmg2f6Nkg/qnNxSgo4oBQ8VC2Fuyn5sYio+5
         3jUCPwoilpRse3N8B0ucVrbn0Ap83Y/RR6eK4cm8BneCQ9tgQj0FCPtXbLl6BG3g/Vc7
         mSpQXjQKWHP2HwbJOwrYjbU5mtsnnkFf7JYuMg7zj95T7DlNwFNR22lLw7wfoBzXvZo9
         Frj6D+rekzxbTEc2FpId7PX66VOrpH9SdxXxruDaDBMzC+ietsufnKBYBqZc/ZXbhMAf
         dyiOYe5pMM8QTC72wogYAPpSZ9vZelFgrgZ5WyeQjfMWmI5sRZiN8CrET0yjDiMG9GtW
         lEhA==
X-Gm-Message-State: AOAM530EKupF6vXtyXp59mZe9SClmMkO5lkbq767vjS7ixSyHLzmsDET
        dLoe0IDPzkuNFtkIr4CDwedzhRO3o685QMj3
X-Google-Smtp-Source: ABdhPJxk/Wvt6julWCbXFWo12MCOEsVoVef1//PBQuZSuCGWqgt1KmfF2eekIvYeD1MvqkEmq5/Csg==
X-Received: by 2002:a62:1949:0:b029:241:be9d:c708 with SMTP id 70-20020a6219490000b0290241be9dc708mr200444pfz.37.1618438299051;
        Wed, 14 Apr 2021 15:11:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y194sm350699pfb.90.2021.04.14.15.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 15:11:38 -0700 (PDT)
Message-ID: <6077689a.1c69fb81.ea017.1af9@mx.google.com>
Date:   Wed, 14 Apr 2021 15:11:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112-12-ged8d92bd8985
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 101 runs,
 1 regressions (v5.4.112-12-ged8d92bd8985)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 101 runs, 1 regressions (v5.4.112-12-ged8d92b=
d8985)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig | re=
gressions
----------------------+-------+-----------------+----------+-----------+---=
---------
imx8mq-zii-ultra-zest | arm64 | lab-pengutronix | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.112-12-ged8d92bd8985/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.112-12-ged8d92bd8985
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed8d92bd8985daab8dff766f312a2e761bdf3294 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig | re=
gressions
----------------------+-------+-----------------+----------+-----------+---=
---------
imx8mq-zii-ultra-zest | arm64 | lab-pengutronix | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60773039bad2794036dac6d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
2-ged8d92bd8985/arm64/defconfig/gcc-8/lab-pengutronix/baseline-imx8mq-zii-u=
ltra-zest.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
2-ged8d92bd8985/arm64/defconfig/gcc-8/lab-pengutronix/baseline-imx8mq-zii-u=
ltra-zest.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60773039bad2794036dac=
6d9
        new failure (last pass: v5.4.101-336-g73aac2336083f) =

 =20
