Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A10D24028
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfETSUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 14:20:01 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36584 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfETSUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 14:20:01 -0400
Received: by mail-wm1-f52.google.com with SMTP id j187so315639wmj.1
        for <stable@vger.kernel.org>; Mon, 20 May 2019 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HmGLQrCdMJnuW0msOlZFsmWFSYM8a4SlYwckrQhrmPc=;
        b=AKmEM96GzzF80vTUxEn+V4j3XN2StilenmBIqwtNR0sDyXE/5RKXmUIHoKXsCQGBG5
         FhkrPhhKbwCRRXtNAHPik0KvEKUKYuBEyWKKvxgXWwe+HSacJD3BLVfaEG47QI2/EtZN
         RTzzRXKals1OWWsAYdsAsukWGac191nM+x0qDdkGKS65WYBD8wilxQJpIXAW5jnzpGY+
         mrEd+vT7O1v32vfaM45hsw7T1cZClxHc2mrGkRALE9lrMP2x0fAu40i10B2ofYgbf21U
         l9EDYtWzd+uq42Oybo6iMu6HaPRigSsLg2OgBHZ+cNEAfCKYJesYCJ+hssUGsKS9bTip
         pxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HmGLQrCdMJnuW0msOlZFsmWFSYM8a4SlYwckrQhrmPc=;
        b=GmvkoEGmP7IxR7V7LoSRv15V7ZbujYtdN3AI9WfWHSq1Bz0eF9k//+kAqxzBb8kqu5
         0R4kxRdaXTituK78ZrrqyefKZEM33Tf06bmEAKyavQFTn/fgesP3lKjjw+c8XU6QbxSx
         flCUnLUigXoEPYBHl5dzuF5ZSDVkoC0xyA7XOZxAleDbRBbPocwt+pvZ4tJdoaQn3sco
         rBIaAS7Nyz9HymXxSQ/oLtaNWhBsbHX/HHDnHCrROZhPyz9s0Ev3emvqpFDuTerJsjiI
         +tBNG/1FpZX5Ntyg0rkQmcYFp0vrOyEus/cyaXVbINjTfFHXhRR0Su2v0OtALWh6/lUJ
         hTyw==
X-Gm-Message-State: APjAAAVq/OvMFIA5JrdmmVTaHVh1oq+OzPdSY3MsGZRAHVgO9MKPOGJq
        60xCh343PrZvG+SWlDGpVJeu+W+sdtSvKw==
X-Google-Smtp-Source: APXvYqwXVT5/pLEdWxv+EYxq4CdBue7wbzgTB22I7watpbwE6hDNXWO9Yw9I+4VKbYM8n1aCZjbENA==
X-Received: by 2002:a1c:9e8e:: with SMTP id h136mr320094wme.29.1558376398712;
        Mon, 20 May 2019 11:19:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z5sm488401wmi.34.2019.05.20.11.19.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 11:19:58 -0700 (PDT)
Message-ID: <5ce2efce.1c69fb81.6b9af.2667@mx.google.com>
Date:   Mon, 20 May 2019 11:19:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.120-64-gffedd7fd95e8
Subject: stable-rc/linux-4.14.y boot: 117 boots: 1 failed,
 113 passed with 1 offline, 1 untried/unknown,
 1 conflict (v4.14.120-64-gffedd7fd95e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 1 failed, 113 passed with 1 offline=
, 1 untried/unknown, 1 conflict (v4.14.120-64-gffedd7fd95e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.120-64-gffedd7fd95e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.120-64-gffedd7fd95e8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.120-64-gffedd7fd95e8
Git Commit: ffedd7fd95e8d03834094434754a33dbc060770d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.120)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
