Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B828846F6F6
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhLIWiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhLIWiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 17:38:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BCBC061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 14:34:50 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8050848pjc.4
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 14:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=udJ3iN2RNld1+JG31o8gpMVqD8nMtj20b0bzDXAUpMo=;
        b=JBni91A2YD9iaD52hlWZy0adfDJuCO6YxwaRexM6/um13uFTQjYHCn6J2RNYPRlG3f
         Od6kk1QgiF6TgtIObK/ay4ujUEZWIfn8Mejahc6/xS24xM8BERq3BwQ4J/23K/cf4+qa
         TlT/WesbTi73cDYvCeHKzF55Hiu2UDA03x43Q0aCpqzGO8k3jwnAgPCKYwp+T0dCesXJ
         liK6LUXgrr8Tx3VwIxUafnRpms2hhi6YIXNRYD2HUIAnIFhRODURQlPy5MwO0dBGnGUt
         qCiq9/BkG9d9xtzwQOD066vlz5tFoi1kK7i8LE0IaPmDH00lwgAPvwcKE9l1Icq6JhRS
         B9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=udJ3iN2RNld1+JG31o8gpMVqD8nMtj20b0bzDXAUpMo=;
        b=Z7QWJMIJt+eFmFjJ5winoSyfDic+bCFcOoeoFbkaXaII643s3ZgMZLJJqZuVDy09cS
         2RaSO+az+10GFyiUFdsGoNZ5WafTxtRADxZyhIzfhmLYDMDCVP/Xj7I+RWDVqTUKV42/
         O4Gp66N7KPfdW1ud6M2SMOGAiUf5AkbW8Clj7lpYq3stqYMupKtDtqLegYbDhLaHOaXi
         SteyGGsUb8q3TaLrXBTbAIN1vM6FzXsneZKGcaXmERuyn8sT3aLaireH1pqzKO4dN554
         1QqCwVabzxmeM3rbWPMhudiXDLWwhn2a0gRUNaDV/lJ0KXedZHb0jI9e1E3dvQoF3jtl
         V0Rg==
X-Gm-Message-State: AOAM5312jLNcefRRA27Ql4Q8+SXdBuraEOnzpprNexl1MnA5K25+mLGJ
        zeGek1CLGgfTj/YjFjghQSSbg+1UjYp2jyDgU3w=
X-Google-Smtp-Source: ABdhPJy8nU2lLh9fv+HghLkS4RVWQc0XHr6g3Ou6usihDBcbgjcU6SX6Tp3N+IQJdfZXgSP6zdOxmw==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr18820195pju.77.1639089290116;
        Thu, 09 Dec 2021 14:34:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g189sm600520pgc.3.2021.12.09.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:34:49 -0800 (PST)
Message-ID: <61b28489.1c69fb81.8a468.28bc@mx.google.com>
Date:   Thu, 09 Dec 2021 14:34:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.163-73-gf01a13d9c502
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 220 runs,
 1 regressions (v5.4.163-73-gf01a13d9c502)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 220 runs, 1 regressions (v5.4.163-73-gf01a13d=
9c502)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.163-73-gf01a13d9c502/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.163-73-gf01a13d9c502
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f01a13d9c50219bcfa6fff97eca67839d473bc26 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b24a5f6270d6431e397144

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.163-7=
3-gf01a13d9c502/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.163-7=
3-gf01a13d9c502/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b24a5f6270d6431e397=
145
        new failure (last pass: v5.4.163-72-gfda44f5f463a) =

 =20
