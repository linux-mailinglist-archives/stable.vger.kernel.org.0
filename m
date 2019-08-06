Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0983D0C
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfHFV4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:56:37 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43499 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfHFV4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 17:56:37 -0400
Received: by mail-wr1-f54.google.com with SMTP id p13so14749422wru.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 14:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fYL3VRmze7Hpc9OwmfSAwEr9bx9mdDwlcF3JEn73tvM=;
        b=mUfXdrPBK5Vav+JUzRQmfZc0PWudN2w9sCB2RtXfnxHwek+IJhDQIDlLmKjtmUmKra
         qPZ3oMOs4cxC/NeD6XAP8vvHCiD1NaRpiCo7RgT7YqHbAWe7C72mQMYnI1jlm+SiMmcO
         gyjVF2WXts8L4DCwOZNM/3iBFQLmRlsFq+rKDAi4H2YvaBrVNTqBa2WEJZ/NivygVvjY
         Zz2Y+J+qwIHBiJXvVereOvjG+hNkLR7QBtzs+79M2MS4DsW2qS3FKcQ1IGLnfIky/PqY
         zA7U3nKtzcocb5Y3MbB16Ga8AYUWurbsZxQUI1maUZUzPWQyNLImjSpZ/xmbtS6U7+85
         cKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fYL3VRmze7Hpc9OwmfSAwEr9bx9mdDwlcF3JEn73tvM=;
        b=Y01HrJOYff4wnnfzEKQELveOT5oAKZXjiOXJKHfxLTTNt3uSYmoz+RKEld3guzWugc
         EQxZwlNnJXoVeC8fknsJqw+mQ9w6VooNWcLiubUidro/ZzCVDIyLwJ7mJUfRXGOU9Iod
         rqIe1cTCN0cZ9BSYUqW+VygUUsNNWCmeOT+iy4/5epalLTqbkj9hFhvxXyCM4PbCC7fL
         ug7KhbMMjwFZiURxGTp1lQxJov+Noii01a/lqiMCbijzlyamT5cxiRTftCIdFQ1IcB4z
         E91xpl+l3C0FMGa/+BVXYXIjrqlz4hXcQrrsuRRolLEzi8Y87lJ/qXKk8jJdCkMwF2hS
         sLtA==
X-Gm-Message-State: APjAAAX00Vqofi0+Gc4hz33hC4WtnOo+FfjzVFCA+daOAbvTjJnQaRsr
        TmCgjuPx1lkIgNdbt1Xes1oJ/3vcdusi0Q==
X-Google-Smtp-Source: APXvYqz+DAszG6tDDvCT+Cu7RgqYTE39FHwl5afevQXzikH3rnsZjNvZVXfNCdYK6SeMHyVRlvW5Rg==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr6403804wrl.79.1565128595086;
        Tue, 06 Aug 2019 14:56:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j33sm204836237wre.42.2019.08.06.14.56.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 14:56:34 -0700 (PDT)
Message-ID: <5d49f792.1c69fb81.a4d2f.e685@mx.google.com>
Date:   Tue, 06 Aug 2019 14:56:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.188
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 46 boots: 3 failed,
 42 passed with 1 conflict (v4.4.188)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 46 boots: 3 failed, 42 passed with 1 conflict (v4.=
4.188)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.188/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.188/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.188
Git Commit: d63f4f2588b2a87ac763de9a427816301c5b1caf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 10 SoC families, 9 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
