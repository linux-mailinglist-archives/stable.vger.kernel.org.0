Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAFCB1F6
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfJCWlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:41:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51184 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfJCWlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:41:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so3678804wmg.0
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 15:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=uOVd3X/wZgzEB6V0Fr+tNeKdOcBOeAY72FFGJ1MiF4Y=;
        b=miFo+VU06QptyI4rqV6HRgzo8qhNbjtt3w1wdJpypaw72rZHGNGN5xbRbWP0WnVDK2
         m5/OlacpBkE4cZLHtmmYSnP3Rz8QsTFmJxNHMufHMmHkShOS7bpEPwxZ6FkggAydKiyp
         cfHRlg+KXP/v1DXhQryS+6L5odYaCVN6E0APfRzNxr7DNUP79pIiCeu7QfbQIBODDsgR
         Aokw80zgJ7g6rr/UNJ1rBqLT5w3cajm1vP2Jze4vW3OIB2+HZiHwL4sv06QqGOgmZa18
         24cxI0UQjecr1PzeQBPofF41AWfHc8XcDd+nfStc9ZJRpd6Vt4Q7ghbCFkeGBSkKpZ4P
         KEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=uOVd3X/wZgzEB6V0Fr+tNeKdOcBOeAY72FFGJ1MiF4Y=;
        b=k+uXVCzVUjw44DYUVbu4eXlW8dUyTwRSD5I6LpP1Z+AoWcdoUUoi00M/uqlh7bckkV
         Utu27/RR+Mg6CEeBUKzD1NYE/QlesWiTGtr2IDV1DvfLKi5T/2ehmC+rKWLJZJ/6OsbE
         a/k3WO9J4Yy6eIrluPmSE1OtbPpkNiTWGFxXE8flt1zSGcxAZ1heWveSFFjMowRv45s+
         Mj7z56YsAwtMGc0UBEtdSWTIaATRNsM5nFo6TFOvAGX5vl6GAcM36JLmeW7buPLWtNbs
         32FEN9gsf60OXppxTlTqPLtYMBDYPjX1+XvBGy0+zROfWFlIKX0eTFOCzCk7VnuwfXOf
         axnw==
X-Gm-Message-State: APjAAAUrWOENM/OC+hOMZ4mWAMvPE9xLBvukNsyMvuKC4INBLNdqn/Lx
        aPAHDJnpaDQOFWZoQpRtSeoeLQ==
X-Google-Smtp-Source: APXvYqyuJkmfu0KDfIG92lUKyRQZ/+be4GBXFc3rX0H85L9SpU3eg379pZCpZHPrMz/oGNZvjlcpSA==
X-Received: by 2002:a1c:454:: with SMTP id 81mr8233401wme.119.1570142458337;
        Thu, 03 Oct 2019 15:40:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 94sm7428514wrk.92.2019.10.03.15.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 15:40:57 -0700 (PDT)
Message-ID: <5d9678f9.1c69fb81.af96f.47ab@mx.google.com>
Date:   Thu, 03 Oct 2019 15:40:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76-212-g319532606385
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
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

stable-rc/linux-4.19.y boot: 124 boots: 0 failed, 115 passed with 9 offline=
 (v4.19.76-212-g319532606385)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76-212-g319532606385/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76-212-g319532606385/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76-212-g319532606385
Git Commit: 319532606385c7221dfbfba6f857bd03e97e20d0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
