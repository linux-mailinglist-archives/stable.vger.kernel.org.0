Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9D65DBB7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjADR5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbjADR4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:56:54 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F93D1ED
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 09:56:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c2-20020a17090a020200b00226c762ed23so637986pjc.5
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 09:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G5EuGtRM4smE9tat24ncmhP1E5HXWkN26K8yKD9I9/o=;
        b=l4vV255Yd/ChMPyg+4qICadQfQYq3JfKn0a1GhZsQgozFvIfLV6zTT1ytMPej2h80s
         76n2s1fJcqQooRi/gDxv6LqwFyjAJO7jY2KtejeF6RpMitTWkZCsLyhnT3y8wR+wA9R8
         DKxKrvVt3mN74vp0P0k9h1qzU7ngpbWyrnia8K+qhUpt0tC7nI721oxBr3eEmYRZhMR/
         x6CsdFmfci2YYp+1JSi/ITIyuocpY9RbIFa8KwBVFrtc+gz/ew4dER4Hq5xutyAjeLrF
         /hYli6TksDbXcLs6+RnmdmYTpWABd01KC8/C4tHmDbrpIQEXF4R/AQCegtCA4d+tdQrA
         qT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5EuGtRM4smE9tat24ncmhP1E5HXWkN26K8yKD9I9/o=;
        b=RdAix6D5RfRfTgmHzatUMTy0+438eWOBONKJciR96hQm1f7zmEb4baczzuaxoyGy6y
         SHkQZyaO/OZsE2FzoQ8k3DOUZarKhKxl6CqlZ17aGAxvZ+tD06jTXjahEDEP2bfqCKsI
         Hhd5lqCTheUJo89rhIEVghwIE1JPf9HcnSSQrUDVGLTzG3nY7Kh9E7pADdCvxbQX/M8h
         FIwvyLvkdcdTYWI+QnhHaG0VSiG64oVjJNsfcrWpGRlsEib1HCYtrXxrPZ26CBYW6TzZ
         LWZw/ha99HHHog0vQiR9gAzQeEofbeHq/Fmo2XRl8jbCEyz+owL1/+qVQlyVTan8yOUV
         Iifg==
X-Gm-Message-State: AFqh2koSO9w4hJlx130dipBUpA8u61ky9GipMmMP5nIdF30QUW41G96O
        DqpAJBY9ztfGPi5yV+lMKalYYLYgOI/ogNEKsoos0g==
X-Google-Smtp-Source: AMrXdXueI7ZSu1ztDqHvGG8tcGKYU4qtGPln4dmzD/w+CwlCW9HjRTtuxHT8zwdariNGx98yYo+Tyg==
X-Received: by 2002:a17:902:6b4b:b0:189:8790:73b1 with SMTP id g11-20020a1709026b4b00b00189879073b1mr53663571plt.65.1672855012913;
        Wed, 04 Jan 2023 09:56:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b0019145e3f77dsm6862368plw.111.2023.01.04.09.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:56:52 -0800 (PST)
Message-ID: <63b5bde4.170a0220.18279.9a8b@mx.google.com>
Date:   Wed, 04 Jan 2023 09:56:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.86
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 253 runs, 1 regressions (v5.15.86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 253 runs, 1 regressions (v5.15.86)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90ffbb727c511c6de9c5905c8d5aba69e413bcba =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63b589dcceace9eb834eee49

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b589dcceace9eb834ee=
e4a
        new failure (last pass: v5.15.86-55-gf2bfb0f17c65f) =

 =20
