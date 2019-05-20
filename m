Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538A323E42
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbfETRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:18:56 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46738 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390154AbfETRSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:18:55 -0400
Received: by mail-wr1-f42.google.com with SMTP id r7so15454875wrr.13
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pxyI5TL8hvd5HHAD0U3xN7qE3cCe7FmMwI3QPHrSHyE=;
        b=VQdhFgHuaWA/rmGm1ng0yiD9NR3LcKwgib05/ob2uOU5cpIAuadfMpGia2t1Dp+uqe
         Dltkkdj5fYwxe+uvR34n7XIKcxME05Hq6EL+rgGrdrEk0w/zNBZxQ9JjVF/0i4oQXeHv
         hBcRzoPcLQt9B0EnbVDP8tfGBr8mD8hrV6TV1Xwnir43vxnvEwdNKMMQJ/yLhljRZOox
         YRYC2ozwmihc+IdeG8d87oyBLmNg+aXWF3w+fN7Gq4UN6YKFERxxV/LHqE4x+hk+wf4u
         W+17VrPhV7P6jhJO9gE8fvZc48/rt3LWerQewaHK+v4J45q08groRqXOLIrj7OPof880
         snAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pxyI5TL8hvd5HHAD0U3xN7qE3cCe7FmMwI3QPHrSHyE=;
        b=hxTdfPxSFD7auI3DzdZKuE6JzOjEqo6PpJFds+9I8LxlvKf1m7bj/s5qmPNpsd5you
         VMgto2vYVnxV9lmtwy6gOvdF2eA/AgpcgjIg1UVpZRdLbfU+TrgaRGqTwohSVRTEGO22
         6xVmEO7VqbkrLAKiBbfo9skqW5KU1XRIKWVPHb75TjusRMdJQvaCJ5JOE3VPzgTFhktF
         JFEbf6HfLQUjtiQfpYYVXvV3VDM/wA4OCyd2obUT3nCZMyufCet9NqAiG5gPYvueDCx0
         2Pc2Ed5UyeVt3Ir8cAmigr1vu5LOSSUyoCJQluzUIdxbH+TYx28jvA0CFDGlpxy8Wz7w
         VaMQ==
X-Gm-Message-State: APjAAAXg3f77f39UucIW0FRZ03Dvl5noqamhXefUw6pkuZmt7KH0ZI0h
        eqY92Kg+xc0K9aNgJyB4qa9MmjVTAmSL8w==
X-Google-Smtp-Source: APXvYqwTurtQLHrj3hLQcrkGJB7PIcFfNreonv+hj8DUOYpTds9Xqn2MHf3Yu2Wo5waP/rJ4p9bm/g==
X-Received: by 2002:adf:e845:: with SMTP id d5mr683814wrn.154.1558372734315;
        Mon, 20 May 2019 10:18:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z13sm14048653wrw.42.2019.05.20.10.18.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:18:53 -0700 (PDT)
Message-ID: <5ce2e17d.1c69fb81.939ee.87ae@mx.google.com>
Date:   Mon, 20 May 2019 10:18:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17-117-gc76436debfdf
Subject: stable-rc/linux-5.0.y boot: 128 boots: 0 failed,
 126 passed with 1 offline, 1 conflict (v5.0.17-117-gc76436debfdf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 128 boots: 0 failed, 126 passed with 1 offline,=
 1 conflict (v5.0.17-117-gc76436debfdf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.17-117-gc76436debfdf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.17-117-gc76436debfdf/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.17-117-gc76436debfdf
Git Commit: c76436debfdf5cff1e99cf15f44e49fa7b02664f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v5.0.16 - firs=
t fail: v5.0.17)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
