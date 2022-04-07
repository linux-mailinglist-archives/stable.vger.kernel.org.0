Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C43F4F7462
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 06:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiDGEJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 00:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbiDGEJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 00:09:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE19C6839
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 21:07:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso7768896pjb.2
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 21:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fekx4Vpn18kJcVBxyhxsvp6NxGiaDV1hilm641wI4c0=;
        b=r3DAKtRNhmvwbBVB6VUUhnRmvCm5t7R534w7CgIwVaDv06jAF6/nHAfrKtCeYLu9JY
         wNXKaozhBlsA0Fc3YhLA0ON+9T59jhj0GPK6xFSXFHEf8ovjj6XzkNT6XG+ywfQtrrNe
         EUTkTENLzGVsNmu/bqHk7qaIS9XUwXElGAKCfE9AJm+yFgp23MCXvGJ1hDzEmdRaVQrg
         io8e2LbJvFPihJZl7hutgmGx65T7Te7InBNXAN6fv8e1qez/TpZllbeZ27w1ZSVYOloH
         5Z2tBFQMrYsuaNLUXiAI1X9oRQsCWRneoGj4OaHZ36QcIensozY5AtuJ9UNE8sAwK1Fm
         /l2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fekx4Vpn18kJcVBxyhxsvp6NxGiaDV1hilm641wI4c0=;
        b=Yv0e+b8LSKG3jFWrqlgZtUfBQVtroCQ5ONsNldmchPj9LAZ7FSO9FuEMD0T3pllIEH
         0GxqDn3N7fPe4kOKy3wa9hx7lLvSkgDkJPa9OEJOadyldHn6CeqJLEqPOmaMUcg1riTz
         DRSL1Haw1BVzIDXrQ+YWKEGW3wdPTzohOhzRu7A233GlIZ/jdcS0NLXDo8tYMa0SdUXX
         lrua5+Sg8BWRtJ0RbMXkr7Tqi64l/urDfoaWWnh3Krgh9rbIpVKgKfTk9qbpDT26ufOD
         K7wn6oDfCpK/1px6lt6Do7kB69uuNeqtyr2UogM1b1pSYv/PYxJAQ/P7La722XWRKF9f
         YOcw==
X-Gm-Message-State: AOAM533hVa/m5L8Ir5NidR6f+xHj4pReih64z6fKUfC6b0n/Abhwo980
        QlWQlOWkJGctKcJEf6MhxJDyUYFZYqNzUF4xNWM=
X-Google-Smtp-Source: ABdhPJxqytmH0I5aqn/8LW82BZrztieZJv2s5ypX84NHiHcpkEAiT9RKlPVykPchTiDMULR43Me9OA==
X-Received: by 2002:a17:902:70c8:b0:156:509b:68e3 with SMTP id l8-20020a17090270c800b00156509b68e3mr12137696plt.113.1649304467573;
        Wed, 06 Apr 2022 21:07:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj16-20020a17090b4d9000b001c709bca712sm7499646pjb.29.2022.04.06.21.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 21:07:47 -0700 (PDT)
Message-ID: <624e6393.1c69fb81.5de12.5be6@mx.google.com>
Date:   Wed, 06 Apr 2022 21:07:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-255-g0d85e9f8f6ff4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 1 regressions (v4.19.237-255-g0d85e9f8f6ff4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 82 runs, 1 regressions (v4.19.237-255-g0d85e=
9f8f6ff4)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-255-g0d85e9f8f6ff4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-255-g0d85e9f8f6ff4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d85e9f8f6ff4613ae4b3af9241ce9e14b7f33c7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624e327a11dfc3bd12ae06de

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0d85e9f8f6ff4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-g0d85e9f8f6ff4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624e327a11dfc3bd12ae0703
        failing since 31 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-07T00:38:06.089874  =

    2022-04-07T00:38:07.101574  /lava-6041926/1/../bin/lava-test-case   =

 =20
