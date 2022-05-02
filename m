Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EECB5177B0
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 22:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiEBUKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 16:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiEBUKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 16:10:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E9D63E8
        for <stable@vger.kernel.org>; Mon,  2 May 2022 13:07:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c11so3069914plg.13
        for <stable@vger.kernel.org>; Mon, 02 May 2022 13:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d+A1x3TcXGB0e4sYniw2KL6fjqxlxAfLYfJClQs9rQM=;
        b=athx/oIP5VvTKsHWTLApZ2Iwac4Pu0srQh/jvv2h0WVnyF+vFZuNEHBDfcfpyktq9T
         X6j+xGzbklbS9JTVwWSoW1fo0IexFHbG6P5OthB7sFi9GpgUDn8hy41cioYsowXzO1jC
         Xwhf7uzv7MGH7TDtwCFJRdhFYJ8R8nEbDLtLLK6QNaJ/O5wllXxXjW299yNlp2dQh3lQ
         COKDT+cZp+WlN3RlO1nI+wWyw8i0xSa8epcMsUNFGnbkzHFLL61s7zvTD5Pyw6sEhuo0
         4voK3unjzL6rAAuKxEKK8ytaYGkACoHn0J6IMdY18I02XS6EMyiYEJcEhiDU5Z/NUf1Q
         mwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d+A1x3TcXGB0e4sYniw2KL6fjqxlxAfLYfJClQs9rQM=;
        b=OAqMq60SuvVf0eAgDyRCbUW3T1FdQAwJmfAi8s7U/UlIHzcfN0sH2DUR0peDcklhwZ
         WTF5Zy4YTLsVYLu61dOfAGxcEAPhway1jbHa7O4XY0MkUrGoNYTyUE9Z9JOH1cTxqwAf
         wHFitAGPgbIb6wO7yAxdgPA5nUSdSOr3l3XBsb4kVMyZfI8a+p+4JGYsv84PdnxhtfRJ
         I7Hfl24DMs+OXC5XU+CpAcZkCkh6aFNcYmOaoMqQ3qMV+yHhC143zPr7stHqz3IOynop
         qcybhq4X0In0PpdfJeEVNlsdM16XioORIxF/cCOJHDLw1AdyQKLn+ALKIa99xIqxDCMB
         ebZg==
X-Gm-Message-State: AOAM533PzHJoT738+C7KiN+KMyEF9wZ//udwovbNzJZL9xQ53lZloMli
        GcpYOwiVDm4JR+JS+o7lV+ovaSJC8/rW51WQz/0=
X-Google-Smtp-Source: ABdhPJwYd5BqdDuUSaAAZ+oXbl740OVWvI29Seig1B9W2L3kpdh9PQUBnOs7i3cas6mwN5hnjJSM7A==
X-Received: by 2002:a17:902:c24c:b0:15c:fa6f:263c with SMTP id 12-20020a170902c24c00b0015cfa6f263cmr13718994plg.66.1651522028151;
        Mon, 02 May 2022 13:07:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0015e8d4eb1d4sm5046483plg.30.2022.05.02.13.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:07:07 -0700 (PDT)
Message-ID: <627039eb.1c69fb81.e8e6d.c2a5@mx.google.com>
Date:   Mon, 02 May 2022 13:07:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.37
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 81 runs, 2 regressions (v5.15.37)
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

stable-rc/linux-5.15.y baseline: 81 runs, 2 regressions (v5.15.37)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bf7f350c1638def0caa1835ad92948c15853916 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/626fcee7f159c6218975dc88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626fcee7f159c6218975d=
c89
        failing since 101 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first=
 fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/626fd114b6e8c538ad75dc7a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/626fd114b6e8c538ad75dca0
        failing since 55 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-02T12:39:39.263371  /lava-6235589/1/../bin/lava-test-case
    2022-05-02T12:39:39.274295  <8>[   33.473355] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
