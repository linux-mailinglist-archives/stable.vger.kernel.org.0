Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696D0153EDE
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 07:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgBFGq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 01:46:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46187 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgBFGq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 01:46:57 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so5687468wrl.13
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 22:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PZXNVm6uHqyk7jPiD6C+wUJAKoEklplmnTMN+uoKiw4=;
        b=jeO8nLsJUVwGnQNw2yprtZ2N3kEZ6zJM5gOE4MsnlyjzzQ9yPofkUYfOYXghlIZUMP
         xEOavOsdQ0XcDHcaNZiKqsZWLequVtOJ7Hq4TqzkO2bVoB3/Om1ahfgODBONUHnWHyrc
         9FbksmgDfyBNQ7eo8hsL90/NCCkHCKqz0a8A5RL+SxSZ9HNqxc8/Oiv5ZteIfxvjgoXV
         wFQXV/GZkRjKQuVdUkJQg7rDExA/6he3QmcS025QRMICAtixy6HhTB+oAH4rpjiO3869
         d3bhLhjkjiUawRjjjBlu/8YSnSJ8424/xXmQgJXx8uoWCdscd5nUmZ2V3DthIpgNCnDk
         iVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PZXNVm6uHqyk7jPiD6C+wUJAKoEklplmnTMN+uoKiw4=;
        b=klmcApbn+RoTcnuwrtNy5jF4aGhwHMlO2kSef2qTmhNVyuV9B5kEAg1rmoOINnpO2V
         xuGZjCXgdusrSiJqENDCheIOIAdxhI98F3fG1lEmYk3xKLAPoYxuRyCq3d1cUWnRvGUW
         h6/rRSEcvex0SUgfND38rJerdpeKSYxZs8lanBLMn0GwPe764YStI9jyk2p5PSTB4h6M
         e7gdHYWK97RAssnNk1f8TSXe9QeDdbmgDaf5Panw9dyiDySpdiJ1SnY0gEE61VBlO7qA
         uKZ8bs1UaGtZNKSKitxRJSRAsIiKy4BXklwZAyB+IRWfvUXw0vTiVYPcBAw0c+TySKDn
         yugw==
X-Gm-Message-State: APjAAAVYByApiLvgvhKRyhfa2UkgFBn25zoFVr9dsuTl4NeObMt39Zio
        QUPnDxEXhqz5fE+GmmlpTDd6rpLKPCQFjQ==
X-Google-Smtp-Source: APXvYqwM78+Bs8zqow+6qWzhwPot0Hx8503jKTqjXqCtMnLDs9oLBmNCLX4BRqGoVC5n35mFWbJ6XQ==
X-Received: by 2002:adf:ea06:: with SMTP id q6mr1941824wrm.218.1580971614947;
        Wed, 05 Feb 2020 22:46:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w26sm2427274wmi.8.2020.02.05.22.46.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 22:46:54 -0800 (PST)
Message-ID: <5e3bb65e.1c69fb81.76e15.9c30@mx.google.com>
Date:   Wed, 05 Feb 2020 22:46:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.102
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 27 boots: 0 failed,
 26 passed with 1 conflict (v4.19.102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 27 boots: 0 failed, 26 passed with 1 conflict (v4=
.19.102)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.102/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.102/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.102
Git Commit: b499cf4b3a901e87e1f933df04abf69b54de4457
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 9 SoC families, 2 builds out of 15

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        am335x-boneblack:
            lab-baylibre: PASS (gcc-8)
            lab-drue: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
