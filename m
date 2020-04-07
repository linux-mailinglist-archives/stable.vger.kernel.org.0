Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5E01A1336
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDGR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:59:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38563 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGR7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:59:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id m17so2082058pgj.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hvgo/7ZK5DqglHbtiG5quxKXkpzwr+e/lruSsdj6J88=;
        b=oHbyBnnnUAoTufbJrc0ZMRLMoZ14pVdjeTWx5gK+9jc9dyGmW6hvIuW29e0+v9xDHl
         y8TUBSMfIpW7fRK7r7jRjSPLwZzEDrUkSRMZByiuH57CnQbGI/Mu7Y99LadiFx2Im0fp
         RBcWgtnyVViY1rrDXxFuIREXyOeGkUZ1lDIpLsWoOkfZDnxRbHXnfGTDSL9Lx5PLZ6/Q
         BfIcDIN5xg+l3FPOgXDeiOfbw05Epsrn/OdSw9mP62ztBQGi+KetonSVMwuLpo1FjsmR
         nX30VHoD7bF5nL+rIqqIyKYpMpJgW0KWHLclQReBs1ZL4LMuEhpsG1/KCkPHeJ6pmbXe
         DkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hvgo/7ZK5DqglHbtiG5quxKXkpzwr+e/lruSsdj6J88=;
        b=N1Q0RWcVXc87eTM69ppZk9VBBJN1xBdaWZ2KJS402YN9VbwZBVlmY4ZETJ9L52YenC
         Yuy07FH+dO2U8Tw0W601tRLFtbKUq8ZfWLkuwS0l/0UIwGF4/4nu6nbk6J4dT67dRKlb
         wZDGSkxBvLPVZ9FrxDHjinYUjNttulssK0jaZrAHQ2/lviKMPGLa1r30c9yXOmc1YMUz
         IwD4JnQC8bRDDRtjnsIXBC1VSdjY8R+lPEBn0DfP8lgjf3nZE7Y+LQ3vm8pWx6fFHP+J
         XuNO22OZWFXTYOY7ZXIZPx5P9opSDNQ88SIhPzv3hwYnx5BzMJZ0R9R7ok1xapY1mH/0
         bIXw==
X-Gm-Message-State: AGi0PuZ9IbK6GsqjDclFfyW7QsiKHEjoHCEWD03C5185yZ8RVlP7WtXu
        Rkri7uD3m68CcuzaBO2oFXPMFFDEMjc=
X-Google-Smtp-Source: APiQypJbp9/kBO78LbjUvVXZDCMGtf9i/e+72axClNpl/cDJB3fh6ZEikun5IAN+jnpLAgJNpaPn6w==
X-Received: by 2002:a62:6454:: with SMTP id y81mr3610967pfb.13.1586282342651;
        Tue, 07 Apr 2020 10:59:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y22sm14558326pfr.68.2020.04.07.10.59.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 10:59:02 -0700 (PDT)
Message-ID: <5e8cbf66.1c69fb81.c66c0.4120@mx.google.com>
Date:   Tue, 07 Apr 2020 10:59:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-37-g40da5db79b55
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 166 boots: 1 failed,
 158 passed with 2 offline, 5 untried/unknown (v5.4.30-37-g40da5db79b55)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 166 boots: 1 failed, 158 passed with 2 offline,=
 5 untried/unknown (v5.4.30-37-g40da5db79b55)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-37-g40da5db79b55/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-37-g40da5db79b55/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-37-g40da5db79b55
Git Commit: 40da5db79b5500c830fe36a40e26daaaeb82f6b2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.30-26-g701bb843eab=
1)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
