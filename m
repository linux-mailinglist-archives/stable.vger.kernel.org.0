Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C944FDE6
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfFWUJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:09:42 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:46192 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfFWUJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:09:42 -0400
Received: by mail-wr1-f41.google.com with SMTP id n4so11569190wrw.13
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 13:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k3WB4vtYcj3l2+rsYlTboGpx6bKlz5tv71+Bgs+PYTw=;
        b=t2rM5/gvjE58Xu4sCC0fTrl4RcvQjZBQI4czHUbjUxI22tMyrUrAfbfPvIk1fI83Eh
         T7RU1jDTUWm3iLbeRUegJCtW6km8wsG+AZCNj8IHJZltwDrDiuYr/UWDaV1UpBIuEwq4
         OyEq6N7qtsm4htvrMVN0DmlyjyMdvoMf6odpXeape4NQjY8YTqRtoyVJk6dcDcv7o7Od
         IbJrTgIH0uloP4EKIQG8PEyUVo2XqKRY6/IxVZRRrcx6MJgAYHKRY4qoC9uLtsCO34hj
         RmAwdOs4fK+kvbEYviuCPUWjMVgeffq3CrKYae3K0ZKC0641ljh8zx/hNTSHlhsVsHe5
         23xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k3WB4vtYcj3l2+rsYlTboGpx6bKlz5tv71+Bgs+PYTw=;
        b=S47NeULgPRag6apxLTHvS/5+OEfQejxF8u/COQPoJxYIXNI93YPZH5/mpXmKCQIzaY
         Oibxahm1Z9U7yqreDcKihoYhWBy5OZ4cwl7vmwLcGDt0bJ62n8IuhQRHrIocqUicVSu0
         ElVnWcalkcJXTp44dc+RT+mlCzs8rFEWFTDxI9T8sj+bzasRCLucPm3rP5YQ5Eky8h45
         LnQ5APBbZxKTC+iOAihkoNx0QcUosqdaeI83rsQuV+k9Qbnh2bCAqNje/4yHUV+zM32J
         G9i8LqlW/inu9+6ex+i9kbDABFmriNG7UNi/UJZ7+G0UsP13kxjIjdIKLAQjSxzilD8v
         27Xg==
X-Gm-Message-State: APjAAAVp3rp9u2Q2UyrhzpMfpzBVlGJQEwmcAj9qEtSZU/Rkq6Lo3w/a
        WiwRehzrBUpY5MrlsjW+tLNzcmexHt8=
X-Google-Smtp-Source: APXvYqwDmvLUDi9+0Luhe5nCQP8xr+056nwj2Qmm9JhCWGM/NaoPeocROAaLUfYnVTpBcMMU4IkyKg==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr94046138wrn.31.1561320580072;
        Sun, 23 Jun 2019 13:09:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm7315856wmg.44.2019.06.23.13.09.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 13:09:39 -0700 (PDT)
Message-ID: <5d0fdc83.1c69fb81.58cea.724a@mx.google.com>
Date:   Sun, 23 Jun 2019 13:09:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129-8-g9b23bd257a25
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.14.129-8-g9b23bd257a25)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.14.129-8-g9b23bd257a25)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129-8-g9b23bd257a25/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-8-g9b23bd257a25/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-8-g9b23bd257a25
Git Commit: 9b23bd257a25bf099aeb0aea7f2b4a2b1ecce738
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
