Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9294729EEED
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgJ2O5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgJ2O5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 10:57:24 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EDDC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:57:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r186so2566099pgr.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fgcGnqbsKJDncXNQGiLF8zGlekA9rqnjeyDKPHYEPVw=;
        b=Ai+CgOoBogA8yOD0ezIYROtCxrwI/xxqV1JlhZtJ1y4TWp7J8mmnDzEFy+uth3l5E2
         Zqr2wPfwA8/SqCskzfhUzjExABTGw1Si4eFqlTHkTBp03dbnge3oD5WBr6CJVBN6ai7H
         8bxRfSyg4KTEbG9QZUzQpxgaJwsLXZNV2YpqmAqRS/b21ihh42qKSW+zRqHz5gYCTSY4
         tFCf6wI2pGU7km3Dwn14IzPVU5sGdQm1+MCKWyLxYS433DNVaANexhQ0+JAnPOAm4RGD
         Ii1xm+NFqisrFpRMx1FBUjqct/XF2XpDb7MBSJWJ3uZQ3oT3TfHmnCWMtnTVdVlgWEMz
         w/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fgcGnqbsKJDncXNQGiLF8zGlekA9rqnjeyDKPHYEPVw=;
        b=Cw07C/TczjMSDaeNoI9OAVCsG6q6WKClL0RgQOZBeVgcfhOqBKiPBffFOuSwe6yN3R
         vKy6IeVxF9fsk1GwGWWEZvo7ehCTp9xxz/dXpqn2USSWEOvhBOGotURlyrxvnDOsHT/3
         kjHbGxGWRLHtrr5DkJSF8g19vAt/cJA0jhMrDTUd+/xEwoLidSNNRB7aIZVZ0Z2gGDTH
         KSn/HtU9P8OV9ZwThsMfA0XjnkcyH9JQgrm06elGFMbNQMfvAhYbnE2uetNTuTHOHqZ2
         wk6xJh2kNRPrDA/WuZUUdkdEi56Rtmqmy6Xz85jK61eqzmicmbi3FmFP05btr3gE/rK2
         ToWw==
X-Gm-Message-State: AOAM532ZHvAPeu76AqtWEe2s0TDwBg8gOTLe+qBEQYotqnRMevHk+30S
        2mmj0BOpb9aA5G6k75TcsWUlglxSHL05fA==
X-Google-Smtp-Source: ABdhPJx0+loBGk7AFAFeDJnXec371kByLo/+rE8zjPYwMq0n8EU1hUH1KyUQsFl96AGT93WdOTlZ7w==
X-Received: by 2002:a63:6d4e:: with SMTP id i75mr1908192pgc.305.1603983443832;
        Thu, 29 Oct 2020 07:57:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm76602pjr.51.2020.10.29.07.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:57:23 -0700 (PDT)
Message-ID: <5f9ad853.1c69fb81.6555f.0235@mx.google.com>
Date:   Thu, 29 Oct 2020 07:57:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 207 runs, 1 regressions (v5.4.73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 207 runs, 1 regressions (v5.4.73)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.73/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bde3f94035b0e5a724853544d65d00536e1889b2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9aa4414a95575b9238105f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.73/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.73/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9aa4414a95575b92381=
060
        failing since 133 days (last pass: v5.4.46, first fail: v5.4.47) =

 =20
