Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAF92765AE
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 03:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIXBJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 21:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 21:09:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FBC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 18:09:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q4so713123pjh.5
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7Tf1vrHWxtci5oQKRrdRk4X09pnfktkhC54TgqvCjl0=;
        b=fR4PIlj9f19e1QajHgD0PLfe42HFJ+pdQCdc3aoZugCJd5v+Pu4uatF1MOSEdM+GLR
         WTuOF0UDh60XD3Grw0gC1srxDLM0kKFUTG2wvR3iko8Z1pWEEHJx5anyfqfJsr5XF76j
         RJWgtlHHrbemfXMt+JzaLdfAXuspmvJuxkbFPflibAQvDwNIsHTT1aG/pglSw/VKInvy
         AZS7TmqSricK7NMKzvvQzlTz8oG4JSbNHqa6ehdP0GAYcqpFyEqI9TJwszToYVkcUkCa
         AgWUBnuYZIpxdwpqG6op8eT3uT5U9Pe8hYsMtl0cuyH7ZB6fQ715U7C63ZKgLFXTunRb
         JMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7Tf1vrHWxtci5oQKRrdRk4X09pnfktkhC54TgqvCjl0=;
        b=CmRgDeBtDuvS7QhupIFRweI2maTJITPQ7AxvrVFCt3dEgUcHZq/YkRt3HwWDf+TuYI
         geptOojcWfaq0N8LSesxs+vj+SGVHGoFzvH+bMIz0AqJ8TqtThKsmqNokCoZ64Diz8PD
         IlwqfdvvHURLsjIqoW4PyC7jMWXaORXqE2nNN9ubfgTQKLNbiG5ZxWzAv+QkIuudG8Io
         8/hd4PRkuh9Pa+lmg7PM7yNMrkUaEAuxjxkBZToWvIweiI9BPO13ePC4Hxo5DYGT/Wn2
         mD0DcqUXhTIYcHmy00DvVKrdPyEz0KnNy/CR13noyRjmbQ2OUNT+Wb55ap8eFxj12FDr
         QZnQ==
X-Gm-Message-State: AOAM531p70MwKyyoxvOD67NRunoeuQ0FUi+p11wlI5Ueva4avtjdnoQy
        9EI6Gu3vrSaOA0mEyB4uPgneBEmoMSVNgw==
X-Google-Smtp-Source: ABdhPJyJDgsWA9d+0s+DT99Ee4HUY1ziMOg3UQXZxm2g0HFV4llPKLKvic+kZDWCVLeMKUan2tvo0w==
X-Received: by 2002:a17:902:9041:b029:d0:cc02:8540 with SMTP id w1-20020a1709029041b02900d0cc028540mr2117777plz.41.1600909776329;
        Wed, 23 Sep 2020 18:09:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4sm891991pgk.19.2020.09.23.18.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 18:09:35 -0700 (PDT)
Message-ID: <5f6bf1cf.1c69fb81.5e79b.342d@mx.google.com>
Date:   Wed, 23 Sep 2020 18:09:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.237
Subject: stable-rc/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.237)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.237)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
         | results
---------------------------+------+-----------------+----------+-----------=
---------+--------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.237/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4dd8bb0de56ee0a11cd64fa4e62cc17a71758609 =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
         | results
---------------------------+------+-----------------+----------+-----------=
---------+--------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6bc01556c9584d5dbf9dfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27-phytec-phycard=
-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27-phytec-phycard=
-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6bc01556c9584d5dbf9=
dfd
      new failure (last pass: v4.9.236-71-gb7aa672795fd)  =20
