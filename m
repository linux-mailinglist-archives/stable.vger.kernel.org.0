Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6744A9D81
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376824AbiBDROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiBDROo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:14:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D31BC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 09:14:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e6so5633861pfc.7
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 09:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jct90KimDRldOmmlw8EU+EwmdGMnAPciTlm5UIjbFe8=;
        b=dT9vZDopDibOSToYq3T8Qyzuvhz/ma+WLRVLFzqWtFtIOLPtQV7OQdYSu2hpbzCS/0
         ec4UHtVvU2PjO8VrjZ9fxzQG/d0Wf9dL69jCyJY8yFhtM8SXP/8cRVd5SpIdtAmfFpCm
         5xSQmckKACrv68M89JQ9Q5DnWmmgO4PrIwJErtB/XMOBjVdkQYqj1s8OsrIjqXJ81EJr
         Q8INVR2lU0S0Qo5llOPAu+4TN1UiQeG5qOFCCfTAMyZDtqoiqGlfHP2pg08Df9piR4Gn
         AaTnu7lRjXN/lAdUqHSYoQx+4ut0JhDwEDU8sFizQ0qCbepZAotvBnZ8kCsFQ03+O4h7
         ZzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jct90KimDRldOmmlw8EU+EwmdGMnAPciTlm5UIjbFe8=;
        b=xmkFqTxGE6MXlOJ1tA952ijcNi8s5RtYHR5LVL0cxYSfIxSTCcO3vSMy0d73vobmg6
         JyVG3UirE9sAbYZuKDGwa+nddBUCVf1F9XobnTNHuI6yqr+BtmFMGyNRjyi4uqx04sdK
         y8+wli19l9FLfGv00D+bPMnkPlbkvyHF/wKc0/nBGfmB0N66Vkzb/L9XNBtRdV6hSPlh
         4RqSRBikMf3KBhP+ehWLx82sPsBIQYBNSIuiZmVQulUG+Sa4mE0sJOTKgYdnsFa8Q6sd
         88F0q5K55qK7CppcNWXuV8PsBCi8S5TAo2MmSYiykRaBxs/ZVrs9KZCn0oSkMkEv829u
         uG7g==
X-Gm-Message-State: AOAM532p/+bhGA1f+PegPgyG69r59YI+o7KXnAGvBct7IL6XUbi30naD
        Jp1Xqu1Rbc76CEeX4+mzvVQ+FifZ+XWQQqBT
X-Google-Smtp-Source: ABdhPJyUe89bqKd+VGwLedcEGUHa3C1Q5CSZa+qnAdBmpc0HTHMckNEBRYLSWzg4MAKGWBt31jfAlQ==
X-Received: by 2002:a63:ed13:: with SMTP id d19mr3098327pgi.335.1643994882985;
        Fri, 04 Feb 2022 09:14:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm3363482pfh.173.2022.02.04.09.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 09:14:42 -0800 (PST)
Message-ID: <61fd5f02.1c69fb81.d1a67.874e@mx.google.com>
Date:   Fri, 04 Feb 2022 09:14:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.19-33-g3f3ff8b0d873
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 130 runs,
 1 regressions (v5.15.19-33-g3f3ff8b0d873)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 130 runs, 1 regressions (v5.15.19-33-g3f3ff8=
b0d873)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.19-33-g3f3ff8b0d873/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.19-33-g3f3ff8b0d873
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f3ff8b0d873c10fc358b6fc00119cfe1bd1361b =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd27c5d94e96a81b5d6ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
33-g3f3ff8b0d873/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.19-=
33-g3f3ff8b0d873/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd27c5d94e96a81b5d6=
eea
        new failure (last pass: v5.15.19-4-g6ea0b6ac4866) =

 =20
