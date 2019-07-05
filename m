Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F960E12
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 01:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfGEXNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 19:13:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52400 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfGEXNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 19:13:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so10537388wms.2
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 16:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UufTAgwINd9EAVqiqfcxcVKxw6laHzeLnE2aA7BrHFQ=;
        b=uE3J+4X+NCBkMdf5g7Inxe2xGb4OBG87J/RlsRuCMUpXwm0Cn3x6lxXAA73NBBZBsM
         6bGsSZBEYA+fo5DuNIwyeSAvoKAb9mPk0zHyNXl59mZgTw7kK6Umt6ZEq42YKF33lLLG
         /eSUKGLflutCq918hVxDVGxOSYG5Q5KmO9PvLTCxVJXU8d78Z1gfTOujXmfCFGjT6N2S
         mawvkIROvlXmM6ktnZqO5eHc5I3bRi6emjqCkpKeEGj9NCBfLyjLTkXXVQ2vjAX+grSJ
         cpBpFtqwG8HPAZJSS7x+junfqFpZ6NNqv7CHPCG98JFVefQ7D6LvOGGUFzA3Z6cKvEiR
         wu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UufTAgwINd9EAVqiqfcxcVKxw6laHzeLnE2aA7BrHFQ=;
        b=J2f0fIIbN4bjqTgFR5Ubs9EL2gwxiD4zgci/S99vZ/vHjN9Ditke9WJe6twf58iFWK
         oMAjfw1xeTuGV3grucCWvK2675qLxFm2/5rYasRAUmJQMqzvmOsBt419q1/Ql3yzR085
         8ERBirNbyy7YrR/7BkSeViV8YrG6Vs6vz894IWAeWWXqkHlE93sXxczG2MyGBMvjlf5l
         2BLLNEZY17p8toLDJglR0WqcsX/wbf7c76IqGJouIWlJpDLR4KWy7T0GPyBc9p64K1MG
         Q30la2IMz3ZGDGZLXtPca8J8r9mgJ2ZRFoOrc1bnU2oy7PHU5pj0DCEM19dgGi4AULsw
         /ggA==
X-Gm-Message-State: APjAAAUY/MjPISR7q906g9A2Xt2ENvncaMXf6LxB3xKUXpurVHYQol1W
        XGGu53/bfSDp0EVffMLbzTCRff34KbSUpg==
X-Google-Smtp-Source: APXvYqwg9HwhnbXtKaIgsVIo2xm9xZ4zGsFAkduyYTkU8G87PnYDxK/aAGVcxs6uSK1QCrzF9qmQ9Q==
X-Received: by 2002:a1c:7a15:: with SMTP id v21mr4826161wmc.176.1562368423447;
        Fri, 05 Jul 2019 16:13:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v15sm10092132wru.61.2019.07.05.16.13.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 16:13:42 -0700 (PDT)
Message-ID: <5d1fd9a6.1c69fb81.ef6a3.af8a@mx.google.com>
Date:   Fri, 05 Jul 2019 16:13:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-85-g925bedf91c6b
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 139 boots: 3 failed,
 135 passed with 1 untried/unknown (v5.1.16-85-g925bedf91c6b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 139 boots: 3 failed, 135 passed with 1 untried/=
unknown (v5.1.16-85-g925bedf91c6b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-85-g925bedf91c6b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-85-g925bedf91c6b/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-85-g925bedf91c6b
Git Commit: 925bedf91c6bb194cb6b23a553cb8469f3a2007f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v5.1.16-83-g4af32c555274)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
