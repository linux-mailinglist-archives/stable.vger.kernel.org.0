Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC647840D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 05:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhLQEZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 23:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhLQEZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 23:25:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D99BC061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 20:25:49 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mj19so1090757pjb.3
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 20:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CCOeSfjCgDMuk0FjKxIJWdufYcys32FQbMZfI30cbxo=;
        b=xQD1sb6JOIkT+yTrJlb3qNZuhXZUvI1BBv3FVLwPQNEBDjGjk+DSsiJQnUMVTi1Vn4
         Zgt+xTtPxLqYCUpyVbnHb2Um4PmosLce5AZ5VhZkaUndYdRCz5r7arum1kFhXX0cOKtN
         1k5XaScqFJdZfV0aUXV8u/dwagFJE3SnE6CfM0t+KsLa+474XO1NXVr8cUJy1JioqyRD
         EROEQ0+XOOWm10pMUhic9NgSTXen4BJvhWkK3LaQM/AhwJMIulNV143ZPXIKoQqreYxI
         Wj0mGJTGUORCuvP7SC1gNu38ljqO4Lojv2zolCmP3qbnkkO6wZSbNxXtHQ7wgoF9a3bH
         +ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CCOeSfjCgDMuk0FjKxIJWdufYcys32FQbMZfI30cbxo=;
        b=atCPWDmuJIsm6RecbJpcQi/EJGXvrFObYzm86JGCYVS/bHvoPBRqAGHauXTaxjVqqU
         Asx6KYNkk3oGWT3QGcccXvuCuao+h4R73A5/vA9Tcc4G/599IrRnKDQ4Lti9hFZOsC1u
         j4KUA0Cl/VfORoQFtgUFIIllTwXswebAaeph4HE5rvyiWu1RwMyzOMEU202lh8KNc8lH
         pCR27/EHRoFrw1R1aQvjnBhl13AYyjdSQtz/NcHBw2lSfSl2+5ETBVFeByb5HzhOUQ4L
         /19UdGDNCH9dIyXyoChtAzfGYHaic4oBqABnkyx7kqRKVbgHaqirVo/WZo5xKPZDyq4q
         0u3Q==
X-Gm-Message-State: AOAM530+W9NdhFJRoQ/dWzuLmTPrfCeA7RzfMc/r7EJPQOo7/W5sIvy8
        CudqZ4C13/sTQ6quTjxHSE4sxqaOOePOog2x
X-Google-Smtp-Source: ABdhPJyzhSBwQ8xdmllaNG+IQoxdutgH9dUF/tmYew7DRpaZRt+gyul6n75m/b+noOSYheqKz6sYcg==
X-Received: by 2002:a17:902:e8d4:b0:143:88c2:e2c9 with SMTP id v20-20020a170902e8d400b0014388c2e2c9mr1238693plg.12.1639715148487;
        Thu, 16 Dec 2021 20:25:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s28sm8011059pfg.147.2021.12.16.20.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 20:25:48 -0800 (PST)
Message-ID: <61bc114c.1c69fb81.3398d.785d@mx.google.com>
Date:   Thu, 16 Dec 2021 20:25:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-18-gb3b2c311e2fb
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 143 runs,
 1 regressions (v5.4.165-18-gb3b2c311e2fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 143 runs, 1 regressions (v5.4.165-18-gb3b2c31=
1e2fb)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.165-18-gb3b2c311e2fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.165-18-gb3b2c311e2fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3b2c311e2fbb0723cbff8be772bf635a4997db3 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bbd6a573bf80d234397127

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-gb3b2c311e2fb/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-gb3b2c311e2fb/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bbd6a573bf80d234397=
128
        new failure (last pass: v5.4.165-18-ge938927511cb) =

 =20
