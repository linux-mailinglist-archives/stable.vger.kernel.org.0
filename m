Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6736A39A48E
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFCPac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 11:30:32 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:34414 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFCPac (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 11:30:32 -0400
Received: by mail-pj1-f52.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso3547296pjx.1
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 08:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pFpDvuvgzIVhxZ0616D09iKuiI8AEMZ4rBtIQrgbnPc=;
        b=kmZHPvIbp6IJotbX8wjl4BI7QoyVT7VhDhJUHFRKLL5PmxIxJGBpYGX6ZkxEnDgYjR
         kLvfuiQpWdhGAnbNwvMfQtZsMXthUyeOjj22q3oRhn85OXWIlaFFoGRXACNEgktOykPU
         5INMHq85Rx+CNIMRgizfhp/M+KKPhYqG/NAVarx+jh1EXhDBDUkK/XQdaICBKqMQeB54
         hyKCVTdi2tMhT9iimcxsRdM/J+PMO+ogvmRvXiCg4Ki6WNPxVDX2KE3qeOO4nKxmENCZ
         zsgsWmc+Q3FPJLDCg2NsMkDQkWrk+13GFt+u9Tt+2dRqG2/qGZ/Szh11gT1/3WfEimbO
         UhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pFpDvuvgzIVhxZ0616D09iKuiI8AEMZ4rBtIQrgbnPc=;
        b=AhLQKUXUPTt95Tuj0J3LLYhgYqO47OBTOqT89D+RnjqxP/yo/x1LwAfxWvICUfKznk
         dw/Zksd7PHBFL8TqEwMdvwQMiS3UWlD0MeHgF1NxwXl4kKgA3T+Iio1AXEpgFNvBNlNH
         DITTQOQrenTNmyzY5mMqHULMCcWmuhATYh+sY8ohTU7CqRn9+JgkN2bM66hdmIF2+g0a
         SMid2mXlG1D0XaxrEr/SXSMnsrIRfLtifxsDsEKBaXUME4V44UU1ub6KoYwSSknp2oz/
         OxuWqcnjmzf5iGDpjAlTQmSKLogbY1zPIacLSMC7KRvTlE48fXPnH33nXS9p5XOr3Onr
         HVNw==
X-Gm-Message-State: AOAM5307uepITUeuhTCFhPvAWp55OqG0/3/O6KgQ9tkPHLQxlln5qJ2L
        0Ongu102FN/5f15NamFO6YqWltsPqVQI0g==
X-Google-Smtp-Source: ABdhPJycZp9qT2wFI4RUDkKsBk+Z2ZV7mYwsboGx3tVJy+9jzSq1Dd7noR6IPRgNKWC78Uk4czDByw==
X-Received: by 2002:a17:902:8505:b029:ec:b451:71cd with SMTP id bj5-20020a1709028505b02900ecb45171cdmr232508plb.23.1622734067493;
        Thu, 03 Jun 2021 08:27:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w27sm2762943pfq.117.2021.06.03.08.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:27:47 -0700 (PDT)
Message-ID: <60b8f4f3.1c69fb81.a1084.88f4@mx.google.com>
Date:   Thu, 03 Jun 2021 08:27:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.123-176-gd4db92620f28
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 165 runs,
 1 regressions (v5.4.123-176-gd4db92620f28)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 165 runs, 1 regressions (v5.4.123-176-gd4db92=
620f28)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.123-176-gd4db92620f28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.123-176-gd4db92620f28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4db92620f2864e72fe6e9d014027b36be6faa04 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60b8bf3fa526d6b8d7b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.123-1=
76-gd4db92620f28/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.123-1=
76-gd4db92620f28/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8bf3fa526d6b8d7b3a=
fa1
        new failure (last pass: v5.4.122-184-gdbef2d102743) =

 =20
