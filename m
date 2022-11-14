Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C240D628740
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 18:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiKNRiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 12:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiKNRhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 12:37:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532430562
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 09:37:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso14478807pjg.5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 09:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WQPBYqVVWIuWDw2yoYgt7ml230yNyYRB13IkWTrFVSI=;
        b=p37vIxmKXaWPjPD+Gp838Xybn8HUVpENA63iiY5HPoWS9rcF6owVkH9eCmCDX9HGSr
         k2XTr8XIJNNaeW3As9LZ1iCZ4l+Z+FxPI7i4ZvaLZmBOBjNdtUe3mepAdE/vUQaaELnC
         kOLm/W717LEtsSfIHWtezTbWa7qxytfRgN20qOweraKOQrSN67PfU16NSAjQ2TgmhcUy
         0027BqCoCo6tO23gHVkmqVZVHyh2AkTPEuTdju7mWSTVXl2lW9CpuLnes7jcE1vaohRm
         TwP1K/AJTX2Lo/Jp1yo3AjqStitLAnKgCiUIaIcCpLFj4P/WCaFoX0MK9Yqxz+XCG3Sm
         UsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WQPBYqVVWIuWDw2yoYgt7ml230yNyYRB13IkWTrFVSI=;
        b=uqU2XxhCYJ3tPFtrNlzZDni7BnPZ6XTkLXoK4HocXBHCvwgzIUAPNZMEXatRPJEf1M
         tM7k0l49cZYRzcAJfPFkcEbsc/sRwRiTDqh/ttVPAm51aiU+Cn9YkLcUjObhfTIUDGHD
         +m23aXib7xT//7bT7px0ttGoou3ATxvpmElpWgI0CrAbz3O2SeWXb9kS/H14W9RdVmgj
         66TWDJ61KcJCho6ZKQeWBXBh4SMKc7OZ7rU/M8TKCxTsghpHEw539QtfVagA8lFuYYEC
         4EtzQbKGP2CWvfTviRE1X0Q0M9E28Lfr0YJp+TAUDNQdiib5E/kVMKevGfxWp3LnIh1J
         W+/w==
X-Gm-Message-State: ANoB5plbIw7IWdQDo8Iq8h54vv8Kxlbj4rFkNGaB8b0mgBkj6Ab0zVYC
        fAs2RW1CuAlCyR9aaM6ynTAcktxbVNlG15tVfYA=
X-Google-Smtp-Source: AA0mqf5EyxQYhC0mdeWbBipsYQJhCX5St7ZxvJ/ZdJAh1Nn+DXBMGJ8vOgmZleBoWj3ZiaLLo0/WKQ==
X-Received: by 2002:a17:902:eac6:b0:186:a808:5384 with SMTP id p6-20020a170902eac600b00186a8085384mr197462pld.150.1668447466307;
        Mon, 14 Nov 2022 09:37:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k15-20020aa7972f000000b0056bbba4302dsm6964455pfg.119.2022.11.14.09.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:37:45 -0800 (PST)
Message-ID: <63727ce9.a70a0220.647ff.9e10@mx.google.com>
Date:   Mon, 14 Nov 2022 09:37:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.154-96-gd59f46a55fcd
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 170 runs,
 1 regressions (v5.10.154-96-gd59f46a55fcd)
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

stable-rc/linux-5.10.y baseline: 170 runs, 1 regressions (v5.10.154-96-gd59=
f46a55fcd)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.154-96-gd59f46a55fcd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.154-96-gd59f46a55fcd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d59f46a55fcdeaab7337522c1c89553399bd1648 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63724ada3d2d7005bce7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
54-96-gd59f46a55fcd/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
54-96-gd59f46a55fcd/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63724ada3d2d7005bce7d=
b4f
        new failure (last pass: v5.10.154) =

 =20
