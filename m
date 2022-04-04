Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E0A4F14EB
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 14:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiDDMfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbiDDMfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 08:35:06 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A7525C43
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 05:33:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bx5so8567389pjb.3
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 05:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TZxwxcodhQmLMRN+Se+0HfWhOmx4NIlrH22Wz1IMp/U=;
        b=sYAwL5xdkjKCKv7WgMyihEWYRxI25b5eSI7KWEf8BGI/Z1uRffj9VjJZfzjGkTPXv6
         DtBhg48dQajOgzpgH6WnNK0+5Cx8wTxyfl2+LJip12RT/elZM5IZznUwF5Bv9L2oZoAs
         INiZG1yYRRJngMSc4zQ4Yjwa389FDQZnOOZJRE2VXTys+tFV89JMQPGjCA+f7FR6TKYq
         k0P1itAccAHYQne3AqMIpzrxBN29X18J6bG1fhXzJCCVmeVWHc1JpD44D0g6bvcrG98r
         8xXtzp+J9h/JOpIv0t4RvW/5lUyrufcXtPxYDtUShDgYgDljrWn7P0DyU8iVauFxyQFE
         OJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TZxwxcodhQmLMRN+Se+0HfWhOmx4NIlrH22Wz1IMp/U=;
        b=E8aLTKyUY9Ke38khfFA3DU+s8pb/uCYu6B7p4VIK/6ASc8HUxfWLqdJBhas6OX/sL0
         /odmXubzSflNV5LYd4m3Xc1egcQlcHzC85W1h/sJTUQvfehSIChokc92QVC9YcvhQ30e
         WmQEZBqAtwEe1AKyAx+cfIdor0T6JBzYnv08FDGzLej6zyPFBhctRRgCTULpIUJPm95p
         N8SWG+v3Nwn15UpupPXP0Dcpjr9yxDyGyVhy44jhT99BnYIOxmStIgVpkYpNRYC+mkxb
         4jFM6LnrbOKnjE6aubL3pa0YNtpdced/qclBn6vlnpFJpeY3sUsqxgKy8GQUgut8aG4T
         QzPg==
X-Gm-Message-State: AOAM530XV45EVITSsDw3agFY39cwW+o8LhFi8of0bOx0lv+IzOE+jFOD
        UDkvsR+Iz2WhmJ7oSb8JMC6EEPL/gZmTkwciDVg=
X-Google-Smtp-Source: ABdhPJyEKOBnlSSucIqwP73SYVcMjBmex1md4NEUPKqTypb4ai3EEDvOLKr/LJpcszyX9DbVlKVMYw==
X-Received: by 2002:a17:90a:7484:b0:1ca:8db5:3f4a with SMTP id p4-20020a17090a748400b001ca8db53f4amr6771253pjk.195.1649075586824;
        Mon, 04 Apr 2022 05:33:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w198-20020a627bcf000000b004fdac356766sm12253866pfc.94.2022.04.04.05.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 05:33:06 -0700 (PDT)
Message-ID: <624ae582.1c69fb81.75d17.e852@mx.google.com>
Date:   Mon, 04 Apr 2022 05:33:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-11-gf359b5081cc2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 46 runs,
 1 regressions (v4.19.237-11-gf359b5081cc2)
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

stable-rc/queue/4.19 baseline: 46 runs, 1 regressions (v4.19.237-11-gf359b5=
081cc2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-11-gf359b5081cc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-11-gf359b5081cc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f359b5081cc2e28707dc700f2949ba846c30eaca =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624453383f24dded2fae069b

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-gf359b5081cc2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-gf359b5081cc2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624453383f24dded2fae06bd
        failing since 24 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-30T12:55:09.618538  /lava-5980478/1/../bin/lava-test-case   =

 =20
