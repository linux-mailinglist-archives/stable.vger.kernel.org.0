Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6D3501EE7
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243698AbiDNXMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242764AbiDNXMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 19:12:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B5423179
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:09:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so5895371plk.8
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wXslC5trqMrA6GdKgn+8ZIqUtuRPK5p3QfVNv+pCnD4=;
        b=AGbE3yhXhGB+QUf52K9YNgu1NvjewKvhyCCVUrRw27z3vuZlbD7uHTh5Rv5FkeqQTN
         syUWL5IspLAxRoPKjtkcfFiogu6Tg4iNjqw0lNh80hjlhQKGnQlL1pfSdaNsqnY+nLC/
         ZgEwVgrTG7pi0tKSuv/MiTfhyKgADAzsuWkDvvYNmYa6U2FrdLzEcTebNN7VDfXZ+m+y
         6TEYJhMVa2aLoFxeJBqpWtuKzHyo8CK3IU5UVtZrv07Me1N+AXW1AnKIKGF/myCkx7qa
         cYGnVhGx8ziDmkLvM3YpZuDVGTeqz9JJro7XoYaqci1Arpkpj8gaXI9ZXI59BYNriY+J
         1v/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wXslC5trqMrA6GdKgn+8ZIqUtuRPK5p3QfVNv+pCnD4=;
        b=m6VnEDFieJCoit9GCIRD6ww6Kd2KNlLsxKQ/s/SYqnOsPCoVq+WbTxaPCUzp+pN5LP
         4XjuFrLNsMhZhRYkp2i79kURLSKKX4UYk9AuSePZo8os3oFjXpCBjy44zwqUtuo35UaJ
         a0DM21I4onS6fZschIX4eLeEu0eILgQOu2ixVIGPLNhYlksTutKRi5vaHy9wzgs9i7Aq
         b66NmgJxD5ldEc8rqv7JE0YJqzPBVM8YOM4LVRzH6F5ioG9CT6RNsJWuG+dpeeRIcovJ
         EpJaMTLHw88gw5XgzAdxjDl2kHInE8AHIj/BAO+bWq2wVoqk8mHT0StwqLiI5zZ05ekC
         TJmA==
X-Gm-Message-State: AOAM5317BMKaqd4KcoSOmke3jiZHrkfW7QQP+kX8gTA89oKUMbBzrf3D
        Ci4Wp6qwsWNC5Qy9VBtR/f4fZNWN22KLgZBv
X-Google-Smtp-Source: ABdhPJyX50v3V6dtDGG7lR94ZCoPhM2UXjEXaiKv7iTu2N7RU4g/FOgoqKS9BjAm1rZjzPVgjuOFCw==
X-Received: by 2002:a17:902:e84c:b0:158:6bd9:8591 with SMTP id t12-20020a170902e84c00b001586bd98591mr20697993plg.170.1649977790488;
        Thu, 14 Apr 2022 16:09:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b00505a38fc90bsm897028pfb.173.2022.04.14.16.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 16:09:50 -0700 (PDT)
Message-ID: <6258a9be.1c69fb81.f01a.3393@mx.google.com>
Date:   Thu, 14 Apr 2022 16:09:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-201-g4d7a1adf26695
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 44 runs,
 1 regressions (v4.9.310-201-g4d7a1adf26695)
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

stable-rc/queue/4.9 baseline: 44 runs, 1 regressions (v4.9.310-201-g4d7a1ad=
f26695)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-201-g4d7a1adf26695/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-201-g4d7a1adf26695
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d7a1adf266955818a797b28f417e09535b1b378 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6258780306c123c473ae06a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g4d7a1adf26695/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g4d7a1adf26695/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6258780306c123c473ae0=
6a4
        failing since 9 days (last pass: v4.9.306-19-g53cdf8047e71, first f=
ail: v4.9.307-10-g6fa56dc70baa) =

 =20
