Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C167425FA1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 00:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241214AbhJGWEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 18:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhJGWEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 18:04:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E78DC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 15:02:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso3823736pjb.1
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 15:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uNBSCrqmISpx6MZX4j1GeD1ZPyOiycm0DFmzVg8/ji4=;
        b=NITEletmO9hiehzxh0zF777D73UOzszYE3rS0H/3v7KKWoFVUlhR1ehu07vDha2FQ0
         2c7WDx5GgpVQJg4XurTvoUc63fgNNzf2Kbar95SCIYVP0AjQlcuWWMagze1ZcaBbZHsk
         AIICoXhcLxC8iMbx2UiOET1kWr5FqNRb/nGpAIL4pdZXUyHwmy29Ipw3ndkPXF8cJzWb
         Mf8DVR7n7b4Kot4nKPGwkDNQgkwxYCrb6/FYdQeC4+PkAHmMpd+Pv2PJSZEe4OwUzmXo
         vye1zu7ZdvU1pF8CQg/28LJEJOo3n52AAvTb4/IlaD690EDpQYeqxn+vdHdp/9MI5jG5
         Kdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uNBSCrqmISpx6MZX4j1GeD1ZPyOiycm0DFmzVg8/ji4=;
        b=aUzbOpaWK0814hi3HerSy14r1wzLB3wt1I2k5+H78jGYT1s3+rUJfuIKQ/AijB8ozy
         mdugwfHFi+V72o1T6dCh5FTvdoYtC2Nl3UXR58iplgGsYWzSq8gOedk8cY5m4rpQrvok
         bwHr/MBWCxf7RTYXMdBOTYofvfnstXqht4oZTrnY/zzIWS41Xvqcu4vfom4HDV2M0d69
         Je5KxvANtpKgGsS3999kyeCJUo/tTWzA/UQYd9rPjx1EV7N6TSOx9oXCikvwlhY8QZW8
         fsVdwLo6yc/nNBToiVA+my1acozhXkiri/qyWMXWxz9EJJgS80AVI2fD6JlOkRTv1RxL
         6iFw==
X-Gm-Message-State: AOAM533+yUov3jVDIdFvmMrp9fvsAX5B+qpU6xbDkuYCZKx/VhCAYgVC
        6+zuenvgnKgbf4o/pAKOBNtYgeSCnW6lSq7/
X-Google-Smtp-Source: ABdhPJxS1QumxJzP7C8QhnV9XRYG0UP1wBc4ZjUJk5t9CAStxLN3wfHlkDnrBjpe3UzZZj3rlbykWw==
X-Received: by 2002:a17:902:b48d:b0:13e:8e7e:24d8 with SMTP id y13-20020a170902b48d00b0013e8e7e24d8mr6268202plr.55.1633644175773;
        Thu, 07 Oct 2021 15:02:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b142sm399041pfb.17.2021.10.07.15.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:02:55 -0700 (PDT)
Message-ID: <615f6e8f.1c69fb81.b998b.212a@mx.google.com>
Date:   Thu, 07 Oct 2021 15:02:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.71-28-g2f55a27c87e9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 1 regressions (v5.10.71-28-g2f55a27c87e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 130 runs, 1 regressions (v5.10.71-28-g2f55a2=
7c87e9)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.71-28-g2f55a27c87e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.71-28-g2f55a27c87e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f55a27c87e95e9c2587005feb275bcd367a7bdd =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615f4e4098c2c1e0a999a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
28-g2f55a27c87e9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.71-=
28-g2f55a27c87e9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f4e4198c2c1e0a999a=
2ef
        failing since 98 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20
