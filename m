Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671093AC25
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfFIVwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 17:52:44 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:33355 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIVwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 17:52:44 -0400
Received: by mail-wr1-f54.google.com with SMTP id n9so7229891wru.0
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2SWyFvEavyrqCv7g0qg3nkQ1nJujvkYSoQyWpe8waIw=;
        b=uS/Pn2VS3qYn4qFKb2h8niPUgfXvkS50CKWByPve/O0GWJLwoKpQCT7UgCYDgs4NNI
         bbaOGTQJ2ZiX5kCtJyEjn22TwCRf3eq3MKYPFlzcGfuAb9UjkbttJIexx7TZ7yVTviTz
         pNwJlEwIsGR4yOeEVT7o+tM+ZMu6h/VvA5Q55JNEf5FSUssOWf4oEXFPEOE8gvYX8yUw
         WBugUQ0pMdE3/+5NjPi8MJQOwDBTlbh6qA3phgFuDpPfMRnj2a9hrh34uwjezkVwGUQl
         8/lXvYqg1zeC7IoU2nZ9UY+G75Z+fzvEr5GX92XYKNQ9M7b3BBfDUvZ/7TPmrn8FcRWd
         Ej7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2SWyFvEavyrqCv7g0qg3nkQ1nJujvkYSoQyWpe8waIw=;
        b=Rt+x62K4INjzanPV0S8ua99kOOzI4oNW14456Uta422522gOwR/uHtMD4LC+h3ZKrn
         r40oVZb4S9z4wUuBqM1xxBx5hjHxtf+siAW6LpfMG0cCEa0LIH41WeMhjtH22tsR1Ed+
         8eCCWWR0ZYW8wf8vqyPapviT+uhbPScGlAORZE24rWaYLfXaSZUvNnPYRSTZMO5QwN6w
         uUZ+75/gq50ROvJpjcg34WAuutqshf1N8DVOI2UqFVIDQ8qXuZwdcoV60EwhftmkFqDw
         gYM17ELNcTuU2Zg1bh3XuNgOJhxDZj2QQd+NsJNwvulaKe884OcbLMgQWFWUInDjXtqr
         CffQ==
X-Gm-Message-State: APjAAAW0c687UJWlVanrYa5dr4MeWU/JJx+8OLZFzeu6IqV47qmXCxa6
        KidwwlOXGzEj7LEoqqqMUHn/Tum258I=
X-Google-Smtp-Source: APXvYqyAPlkv2TKzbtdseuxRAXn9SP5b25m1Z+vfiH7CHg+9oALCwmyIRezAft0DxBSE3z0AOiCxCQ==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr13948940wrn.285.1560117162761;
        Sun, 09 Jun 2019 14:52:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x16sm6630634wmj.4.2019.06.09.14.52.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 14:52:42 -0700 (PDT)
Message-ID: <5cfd7faa.1c69fb81.6a8f7.5b3d@mx.google.com>
Date:   Sun, 09 Jun 2019 14:52:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180-84-g4fcf72df7bc7
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 107 boots: 1 failed,
 106 passed (v4.9.180-84-g4fcf72df7bc7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 1 failed, 106 passed (v4.9.180-84-g4=
fcf72df7bc7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180-84-g4fcf72df7bc7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180-84-g4fcf72df7bc7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180-84-g4fcf72df7bc7
Git Commit: 4fcf72df7bc71264d86e616874a0a0cd382f1b12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.180-62-gd9b5fd7ab1=
7b)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
