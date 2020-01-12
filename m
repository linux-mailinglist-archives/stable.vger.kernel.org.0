Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBF6138834
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbgALUZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 15:25:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38547 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732914AbgALUZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 15:25:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id u2so7448353wmc.3
        for <stable@vger.kernel.org>; Sun, 12 Jan 2020 12:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OeiEye12ISQh92lHzkH/eJUfzOSnbcn3rp0eetOJG1s=;
        b=OJgzZbgbixfss9Sk+0GrOgWJTnB1xIqEUpbhWzio9LVvFWefP3j73sj1MhxKIl8z5v
         pPzPMghrRGDNB3B7vhluBm6GyX9ZgAfo1eF/324OGNZZTgugdDRervZdm8xxBNZ89rm+
         7pnOIUKl8k4n2WSCEFZNeBOggm38WRg+A3GamtZ4H/BkV6IOfN5N8xNtkI3wPMMEFPaR
         MRbgAR2ahdtGjNsHrfVt68PzW4+f+evxOOWTff5enBlZi8sOlb9KOpdJs/B3CPZiwOI8
         kzGl/fFX4A2i+FbhCnERBcvAVGMDaq6VF8ontXUo3A1+zCwsBX4ZDpVIuRMihjpmbn11
         DNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OeiEye12ISQh92lHzkH/eJUfzOSnbcn3rp0eetOJG1s=;
        b=cwI1Uto04hlkQ6IzZHn6KALnpYSPF8WcHIosJ9ZK0f3jxBqhjxgAHFuA6Vc8weJxV2
         bD81+Sax0Qw+vdgNYPljQJSAGvyadRCDOSdRbpVJpYCl9dDqT0oB/VT5qRdLj2WkDGqo
         BwLYQMiQGsTh1mWiz/KdXVAZi4Ix5fVSJJHCIOr3LjWxVXZYVDUITBTDpkF0XDkVWYvJ
         qtHeR6MGzyxKvrJ/EDuwXeEiCGdR3v+Irf+9ZXepGtWdMXGNo1zUrW+WVEvRg3uHAPbf
         vXxT0IiBxeCESqxqTlwKi5+qaqe+V2BEbBgQ18oiu+OJSLDy5zZoNzXlODAIi9H12fph
         ZxOw==
X-Gm-Message-State: APjAAAWaVd49EwD3BEMhM4L7EtZugNLv5hZaihMcWZTaOAYl0H5GX2Ji
        pHhXiTN6RTC7t2MqWqa1fLFrzK6arqZZzQ==
X-Google-Smtp-Source: APXvYqx8Z+UFfhLBOAfX/TulNiTk5yjTZXs1LNWYi27JFicPM5Qu/ytmos+QxdgPUZI0jGZzVKJ8lw==
X-Received: by 2002:a1c:f218:: with SMTP id s24mr16512458wmc.128.1578860744838;
        Sun, 12 Jan 2020 12:25:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y139sm11885369wmd.24.2020.01.12.12.25.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 12:25:44 -0800 (PST)
Message-ID: <5e1b80c8.1c69fb81.bd51.0c3e@mx.google.com>
Date:   Sun, 12 Jan 2020 12:25:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.164
Subject: stable/linux-4.14.y boot: 63 boots: 1 failed,
 61 passed with 1 untried/unknown (v4.14.164)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 63 boots: 1 failed, 61 passed with 1 untried/unkn=
own (v4.14.164)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.164/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.164/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.164
Git Commit: 6d0c334a400db31751c787c411e7187ab59a3f1d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
