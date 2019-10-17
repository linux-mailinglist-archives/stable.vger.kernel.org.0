Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1118ADA29C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 02:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387667AbfJQAQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 20:16:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38946 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731644AbfJQAQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 20:16:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so245430wrj.6
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 17:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3pn+zb/J1x9Q0gco+xjHeLwbk+I1z+PjLH54ZxyGGKY=;
        b=sG1PtGwfJRXxIWmO3BBpZHK8G2y4uWE7SXWoeAhhFw7iN9nDCXou531j2qXYhUPJWB
         Ugclrykz4QK3tiLpTZZfX7T9UzhELNzYqbYFChENf8fbiSMScLeLYSKaPXb7ewwjfK5Z
         904t93+v+qDiQ7R8I1FF7laGZmytCYMaqkNFKaYlqPku+rtq31+Q7fG5DZ65ttks5YLj
         1C3369jH1hqDItM9URxxmPzR8aLyR4a6nUIIJy9mkFquwWuunHU4Igv87kEKIaibAsbd
         8bZ5V74YkPULMRrJX9LlLavsDRHsQz3khP11chYgfqpa5hAoR6um478eDACqsPBS7Qk/
         qMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3pn+zb/J1x9Q0gco+xjHeLwbk+I1z+PjLH54ZxyGGKY=;
        b=KHzWWLjkJEq+kTycO9dglUzYqP2zyxQinPJinlA2BPRqz5kuDb+V/ImCGU76T9HUnk
         HfOVMIlTLLrvkY7Q5/qGkscsV08M325O7oFHW9f0mVRzYxRVrWe6xEHN/qXjaW4RWbyB
         P5SOUNubrPSB7wGxWW1xb/9U1+NBZlqarhIaAGq+1PW0Y7MEb1sBk+VDrCDp7jkURc/y
         qflgLHnKO2bCDaKF8lsgXB972wU1jXHUKekzua5mMEy+IKgqi045dzexnoQG+kwJCcgp
         uctZpup14Q04k5tk6s6s7cMrTtgqtvEKFrC+MozWVyVlLlrafz61S7CGMj4nYdgHDV2/
         7ibA==
X-Gm-Message-State: APjAAAWS6o+GH2RSGzUvZLOa7fC5sBhZ9zFaJvkiUA8MebLx8/9xLBpO
        r3XAssadYoAHSLDzZOmKY5LSgg7b/ss=
X-Google-Smtp-Source: APXvYqyTTvjGVMfsO6ykZWuYosABTR6urmD1qLq3SBe4RJnhwqEu2/3AWciagIOkUGiYHaMxarQIeg==
X-Received: by 2002:adf:f343:: with SMTP id e3mr395405wrp.315.1571271404976;
        Wed, 16 Oct 2019 17:16:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g185sm542114wme.10.2019.10.16.17.16.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 17:16:44 -0700 (PDT)
Message-ID: <5da7b2ec.1c69fb81.dae70.275e@mx.google.com>
Date:   Wed, 16 Oct 2019 17:16:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6-111-g62691bf9f844
Subject: stable-rc/linux-5.3.y boot: 99 boots: 0 failed,
 94 passed with 5 offline (v5.3.6-111-g62691bf9f844)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 99 boots: 0 failed, 94 passed with 5 offline (v=
5.3.6-111-g62691bf9f844)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.6-111-g62691bf9f844/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.6-111-g62691bf9f844/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.6-111-g62691bf9f844
Git Commit: 62691bf9f8443d9a341d2355c7a57532cfc75b2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
