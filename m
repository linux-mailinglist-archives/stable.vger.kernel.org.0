Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9B580949
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 04:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiGZCKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 22:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiGZCKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 22:10:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27E827CF8
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:10:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w205so8684408pfc.8
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IhfDO8L4KJxk2t/J93veQ+ki5bVxRqE65iVknpRls3g=;
        b=fZKYUQgENidumdm/Ykbwzb8oUZDt9O5aESIE5bHriEfhNzuXwpCd6YIxcRJg7/ioIl
         mX3RqPjHrKXDyErl/n40F9jUQ7gOEbL5ZhUmp37KN4Y4T1x7isDBSwJ11gX1nqdJIPFp
         uP0aJ2GW+oAN5JpdCpPF6NhVAGmhlUcLPIuBNR+W4HuI7PbOW8C3NzbFYFTRJ2gmPIq6
         Qbi8/GpKHXpcKH2FiwljpRVMYPl3Ejs7Nww+pZYYj03R7AYQn0iTQFZxF6FTmd6vLc6z
         yUXHdf4eSOjn7Y6vf/jrS9Nnw/ivkOhcPbJWlPe7p/0LzgkCKrRMakqVQzRQBq8cqLTF
         QXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IhfDO8L4KJxk2t/J93veQ+ki5bVxRqE65iVknpRls3g=;
        b=07cCsBZ7LRCu38W/8eoPpuabFEMlxxD7kUPl8x6jifx31pnL2YHdU7FdTw0UuiNxxW
         cClBMqn2Olv7eSYb3t244GIKUKLzf0ii0UO84Xd9NNbVzJblNc6Eiaym6pCssFx8RLFl
         z9pm/F1fyyKjAtDNbt0dBdzhENe8ANpMSPGJxkNrQea6tS0PMVfaXrzKw/40kiQhiWBx
         w8TlxsIirjx8u2/FY7P6EDs2rlmycGuKMurODZfhWT0xJ1aa+Q/2u6QFZJWaiNqKK9Tk
         XqqFfxXKdYOUirFPYZRXhj3pNYdFClZue2x99JF1SAPu7inuXsteMVUYIBDfXX0F8gIZ
         RtfA==
X-Gm-Message-State: AJIora/xrfZwwMjzOIyNFDBMhRI+NwsprwzYqgaBIo5Ye4dd/YSkFWUs
        b5qu8ofL8ft8LTsAnhKzcPq4ehiGXfUutnPR
X-Google-Smtp-Source: AGRyM1sW63o55fVhMzrpxVLpBN5NFMJjRuGNKZYI3Z+aFat2FWbECavtI/H2Ytgl28botzjvWUOu9Q==
X-Received: by 2002:a63:4042:0:b0:411:bbfe:e736 with SMTP id n63-20020a634042000000b00411bbfee736mr13220127pga.1.1658801450763;
        Mon, 25 Jul 2022 19:10:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d72-20020a621d4b000000b0052bae7a9722sm10317494pfd.116.2022.07.25.19.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 19:10:50 -0700 (PDT)
Message-ID: <62df4d2a.1c69fb81.ccae0.0b6b@mx.google.com>
Date:   Mon, 25 Jul 2022 19:10:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-150-g9bc06eb2a799
Subject: stable-rc/queue/5.18 baseline: 203 runs,
 1 regressions (v5.18.14-150-g9bc06eb2a799)
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

stable-rc/queue/5.18 baseline: 203 runs, 1 regressions (v5.18.14-150-g9bc06=
eb2a799)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-150-g9bc06eb2a799/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-150-g9bc06eb2a799
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bc06eb2a799eb248f6381b87ff249fdf5d11558 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62df1969875d821938daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-g9bc06eb2a799/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-g9bc06eb2a799/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df1969875d821938daf=
057
        failing since 19 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
