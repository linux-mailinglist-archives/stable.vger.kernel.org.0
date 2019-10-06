Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FF1CD959
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 23:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfJFVtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 17:49:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40900 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJFVtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 17:49:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so10416985wmj.5
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 14:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4tZ6Nhq2J7dnlz9CBacwwVAdRt/8joOETVcwqvRQoQk=;
        b=JsHbFzTzcro21dmLGpYxyzLbxJAVetD5ai977WgyYCFR7gNOYF6rfsLWFzOD/GjRDs
         9hCbMnA4uYGccov17E6CtCGHj5zPZuGNiJ/RaSHVEmqC5BV1AiVeSgZJlEh0h5dPcEzk
         tbvMDRWlBz4t1uNbv453gFj9BxXMLT77/1sCp/jNEWN9iAjmm+vMb68MK89huUyhNl7Q
         pCjAOxdi/J0U/xYpCfAeH4tpNR/gnD50OcAsfPYiftkqHBI8AGAgPxL5tmAj85fvzf3s
         UQJh8n4Dd0EzUA6PPCp5Pj+KC4WaP+6j/gWpVWd2B1NQlxaDgT68X/93srSQdJ7rW6eh
         uEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4tZ6Nhq2J7dnlz9CBacwwVAdRt/8joOETVcwqvRQoQk=;
        b=rfzDem0XgKVq+z5WhDVVPvLjjJ0VJCsf/3UIr9n9ctxR0kYlmGBd2EgNbq/Kk5JOm4
         DwBiLW1QG+64KpUJSmbHEfngfwYxJfDTDHLXAwpWxQ7nEUVErETtNjlHGpk5R3H4ABgX
         HSA8pOYhPxWBVkiOU9XA8BilNRKdLrk6KTHNVWhq7bLhYBsEZTzYzDHdp0pvmCpAZfE0
         CMqTOY/pNc2ytyyEpDV/43AN/LNkTxcRCmaMGMTIFx53oxG6WR2o5aitJShWC0h+9kcE
         AWztjAD0j1wiCWWz+EDzLsgg0ktekfLP6oHkFFp1S2IKuKoJh77LR25FYESp5siUDK7j
         odaw==
X-Gm-Message-State: APjAAAWxiD/FxTN0gnjdvbokW2BKKO9zMsYRg+g/ZnsmxM8NwatEF9hY
        tNgvv1v0Ah9LcGOZiT322dClxHz0ZFI=
X-Google-Smtp-Source: APXvYqxeYgh+HYmBier0lMZ0rfRfricjP9nkMh+rDPNwMwOnYTorf+s2JYaknGy/NploHGcVYqcYwA==
X-Received: by 2002:a05:600c:248a:: with SMTP id 10mr18103058wms.97.1570398582363;
        Sun, 06 Oct 2019 14:49:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m16sm9977598wml.11.2019.10.06.14.49.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 14:49:41 -0700 (PDT)
Message-ID: <5d9a6175.1c69fb81.a2996.b007@mx.google.com>
Date:   Sun, 06 Oct 2019 14:49:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.77-104-gb8e4eeef9f82
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 57 boots: 1 failed,
 56 passed (v4.19.77-104-gb8e4eeef9f82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 57 boots: 1 failed, 56 passed (v4.19.77-104-gb=
8e4eeef9f82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.77-104-gb8e4eeef9f82/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.77-104-gb8e4eeef9f82/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.77-104-gb8e4eeef9f82
Git Commit: b8e4eeef9f824988aeea3d39679438a17ea4a44d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 16 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-collabora: new failure (last pass: v4.19.77)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
