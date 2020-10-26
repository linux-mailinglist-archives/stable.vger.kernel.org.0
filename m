Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8829940D
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788111AbgJZRkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:40:39 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35118 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1788047AbgJZRki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 13:40:38 -0400
Received: by mail-pj1-f53.google.com with SMTP id h4so3440626pjk.0
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 10:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AN7o1rZx4OBuiDrzEtib1Krtu9JtCscxTkK6KAcUDmg=;
        b=xjSQdRpuXc/HKMR7THKMO1Wcm+nG5DbW2WcIq/0bUDCKTmR9iimiZZDazfc1qqBQAW
         HP9fWioHGRjtBRnCytVbI+O9KXaXBO3V2z0aBkD+ymDBnm9XNErFEG+ODa/FZE4rEZvJ
         yYN4NvhnYzZ3mowM6TuYoPpAdbHacQr8UXrTK+e3+B4y1zpcrs5pRqH47gE5UL+HdOck
         wmlOWbWzVqVV+IPvG+LO1MkQ3wNaUA86YxoK9XdHSa2hIuiGrGAElGTNXolYvnKX0JAv
         wfG/NZ2aTe4w0Yl4Q9fnajel478y5zweXrLU4jTHB9g0ii8rL5sDQ7zgNRzemLlnXAsL
         gH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AN7o1rZx4OBuiDrzEtib1Krtu9JtCscxTkK6KAcUDmg=;
        b=DK62I+PA6nyTPuX/43ADeO6IWM8vyQ8HcdbLoJ3cB223ee3w1dFoNyszagujj2o37r
         qSi4VeKFePZEusgYa78Wx3QuNtBJBAIuTc8PcNMiBd7kpW8XUE91GeQobv+hsnI+grxQ
         bb6D/GlKn8YW91dtUaScOO39qw9gHobXgGckDcW7xsA7SUefQJUhlsYM7P1awU1yQjOB
         RiNBCVauwOB4sBX0utWSLHFuQD6AHGMX9xxiBqDud8g9H+A0ezWKKOHuW+eBQPw+1H6Y
         Y+TkXYcqkHcpEMVcHOuWaGzJx24fvNB+LA7CkWtnDoPGjrcmowm9fryURYPhzGeqRiCh
         X/nA==
X-Gm-Message-State: AOAM53069IPhQqo4XLgdGUTXp2iV347vRODKjSqTYdXGB94zefUrpbBc
        pIcFthQDJbRCVgMVEQmsWHc7sY4c37O/GQ==
X-Google-Smtp-Source: ABdhPJx5CYnQk+2g2t+sxu4UI92Y7gfCAyTx4RT1Yttn81QBo6mZtieMVwU6g/mgtflZ5vuPFfB/Kg==
X-Received: by 2002:a17:90a:e60c:: with SMTP id j12mr17032704pjy.14.1603734037312;
        Mon, 26 Oct 2020 10:40:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c127sm12563854pfc.115.2020.10.26.10.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 10:40:36 -0700 (PDT)
Message-ID: <5f970a14.1c69fb81.9831b.a57f@mx.google.com>
Date:   Mon, 26 Oct 2020 10:40:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-186-gf98944e78a49
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 157 runs,
 1 regressions (v4.14.202-186-gf98944e78a49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 157 runs, 1 regressions (v4.14.202-186-gf989=
44e78a49)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-186-gf98944e78a49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-186-gf98944e78a49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f98944e78a49e35cd8e465c9aa2acd9f36ba2f58 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d4752e1890468a38101a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-186-gf98944e78a49/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-186-gf98944e78a49/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d4762e1890468a381=
01b
        new failure (last pass: v4.14.202-187-g41515da3a101) =

 =20
