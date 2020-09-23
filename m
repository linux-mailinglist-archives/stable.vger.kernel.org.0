Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B954D275D44
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIWQXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 12:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgIWQXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 12:23:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958BBC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 09:23:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s19so1393977plp.3
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HSxokkpiRlgo1QLveU8JNmor8JjTbTSB0iojgrhho88=;
        b=mqkV/yww3mCHT+WhAyndfD0OxxCpHV7ocWV85n86OrzMJtyn/vMXI9ldB6Oq9dmzCr
         DUGFl9wK60pIMKlZf9Xjs2pUXdH8TXztgEnqiTOffYPKVYMAq1482nfOEd60940eoOwQ
         6FXzpZijwg8H6ixJDzuwc3QQSQcuC6HOd+GDsrA+C4exPM/JlhYeIQpadTOkb6nUf/tQ
         ROoWLXb76PqUHrQLwZKqEHSbBNiY6BdpYVCrwMKFSqXkm1OLsVh13+2LTy3vyx8X7q9Y
         UOE6xSUOsgxzzqqVzCQvb26mg3t7I84SUpVtkMJ/bn9ebyupxq2Qir29ekJRL8N/5qjY
         cufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HSxokkpiRlgo1QLveU8JNmor8JjTbTSB0iojgrhho88=;
        b=hEzjFlVDOaWoZExNQsDbMnI+9YQYnvRmH6ZC2OfigOsMbX2JHXHW93Bo+WkjigBpN1
         hkdCPrVmDxx+l2/DwdG9pi8wh1I9P43qvm5ZO42EJkESy12SfaeHJCkObLMq8khYfF1t
         y04t6JzMaN/2RvQ6ZtLdlqtVPxmNefMSqcpPe5uW2imnaZFhpTiZx6lOo87loh+07dFO
         D1mZ/IKaAWvbYFVyjjAkmAoAxW4C3cLVCRldDwE9pm39xRFaMRU5X3Lf1N3PgU6ZxUfX
         li6pWFvlNFyzY5VD87Jf17VprXXLpGAJYrExuBN/HuCHrzPGiSb9JU4PuSTPDgAVPuqD
         zphQ==
X-Gm-Message-State: AOAM533OGBet0A/BSHsjhnBEeJJouj9Le2cIi73PCco/R+V/HMYv/u+u
        MSx2uC29i/STEkurAPhcJz3lcJrI9MKvZw==
X-Google-Smtp-Source: ABdhPJz9CH//kRwuIRWlXF9awNvzqY3AyXbA10YQ7JS1ccFZWED3/LblrQhIj3/aUNN2WkY0L/HFuQ==
X-Received: by 2002:a17:902:9308:b029:d1:9bd3:6775 with SMTP id bc8-20020a1709029308b02900d19bd36775mr581861plb.26.1600878215739;
        Wed, 23 Sep 2020 09:23:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t186sm338211pgc.49.2020.09.23.09.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 09:23:34 -0700 (PDT)
Message-ID: <5f6b7686.1c69fb81.e595e.0d3c@mx.google.com>
Date:   Wed, 23 Sep 2020 09:23:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.199
Subject: stable/linux-4.14.y baseline: 142 runs, 1 regressions (v4.14.199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 142 runs, 1 regressions (v4.14.199)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.199/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.199
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ca87c82811906f4fc5e936705564ba8176ba497f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6b420f4a7df1325fbf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.199/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.199/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6b420f4a7df1325fbf9=
db4
      failing since 173 days (last pass: v4.14.172, first fail: v4.14.175) =
 =20
