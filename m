Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F12D3A6C4
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfFIQWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:22:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38665 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbfFIQWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 12:22:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so3539960wmj.3
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9QLuQTjxzPLJKZK84/zH+YHQHlC422OC5uL/Ysm6xvA=;
        b=OZAlLwEdAFlE65rV/5Hm7rMy8Pn1kYmOtBSBxpeZ42dWqbIV5eh3XisLaCppzXSR3b
         gvrQLTVxfS5rYhc6sNVWLhZKRjRFuR6mdrMWELT8YF3qrXFabHbdzsnvUi01hpY3IDaU
         BX+bCz7syK34I77779uJyiWT6/dYFXJsFjFc4+fC6Wf4fNVOp9T805smuh3g/tw0WdBn
         xOjOH446sUl/coXuNH9nE8cxAttEiIHmdgzHCwSbAgQKgAYt9jeLVWsKm7XCamSFfK6U
         5rklX62GF9dXWZZX2kr8HYLFesiD2yAXQmhRn/d3gkW4yiyCpAvCCqc9egEY/Kg8ZkKG
         wLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9QLuQTjxzPLJKZK84/zH+YHQHlC422OC5uL/Ysm6xvA=;
        b=ReALS/1XfaDQgK7oDAYaSJpnrQ6XDxB9X/hAAUNSme0BZEB0/iDWwgN8kAVHJVKBB2
         UbixlVliRdEM22bTwLVTS4eis4Sc6YP2zRyjVOmjUoIJXogNjLW3svfkx6RQ5RdRas4i
         IA0WjcmUHLDk2BAksRclSdTKkBsPafEW5alfTtyeGSx9qhUBl3YzMy4TKis2Dqj/H1Ac
         UkWgkEpeEnZz5hD+zLkUCKeh74DnvJTayKc7bZkCUOGlNtpx8YAiAjCBYNPoJCG4UwQC
         oDeP41qiOdcp9b2ZTixmZK1VQDHAo8C9/XpYCL533wt1YLbsyXFc1NNNoiiG+iAP0Fe3
         NiKQ==
X-Gm-Message-State: APjAAAVUnYPtsGu6i6GDlPOU0yZZdIi/UeHimOy1JipJJTyE4eCLhjrD
        YAefYypgV5r2X3MeKYH4D0QeBSSu1DQ=
X-Google-Smtp-Source: APXvYqwjiGQvHxMgHuqtnumdYqoDOMxXrbTC+FAXKwFvOvHaxWxJGAcGK4Hgw5NGBwyYhpaRh7nZJA==
X-Received: by 2002:a1c:a387:: with SMTP id m129mr10647037wme.15.1560097333745;
        Sun, 09 Jun 2019 09:22:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm9543416wme.30.2019.06.09.09.22.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 09:22:12 -0700 (PDT)
Message-ID: <5cfd3234.1c69fb81.f66ce.83f6@mx.google.com>
Date:   Sun, 09 Jun 2019 09:22:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.124
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 63 boots: 1 failed,
 61 passed with 1 untried/unknown (v4.14.124)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 63 boots: 1 failed, 61 passed with 1 untried/unkn=
own (v4.14.124)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.124/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.124/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.124
Git Commit: e6a95d8851f1e993269b2172595107061f9371ae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 16 SoC families, 11 builds out of 199

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.123)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
