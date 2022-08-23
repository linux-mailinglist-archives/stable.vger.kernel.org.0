Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6A259E77E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbiHWQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244981AbiHWQep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:34:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C10853D2B
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 07:49:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso14901173pjj.4
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 07:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=zPXx/4i9UR7nTgF7pEIVmXYAGegwZQNB/U+IIrb3nSg=;
        b=Wgw4T1UpM9SI6qJGPczRb7WR90KZetWnFtmEtk8yQaG7xWsMoD8XsXl0gF28jnaL+M
         +XEuogx7TZEl7xkwTknZ9wD6ZtPEj3ZI3w3I1mTK01JNLMg1vPHdnoPEJuVDF6tVm6eZ
         hld5U/Gck5BJO05GITJ7POV4fT/wsOH9hBlZLxk2r4mEQWSQRIF/01HrtjSnBMAGKE3a
         1I51FMCDRcDMvZk8RsxjC4hF3Lp4ZNP59e420gsCDZGq809iViP28m0j6PnYjLlPYFLC
         cr4WvGByo1d4umjwZvHtYPmgfr92eS+E3kjnJ5K7TPok+XXHnt/07m+6I1cOvj5cmWoz
         RcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=zPXx/4i9UR7nTgF7pEIVmXYAGegwZQNB/U+IIrb3nSg=;
        b=NqJPVarpf2fHhZP2hZupziQHnP3Pk9EZdeLMmlpytmSI3VXdynXA8EwpLCKXHr2+pV
         HRcVnl7uQgSY/oIZUTY8BBXM78W+DIfX9nU2vBM6bW8gHn8U/CvGM0/NS7wDFFHNnuQS
         HeERB8yctEIRtsSaNQUTqW1G2IAW2kyfwarGnrwJ+jf7VRd4JxMN7q/tippUm+K/aaZv
         p9NBgsJ4U6ZW7Kbk6WuudaUzcOXyqESoIotODS3jEpmhuK5ZHI2jL8b7UKjnz9HsO+y5
         XU9v0e0setIeZXTZmP1tJpgCk2Z3x5g8wR5KcB5UgL/7+N5C+8nmMxOVdOhQegjHNRGr
         szuQ==
X-Gm-Message-State: ACgBeo1IOATdjGyXZpruNGmVHgazDQ8SNb2RN+lDDXqZ5NT8iX8Z9U1/
        kOsx7zHAxJ/qjCBTk33fHaaULt8EwRVTEtMB
X-Google-Smtp-Source: AA6agR7qtlzclH3C0rh2yO6YMFV/n+Y+m+d1sMrIkWU9BhEoemhDHXzYg70MlUvUT1wSodMws1U7RQ==
X-Received: by 2002:a17:902:ef85:b0:172:c13d:bb1c with SMTP id iz5-20020a170902ef8500b00172c13dbb1cmr20632760plb.90.1661266173986;
        Tue, 23 Aug 2022 07:49:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3-20020a626303000000b0052dd7d0ad02sm10843940pfb.162.2022.08.23.07.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 07:49:33 -0700 (PDT)
Message-ID: <6304e8fd.620a0220.cd00e.39e6@mx.google.com>
Date:   Tue, 23 Aug 2022 07:49:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.3-365-gdfdad101d6ba
Subject: stable-rc/queue/5.19 baseline: 174 runs,
 1 regressions (v5.19.3-365-gdfdad101d6ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 174 runs, 1 regressions (v5.19.3-365-gdfdad1=
01d6ba)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.3-365-gdfdad101d6ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.3-365-gdfdad101d6ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfdad101d6ba856518cfa04a2a28e717122a6b96 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304b5909d76641bf035564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.3-3=
65-gdfdad101d6ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.3-3=
65-gdfdad101d6ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304b5909d76641bf0355=
650
        new failure (last pass: v5.19.3-363-g62092b167c30) =

 =20
