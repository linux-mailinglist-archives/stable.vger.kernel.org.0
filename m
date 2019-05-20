Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39070240B3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfETSvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 14:51:31 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45965 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfETSvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 14:51:31 -0400
Received: by mail-wr1-f50.google.com with SMTP id b18so15720644wrq.12
        for <stable@vger.kernel.org>; Mon, 20 May 2019 11:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YzAXxaOC5xqVMd8/F/Ga0LPRdXuar3Jj9JxMXvVw7Sc=;
        b=CHh4wVRjK4Giz3Deuoswrh6miijkO/8gSQXh2/9IdrxEYnKpxn2oQf+wsG1oK5l8c5
         fvD2pJ2DUbI1aoK+vNqLK8zc1VPh6rLOHCAgBOIhDveOF70443B3ownEchXmbBLaBNut
         T1S1aJuELukfwoSPTuNtcxpTdFFZ/Y+5ErJnDdiNIkwzgy+9LgTD+IqVz41n++kBzqRQ
         XB1tq1UGR2JkZDhWAlyQCc5iiWn+DGY8jVpiz0XeqmN5w9bFY5ZVyK+KIFa4fpYlLIwn
         I7iN52olDHmwX+QMPfTLeMvatR+/aFLuKDqhz1cFLlhMatZEbIjOn2jdYE3n6Dnl/Vlg
         Ar1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YzAXxaOC5xqVMd8/F/Ga0LPRdXuar3Jj9JxMXvVw7Sc=;
        b=pjdkgIKKHFq9MsCBh9f1nQsdQb/F604CdLG37r3N8S3i8JmUZox+MRdrqZFGOYS4oy
         /JaSS8dJaopbWgqHHswtfJDDwETtJ6Lelz+Q0/slYXJZ0wwDYqZS4B6fBrbrqPnX493n
         vtOF4XqI6aQ1C9RfvqNHoDMt/njeUvnNgESlxhzW5pu62enDeIUHz0k4GSfXVXZ0/Yby
         a8uubxreOeNvf0+OCTHnePiaf+IHYeuWlqQtQ7GoNkMZotTjmrWWW4v4fc4/rJG20Zo8
         GjDQt79z8JFWKDHx2FYgh/TL3sKPCOxt4t/ptVwbqRWLCc98loOP5HJSFBHu0gUbqf2h
         TL4w==
X-Gm-Message-State: APjAAAUQoSdQJqWbHYJ1PI8uP345oF3KPYCEep+sEz2QwYC5vApYmYYD
        FiH0lw8VJHyZFPTkc9kvac1whEa+i3KjrQ==
X-Google-Smtp-Source: APXvYqzUsJIAvwlkIAPB1E4rZYPV0x6Lu+nZDcVsSJPTSlc6xMcd7uYHjzJ0Edqcsby18L+PRLxsvA==
X-Received: by 2002:a5d:4fd2:: with SMTP id h18mr12782984wrw.117.1558378289344;
        Mon, 20 May 2019 11:51:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm573978wmd.38.2019.05.20.11.51.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 11:51:28 -0700 (PDT)
Message-ID: <5ce2f730.1c69fb81.f07e5.2a9e@mx.google.com>
Date:   Mon, 20 May 2019 11:51:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17-124-gbb2772791a81
Subject: stable-rc/linux-5.0.y boot: 126 boots: 0 failed,
 120 passed with 5 offline, 1 conflict (v5.0.17-124-gbb2772791a81)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 126 boots: 0 failed, 120 passed with 5 offline,=
 1 conflict (v5.0.17-124-gbb2772791a81)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.17-124-gbb2772791a81/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.17-124-gbb2772791a81/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.17-124-gbb2772791a81
Git Commit: bb2772791a81b9bbda82fc5b02ac84b8b8b42628
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.17-117-gc76436debf=
df)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
