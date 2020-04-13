Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF01A6743
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 15:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgDMNla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730085AbgDMNl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 09:41:29 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B022EC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 06:41:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w11so4442206pga.12
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 06:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cnGfdlw2Jh1gUwTmXUlok1FHeaGW0WINmo0nXPJbM9M=;
        b=ebz7IjpfA9HAQqi6KthJxqgqXr/hPxLJvXkkO7JFMv9IluFgI+0lp8MJPyA/K+zHCJ
         mvujL3shnbqV75K8CSTQxDAgmreNa/qhG6XL0WFA7rSIFmOEgKcRoxUKfaGfYuE6C/jV
         7Sx9VFdTUkL4wse1pE7nIRchGiBuyWlzERmbG4Z8fra/rkrUNwdpz4WxUqKdKaKR/Rzg
         Fm1Hlly8gkFMSOgiGd5gTBMV8GfwZ5v0IpUQp/ZifVdjK76en7DNrmwhdxw9TNWPkNPt
         uL861Ki4AzhvTUKjro1LhcWdAvq6B8teYwLxn8e+coji+zsx2D5YV2Tnvo5F5ogmb9gR
         pmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cnGfdlw2Jh1gUwTmXUlok1FHeaGW0WINmo0nXPJbM9M=;
        b=DCB9UY7TQ1u2r7lZRhEM3SsVAJHxoeO5cmuNy8Gyuorjf08P7ESisWKjXB+W+a8Eh0
         a21rqRiR/yGVE+qtV/8+G69zSnOMXUufUebEDVusUgcbP3xMGZEevVyxoo0V1jGuU9eb
         auR1GjSDcxvh8fsoVcDLQOTr+2DgcDFV+4czDKsgT7xiX/sGgJ2udotdFsPQo398/K3/
         CCP7ibjECb9EXUR+7R3dPxw12ZT1K/S/JlqQKKA19qhMfpimyZq2LT3gYhXPolcpwo/g
         tz2PoDTuccbCtNZZ18RQlfeaISBfTC0bA5uaw0JXN5UQE1Z4dEGtV0mdjQ05TrD5C4ef
         /7GQ==
X-Gm-Message-State: AGi0PuZPuupszKamvIViPIKc4PEIz34ZOzn2I4ecLkklWVRKGeUv2XQl
        9Ocd9asMHm3pF2ljGKiYdCcU4QaTg9Y=
X-Google-Smtp-Source: APiQypIb9Usg/AFC5XKXeQqe2Q8xKFv8UC+Rvw4+QXX0Hnw7vg8Ag/qayddHEA7qTPMKbB6QxOEkfw==
X-Received: by 2002:a63:f957:: with SMTP id q23mr1241352pgk.87.1586785288968;
        Mon, 13 Apr 2020 06:41:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm8910222pfj.108.2020.04.13.06.41.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 06:41:28 -0700 (PDT)
Message-ID: <5e946c08.1c69fb81.a2709.d443@mx.google.com>
Date:   Mon, 13 Apr 2020 06:41:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.219
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 35 boots: 3 failed,
 30 passed with 2 untried/unknown (v4.4.219)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 35 boots: 3 failed, 30 passed with 2 untried/unkno=
wn (v4.4.219)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.219/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.219/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.219
Git Commit: 10d9c6f92756c1b9049e409cd5e7faed40f95294
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 8 SoC families, 12 builds out of 190

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
