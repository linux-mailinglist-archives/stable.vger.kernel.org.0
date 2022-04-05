Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF8F4F412C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbiDEOgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380544AbiDEMx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:53:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA6C4D9E3
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 04:54:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so2322369pjb.0
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 04:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J4MYRUdA/O6ggZkxANz9GrWZqW2+irvGkdmFzl0+Ikk=;
        b=NtkoA9P8PL9MdSif6sC6tnvo0Y/IC3OaGKheT1Ujbt62vaU1HELNUDFsOOiehLAF4n
         lYAGv+W514vJmmD7pIJdG/wcemJww0RT9axrMe7NnUZcED9CpfqSElKiaV4RDMhp5ZZf
         LDGECvuxFRQG/jS51GCLzv3soEoigve5eUDMnAG9pK0KOp9mYAH0APr7gP7VhgGa8DSD
         RFfurw9dZff/M5fobvBcdYQnncFtsR+eR3/vk8S8KtmkcNXC7S+B//w05b3MWukBX1Qs
         aXDN1bQ861Aec38svC7BulAAdrXEBOClCAN0zde21sQUk7lKE6cFrrc8zVkLatIxXIb1
         evJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J4MYRUdA/O6ggZkxANz9GrWZqW2+irvGkdmFzl0+Ikk=;
        b=OxBv2+wya9JXjHmEvsfMYe9UbgkJNUpOpddf29umSzrREi6/RTt4z/jbbm0qyIh7D5
         kpMTmWphS5mmuXcIRj+zH5wh2xUt0HFOuMsM5LxXJYYygJH7hu4q49OAsU+4z0XXHfg2
         KuPbpyadzSlDsXnZKstksiupfaAMG6DmGquyZYx6f9QnvmhhDIFRmCDGFW0nHl6Uri9l
         JuzpSLjDp/e3YOdVGnsAJ5Tfi2GWH4Unjk92xFbE1wcDCwE6kr60Kd31OKawJ2V5dUmB
         QNzI378xRVPoX5U+GmyGPrQG7UpTYUvNFtdEm3QYlzLhIYLA046WjCDHOzf1dIdCflLs
         7/Aw==
X-Gm-Message-State: AOAM533XYl0+YRkwDrH0O6zF65riCA2n0sI+EWx9WeuSEs7aTU5ln4lY
        U1PVvrElyExI1D2gPUkBcbZKMJ9s1IKEJD69Z04=
X-Google-Smtp-Source: ABdhPJznPxnVzPhxsEiIKUfTkjQloGdM/OGoI3Ud0zQ06kbHu04hmM7KFH/TKeGqMcWCMuTjNHuy2g==
X-Received: by 2002:a17:902:bd89:b0:156:8467:782b with SMTP id q9-20020a170902bd8900b001568467782bmr3178796pls.12.1649159646306;
        Tue, 05 Apr 2022 04:54:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx22-20020a056a00429600b004fa936a64b0sm14576834pfb.196.2022.04.05.04.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 04:54:06 -0700 (PDT)
Message-ID: <624c2dde.1c69fb81.7b575.623c@mx.google.com>
Date:   Tue, 05 Apr 2022 04:54:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.32-914-g841880eaff92b
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 45 runs,
 1 regressions (v5.15.32-914-g841880eaff92b)
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

stable-rc/linux-5.15.y baseline: 45 runs, 1 regressions (v5.15.32-914-g8418=
80eaff92b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.32-914-g841880eaff92b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.32-914-g841880eaff92b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      841880eaff92b260de5b0fe749c05c6371bcc78c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624bfa1cec7baeadd4ae0689

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2-914-g841880eaff92b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2-914-g841880eaff92b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624bfa1cec7baeadd4ae06e2
        failing since 28 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-05T08:13:07.192341  <8>[   32.519654] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-05T08:13:08.216146  /lava-6023951/1/../bin/lava-test-case
    2022-04-05T08:13:08.227308  <8>[   33.554663] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
