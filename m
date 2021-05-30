Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAF13952C9
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 21:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhE3TwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 15:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhE3TwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 15:52:19 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800F9C061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 12:50:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so1933725pja.2
        for <stable@vger.kernel.org>; Sun, 30 May 2021 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TLXEpklYPDE53n4vH2BhD9aZ/jSNZjokPLg7FHhus0g=;
        b=RGL0uNffS6QElQIaKGy0KJYsFrmDfOq+Tc2mYkuS8IOnHUwql6m+vZjU0fss405ThH
         9mg1MamOLe1H288CT3u/65x8Z37Kd9nvsaSZqid8KmoFItjFklimz6oJkAvpG7kOrozX
         cg0bAngKsxf8+aq3Pi6RMB5Ny/OdpDhkcXKIclvGl5gf9Z9d4WHhrXJowgUCgUrGm0dd
         qfoqme2TUA88GL45678/gShbKyePjDsQJ8VOpxUBTX+ELG+kvkQjEZMqjuFcnd1rePSk
         Du9v50qBY2GIsQ3oPfUzLMen2/ZbzvHwmRVHvKdUzE9iYHckLgucQ3SqVvp2rbek0NKQ
         TsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TLXEpklYPDE53n4vH2BhD9aZ/jSNZjokPLg7FHhus0g=;
        b=p5L2Nf2l1WsdsAp4PKOtfjJegNdiPYVKiUNFW7INMg6BkANr4kViZUfatslij2rqvF
         lGYVt8cpwO7iDzP1qpb+TYIrcJDZk1YtYgR1qyS8FRq5PCsOech/rNKsFkQF7EB24Nok
         h05vyRKBb8R7Ob75TUpnhNxZRs+Y2zJHtid/ST3MxZoLTNbjOfwxFI86MqnUnWn0bm6/
         Vto2ZNZ0DdVktIZCHiXwI6sjKdBzi9FHIeB1JuvfvijJqbupU8bRbpRLLMTegbN81q+E
         mMOBV6eJquDnW0q0PK0Q6r+LEi0gs5GInsdIXwo+cR3ubk6U/Jsp7I/deLInbCDd13AM
         XXDw==
X-Gm-Message-State: AOAM532hiGC67hXIyJ4mMv11UpiNFNpMVOq/HSheLZ15SvNT4QhpnAW2
        bH+8RsMnqNbHkCdgO1Jw4FZXFXMV+glT7fJP
X-Google-Smtp-Source: ABdhPJxZ1AU8v520BmkZeBfB8UlLwy4Bd41/RyNySoqnanXhi5GiBqlHjnRIrMFQf++B2FcbSxIyHA==
X-Received: by 2002:a17:902:cec5:b029:f0:b123:44b2 with SMTP id d5-20020a170902cec5b02900f0b12344b2mr17091744plg.55.1622404238758;
        Sun, 30 May 2021 12:50:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm4845184pgf.20.2021.05.30.12.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 12:50:38 -0700 (PDT)
Message-ID: <60b3ec8e.1c69fb81.377af.e7fa@mx.google.com>
Date:   Sun, 30 May 2021 12:50:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-139-g2cb2acbbafd8
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 196 runs,
 1 regressions (v5.10.40-139-g2cb2acbbafd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 196 runs, 1 regressions (v5.10.40-139-g2cb2a=
cbbafd8)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-139-g2cb2acbbafd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-139-g2cb2acbbafd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2cb2acbbafd8176b63aaeb1d8dd2a318de206371 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b3b324f3dd467474b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
139-g2cb2acbbafd8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
139-g2cb2acbbafd8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b3b324f3dd467474b3a=
fba
        new failure (last pass: v5.10.40-98-gef1477410758) =

 =20
