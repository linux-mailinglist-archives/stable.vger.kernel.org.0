Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7385EF48
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 00:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfGCWzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 18:55:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52421 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfGCWzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 18:55:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so3800710wms.2
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 15:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=We+o/j36bpuWtN8+9foORejIMtHCnbq5tVy4XuNjR08=;
        b=qoKsGyj1arM39taP0CajaatgrR55D8MHoVSJuf7r7LeZyQrAYFcbQunzQm4Wyh+9f4
         WY+Q5skYb0E/JGCU5in/8ydeOu0H264nnErmLW6ZAEtPHX1oSXVrzpTF8hi6h7ByH/ov
         SUeQY8iam5gyxXCZSVhctu0Yz3dLJZvlyC+JlpLa8zfibfAlN9dN4OWrxzRTI0dYi7zT
         xi4o9/ycRUD/6dDv2wFpgVFZTO6xAZcnSzLxjeV36t4qbAtsbCztZA7zYfZv+8F35e8b
         iPM//QHYmx5op/OGpXHO70pynXRkGyOif4frzTD6IfjCh5BSdk2ETecil7sx4ykBae3A
         3ifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=We+o/j36bpuWtN8+9foORejIMtHCnbq5tVy4XuNjR08=;
        b=rk65bc50rHZSi1xA5V8ZEcC7oSzukYba+9Ue+X2uJT1YmMw7NfmW2yBHMzXML1PC98
         /Tqebn/M4lLQOhsXY3zx7eGlRhedr4zhEKR7PRAWDpQ8gFKWF5R49aXqK5eCZpbmBD0N
         1MdT1160+ifBlyHjU02GjYaS/rJc3JDIxS3CJ2kxhrpmAwL4E/V0rT7GgQcEo3CD6YcM
         qSgRuGa3iCGa0lqsMVZpwwkghyORvaGgIGpKJjlWhMw0J9D5gkUulxOzt/5E4pWx7oT1
         /wWn398PVGPI3hzuVVDS0AeoMnNJTLRPRahCvgy8SH6HAQyydPQlqggYfq+d3ILkHaPY
         wuTw==
X-Gm-Message-State: APjAAAU9AyAjpBvUj2Y1jjRj8YJhTnTlk8vycrEVHAjbsrf76na3PfIm
        c7gEdMI/KN5m5m4/kTA3lCOQnlTwLRigtA==
X-Google-Smtp-Source: APXvYqxb4PAGJiRuhJQWw0Ptax7lUU1Y9jB+fxbDy9b4Dvq1mIZpFKKh0BPKb9Fu77aOtWUa2YoLrw==
X-Received: by 2002:a7b:c051:: with SMTP id u17mr9214737wmc.25.1562194530944;
        Wed, 03 Jul 2019 15:55:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o7sm135642wmc.36.2019.07.03.15.55.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 15:55:29 -0700 (PDT)
Message-ID: <5d1d3261.1c69fb81.19b8f.0d79@mx.google.com>
Date:   Wed, 03 Jul 2019 15:55:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-49-g7d3f5931514f
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 4 failed,
 95 passed with 1 conflict (v4.4.184-49-g7d3f5931514f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 95 passed with 1 conflict =
(v4.4.184-49-g7d3f5931514f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-49-g7d3f5931514f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-49-g7d3f5931514f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-49-g7d3f5931514f
Git Commit: 7d3f5931514f4a3ff9d60f6ccc097de0966e0b35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
