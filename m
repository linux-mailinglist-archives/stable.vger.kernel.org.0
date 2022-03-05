Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F244F4CE73E
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 22:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiCEVlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 16:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiCEVlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 16:41:24 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B3C37022
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:40:34 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w4so310386ply.13
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 13:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A4QR0inPdbddpgly6fFCv5B1ZwnxUfGupxm/NlBYaPg=;
        b=6geXGsOs1fcW/sliODTw20LKQ5XCDQjPpVZkszJA5r9h98EsbzSXRFLfg8PAPuwn0g
         DE0+gJ6Y5bTwFJSPlCCf7Ws3EfHXZU9s97Wr8N/I70mcoa5q2ST/dcvRwnCpwg1Iaxwz
         VK1kO/eHZ/FNuEmVujBGyzIlWT8hKHNBdg5+JyTUDPgdKeD7K9AdIpqkvI9eblp4Kb4I
         1rXRXJTLOYtjuCYor0AoN1pZSkUa3KK80+x6btRanHmUyazpro6q3E5HlbV4Lj71nJ0p
         /QSHRrFKqIDc10y5dvVPSCsXTrIKo/nlcyN4LsHKX8kvwv2wlt4AWlBAODlBYr7TRMEJ
         Rneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A4QR0inPdbddpgly6fFCv5B1ZwnxUfGupxm/NlBYaPg=;
        b=e4D6NQZ5u+dmanOZLedRIloiV2cIKAa9duVXP0wjvqGidWXp1RsDUH5EsA51o+RFbp
         1nZhhOL23ReJg2yM5jTIKX2XpmLkzBP2bu9FXMS+qAqoO7sSxEtFwAHC/b1mf8bhtfju
         YWX1jGd1o0VCGi5Kv5d8s54Wa4jhYZ3BmdIZQjx6drzelfBgyXWV3hmz2EU3Wl+T50mh
         rbXcykvI7TJdIKGK2+vhSm2NjSypFdyrGJARmabtyu++8/vf8dBmdcD8wtTzU4YFXcS6
         veVLoM2xqPaIPY9vMQXIcII5DPKwc9vZrfeGJsiHj3XqCbqtiu+cmA0hKzkubsUmalMg
         /v3A==
X-Gm-Message-State: AOAM532ExO0ouZt+TZtmunUgGO1wT19nlK65cm/wiBq+uFuu7vH32Yom
        JVdJrQlsDoGziMx/XFh00HKQNda6axczAQFV+9g=
X-Google-Smtp-Source: ABdhPJxC67VDWTV72u5/eVvac/pAdOlNZ//tedhxN7to4Jfv2g1GD5gBhCqgHShbf+NBv2X6MuxgcA==
X-Received: by 2002:a17:90b:1b46:b0:1bf:3356:991 with SMTP id nv6-20020a17090b1b4600b001bf33560991mr7679738pjb.163.1646516433753;
        Sat, 05 Mar 2022 13:40:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa12-20020a17090b1bcc00b001bf430c3909sm2309896pjb.32.2022.03.05.13.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 13:40:33 -0800 (PST)
Message-ID: <6223d8d1.1c69fb81.11158.48b7@mx.google.com>
Date:   Sat, 05 Mar 2022 13:40:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-27-gbe5be336f33a
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 1 regressions (v4.14.269-27-gbe5be336f33a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 1 regressions (v4.14.269-27-gbe5be3=
36f33a)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-27-gbe5be336f33a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-27-gbe5be336f33a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be5be336f33a976b27095e2d145093f59b859cab =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6223a16366ce36a384c62973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-27-gbe5be336f33a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-27-gbe5be336f33a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223a16366ce36a384c62=
974
        failing since 20 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
