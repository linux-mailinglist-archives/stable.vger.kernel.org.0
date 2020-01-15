Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC213B8E5
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 06:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgAOFTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 00:19:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51677 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgAOFTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 00:19:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so16392434wmd.1
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 21:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6C2Hsbx8JOFxcFDyhZp1Nz6ZuUMRrK8alAHk5nbyM4w=;
        b=GCpN9CQ4qjz5MuJpVIYIFc28mBCNEGV9BLCMYwXskh7a5jZQ6MhNu0HlnvWWPSYUST
         bKBbpwNgAkve1MQXl57vU7lWKIHD68EuAqfOYsMnsIgfj7LtpvGAGeBlFM14maMSXQtC
         2bfqDUaG4bbZ/PzIk3uBBprAgYbSZzwgQlhVJWX53pL94JQb/ZPIOkjZOGq1T0x0mhF4
         0sgsvnmHOCw3k03ospS5WxIAZmattprs7Vn+SFrIeXerf11k8oPp1SnlmzP/x0qxnqgw
         t11UgF/DMrBKZeLZD6vvUkT0HFLB4qg+57ycnAheLjfE3aoZ1navAA+Hqms6hE7TytEQ
         Ioyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6C2Hsbx8JOFxcFDyhZp1Nz6ZuUMRrK8alAHk5nbyM4w=;
        b=jwM4W6Q6yQyLCLM7LqZbD1D7xXrhxJXiyZ8hSjqWoYXRhR0V1Wo1jYfXiVxpxEwNJJ
         n2Wk+yTDzbiLWRBH9siLddhTPW4b3xdyYKRCe4znkiKOSfFbGZY+u5SahcXZ/cThxVLJ
         4rOtOkSnfOW4tyYrWD+FcLUFYit5EBs5xdbLWgTeNIWhC8J1E40vynH3rIhynvQmKHyq
         E4FUozNCzzm8jQp3AHsSjX5SLFGTuIG8+uugr7Kon9ds/wdvDwwlrh3JuN1BiNk7xdTM
         HQGCF0Fa0WeyBIbfLWP5P/VbC865sJexF1YtxhpL+AQwlih3It8doyYKPtsSDEDtsZA7
         iaLA==
X-Gm-Message-State: APjAAAUsm30+SroSmup8OsJUGM3ccmbHVhtnIc2Fr7TLvLeOSkJO5Epu
        uZRSFRnp17yIFPe5ZKH68x2Vpcn7YaUkWA==
X-Google-Smtp-Source: APXvYqz4hDSevoWLbZYMxmNL8sNnzkpQlvDvXA+BbeW6VjaEA3/C6kUMOyEQoGL3vR01prUBH2hF+Q==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr31544263wmf.93.1579065574512;
        Tue, 14 Jan 2020 21:19:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s16sm23259659wrn.78.2020.01.14.21.19.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 21:19:34 -0800 (PST)
Message-ID: <5e1ea0e6.1c69fb81.997de.0f99@mx.google.com>
Date:   Tue, 14 Jan 2020 21:19:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210
Subject: stable/linux-4.4.y boot: 47 boots: 0 failed,
 46 passed with 1 conflict (v4.4.210)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 47 boots: 0 failed, 46 passed with 1 conflict (v4.=
4.210)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.210/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.210/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.210
Git Commit: 05bbb560f4f40fef38df338f87a17852a308d9dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 10 SoC families, 9 builds out of 189

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
