Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5804A635057
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 07:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiKWGTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 01:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiKWGSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 01:18:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFCD742D3
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:18:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id a1-20020a17090abe0100b00218a7df7789so1013379pjs.5
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xIGvbsztQxk2Wz7XJfRJpr33ohVi2y2QPwaaL8GcFpo=;
        b=OybZ4T8ffwgglbzhFust0yu+U0YBZqd+GLf7xtVyP8DMdfW3CPAosDpiLDJSj5NVuX
         P8FPgCA/Ho7d6+wyEVJr8/J402AQHiaywPyFwByLRS1BKBX8T0ltV6p1lqnrUMRXEBw2
         MCTWZkJbSYIMXq0iogxdyBFuuPafQFVfSsKptUIpvDdMaMGoUxOk29iEgqVtT6R3TZBv
         WrnrtWSDuW/RVJ6AG0krphSe384Xpp8w70sSWSwVO0xBcbXMEZKVqy+kaRQVxDy7MVYy
         5meT/h5Xyb+Wk27fTVmQUX2Vq92g2LDomQwhKyNO2sAmdMZ0ug4aDLgweIUz27swzmue
         ZAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xIGvbsztQxk2Wz7XJfRJpr33ohVi2y2QPwaaL8GcFpo=;
        b=Y1NfwuDa4mYlVuhRULgVKYEauhsQO9MZ3HtvPcBH2Awl/3UUUifuiAIyvSGciXB6L8
         clzD0obKkfKPreQufuTWwGP106cvzcEedQqXuDr5frttISIlnqgxeN4yYqfpcwZ0rYpa
         S/WTGajgS8NBejvXGUm9ldlwlZCTMnLDOKwqSa98yhlkhGxkWaqekFQpQFQkdHOiBQwK
         M33f8jWP7/IhWrmA480unhqM/ObsPtLKsxnDNCIaTaOsoYZyJSG1rNgXixDsrFcpy40P
         qBKTv2p10fXjNAM8yFkH3yoFIy2JVAhlDs653TcxaBB8WTpfV89zR0KBnnUxQGkxrq21
         Bz0A==
X-Gm-Message-State: ANoB5pmCE4FDc99eB1NGbOiY1ptkFwH4TMuQ1n3rBAT0kjbnAMrX9B9Y
        VxDAkrTpFrH9DcZdIzW6N4xeS40svjBx9hLP3kk=
X-Google-Smtp-Source: AA0mqf6e9rXTeUg4w5KIoPk3o0RDD8UOvEwkA3ZKDu+ogtlAKOc2WLsbemPQt6SYwfshrAYFCvwBJw==
X-Received: by 2002:a17:902:ab08:b0:189:dc3:ee83 with SMTP id ik8-20020a170902ab0800b001890dc3ee83mr18312976plb.58.1669184330661;
        Tue, 22 Nov 2022 22:18:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903028f00b001754fa42065sm13125780plr.143.2022.11.22.22.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 22:18:50 -0800 (PST)
Message-ID: <637dbb4a.170a0220.ec2b7.4639@mx.google.com>
Date:   Tue, 22 Nov 2022 22:18:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.155-136-gbe7d64a2c2ab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 139 runs,
 1 regressions (v5.10.155-136-gbe7d64a2c2ab)
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

stable-rc/queue/5.10 baseline: 139 runs, 1 regressions (v5.10.155-136-gbe7d=
64a2c2ab)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.155-136-gbe7d64a2c2ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.155-136-gbe7d64a2c2ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be7d64a2c2abfbef12e79467e85ff10cf01675e7 =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/637d89252b1dfe55c72abd6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-136-gbe7d64a2c2ab/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-136-gbe7d64a2c2ab/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d89252b1dfe55c72ab=
d70
        new failure (last pass: v5.10.155-137-gb87a9fc4c2e49) =

 =20
