Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DF147B659
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhLTX6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhLTX6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:58:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820DC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:58:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v16so10870178pjn.1
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=56v4mGfDxFiIIoiJ2ybo7jNtcQIOPzVzbeeDgG7v/nU=;
        b=yAavESEoZ0QQulIyGzKkLpvQsX/dBhIyACk8F31n9/kIEO2HptwDjXayQXRbjsspTn
         gZEF0sqf1lzZyyDz/wIxFslPjttNuHT3OKBg3Diy2XboWwr/Agl85T5ArUkg3VPbYJFZ
         Oq5GgjvOF3wDrLYhPCfwfdIlCZVmJb9vhLijIc+Xx18Teh3i+W0mMta+A1njEbslL6rY
         r7yxmbLVDxzxm0bUuF22EHKHxrg6zlTHLhr/fQ6IDGXQriDpWL3bhTVqy6hqyDT1R9oK
         BrXRGWkfNhBwIY5SEY7rYbJtYQB+v3UL7AgMVmByXNs8KvZEZa/pxtQrOkRWQgkt3W1A
         g/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=56v4mGfDxFiIIoiJ2ybo7jNtcQIOPzVzbeeDgG7v/nU=;
        b=JosOOcM6TP9a/qSRPnRVJjFJfoDONvruxgmJzhLpAEZQ/6QmWF6o9gj+5uPIj0IzPo
         RChh4MJcRCOBnFgbzqfJjzQJ99cOXUw65xNzbzFVK37awSAHsG8uwdbecf1U/n7anXw/
         w6J8MosqwmX2n/mlku1kY01LD64TqxR6E74CQ3XdUR0OdBOWSDnlBmGWbSG8MY5yzrTk
         IqVXWIq9oh5GgET8OUn0a088I7TOpVbJi4FJDLDQqIU5FlAoWZxsRXr7hngmJYabL5+x
         kDlnUJjqJwQ7aoUEVYZjus1/2rVGsAuNIQ8Ossmq+QlESz9aEjBIsXlwHyv+uYZUGp6R
         P7wg==
X-Gm-Message-State: AOAM530oOJSdLdN/wZkOoOqmBIH29BmL6MQNJasaXHHSzBZ2tmYXPRxw
        97krSxXkJGF6cknGkOrIgB301AdvONHN/6X3
X-Google-Smtp-Source: ABdhPJz+qhRv2Tea0cC+xzsn8FpdkqDhMHqFW5J5biiOZIP4JBqOOKhLdfoRw2VdmlMgQBdRdZQKBw==
X-Received: by 2002:a17:902:76c7:b0:149:24f4:326f with SMTP id j7-20020a17090276c700b0014924f4326fmr523666plt.161.1640044730271;
        Mon, 20 Dec 2021 15:58:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l191sm17119505pgd.8.2021.12.20.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 15:58:49 -0800 (PST)
Message-ID: <61c118b9.1c69fb81.bbb4.f488@mx.google.com>
Date:   Mon, 20 Dec 2021 15:58:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-57-g2b0e0aea0c2a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 171 runs,
 1 regressions (v4.19.221-57-g2b0e0aea0c2a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 171 runs, 1 regressions (v4.19.221-57-g2b0=
e0aea0c2a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.221-57-g2b0e0aea0c2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.221-57-g2b0e0aea0c2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b0e0aea0c2aec46fb5e692e66a67cb1701ee5fd =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0eb3c69c7047a22397130

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-57-g2b0e0aea0c2a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21-57-g2b0e0aea0c2a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0eb3c69c7047a22397=
131
        new failure (last pass: v4.19.221-10-g1d60913d545c) =

 =20
