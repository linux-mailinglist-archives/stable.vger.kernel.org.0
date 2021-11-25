Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67B45DE4E
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbhKYQKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349570AbhKYQIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 11:08:54 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27EBC0619D4
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:55:09 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g19so6258228pfb.8
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TA2EiOVRRy7kPwDCkzuqekPKniaMsTNC3GUzSsCbsNU=;
        b=5Yj6BqgqEhIouzMpPMo5MebXzEx/mYDFlhq1WpUjZrTorCe86h4Bg9FOaGROXWASaY
         gDn7gDwL3FGYtYGHINKiX89FhlOLHZA8iMK2KqQGDbkYI6/w2D20zqeRka74lmvxeC2F
         x4204At0+rEy5Q3FMHV/4hCQi1BqrznecSh79ujsYIYMgkYaW2IvtxP78+LF6HC03UDk
         RNu40sblRfj9vVz2H9hJJBoiab7DEJ9fr39B3Uk0slcBfLGikpgVzSWYRiioAkn5GzL7
         BZEUSpZqxAWYQtye5ULkWujvElmEiHq/JhsYM/9/FHD5CS5L2zamGsGE6qFXSikXUd3M
         Thdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TA2EiOVRRy7kPwDCkzuqekPKniaMsTNC3GUzSsCbsNU=;
        b=5M21oy2ity6Q4tONptcM0SU1wTwQDHEdI45Ztqxm8V2OdV9jxKr835LnNxFxOpNp9a
         7DxHwUlOxLmePnqjiNyTFnS+8GqkXB5uZQAqBje6riZ0EwDnxYhjd8GWFOQ3NkmtXvxT
         89NgvpmeFmR6zgC3ttsAl+cVOFTbX3evwhDNEbvgwfBe5ETg+6jGOJtsMBKp14ga4H0/
         Yi8xxbyHcvEODwmywCaVE5n8jqa6J2VK7aSxnMwvemO9OQkM7ybkMW8SqsU6bseWTL6a
         tJrnU/IyZg6txvY2VyZLTNzw+fR+jkiNEFbLeqJkV6ONkgZbzVUVqcU7IMdWqjrdH2m5
         9/YQ==
X-Gm-Message-State: AOAM531otSDJc+jI8OSKFMbJ/JLSQFYQAdHJTG1QjsSINrD/dhq/AtFu
        NDZxtG2KSavM+U8VO0zVWpbQKWiDT1CnGq7OTm8=
X-Google-Smtp-Source: ABdhPJxi2W2PDN/cvZoRd2EOQ3uzQK8TaLx3R+EzhDDqAC9NQNzzn+busFyObe6LOgurPpPdWbAnnA==
X-Received: by 2002:aa7:9207:0:b0:4a4:f59a:9df with SMTP id 7-20020aa79207000000b004a4f59a09dfmr15001140pfo.63.1637855709110;
        Thu, 25 Nov 2021 07:55:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv1sm7991698pjb.48.2021.11.25.07.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 07:55:08 -0800 (PST)
Message-ID: <619fb1dc.1c69fb81.b27cb.3671@mx.google.com>
Date:   Thu, 25 Nov 2021 07:55:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.81-153-g3504055afb99
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 1 regressions (v5.10.81-153-g3504055afb99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 168 runs, 1 regressions (v5.10.81-153-g35040=
55afb99)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.81-153-g3504055afb99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.81-153-g3504055afb99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3504055afb991b597de44332c734b71ee7922ae6 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/619f794eea60707777f2efac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g3504055afb99/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g3504055afb99/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f794eea60707777f2e=
fad
        new failure (last pass: v5.10.81-153-gc68f60f1d94a) =

 =20
