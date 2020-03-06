Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB517C00A
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 15:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCFOPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 09:15:55 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33197 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgCFOPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 09:15:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id m5so1160625pgg.0
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 06:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f0zsRG03jnn1MdP9gCStNinZKUTfTGP/ovjGO03crsM=;
        b=ikVT5v0evdTjbT7Sewr5PqQLwmxbi/vuJ1S+3sZTBULpG8XCWLzCcLGhP2seF72fa2
         2xKPhSn6jg4TWV/65jLeFTZS9n/bCDzN9dsB+A3+oDR2a5ti7BHBiffu4HvDjkKWsJWH
         G7v5rSNTbMSQoOLViNXqG8sP4/6IFbpDoqYbQRsEzbyo9jDtZoEMIm9Y3J3XostbK2S8
         QQ1anrRvgDLcWDz2AO/aDB9h0PprhfK3S44WWdPJHwbn0A4lx9DeSvgPMig7Do98Ywik
         Pjml8HJN0wiTeBt6ok/3zRfNi3hekWdlWe5wqTuTbDaQS/BbHx8O0NY2J2FjZN49gDKk
         hg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f0zsRG03jnn1MdP9gCStNinZKUTfTGP/ovjGO03crsM=;
        b=KOkRuH5BnBgI/Xaa6YUTYTMplXdJXqiRI727tLSfcgeudeoJ9QMp+Zaqgo9Wnx6/cE
         qTvhZnMIZkaVO6K/XLwUaioPu7LRPtyXMNMOeSS3x6IorcR+QKpgY9phTg9CsX0ZFLll
         ZdplgQJMRQKnhmc/hpcT0rJN5TSkkWBtTy0YNL/koRcekXc71pEkHUzDs/2F9q5OX+yi
         XGsrHG+0FuBxlxJBbdpgbqJf2UQTtJgi7vgptWCsL3kUm/fY40o0CTuUv7KUY/SJgM66
         7wArsSTHNQE86Q49nOw9aZQmRx3AC7hS5fS8eglrDH2DAoAsa5uKpVQu3E1p7at8ltOk
         vDKg==
X-Gm-Message-State: ANhLgQ0Jciq4BRRRjp7+UXSOziQergI3zLtiFXUtb/UG1w6YsTyXONXS
        S/PkFMwuU9XAEiBZbNIOVQzAPCZ1QTE=
X-Google-Smtp-Source: ADFU+vsO+FWr+F3oFeHSVwVtHZp92zxp4T99kUXADgQ0wwxKKoj7/o1KrxKwIbbflUkHdnw1wC1nVQ==
X-Received: by 2002:a63:b648:: with SMTP id v8mr3360343pgt.397.1583504153238;
        Fri, 06 Mar 2020 06:15:53 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a31sm20343417pgl.58.2020.03.06.06.15.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:15:52 -0800 (PST)
Message-ID: <5e625b18.1c69fb81.6ddbb.6745@mx.google.com>
Date:   Fri, 06 Mar 2020 06:15:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.215
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 36 boots: 1 failed,
 34 passed with 1 untried/unknown (v4.9.215)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 36 boots: 1 failed, 34 passed with 1 untried/un=
known (v4.9.215)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.215/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.215/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.215
Git Commit: 4cd444443b6f3732fbe0552315cc5e5b35112a85
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 12 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2836-rpi-2-b:
              lab-collabora: new failure (last pass: v4.9.214-163-g176b68c7=
2aeb)

    sunxi_defconfig:
        gcc-8:
          sun8i-h3-orangepi-pc:
              lab-clabbe: new failure (last pass: v4.9.214-163-g176b68c72ae=
b)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
