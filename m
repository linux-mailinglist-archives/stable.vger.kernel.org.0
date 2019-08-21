Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D609F97075
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 05:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfHUDnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 23:43:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55710 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfHUDnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 23:43:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so589303wmf.5
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 20:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kk47wiWK5d887Sn6m1vOW5bsckewdhcjuynWo9BV+B4=;
        b=lE34UZIIMPyDLUbPeWNDg/OK1fNHecLP5OY0TxOACVbQcdT1Z9pq+qdR0CBOyk3Uc/
         JT8dTqtX6k3+x9UBFlm+Bmo89j2hMJb5pUrHPzGdt47186XDC/8h9FhG6IAJUTDMnWn1
         oiUV9kMo3fCrvB67x+bmj8cBpRWK8oVB1ba6b4CpXpw/jCerdBwch41TJFro3ljroer4
         BXs33outOx1bANJrbVhYtZJXwea7siP6XB6YX/rkIUFM4Zd1ZVxPfAukm9w5suTu9KF6
         XEQN5/adSukFxa9IMYb6M/OFtZTBlz9jIj7pEAi+SEGC7Uc+H7ZM6/xChNPlLk0EsbgL
         EA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kk47wiWK5d887Sn6m1vOW5bsckewdhcjuynWo9BV+B4=;
        b=O5tnkd+wkxZZUl+M7/4WurLn8Y2TMYvQ0A0+z09i41kwrYRO5prw5+kZtLDiH9F4kI
         d4K5GHScfWIGupmaNax4DsuK9QQ1dglvwxUl3+eFvM3do2yllRspE6YLrG0Xwttuwfbr
         7UzPG5QYDgpLmK4ZCsI3a5Hq31NJFId2+4Qke5miTaxTf5eV34WdRBsFaqwcwRQl04MG
         aYZJueNqfX8xYhJx5XnFDzkltfJVWAVqQ8LUoaTCLx00db8UEgQQlvAi/r8Yh2RH5+nl
         2QKMDozSzrxavgppitdlMBxMJj9QlXJByCTuDPlf3ZTafcN6VMFiSZi0LFlQSwr9whv8
         KhMA==
X-Gm-Message-State: APjAAAXyr40h6ZnwNhgeT0QG+GQdUCxUkA67urGTfOYiS9tkCGWY0e0z
        HTBhTCPPsSONCd8OizzOrutRuwN/vQ/SIw==
X-Google-Smtp-Source: APXvYqyv4q3xz6LhfcoAOy1IOe3hKMHgp2/tlL/l7CzAJmNdxZuESUyess+MOQamjr67QLEiwF+SVw==
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr3427289wmc.50.1566358977563;
        Tue, 20 Aug 2019 20:42:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l9sm1497396wmi.29.2019.08.20.20.42.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 20:42:57 -0700 (PDT)
Message-ID: <5d5cbdc1.1c69fb81.2f558.6615@mx.google.com>
Date:   Tue, 20 Aug 2019 20:42:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-72-g61debbcee15e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 55 boots: 1 failed,
 53 passed with 1 conflict (v4.4.189-72-g61debbcee15e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 55 boots: 1 failed, 53 passed with 1 conflict (=
v4.4.189-72-g61debbcee15e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-72-g61debbcee15e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-72-g61debbcee15e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-72-g61debbcee15e
Git Commit: 61debbcee15eae625f35c5b4d65bf77314f2282e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 9 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
