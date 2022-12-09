Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E67648076
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 10:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLIJ4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 04:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIJ4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 04:56:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315EA5F6F4
        for <stable@vger.kernel.org>; Fri,  9 Dec 2022 01:56:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so4481310pjd.0
        for <stable@vger.kernel.org>; Fri, 09 Dec 2022 01:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OusS1ZfOaE1XqAN5qf3KzpoY4BtrULyIX2+XpxcrtzA=;
        b=B5eGWh/jDngmGIcgsurxMQExQDbCOiawEO/o+5VeP/v1HdLNWY9VnJ2OpZUwpvfape
         ouAsI7qumXVGWQw8FbEIVhBMzeezssYcMBEkj2ew+3PIoWjIxUccs21FCZfDfkN+vRgY
         fv60DJo/H3eg+081yUHeVKlAe/QHMg/HPhz/Mw+cWDE3SNVXOmu6QUv96zrX4BeBpEWp
         pn4HV9Jh1GSBt3HsjKlWBeJfn/xd2E5FosyuayD23Hk+w6vIZB+oKAXpbY718ALbu5Yl
         abOLWvGoHwImHwowsKZ3CQUPKGMLs685ntNUQlxySrSoGba+wVvjJa2nzvChDaTfenP8
         U8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OusS1ZfOaE1XqAN5qf3KzpoY4BtrULyIX2+XpxcrtzA=;
        b=m3Tw0hd9gpnSbi/D7j9duwSa6cKhsWUFbpuXc0bYFc+ElmLMxaGwLTo3R4L+56HZ+n
         dIfXqse7T57FHqnX/N+ihnJ0CJnm70NVrxQpGJ3kHVh6KFCZMK5K7tr7Bk0IxzaM3Ktd
         oDZYZWpXkzw1fm3chJJLYfrfnnGDrIWt71meId42cW7Lvf+rYajLaK4RU9qUGJGwq40A
         SN3FJvdkQrKLkdHoHF1sLn/TtqDcCOzNfmIgy2DgGM5nMt2BHZUK/mK7wS5xkNyagFJ3
         vqwDLioBtr6SujsuONdhYDTc0Jsbup4LMduKfYaoKkbF+V64fJlafYVSFnsdaljkhJZ8
         vFyg==
X-Gm-Message-State: ANoB5plG/SWfWYYn4RNtolqK+g5BJb0eM4q6nkjTlh+lkdyyHGIUyeHh
        s9G26YJvQM9LXNN8F4z5m/qypSoy0IZhQ1PkD4fCxA==
X-Google-Smtp-Source: AA0mqf4srUdke8KDdUtih+8HeKlVW9pz1+nAqdMnYpXrHVWw1y/SnVVS95Drwm7TC5LGnhIb6vU9lw==
X-Received: by 2002:a17:902:e5c5:b0:189:f69d:d5f7 with SMTP id u5-20020a170902e5c500b00189f69dd5f7mr6792598plf.57.1670579767394;
        Fri, 09 Dec 2022 01:56:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ju2-20020a170903428200b00186ae20e8dcsm930685plb.271.2022.12.09.01.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 01:56:06 -0800 (PST)
Message-ID: <63930636.170a0220.ca5a7.176c@mx.google.com>
Date:   Fri, 09 Dec 2022 01:56:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.82-41-gbb088059d0b6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 161 runs,
 1 regressions (v5.15.82-41-gbb088059d0b6)
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

stable-rc/queue/5.15 baseline: 161 runs, 1 regressions (v5.15.82-41-gbb0880=
59d0b6)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.82-41-gbb088059d0b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.82-41-gbb088059d0b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb088059d0b6b97c4f76cbabd1e4d9597e0cbdb7 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6392d269b83408e1c42abd08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.82-=
41-gbb088059d0b6/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock-=
pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.82-=
41-gbb088059d0b6/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock-=
pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6392d269b83408e1c42ab=
d09
        new failure (last pass: v5.15.81-121-gcb14018a85f6) =

 =20
