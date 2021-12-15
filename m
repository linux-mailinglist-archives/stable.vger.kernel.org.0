Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4105D4750A5
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 03:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhLOCBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 21:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbhLOCBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 21:01:24 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C8C06173E
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:01:24 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p18so210244pld.13
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XbZD/ApI8OtcmEb1EkLPdVuA6GjZgPXPBlZxywvg3Sg=;
        b=VA2yOZgRmlFBQd7vHOsH9Afgm9dmb/mzGItLxFZOJDt4Sels6s+ehDWZwiAJlvPavz
         BW3NISs5jnuINwifE4xZ97tzkLGqepFQja9PpoGCKhuGiYfy07pxPPAHIQO5tHTtWGip
         E7w+YXchye2J3LmbvUGlL/ZLiZybsx+J4V+L/N1Ijw0ZUku/bSXbMSQHLQeucJn+IlRG
         hSHUub9/huxR2Y9D5P3nj+OZvvOmxmIEvjU3Yr621WNlN1w7iXM2RJjJ3zYVEFlNgwWS
         6RJgjsL1QZT5TjCdYEaAOQlB3WmaQfBfv2kLGLAD70k7M9+puHPjLoJAJS49/+pgpLS9
         G1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XbZD/ApI8OtcmEb1EkLPdVuA6GjZgPXPBlZxywvg3Sg=;
        b=7bHzwCJkUhHB23b0d6LCyvSsPnvrZTIhZFplYKMMbrfBd6DnNHho/xVLjNJtD2Cq3c
         qR3cnDhRXCd8VIc2MosrxV5MThhrg8chbVFPSvgfe5CwjdIp0GxUr5lsPcglDepw4RxK
         VDeAjuEFsyyqaWnIq3dugIrCTJa9PKxnzaK6oTDX9EHr//LWEoLgjWDCL30qRaSEneRT
         RZAZDwOBWD+IAM/DKuqgFoQ50Zm7QbGiTIfwTJ3rnpPAt41gOuw5bE7cjaHbSGdBpNkA
         13CJ58qi6mfUE+Kr0odmejQgMRwueHb3Dh6taWpk2JkA9zRduvu0b7UGG0wMxpgj5VFV
         5fFA==
X-Gm-Message-State: AOAM531Zjb24eZFNn1CnCwjBw9B5B3dBDFE+rFQoeXpb9GQ55o6Gdu4G
        G0UJI8x2F5I3kT1/eDojcsVVIHcKwwFgnopY
X-Google-Smtp-Source: ABdhPJzLZ+g0RQtXELwDHNB1cWGXjEdnohuZxLsFiEtVFl1agX+trxmvNnKm4DAilkv241Ot0NmsAg==
X-Received: by 2002:a17:903:230d:b0:141:e3ce:2738 with SMTP id d13-20020a170903230d00b00141e3ce2738mr8705731plh.57.1639533683853;
        Tue, 14 Dec 2021 18:01:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19sm292781pgb.77.2021.12.14.18.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 18:01:23 -0800 (PST)
Message-ID: <61b94c73.1c69fb81.bfbd8.1817@mx.google.com>
Date:   Tue, 14 Dec 2021 18:01:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 168 runs, 1 regressions (v5.4.165)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 168 runs, 1 regressions (v5.4.165)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.165/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.165
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7f70428f0109470aa9177d1a9e5ce02de736f480 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b91384065d2b5bb539711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.165/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.165/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b91384065d2b5bb5397=
11f
        new failure (last pass: v5.4.164) =

 =20
