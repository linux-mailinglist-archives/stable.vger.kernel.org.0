Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17029CD962
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 00:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfJFWBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 18:01:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41102 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfJFWBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 18:01:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id q9so12937201wrm.8
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 15:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=NBscSK9/PABkrhGaoKEyted3c0aXOSPIsnMVHJZb4o4=;
        b=MuzBwMfZKO+1FSeQUfs6os+6Hc/54765JFNmSAz9oSN5jpQrcSWIiZIdZ1o3Fwjjf8
         Tvk561k5t8v02IAyO3kWJsqxps3Fgn29RJRomgAsok4u+pzIKkkQGovAHeh3WS37/yut
         fQyDnVuon8sVGfkMAhhopmHQ20KvT2kRsU4kbZrMXE9aUcB855j587q5H7VwJxn0ryZ7
         pE9esUNHeTvYtJgyatbJ6J+vRzA/6JT5ekut+b30eEx6Dnj+nf4QyXAgbHREdieGUaSU
         eiMS/cHF35ES4BG9ffX7zbdTGfWMz+2fz1C1jXMc0ny3LLXk/W/fz+8l+No9Q7dSJpaA
         CJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=NBscSK9/PABkrhGaoKEyted3c0aXOSPIsnMVHJZb4o4=;
        b=rISMLYF5Lf2pjqPTnvG/MozCwgXyKusi0ENlvhyaqUoVgY4e2R88d7if30tV8wPyPB
         +NGVoCs0lX8m11JbmixsyJ1L4f9/aMyWjfJwGgU6oncds16TdcS7mKY+QidbXXtoNjFr
         6oI0jfdf3VWDdl0eRVPODiSY+mtj/KLFYsA4EURfK8IcJyZQCe4m/Cdn4VSflYlMFjQ/
         y2PRA10ZU/aQwq+F06qntgzA6PB44p0keoWBkmNXB//HjlP75+h8V7OQ+LedEf67FmG1
         xzUp8kw0ffpedGUI66vEiboRcGvovNs1ArcyEpxmQG6euyaz1q0jczCV1wE5Xj7Lb0Zy
         RjQg==
X-Gm-Message-State: APjAAAULca4j1NhaYUPTCjT3loNYoJeE35OCT+yP/Sk8F1BoVnvpj1Y5
        e5xw7hFIDUlWNVqR7d4t/yMrHg==
X-Google-Smtp-Source: APXvYqwsm/vzqYRWceBIly7qGTPnqCTar/v9PCFAz5CxeO1eAQBcf54P2RgRIvBvp54NcvH2znIYRg==
X-Received: by 2002:adf:9083:: with SMTP id i3mr19624291wri.310.1570399277295;
        Sun, 06 Oct 2019 15:01:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm16776577wrt.45.2019.10.06.15.01.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 15:01:16 -0700 (PDT)
Message-ID: <5d9a642c.1c69fb81.92d17.add1@mx.google.com>
Date:   Sun, 06 Oct 2019 15:01:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.195-37-g13cac61d31df
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 39 boots: 1 failed, 36 passed with 2 conflicts =
(v4.4.195-37-g13cac61d31df)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.195-37-g13cac61d31df/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.195-37-g13cac61d31df/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.195-37-g13cac61d31df
Git Commit: 13cac61d31df3572c7a2c88f2f40c59e0a92baf2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 21 unique boards, 10 SoC families, 8 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
