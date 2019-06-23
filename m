Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12EB4FD44
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfFWRR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 13:17:26 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38713 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWRRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 13:17:25 -0400
Received: by mail-wr1-f43.google.com with SMTP id d18so11368874wrs.5
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 10:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7BXRDH3Ki1I+2H6HEaSZgRhPCrDkvTIQxfTYCaweESs=;
        b=fnHORJ/QnLkjcJ4fUduMWrb3JG38JRCvLPJgTRxZrNapo7Iy8VMZwBOwuxAH5hs83r
         k84KSuzTmF8OebtfaNXvRYA6ylHK/AwQ/WnTCbs5hksPHEyg0ZBeGzehWlUazTGDwzyX
         vdlMhA838gyG60d3l4Pwr/qbXBog7NzcfFKqmqqrkF7/Dix8DpkT0KTk6NNWHkMByNg8
         xQqLlNQRMmIrdnMspjZIkYJXeb8CThHpUSLxxgeLjLZHoZu9bSksTPSPR+dki5un0be8
         iofeQQ6pmQyCRZ6/8xjpH/lxT2pLimQYqgYmF4NjskyfeKlUjZ6MpIu0iXQa4RddC9cL
         JeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7BXRDH3Ki1I+2H6HEaSZgRhPCrDkvTIQxfTYCaweESs=;
        b=G9DTy0X/IXeawZULfBiD7Eq0EVW/MhDPYDDVithNE86EfDd3ec1FnfAxFSckCH3ZDT
         TZ3qmpYXlyRO9j+2p81A0S6Yijh1MPdKtYJYXgBzClTDAaJattW03gIE4BPTBksXGjn7
         si7HUNGH17QywyzbOF2qvBSNUR/S7B3xZYKDc2/tLjuF+94xT9EfmkPWJ/OOHqQy07mH
         EsVgMnKd1cwTDgb83FWEdFrwWr1ZA89CDGUo5OS6CeyuMx3NBzTgZDzfLzPsR3UmAZsv
         VqV/jXbCZcdVhdia0SfA9ez3EcSjay0RVlVU8YnTPpaYamfCD7UswWF/54NRT+HDKCoc
         H8gA==
X-Gm-Message-State: APjAAAU/8fVoLgWNKHVm4H9aHkPQ8Jg0jbA9CynA8VO4GtbbRte1lDtM
        flYmUYBz+JvUxJlKomyUk2et/C8YyXI=
X-Google-Smtp-Source: APXvYqyc67dXdHZK3ZmIgprdTVcD4Lj4OzcLo0v3fWZtC4YVMMVHJnZO3UkQ5Hq4xm61Bbe76P+atA==
X-Received: by 2002:adf:e841:: with SMTP id d1mr42668072wrn.204.1561310243970;
        Sun, 23 Jun 2019 10:17:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d18sm6893503wrn.26.2019.06.23.10.17.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 10:17:23 -0700 (PDT)
Message-ID: <5d0fb423.1c69fb81.7f3d0.4a1a@mx.google.com>
Date:   Sun, 23 Jun 2019 10:17:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129-8-g10a845a8eaf6
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.14.129-8-g10a845a8eaf6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.14.129-8-g10a845a8eaf6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129-8-g10a845a8eaf6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-8-g10a845a8eaf6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-8-g10a845a8eaf6
Git Commit: 10a845a8eaf61f0c50ae1859d42422bdd7a4b696
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
