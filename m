Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8D1186E94
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 16:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbgCPP3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 11:29:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40269 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731483AbgCPP3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 11:29:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so10119762pfl.7
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ra2vHmVPdJ9UqKpGtDAR60J52SLVzqyVFiqo+p2bgT0=;
        b=TdC/S7ngbYc7Xu9cCesCG841A7ZvGX238GoiBz6bjKE+X8RF3aonZ1RQaj476qEgkc
         uTWc/xJDnn98zL9i4CQPgo+jI2kPmENb8+14H4wHK5KpcXXCBAHt4jjxmQRBskH/xpqe
         p5wN2wN3imthJAFK4lS/AlIpdmt4j2UkO/jVnCox7XMpYAHiyFKInPGv+07BCD4UL0nX
         Di6N/ZST4um/RqteqqnsRnCWxJ6XURNAPlahNs62VbXfkLcJuqAT2o3tBS7n6F1Qoya/
         ycQHvfEXx2SA2FFKkfxVQ5TOjYxbnE3VHHTU0N9Aednt0IEpuWdA3CJ+eurvP5xUwaBS
         HnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ra2vHmVPdJ9UqKpGtDAR60J52SLVzqyVFiqo+p2bgT0=;
        b=KwsqJoOmU4yPYbnuzGiiQj/ezudURu/TezHWDE/Xcwbfr+VDadqSqojVBTVtmGGreH
         wFhkMfJ1YsnbaSVci/mRXh8y4hYSUrTbPz9jdzBN1uGvc89zhiD/tTYDxx8LufT34sGS
         k3hvkpH7Quhrpj9LB22XaLNEieXrS+kpcmLk4dVPfKc6ijYtfHLznAFDU65j6mu2X6EH
         qmygwV6vNdeM7RtpLfzVXvUWkJH2wDEjvvswKhNYpRF8mL4yfS3UnUdxF/6SbVHhZx3j
         tDPi9/idixulP2HFsLBAejdyiJ0BUUJkoUCEPra3Rco+iB8nXzfYpJLdwhWHbnmTMjEK
         4XaA==
X-Gm-Message-State: ANhLgQ3clhh22Z/reLMerdpf6s+JY8SiSFp1UG8HQohpB0YDs8STyWlt
        6mhl9G4eQhwdIRWoCsv4wXYgkuQ0wlU=
X-Google-Smtp-Source: ADFU+vsg6Bqpo8aXyq/rzHEt1zdbbdT4of0BbVG74/oXAY06vHd3hwCyyHrF4JNrpUSuw82WB4r5sQ==
X-Received: by 2002:aa7:810f:: with SMTP id b15mr183591pfi.17.1584372594210;
        Mon, 16 Mar 2020 08:29:54 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a18sm287042pfr.109.2020.03.16.08.29.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:29:53 -0700 (PDT)
Message-ID: <5e6f9b71.1c69fb81.7b6ef.174a@mx.google.com>
Date:   Mon, 16 Mar 2020 08:29:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.110
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 95 boots: 1 failed,
 89 passed with 5 untried/unknown (v4.19.110)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 95 boots: 1 failed, 89 passed with 5 untried/unkn=
own (v4.19.110)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.110/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.110/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.110
Git Commit: 339485c9a80f3b9f30708f784346fef42ad127c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 16 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.19.109)
              lab-baylibre: new failure (last pass: v4.19.109)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.19.109)
              lab-baylibre: new failure (last pass: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
