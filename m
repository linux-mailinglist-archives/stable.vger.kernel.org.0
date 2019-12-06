Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB9114B61
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 04:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfLFDVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 22:21:41 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53023 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFDVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 22:21:41 -0500
Received: by mail-wm1-f43.google.com with SMTP id p9so6287078wmc.2
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 19:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gqqo0L9NGCjOwWQN/gRjpKCeuqBb9Fu0spcFKrZ/zl8=;
        b=gp+4kkzxLEcFFi/d9EHPbU7u6AksYjRxJuku9Uw4+v4wC8PwUfVNbZeiAN08GLG6pp
         6xCzbTrR0tdn24u03qSUG8EPzRFefeAcF3yzmajQYYWd1xQBWPi1t04BoGdBt+BXLw8u
         oZ1DSGQlMBtxL91LHF66b8nVK6rDeI2Gd4l25EMnxY8olr3+fv3VIg9n0JIHuYt/KEef
         v6kV/DmelJW7LEV1inIMFS+X+vy7QCb1F2/zDnKLPImOj5aR2Z2w1+wXJN9TlBW3cQG2
         XUw0/nqmPdibdPEh7QDQMqcbrG56oDGKy+Jt4POtAp6fGeInO3Y2AasJWxxO0YF6vw2E
         Wasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gqqo0L9NGCjOwWQN/gRjpKCeuqBb9Fu0spcFKrZ/zl8=;
        b=il4LqeHUReh36cP+HXRtCZ4s181puxuZljXiIctlqLFtJ7yuh7HO4srXkoCNkWEjV9
         Xfb2PwVaB/LAXvR8+Sm5E9OMaZ8pBiMG/ueL3DMrR/2pkxEfgoGQYcym5SAORIROJ8uI
         vfoWAZ6EuxSSugR3k7A24m6L4NXXjSxA+eYhO0+fb8zHfYrIwH+Te8SYcYPmJ55RENNY
         /wklltvu82RzBVsj8PSdMEzSDAFrqGG2BpJ9OMwI2Ye3TmB6euxOihzpQWZ4n/MHHoUP
         QSi9UMux47mQmQ3Y9bIkVd2iqjvixToCvmj7x+i01W2HRmkE6rcTTW4eaFGVWcpqohTm
         R0nw==
X-Gm-Message-State: APjAAAUOzfAwDhkVwqr837U+CT4bX5Hwc/URmD8fenIKCPbHPVoiqVJL
        AAulfVoAY4WgaS7Vz73ErA8SZOfSvgol0Q==
X-Google-Smtp-Source: APXvYqwbycaYvmB99fyF3/W1Of1ZGDu0WLfTU42a8Tl+7Uc82lXAum8GdwbL4QJLnvOcCwsWUj2a0w==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr8046214wmj.7.1575602499142;
        Thu, 05 Dec 2019 19:21:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m7sm1914359wma.39.2019.12.05.19.21.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 19:21:38 -0800 (PST)
Message-ID: <5de9c942.1c69fb81.80488.a727@mx.google.com>
Date:   Thu, 05 Dec 2019 19:21:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 150 boots: 0 failed,
 142 passed with 6 offline, 2 untried/unknown (v5.3.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 150 boots: 0 failed, 142 passed with 6 offline,=
 2 untried/unknown (v5.3.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.15/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.15
Git Commit: 8539dfa4fcbcf58c3c2f92ac57b964add884d12b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 25 SoC families, 19 builds out of 208

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
