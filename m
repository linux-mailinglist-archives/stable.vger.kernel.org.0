Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59035587408
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiHAWlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiHAWlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:41:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FA825295
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 15:41:20 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 23so10871904pgc.8
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 15:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=faPJyiBqcNrzj7bGm4rX7+6bg+ztb3bxRJIoNmRnUNA=;
        b=xJ4TRUj7Wkc1BJ5+yxoltVYgE4FrDqUGayWUxn35b1Nw/sFyy3zujsZGcRaI3jlBjk
         C7lqazRjq5QHObj2GkDtJFKLlbAtG4WNm4U1xKhq0+3gi2rh6CHBUfI5R+6IWBnQQZSG
         hlnExQysI2OdL3TAK4PzsDScRWoLL5Bu+hieTzIBEpy4ZpygMJYmVN8Lg4WGDyJ65o77
         hearDt0K7JnBRTZjv9tLaEf/cjw3Co/9x38UPZTrO5l4P31rfu7MddBu0qhiU92k4BI2
         kNIrUjegG6bYzI1wyPr365nMAGPbtvQsJLAmEs5OmeJB8yR6YhyYFVMR5W5oUTENIhtX
         Gu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=faPJyiBqcNrzj7bGm4rX7+6bg+ztb3bxRJIoNmRnUNA=;
        b=RXXEoS5uRPhvhtnP4St0Vc8Q2s1iyQj2bu5oCX5TDBO7e5w1nN3D0hAURAbwMQQvTn
         7iTHCd6xRhmrohYMVIu7kQJoPlfffRTPH9+HRyMgK0FER/Ehc6LsnW8CFxz2iJ+RAkBF
         W4raNaMMswlzFDQyTImUUPQJY/6Sf27geh1g8hSqq9I49jVrLXwoXHhaxU+KA1vBxMac
         bgEigAox+m00+LoHtoDLNTFg6QyUqdMiCVlJhP9L7ql0O/0VMwjBUmy07f1iAutRGCb7
         NET1LyIEMK1PnXxaho+SyGoKlGJEhhREZ4BX/0reQHChpQMEFVl0rSMXWQI0hrcMyT0+
         g4Yg==
X-Gm-Message-State: AJIora/UT9BiNx0Qd7K0lVop7rNhK+lTT1FckhqupxJPEYrh9bsDD5gh
        ZXKdGQ5zGdfX011+kXpa/jMu4pR+xxqgT8PlBhg=
X-Google-Smtp-Source: AGRyM1v426B0YU0LRO53OZ/G9Eg7/oyRVAipUxf1Pq9l2Pcw/3ZnGpGm+edcAdljYI2kl3XS5YLR8g==
X-Received: by 2002:a63:fc41:0:b0:41b:4714:ac78 with SMTP id r1-20020a63fc41000000b0041b4714ac78mr15081568pgk.319.1659393680068;
        Mon, 01 Aug 2022 15:41:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a626d02000000b0052c0a9234e0sm9428030pfc.11.2022.08.01.15.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 15:41:19 -0700 (PDT)
Message-ID: <62e8568f.620a0220.26e10.e196@mx.google.com>
Date:   Mon, 01 Aug 2022 15:41:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-273-gf7c660e98f9b
Subject: stable-rc/linux-5.15.y baseline: 86 runs,
 1 regressions (v5.15.57-273-gf7c660e98f9b)
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

stable-rc/linux-5.15.y baseline: 86 runs, 1 regressions (v5.15.57-273-gf7c6=
60e98f9b)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
bcm2711-rpi-4-b | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.57-273-gf7c660e98f9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.57-273-gf7c660e98f9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7c660e98f9bd2987c86dfe0017ad54afb4026e1 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
bcm2711-rpi-4-b | arm64 | lab-collabora | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62e8211294255445b5daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7-273-gf7c660e98f9b/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
7-273-gf7c660e98f9b/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e8211294255445b5daf=
057
        new failure (last pass: v5.15.57-203-g77a604df16d5) =

 =20
