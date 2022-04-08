Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76604F8C5C
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 05:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiDHBHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 21:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiDHBHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 21:07:05 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812621CFF4
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 18:05:04 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t13so6433388pgn.8
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 18:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pzR7yhQd+izxnCcb7q3c71nSxgkMkktHUJh3qeIMtNo=;
        b=q7AXkcRQTrDyBZP8uqBnCZIJffILDRgoCJMynpiE11K+H56uaHUGcqIAbIWFmhtrts
         ayRDg7KY1Gy+Lkrr17gwHd77ROnkahUKdT0upPQRH2OIPZwQ89MgqEkUIs2komA+h8HN
         evQpgON0UR/okNy/U3+8ZTZiQGFE4s6wxikuriLyyJq+Tuw1xl+mUYShCHpWTCLQu73X
         RN6VJtY2mb3TAS/Nwezjm9ujttpWkSjgt2h3r/a0sRWv4rgP3LL+506ArYSZW943O6+S
         Jt6CakfxBYEjWmtAwty3PxvnOpgZpOac0wTiipDMB7RmkLtwpK1+mDAuvVoENEDnTv5p
         6tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pzR7yhQd+izxnCcb7q3c71nSxgkMkktHUJh3qeIMtNo=;
        b=t7XfXiwy7QZzjMuInLLxDFaGfhIYbrMBgIXj88dtNPtRfOYnOO4KdnIXMmIPsfiOQP
         1PA54kwT5eY0wSLTL8VH5nfFQvv76lbu3BiAQk1RGckR1s7b+dtoy1UWRIKLRinQ4FHx
         B1sEgUfbU8dHn/T7rct0G5gDq/X6E1z5o0Fpd7z4ePGTDdMq5ocLVnmWkx/xPT5ibe2N
         iDoA9z93t7IC1XbiQso9jnAAZzIcahkSxrza6m2fyf1laZvvqRMB0xt1rXACxzPJeP3s
         AjkhH2ih065WzEbGSZ4Sqsh/TwC/3koPYNVFtTvZB3A+7i2FNEDk3B6DdL6MpVLhcOP0
         P5jA==
X-Gm-Message-State: AOAM533CSmrUox69qIexM6HH/0azVE8V9cKu+O+fVBP1pcUosuJQFKHh
        kQ5Ud0aoU9bVcQ2oAlHom3B1zDpIXtofb33z
X-Google-Smtp-Source: ABdhPJwwZQomfMqD6O96Y04mpEZ3Ns/W/zBAFh6tAGwNHTTF4MmV62B4R3xUnzKiiWalCmGaSWckcQ==
X-Received: by 2002:a65:5ac7:0:b0:399:28c:68d0 with SMTP id d7-20020a655ac7000000b00399028c68d0mr13711627pgt.254.1649379903847;
        Thu, 07 Apr 2022 18:05:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14-20020a63474e000000b0039cce486b9bsm2634986pgk.13.2022.04.07.18.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 18:05:03 -0700 (PDT)
Message-ID: <624f8a3f.1c69fb81.adec.740e@mx.google.com>
Date:   Thu, 07 Apr 2022 18:05:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-597-g64232f26da0d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 1 regressions (v5.10.109-597-g64232f26da0d8)
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

stable-rc/queue/5.10 baseline: 118 runs, 1 regressions (v5.10.109-597-g6423=
2f26da0d8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-597-g64232f26da0d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-597-g64232f26da0d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64232f26da0d8df01a1fecba9edca7125f78daa0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624f581c111b6496d1ae06b7

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g64232f26da0d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-g64232f26da0d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624f581c111b6496d1ae06d9
        failing since 30 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-07T21:30:48.913828  /lava-6048074/1/../bin/lava-test-case   =

 =20
