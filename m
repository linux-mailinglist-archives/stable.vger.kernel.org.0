Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85474DD3E
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 00:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfFTWLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 18:11:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37807 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfFTWLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 18:11:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so4574277wrr.4
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 15:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=mbYFTh6bazxqWo9R2yJjJ1/62LryVwqMQHAl8inkfY8=;
        b=fx8SHCFYj8+ekg/5IL+B4cIMRixAzUC2mMLglXUFG8a0a4DrqVNCDYr4DQ0ztR+15g
         0IX2NUPnNWhxcS0iqJ4+VupcDWFGo7zHbmByixSI1nacq0LI5hKCZ//vZ/KPwnyHSCpO
         4As59nXUwzDuUQvslAPEe+5LkaKL/a6zjFBGwIDlbZlz+OcyPAQCBdyAyahFwljWQ5Xo
         j5QOlOX42Jd5boBQA7P1Ervd7WIsetrKt3CUc0rzBMKdDjm+nFJxGOMqOx/LMuxLkP7M
         zIixdThhX7X9CicKNcK+rQX7D9DdyPIGSWDjb3DkfUEoNUWAyFBirRkS++yTCUZ2IjL5
         dwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=mbYFTh6bazxqWo9R2yJjJ1/62LryVwqMQHAl8inkfY8=;
        b=EptquOswtroF2As43EFZ6uHMffm8Em28V28xpxs6vLXD3zGMowQB5Vp2WN+9ouMGH2
         7H9Yp85Yz8OX9CKGe4Y1BXwqKAh/UpFmoe7ZpCGm1zuVzdo2XO3AHrhW43lIEdx6lqsK
         GhD33gqbtfzIis6zoDWTFbJDpIzJOUoRwHRywUJydFl6OtJlfl1mrRAaF3BWSDeUGQOc
         ZQI6sXWKIBY9y+Pe5NWJlE2N86gfW/1q69Y6Kt+G0NE12xZanVZpPCvD2mGPlv7Q4RPv
         GO9uhStwywOlM62s+UcldcA5+OYOybyoYfBb6Wa2f3IDA0sBdxyf7iyB7nJPJyMhF1Tp
         c9/w==
X-Gm-Message-State: APjAAAUrtaC93H98FBpcqTs5p9KQ8P5CpKfDV9Ysm9pmDrfsE3+F9WAW
        F6O/qfdG98qk+YOxBdb1ydtJaw==
X-Google-Smtp-Source: APXvYqwco75N024LNpbRiHjtMlzSwUitTMmkymBba2UxnLOWOikFVoDkvcDMvidvTsjDzTpVCn9ItA==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr76614756wrm.218.1561068662643;
        Thu, 20 Jun 2019 15:11:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm1824598wrh.8.2019.06.20.15.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 15:11:02 -0700 (PDT)
Message-ID: <5d0c0476.1c69fb81.cef30.b578@mx.google.com>
Date:   Thu, 20 Jun 2019 15:11:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182-85-g847c345985fd
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/84] 4.4.183-stable review
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

stable-rc/linux-4.4.y boot: 90 boots: 2 failed, 86 passed with 1 offline, 1=
 conflict (v4.4.182-85-g847c345985fd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.182-85-g847c345985fd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.182-85-g847c345985fd/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.182-85-g847c345985fd
Git Commit: 847c345985fd296caa81af3820e8185f0d716159
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.182)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.182)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
