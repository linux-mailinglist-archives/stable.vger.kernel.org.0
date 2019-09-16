Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC5B394F
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfIPL1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 07:27:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50999 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfIPL1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 07:27:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so3858027wmg.0
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 04:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M9+YZh/xbKLMmAaBjVDm15lfoYoD7y8gI86XJtn/YSA=;
        b=mOqZTm3iTKl/qeEBFMW8qOWmaDEW9z1NJOasjsW4Nc3WUUI+gZfLucHaKwLBgrijaL
         agWZCmo44KmqLIP0NB6P3snrfCk9zT3fhPrMmQczIpFIOpU1UESNfkvQEpFl7Jdjyl3E
         FAGjx2ZROSH6WwMmFrnOITVl2aniQYFJW1WccNrL/+ho+FZ4xSVmu5onJsVA6YcDbO5K
         eIfw6C34iUCsIYedjKWGxCEw/CDrLFoNrpts8xtcocrpdlMcpOCqzHuVn9b6JoolyOZ4
         qvmawdwDKQaHXl2bypfswRwAWWUkVkjCZgdrqgD6RKqPilm/OBE98qO7khMUGg0tYmC0
         8fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M9+YZh/xbKLMmAaBjVDm15lfoYoD7y8gI86XJtn/YSA=;
        b=C1WrQqJmGiaH0l5eD0QHFE7vKYja9/yJYbrWf/dKPDISRzpU4D8JTLptVhVeK4FV09
         nhmoxYd0fy1guneW3Z3Z0PRIWYcb+fY0Vj9c185VeMuhfwlJcPi/XA+tTzNPDj7ixjLE
         mMb6HZ4gipMNAFMXOsQS2aU44q1SRyTCzX6D0kM5TBR1d+vkCY3HcpFK5fdSQo3oHtMd
         c2IUpftMiy1/fIeO6+nX3bBHn4uqi0sxQTMP0DjMCJTCXFYyVwAOKkC0+LiIj5sqNxCT
         1b73x9m9EYUHnbSvLR3zN7dLTTwfp6ylRQJnhqCn7bk+Ox8WgIl+JJvW0lCKWfltYfwW
         fslw==
X-Gm-Message-State: APjAAAXha0t6ftMrlkBrDCP9tCohtIIq7jiSmqnZUwHqrZroosinvM2z
        wCSrkfYSXAQ/8vnDngo1R18Z9pS9nYg=
X-Google-Smtp-Source: APXvYqw/nyEZdW5napyXn7KbcX9/y9quu5orn1nXEwbsLgd+o4gc1cZvbYr9mUe7vKgPFyySiiyHwA==
X-Received: by 2002:a1c:6a0f:: with SMTP id f15mr10843464wmc.159.1568633250783;
        Mon, 16 Sep 2019 04:27:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r18sm14979830wme.48.2019.09.16.04.27.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 04:27:30 -0700 (PDT)
Message-ID: <5d7f71a2.1c69fb81.3a253.1e51@mx.google.com>
Date:   Mon, 16 Sep 2019 04:27:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.193
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 62 boots: 1 failed,
 60 passed with 1 conflict (v4.4.193)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 62 boots: 1 failed, 60 passed with 1 conflict (v4.=
4.193)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.193/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.193/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.193
Git Commit: e19c5132f78a70cc53745558c0e728fecc74030a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 10 SoC families, 9 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
