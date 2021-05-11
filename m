Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E14379C4F
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 03:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEKBzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 21:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhEKBzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 21:55:21 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD9AC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 18:54:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so435873pjb.4
        for <stable@vger.kernel.org>; Mon, 10 May 2021 18:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sd555tHD0hzj0UvQ6b3nuC8m34TLhUEZg3pBtbnmEwU=;
        b=UaHTLyE/c/o3+BgFtux5fWywj1NkK2kPKUJnHrAKfooAfcoSYRaZqUEDUR3w1BuDhj
         A3MCqeSGNszlCKIMMirSLyXDlFNMZSWw6lbBAVwpFO5xERf3zOFVId66jjM5CQwp8ZBf
         3F00JR/XzbvKls7l8gn+34ieLxNh/5wZMth1/DOqROxnZdC3QkvRaoV0t9RGV2/aFAaa
         vZwYdkOx+0BbCMzRb7bqS6Zmhwu6pwdfg8gXI1PS8XsyKlcMJbfAGnxpm9m5w/UuuK2x
         WgrJx047ckqsEmyLXVcGAoKioC7or2bPhgdNHQ2WILiseq+vHLjvHAI7uTPP8vrcOm8n
         wqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sd555tHD0hzj0UvQ6b3nuC8m34TLhUEZg3pBtbnmEwU=;
        b=XP1RxOfK78GuIsKhrC1EhMxO94xrrAGZA0aS6x6N/89QxmUN1T8h4NZDZC5CkL4Ljg
         lSKt0ppJ182U2TanSdwvi/3Qn0NhdfJdAuN7AsFN5njJl95QXIWSpG0PzyAR9GzvFFoY
         +QxTLV0+M0jRtxWbq1gydAw3UEgVp5ulFEP4EBgMznrNNW06lWjj48YDl5zv45mqab39
         P93pc/zlB2GuQpO0CRrl+atT/32gkYH+P3UppO2jnR5e8/qBIyTNocYr/E4fwH2guUm0
         7rtenAmnHFL+WUigzwoMFAKQsWYaJQbWOZgxxDz7GIZb+oif9t71WDATkNceeF7KrSyo
         pJcg==
X-Gm-Message-State: AOAM533dNynwwJ9qcxirsVM0+Y/XMWnrwYH36hGm9QcNaZeEg6yXS8SX
        3oIPRYrfeMOyfFNePJmeL25VXq4Cu/fY9Oms
X-Google-Smtp-Source: ABdhPJw9bQN1/l0ScIeCoUaiFxiwVlGfwdj7pUtu3GJMqUYTQq/f9DUXiRsNyzd1R2W8kvb3L02hyw==
X-Received: by 2002:a17:902:e88a:b029:ed:6bf3:2290 with SMTP id w10-20020a170902e88ab02900ed6bf32290mr27035791plg.20.1620698055628;
        Mon, 10 May 2021 18:54:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm12559452pfb.174.2021.05.10.18.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 18:54:15 -0700 (PDT)
Message-ID: <6099e3c7.1c69fb81.260f9.734d@mx.google.com>
Date:   Mon, 10 May 2021 18:54:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-299-ge46308859abd9
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 128 runs,
 2 regressions (v5.10.35-299-ge46308859abd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 128 runs, 2 regressions (v5.10.35-299-ge4630=
8859abd9)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-299-ge46308859abd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-299-ge46308859abd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e46308859abd921a8b30257a4bb8d573d0971e2f =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6099b45234a49e40556f5474

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-ge46308859abd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-ge46308859abd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099b45234a49e40556f5=
475
        failing since 1 day (last pass: v5.10.35-249-g83b7e5089f21a, first =
fail: v5.10.35-257-g999b6775fb75e) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6099b2bee5fd8fbcd46f548b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-ge46308859abd9/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
299-ge46308859abd9/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099b2bee5fd8fbcd46f5=
48c
        new failure (last pass: v5.10.35-257-g999b6775fb75e) =

 =20
