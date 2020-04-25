Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38031B83E5
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 08:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgDYGId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 02:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYGIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 02:08:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CDBC09B049
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 23:08:31 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a7so4797260pju.2
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 23:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NIP8x6COALe+PAcRLPvW3+cMxfV6zFW7Hw7bmO/zduA=;
        b=QMqsORsVf9q+as/L81SxvZghoSoYv02AK4aFdrkBSelCNf1eHbYObKjZWXIsU1BG9n
         GRCU8nSqzrG5L+Fb+WR/VegsUMJD9f7g+9j2lv9ZYx3quse7WFVgY2gD1ujuP9CAdesh
         3/nGSWN2BDaBoOne9lknOl5r/wBTCong7mzuJZmVxzNtCbUYv594H5M/yvi0sVqIupka
         2pE8gq8yHYPVBmox1o1ZLgy7LHuUf1xhAsdf6+dEtIq5iv+J/AYElRzo5+VvZPSVT0D0
         3VoGQXPwZdiEgvbugUZ9R8/chBPrCvpnEn3VucVmZ0gqpEegnAsmi2RorFEGdZplqgl1
         8NbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NIP8x6COALe+PAcRLPvW3+cMxfV6zFW7Hw7bmO/zduA=;
        b=hPOLd+YJvK9EokZ++aqj2/Zy0mt2P3/Nw45hYm8RUHkSXt72IcWH4/gqB4dGe4WFyj
         TTGv169DtfYHVH4IKpZrkX/Hq2PMFLlw4UWDQED3FmcGUAmG1+Z+60PXi/xeIh0KkF76
         0ZAPrRedyY93UF+vHuOnN4ocUvHrNS2YZobJH+OApZCoEjtQw07dGXZBogXMXQw4plmf
         wrt9SfPhSb3y6cywxrHtVdY396xr1NTzsGB/9/zUuwzf4h7zCfqIpG39LiTBqCuObKso
         XvN0v41AZajJVuBdJIk4o8Vo7Y7ZjO2lE73axs8OULviSGLxQ+ilY76LvXUMvQ6WBp/X
         tFCQ==
X-Gm-Message-State: AGi0PuaXh8dX6yeKdZ5MdPdbpDls9b0UHVadd+Sw/1VAZvrlMYk0Audl
        7UCcXRPmsvwGONOHlWeArIDHFchRSvM=
X-Google-Smtp-Source: APiQypJpHOohaXcZhKYgRGp/G10kXglqgAkS81xUSvizD3JiQ7NadFKzvgwoSgsTVoVEEmh+v4MNIw==
X-Received: by 2002:a17:90a:c481:: with SMTP id j1mr10639258pjt.5.1587794910293;
        Fri, 24 Apr 2020 23:08:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9sm6207063pje.47.2020.04.24.23.08.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 23:08:29 -0700 (PDT)
Message-ID: <5ea3d3dd.1c69fb81.5267e.41cb@mx.google.com>
Date:   Fri, 24 Apr 2020 23:08:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.220
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 51 boots: 1 failed,
 48 passed with 2 untried/unknown (v4.9.220)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 51 boots: 1 failed, 48 passed with 2 untried/unkno=
wn (v4.9.220)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.220/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.220/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.220
Git Commit: 0661b3d6cfd774e28a2e2ba90a3d87479e5c399b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 11 SoC families, 14 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
