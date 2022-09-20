Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826705BED9C
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiITTZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 15:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiITTZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 15:25:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0C140FC
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:25:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so11831517pjk.4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=eXjtQxP+5Zvi7rqA5JJseq2ez8NLnEkgyH2FGrUZ/nc=;
        b=wFXM62Cut9Tfey9BeK8PGUiLw5xNaTeyqmjaV5QzptMe4PlMXyyx+MMtddktNJ87gg
         3GkeQi6CSD6Y1ohhqTGehoON8xG77tqash/bavwtpnI/NZimHfoMzoJ4bOgWFqA3PNez
         doBvmlaXmEXD6F7wwbJUlaTqmgGcW/osZM/K2oruYfVrgVWjIQ0QDPWIT+JgNWFEOf8m
         bTP+/XpdXJm5BitrEu5ivYpi5zHk6LNg2WfUoatqqXBEWzUIBQQWe5JsDyGwfK+r07sn
         0YEh226+lcIzBkU44Nu8cuWajTU3mfKsqb9zChDp3BQ0puX+CA5HOQbj3unV/vh2pNS/
         6wUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=eXjtQxP+5Zvi7rqA5JJseq2ez8NLnEkgyH2FGrUZ/nc=;
        b=TMxLf8RK4nPNq5XvrluG8vHQENXDXyh/kpcyUS9zXFy022winF2rsZjGLr1LmKmgDM
         QtUljZerQiZknqZMah3C1jtnZZY5H7Ft7fZlT/uMqOGOItO/0xtgvv/mJHcOuKdRj/xk
         gz6p3TzFE81AMgKdaVqv1HmsIMx/F4ajAWxUBQidBQZKQAOf5zXrpDVJMljaJPgDpy15
         v+8P9VHPptTFoFHwqjUMxeKVWvAR9V4TgxZr5zJpj2+subu1yQ+rxDmDm/CuClVEzZTD
         pSUYFvgETPbGk0fCqFZBEPj+fbXhX2dEbbmP/udf6BMM9hvsmUhNPdaIO6X3tqanvYFz
         OGYg==
X-Gm-Message-State: ACrzQf0X8RbPqJqB/m4uYA2Id3v4UHfNmB20fwOpyW7zxbPYrCLVcaKm
        htLGRDSiRzJt+d7LF5yq/rqtzfvjWgQfNfGoXZg=
X-Google-Smtp-Source: AMsMyM68r73owp8Zg/ZOmbiNTFHotl8k3zoiDoA5ACs5T2njjegeHHuDjBZpKER5QxAw3O2y8kX8Xg==
X-Received: by 2002:a17:902:710e:b0:178:b122:9daf with SMTP id a14-20020a170902710e00b00178b1229dafmr1131988pll.98.1663701927077;
        Tue, 20 Sep 2022 12:25:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p18-20020a631e52000000b004393f60db36sm317471pgm.32.2022.09.20.12.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 12:25:26 -0700 (PDT)
Message-ID: <632a13a6.630a0220.fdeda.10d7@mx.google.com>
Date:   Tue, 20 Sep 2022 12:25:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10
Subject: stable/linux-5.19.y baseline: 197 runs, 1 regressions (v5.19.10)
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

stable/linux-5.19.y baseline: 197 runs, 1 regressions (v5.19.10)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b80678c1e00a34f01bce79c27afb7555666f559f =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e275e9e9fb3947355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.10/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.10/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e275e9e9fb3947355=
651
        new failure (last pass: v5.19.9) =

 =20
