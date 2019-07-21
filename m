Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE06F326
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfGUMGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 08:06:48 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:37699 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfGUMGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 08:06:48 -0400
Received: by mail-wr1-f47.google.com with SMTP id n9so11454691wrr.4
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 05:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5LmY4uQW/1tTcgDCmF6caW6aAWvlMC4T8g4BHbwFd+k=;
        b=0CbEuEKczTFczwUTFHtW9OP4ZxyvvCLznSbWIOeak8UkRZJDuHmDMf5oYI6twXBgJd
         d3Ve4h04jr6iVjDu8f1CR72JFM8clKyC6pwmcdl+w4RPiU8ulGgu5p8DSKsyqK8Dtt73
         x0GRT0dbKRdVFGhHhw+vfyb3J91svnevrfu3Ck/ZInB7FORlCzcIqMFn9QVh7QofSQ/B
         LNfvq2kXyupxzBKS9MTmbKmR4LqOt9QFJMqjlHYub3CHFkoihuhx5vYS1tv36u852ART
         W/mzGRTDPqETy5taEsA+FN65dLa6JFg1IyW/abtX/NM7QfMRa+JZLcFOoFzGs5A+IDig
         Junw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5LmY4uQW/1tTcgDCmF6caW6aAWvlMC4T8g4BHbwFd+k=;
        b=Wi5j8v3Ld6SMuEObWX5WjEvWJZ1feRzY1xfbir2eAT9G2rSQg0XTDfFegDGPhRJTwV
         J8Qvvsy5Qy84dVvD2zdnKHp/Nr+4Gc39u6Za/Me816tYAu8rcOH5WNd1/8aTCoYwmtHN
         ukqLRjt0NMQ1YjvSpc4ZLnOhX4nRScsZp2yXnhVTMxDTIcxZ/C/ngM5YrmSvSNiYUlKd
         i9yhtPsGE47XBgjCpA0TL6XqVyoBXJ/C6H6fJ8Dqtrli1Oae8evXtykcyL+NqaZbq9sD
         AbpBFX0X+Kf2nRnF9jlWqkPXHox5GLV9Pi7pND4zHbcTqgukw/MI782+d5pV3pSPcS+D
         f4OA==
X-Gm-Message-State: APjAAAUfQ6dsi/qK0JSxX3pFhAQQM7tQKqQH1uuaSXCOvgEX9/wwRToK
        w2+3zkkAFj8jT11RiKJ3v7J2AzUN
X-Google-Smtp-Source: APXvYqwnDpZRn465kx0eemNbMbLbFw+myiGzSbjN4Qijt6J7KPN6Pjl7CKS2eK+17i4CscIr+fMdqg==
X-Received: by 2002:a5d:428b:: with SMTP id k11mr37831497wrq.174.1563710806201;
        Sun, 21 Jul 2019 05:06:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z19sm26257648wmi.7.2019.07.21.05.06.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 05:06:45 -0700 (PDT)
Message-ID: <5d345555.1c69fb81.be085.e1fa@mx.google.com>
Date:   Sun, 21 Jul 2019 05:06:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.186
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 38 boots: 1 failed, 37 passed (v4.4.186)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 38 boots: 1 failed, 37 passed (v4.4.186)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.186/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.186/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.186
Git Commit: a3e421fbb8579236dfb5fa82c395553828dec233
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 17 unique boards, 8 SoC families, 7 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
