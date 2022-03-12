Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7F4D6CEB
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 06:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiCLFoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 00:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiCLFnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 00:43:55 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F3B264553
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 21:42:34 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so12830510pjb.5
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 21:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PrlNPa/VbmNPKa+7L2XqNL58zZM3i64XD0Hlc1vnX/w=;
        b=qZnYKahAdDvxfHVfREdOLNAcXVOarAvQq3s21j7Jg8h6Jp01C79i/kIK5wZxqJ69dc
         dtVt9aPbWqgPE5Q8F5V+yPLb7nfDJ98IXWoErE2hMBbVXQSemPmWIt90ln2wL75qyqLW
         +gi+kFVB3sOE7tou7MP7IoKqnWB7ZMn55jUiSVDs8XQRl69G5BHB+QHmI0S41t8tdBhZ
         MS8N3w1SOTgy2ECFm5c//BIGQcG6Ukgwm74cj07xLj/NsQOFsKQ8VBNAFS2m15oms6Sx
         YpIwnIDiLM0srE7YqVAbKP2eHRg4ThBKgYlucYoSnHDxY2uL2nZQP1pUG3BgeeocrY5G
         oPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PrlNPa/VbmNPKa+7L2XqNL58zZM3i64XD0Hlc1vnX/w=;
        b=gSIucI44gikDQV/5JxeSEs4e7tzaS+ZWaUimEjId524nEmFMPqWpeUkYg3l84b2L7/
         69vhCqiZGyINXKSW6WxjcU75by5sdi5vbOi/T0t5zsEvpsMfEJDbfblQaSAhkuLDkXrT
         KRZl3SJx3Ab5vUTi9qP9zRjL/lb71mzmvfcsU/qCeW0KNbjP6LWBCT6j5pm0i3K3/p15
         foaY6AC7ZazqOiBTE+HQaqu5g4YJRW9lIUODDx9jzwB33/xzddq+epbSJQce4bcYys5t
         RY0W1MG7qYuTpATL3K0a7pnolxXuzWnGxiiekdgIWREFMub88UYcl3D9ykR6cIDnMDMU
         pKAA==
X-Gm-Message-State: AOAM531KJxbKTL1+cFD1Tv4/EHPsnXWmZWjXVKuoNycjMeATH8I0tJZT
        tI+wA2I/dcHT0aEbuPimYoR+LdX3X0nfzk39FTY=
X-Google-Smtp-Source: ABdhPJz5rkLT3atSqrunwpSDcZqM+75dGd7akwMqP1TXPCAijSp3UFbgeeKmAYkRaVoJDuP0QakTnw==
X-Received: by 2002:a17:902:7d81:b0:14f:e18b:2b9e with SMTP id a1-20020a1709027d8100b0014fe18b2b9emr13883121plm.160.1647063753932;
        Fri, 11 Mar 2022 21:42:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18-20020a628f12000000b004f743724c75sm12037942pfd.53.2022.03.11.21.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 21:42:33 -0800 (PST)
Message-ID: <622c32c9.1c69fb81.c449a.0173@mx.google.com>
Date:   Fri, 11 Mar 2022 21:42:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.233-34-g7603caa5cc11
Subject: stable-rc/linux-4.19.y baseline: 63 runs,
 1 regressions (v4.19.233-34-g7603caa5cc11)
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

stable-rc/linux-4.19.y baseline: 63 runs, 1 regressions (v4.19.233-34-g7603=
caa5cc11)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.233-34-g7603caa5cc11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.233-34-g7603caa5cc11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7603caa5cc1196665ba06ded1f0a6f615eeaebf5 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622bfaf69fc6e6f4c2c629ad

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-34-g7603caa5cc11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-34-g7603caa5cc11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622bfaf69fc6e6f4c2c62a09
        failing since 5 days (last pass: v4.19.232, first fail: v4.19.232-4=
5-g5da8d73687e7) =

 =20
