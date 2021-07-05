Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C383BC2D9
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhGESsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhGESsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 14:48:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239BDC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 11:46:13 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y4so17333937pfi.9
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 11:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IOGnrl5B22FpO/r/clr7sj/ucH9wn0dlbRE+4283KwU=;
        b=b1Mkag2wTqW64jE728ZesNVXt2b19kW5X6arFNhiaQLlHcZzdP4KKWC8OGDfQyBeEi
         IBOAYnDrQal7EbwKylZkOd1TZ6mi87NB8ZleXewW98dC/4mW3OezRUQVFzGBKQYB1BBe
         aAtRBRKKNYYtvki+Oj15Dkk5DXqBvG9KgQbj8XkW5b2SV7oT5C+AdkKkEgnp+n9yiq2I
         agoISQtadUOhOEahQIS6r95sROt63+LX1SM5uuLBgmiq4+geLCRdXODtP/Su6vUb1wjv
         oX46X4aBTDOIDzJp2UzjwuKPGXqSVvis7Pj8yRcYUpjz6y+K3uqBYr5wqT1fYBgPg12B
         c6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IOGnrl5B22FpO/r/clr7sj/ucH9wn0dlbRE+4283KwU=;
        b=mVj9USLBqsPolT87VXCPF1IEA2qc30ToNUS8D01WQpbkUG2ULXJo5pTtQ3APO0CTQ3
         rWOyWTdFWnZtDzHbyJob99uIZlXELt/VJ/jHg6kplPDKTGv4DGOpy2rx/aiuObDXlper
         b+FFYi7WAItQCOYP5uURtfZHnQMmQK1VtfbbSzRqFh9LVfMtdAONgGiwfvw2Sxtn5Gw9
         /8ctH+W2PXF//T/DxBlfxFhiLSy+PgjeO6KiGfcVTlcloHUJZ+qISaJvH2eWonDvvLh3
         uqNAOzMsfej8aUIpth6+ysj1vqpGYbNWlmjYHv5+GSe5GdX4IhN3WkcNsJMxl9A3bOg6
         s4+A==
X-Gm-Message-State: AOAM531Oa08rrtOTyfv8PdXBseCj+pvxt+C7/1JvNwielry3IqHZK/a5
        pSBDXlNyI25QmFLDuKJMkVckxKyGdiYkBR9Y
X-Google-Smtp-Source: ABdhPJzoVTvPxl2LDtfjU/mdOG3qe78I16Vklmc3bJLsjX7KmHAf2yon1S5XRTHrv+m206Hee1p3NQ==
X-Received: by 2002:aa7:9409:0:b029:303:1db:94d5 with SMTP id x9-20020aa794090000b029030301db94d5mr16591151pfo.72.1625510772532;
        Mon, 05 Jul 2021 11:46:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm14610714pgr.65.2021.07.05.11.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:46:12 -0700 (PDT)
Message-ID: <60e35374.1c69fb81.ecf8.cad0@mx.google.com>
Date:   Mon, 05 Jul 2021 11:46:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13-2-g58f1766113f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 176 runs,
 1 regressions (v5.13-2-g58f1766113f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 176 runs, 1 regressions (v5.13-2-g58f17661=
13f0)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13-2-g58f1766113f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13-2-g58f1766113f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58f1766113f042008e2bc54df538cfbb344cb9e7 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e31fa2bd816a6ae9117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-2=
-g58f1766113f0/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6u=
l-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-2=
-g58f1766113f0/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6u=
l-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e31fa2bd816a6ae9117=
973
        new failure (last pass: v5.13-2-g0249db15550e) =

 =20
