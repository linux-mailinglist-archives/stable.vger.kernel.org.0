Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3941CCCBE
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgEJRq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEJRq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 13:46:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA18C061A0C
        for <stable@vger.kernel.org>; Sun, 10 May 2020 10:46:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q124so3417694pgq.13
        for <stable@vger.kernel.org>; Sun, 10 May 2020 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zDzlqYEcfm/gQZiOGegfpvY3ScZvlL1TGEeS5pXkd6U=;
        b=kzr/k5MVwMfdZq7YZF64x12OYd/DsIPeqUL0PuA3jRXKIcX8KSLxlFEI8PpoPjI4Cw
         C1HcFZ3lzNq85aOeB+RSE1Tq3icIS9gAUdFJ/pnCOiBnb5K5eXvTqsdjd1S0ZDle3Xcn
         LOqjYlX1AY+UNq6pLTd3+qUb4OLUnPqepI5WPKPQ2A2Rbk9jG0rYoCos9g+kHaYzEpas
         NZ1GrXsbuPH9zU64b/2KGc8eunUeQtGdloDcmdcHENgn/ktCUMxNhY1R9jrI4/Mh3ooz
         TUX8aDfCHD/FLTFRxslI+BwhIFdDVkbbOCY4G34B0sSzImajIu/cBOpU8Xv141hKemyW
         yqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zDzlqYEcfm/gQZiOGegfpvY3ScZvlL1TGEeS5pXkd6U=;
        b=N7NhC3ZdSNSAvQyZVrRTMvx3YpWCizPzEpa4bAgbJw1zgiNFpIkRlrgr2IpgdNvKYF
         Prpla96YSr9yt3qK/vGJqtb9fh+6fBpzkSD9a/EFr4NGdoxohjQtdelaNeKli/gtmIEj
         Cv0Gd5JiU8OTCgf5zLDHHA1BVwhHBmD3p9ZCq4osnCrvhP95u6ok+4ClIj6RKdybo3Yf
         9Z6kt60l86RJDwayFUwzpgThkTPDXop9tCyMuPLcOBZeQTCS/f7b4XsbGRY6B56qE7o/
         D4bDNlUXO7maUkT49uSMNbrrGr6f7SKLHgTC1TWORwLLG1Mu+BvsclLRmkR8HXf6yHGG
         gvbQ==
X-Gm-Message-State: AGi0PubDkBYSn+7rZ+jE79BU+TvQ6qxUQrTvcpKDiilRV4e070A/wo5y
        fmr8O4ZG0cCthn2H+eMcsdhMvFgGJQg=
X-Google-Smtp-Source: APiQypJqd96Hp5mhg2Z8+uR0cTpA+mdP+XXeGFMGcjoZLshxxX0c3NPm436+8FgYE/Tg/VWJ5z5rrA==
X-Received: by 2002:a63:d909:: with SMTP id r9mr10905475pgg.245.1589132815206;
        Sun, 10 May 2020 10:46:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y10sm7263832pfb.53.2020.05.10.10.46.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 10:46:54 -0700 (PDT)
Message-ID: <5eb83e0e.1c69fb81.fb7e8.9130@mx.google.com>
Date:   Sun, 10 May 2020 10:46:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.180
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 84 boots: 3 failed,
 76 passed with 5 untried/unknown (v4.14.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 84 boots: 3 failed, 76 passed with 5 untried/unkn=
own (v4.14.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.180/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.180/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.180
Git Commit: ab9dfda232481dcfaf549ce774004d116fc80c13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 14 SoC families, 16 builds out of 196

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 107 days (last pass: v4.14.166 - =
first fail: v4.14.167)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: failing since 50 days (last pass: v4.14.173 - =
first fail: v4.14.174)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
