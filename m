Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBB946F945
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 03:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhLJCmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 21:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhLJCmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 21:42:24 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BBDC061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 18:38:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z6so7183700pfe.7
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 18:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lkCuPPM6W5ZXNlcaSvTwjOjwOleY3lQcDTWPFaqEk2s=;
        b=I0UdPvglE3lCUnV/meB0mlZAKlR8anbWZpZKgzrSiuhYqOrRS73z7c5op1EDU4UI6Q
         pe26t/0tWRV3kytI3upgmcI73q5HDNMmhhlzcFXtmErIDfr6D8sFMWn89yS2eS5t6CFF
         9GoG5kjM1lsxSZXgIZS0tePosr2ghc6mHTJ8frrPJnn63BlGE9/bvSTqHfZkXfxBimhs
         YfAUGwXKRQRAX2LMR64F5gh5jvhPuFFNW0T64eVgVsHx5E/S7KmKuzPx3cK0aTfTtvc5
         wWl9uzhXnIOIXqf4vgrRGxw+5kYxYVAAndyI9sFWfZklVQq3W85faGy3K40xsloKtMXl
         Rtbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lkCuPPM6W5ZXNlcaSvTwjOjwOleY3lQcDTWPFaqEk2s=;
        b=smDyZV1KmdPl2wZgTdwZzFpV7JHlGJ8dsEDBRJteriTUyWRjyDeiiWnwlKStml2ePN
         YFPG6tupswflU4usrG+LTj4Chr8SNmTNG6E0x6pVoMF2wM+INev0QF+y86TYiTaRYl1e
         oBVS4P7qiFEO2yQd9gQ9DATLn2p8ortVxkfGmE0M23sIBtXbz8P5rgHHHSlHENpNGwzx
         W59P5/vThvixsRkUD2HzJftcAqO54tRmzB1b3njwFmpI3p3GM85S6W5HMiKkAPzaOFy+
         tA8J9XNRQS0BFYArDodT+m59WUK7HKwUj8ZAwbbHXCNM5WfnuCVstCK5uFiwj4MT+AbC
         zB5g==
X-Gm-Message-State: AOAM532GiHsgsE6zuPnU6p/04yF35ds1HAru6bKDpF/EQP9xqXg6mRop
        k6QOI9Pe7I7jAK2eOpma/qd4+K0DNm7yBbtgHp8=
X-Google-Smtp-Source: ABdhPJwOuGf++SNoCMCE66J+LBfSQ/JDhekpGqXmYTXSqOaQ5f40hrqoV/LA5hQ3PE1BQScsTCvidw==
X-Received: by 2002:a63:1e0f:: with SMTP id e15mr36656613pge.606.1639103929711;
        Thu, 09 Dec 2021 18:38:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm894326pgj.2.2021.12.09.18.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:38:49 -0800 (PST)
Message-ID: <61b2bdb9.1c69fb81.707a6.445a@mx.google.com>
Date:   Thu, 09 Dec 2021 18:38:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.83-138-g0bce101d22d3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 228 runs,
 1 regressions (v5.10.83-138-g0bce101d22d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 228 runs, 1 regressions (v5.10.83-138-g0bce1=
01d22d3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.83-138-g0bce101d22d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.83-138-g0bce101d22d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bce101d22d3ad347a4bb9da375150162c3d3df8 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b28325ac96a6ef8139711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
138-g0bce101d22d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
138-g0bce101d22d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b28325ac96a6ef81397=
120
        failing since 0 day (last pass: v5.10.83-129-g307696aadda6, first f=
ail: v5.10.83-129-gefc3f818915f) =

 =20
