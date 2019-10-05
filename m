Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602CCCCAB6
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfJEPFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 11:05:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42399 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJEPFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 11:05:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so10369138wrw.9
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QdeCOwXP0QUt8SWEIoJsHBurbHRJ74HCSYuz6a8BdlA=;
        b=eTThjXngTQOxVBzdlFAaGNwZvKWgz9jJiSp4WkhMddf/pU9XwFMO5+O25xWQzZV7GP
         IDv8QK7C+M3qM/HTkAsq8YzhFZmdM2VSskLsAzwtQMa5prEJryFE5QnPNQuHnnvZsOym
         Y3mnNTOz1RvuGftcSs1WZjPoYyAw8itZ/+PAmTFvHL/AU5cSD79JMHIyqeWQSOsxY+MW
         U7HRxs6VhbXaakW6wot8WE4Eh/sHygmH1jRTQtZUMSnr1FK3gu9vu+eakj7TrhW5iWXU
         DMGlfaRMj2swKRBWCT4FF2gXXqpyHfU0QmbJqUn7utdDxeRSBiOYULGD4+3c2Mfeazmq
         fo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QdeCOwXP0QUt8SWEIoJsHBurbHRJ74HCSYuz6a8BdlA=;
        b=nyedP6BofipqDhO+uH9O2YDOynwoTko6x0u5yO+/mGRNQHIWSdTRcsjxXrCiegcg6A
         c4TKIp1cUPX7LNntwdW8/LPDgDgH2JMPiX30fKlXmDfsbLm7s5wJQ9vMFPR1NeQ8SK4h
         jqoMA8xejP3kFcAHhoQmjZnnzwMeou0fHekV23ZJIPzOy0VG/UfFA1y211if49F7Q8SR
         MN5FJH/a++Wh0VaqJ7Y3zMgYH5P5EKaiE7zefV2RcVsTlYsuKNSc831ugrN4kZfZj5Fw
         pjJ6NXdTR4+PTuZRPUfhloVdSSJjReHCZ+whvhaNUYJ10X1R+USK3i5nwyacYkYQCqtI
         bMZw==
X-Gm-Message-State: APjAAAWnl8QytRyh9rDJ+gkkgOvCaoN43w+4abbAopKS1tjKcxriqnJj
        VQAbUeUfBvuyqr1ammO9N69Nfr+J0O0=
X-Google-Smtp-Source: APXvYqyosBOY3u4FqY7q5ns4xWMG8bZhEHxunEJxa3QaRcAtVfHRm9KRKSryr/IYn6utUeh2BWwwug==
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr16909391wro.279.1570287936269;
        Sat, 05 Oct 2019 08:05:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y18sm20879553wro.36.2019.10.05.08.05.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 08:05:35 -0700 (PDT)
Message-ID: <5d98b13f.1c69fb81.6f4ff.db64@mx.google.com>
Date:   Sat, 05 Oct 2019 08:05:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.195
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 45 boots: 0 failed,
 44 passed with 1 untried/unknown (v4.9.195)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 45 boots: 0 failed, 44 passed with 1 untried/unkno=
wn (v4.9.195)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.195/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.195/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.195
Git Commit: 6eea609ac3091741dee9080bae6bcf2edc879ca2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 26 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
