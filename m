Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0C47D946
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 23:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbhLVWRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 17:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhLVWRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 17:17:53 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3BC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:17:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so3922755pjp.0
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XNgaP33o+XJ8dIzDOsHXH4Fu2gEObwX0kXjGgicUVj8=;
        b=5KXGRRSeMJgs2uiEG7OQShVOFe09sWb1TznbtHCVe3OUHkrouXMceymjhw3CdFaLmi
         KBoP2QVk4msYzfyXoSNCaE1K6aFrPWvafLXAttngcaPA7I2hhk6cg4g+B/yK/lLpXMbo
         MLKt+bbA1kM6LkscjyTQCf5keW2eQrLle2/uUa3ygATtXLUl8t/zEfsq+oV/2pD8Blc+
         W3uasHP6XleLJQJWuGDaY8vngxJBmeGpn1cB++OTSBk8GxPM2bWgOI+NbHtsJv9WCbyW
         TdXBam9Urng6aywz6TeSXHBEHRBQ8n8wDSg3yt8BI9S4ZVbWOCLR8wRAH9rvtAq1gAMx
         qNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XNgaP33o+XJ8dIzDOsHXH4Fu2gEObwX0kXjGgicUVj8=;
        b=O/3Q9yzyA4uE3ohYPocKLnucCtzNPZS9EIPSIHBl3C6IEiTtJsYa/AffyICqD4W61D
         3r+uZ2dAq1qxE8qWIKSHjE/+Do7CgiXYszFn4HURCrU+Oup+LzBGqJ1dytYfR6VIs9SR
         W5wE4NUuxXieEvynYg7h2CtR3XnRB371xlV6MJeUPYgVrkWeLRgdAcLeCyLXgZ9+y64C
         g1rJgZ5VINo8yLgoNKjbvMAfKm2MpCT+eBg8xq6AN7dT+ngKfb6imFBZEYeil8YX5ipM
         i9hqG4ntlbQug41J4Qm21SzXITLyPu7fBJ207aW/hDI1t7tES6odxKPXl6kkOHYilc1E
         aOIw==
X-Gm-Message-State: AOAM531Qp9+nexGNcfpXaDe38j8RpZt3+OtFrd0VPjn25vV8gs2Wba0L
        KW/NyiX/Row1QmgZkTg8uxafQSUqvRUw/R9Qxaw=
X-Google-Smtp-Source: ABdhPJycDxyQ99bvKmFdAuqjHUH6DtT89rOg/OOngcdbyYv0MgOb0Lt31HUOCdIo0/pB263qkaSS+Q==
X-Received: by 2002:a17:902:a606:b0:148:9b2e:940 with SMTP id u6-20020a170902a60600b001489b2e0940mr4612737plq.35.1640211472928;
        Wed, 22 Dec 2021 14:17:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cu18sm6525114pjb.53.2021.12.22.14.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 14:17:52 -0800 (PST)
Message-ID: <61c3a410.1c69fb81.23f50.283a@mx.google.com>
Date:   Wed, 22 Dec 2021 14:17:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 108 runs, 2 regressions (v4.9.294)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 108 runs, 2 regressions (v4.9.294)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.294/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.294
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f84cbc484575d3e2977e06a4b9d69ab644426786 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c36c61fd134a98e2397122

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c36c61fd134a98e2397=
123
        new failure (last pass: v4.9.293-32-g4578d170efaa) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61c36a95ecb0915c9b397178

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c36a95ecb0915=
c9b39717b
        failing since 9 days (last pass: v4.9.292-29-gdefac0f99886, first f=
ail: v4.9.292-43-gad074ba3bae9)
        2 lines

    2021-12-22T18:12:19.417670  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-12-22T18:12:19.426581  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
