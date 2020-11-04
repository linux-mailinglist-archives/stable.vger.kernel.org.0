Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213832A6CB3
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 19:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgKDScY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 13:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKDScX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 13:32:23 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC124C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 10:32:23 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e7so17972714pfn.12
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 10:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rO47TbW0DVOkj6AuCoKES6NxNr4FBF/Suzzk0bDgMik=;
        b=IU+xhf6RYopiOTarWqDskECVaVAu6WxvDGM/EqdnBEOIv8MR2dtXMIOqq6GE/J5Mjd
         RdD0LmLew2XI1dpBgqHa6ZPtRlR7vCu6M+2Vf+A/xnq3yidCMHcwhjZCP4BY405bJrF9
         1esZfbMmf/rKPKd73P4oZf0MHOqZ1CgjhBrn/XsHhZkHOxtRRmPr1+4m6ECBzzmitGmP
         rBhbViEWKdAN5Qj7peTdtVp6oa2++A54aLKvlnxHAxZ4aI4Pu3NGcNrDKYVPX/TU/Ju9
         kL6B5rIyEVH1GoNbFc80ZVU7KFfFBwVew8DuiiwgeJ8gZmmwNz4oBEuMKWnV2Wkyuhre
         /exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rO47TbW0DVOkj6AuCoKES6NxNr4FBF/Suzzk0bDgMik=;
        b=r67seEVEgF85H1+BgIebXs2I88IrCw2U+W8N5l1/2uEYT0NmA7iW8anv8WOgOMUviH
         0fNueXtGU1oY1aM1RJ6H5njfYc4KLnBw7SjhF+yi7C0qYqvCfVDLjtrppmTkFAIJecQT
         LW/QIfsplmtnllD7W+mMmT7LoOiaqkTMa4HXqQ03l79EicseGillZPNRAfBjrNQ8d3bv
         UYheTTusIxQ/VrjHJTqIkNU6jkjxuJwclA1o6PUTaa4J7NNTzW7PULIQnndh7QkQYApd
         wFDuL/6lWVUL/OtuETtLqIlPZ8xOIpV8UasgzgtBQSBmHIkGVLn7Hh6t2AdfaKJQW3NN
         azUg==
X-Gm-Message-State: AOAM533VazF3iQ7lxBG8G0p4rAAJaMTLiHVeRreTX+oXRR6W81hbR9X6
        hTGYHIgKtzDiZOjDWQhzut9e8BpOdqFr+Q==
X-Google-Smtp-Source: ABdhPJzWFIS7Sx2cHPp34tqgw3rF0hZGv9bV3IQZQ+kBwVE2FkMstb3Zwvsguo0jlJPRdkTL7UO65g==
X-Received: by 2002:a62:6487:0:b029:18b:70d7:bbb5 with SMTP id y129-20020a6264870000b029018b70d7bbb5mr1968832pfb.6.1604514742978;
        Wed, 04 Nov 2020 10:32:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b185sm3057212pgc.68.2020.11.04.10.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 10:32:22 -0800 (PST)
Message-ID: <5fa2f3b6.1c69fb81.674c3.692c@mx.google.com>
Date:   Wed, 04 Nov 2020 10:32:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.18-149-gafeb359ccd03
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 219 runs,
 1 regressions (v5.8.18-149-gafeb359ccd03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 219 runs, 1 regressions (v5.8.18-149-gafeb359=
ccd03)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-149-gafeb359ccd03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-149-gafeb359ccd03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afeb359ccd0361054242d753d2443e197964a8f3 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fa2c3a357fe73b4f8fb5323

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-gafeb359ccd03/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-gafeb359ccd03/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2c3a357fe73b4f8fb5=
324
        failing since 9 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
