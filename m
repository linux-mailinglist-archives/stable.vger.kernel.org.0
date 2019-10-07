Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF87BCEF8C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfJGXZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:25:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43776 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbfJGXZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 19:25:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so16378633wrq.10
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 16:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EwvM+MGAMfGKCYQGSXvF2abohCoJWCIqdhb4OGJiw40=;
        b=nZoq2x6O9/WkYrSrp78jZmmxm5VquDL+Ztk0txr2j42IXBspzTIOR+nVUfHpgy/XHl
         LA5sSxVpkhVVssi0zrG0y+ZzSYXLc1ulDDG1HqjwMOxNLTe2cpRgv2diUQbrbPVvjecj
         0liAy/Ti3G44Vk4PCrnrOZ9UVHfPtz1/xisr16xbjX+411ysCZvxG0WKk+kdb2oaQfyD
         Fr0GWNGLPmJW4Np5aOnR763gC1VKXMQAT1hoLKLW7CYRZCdCmIDgAvO+saOP1zz/gJ0/
         Dd63NF9DoP2/uyeQnkGWgTr0vduBuuCI2sVuR/nLYKZ58J94HjY8wveoJTkzjmjxcRzV
         RuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EwvM+MGAMfGKCYQGSXvF2abohCoJWCIqdhb4OGJiw40=;
        b=gRU0MFyn2HmPBBq7cMnFfUtRJtsBf9oED23d9AXrPqRGkS3ZqTTzPsj3RKHbjb9wBN
         b9Ov272ykB8c9fvHr8LK6G7sSQGnXyMq4q0yp1mMu4Twz7YHJ3L5yVvNExn/b8624VnI
         SnIgPrXPyr+rP1zQpGQsQ/u8NmTzrfl3JX2Bepwe6HdD4OAiFR6FmL+ph3+hPzxIqBOj
         OF/YBJvfXg44/jpbf436j+hZdH3bqFwnOilWvoKehWO9RBN67gexkfSlPL//evUSYcpK
         UAk+4/vqyDPsBnfBRDm/47vkgU+2o8vwd3+N+AqU8envsbq7+IndOo2Ljpz2FHIJV87N
         dfnQ==
X-Gm-Message-State: APjAAAXK4GRYv5poY1E1qp/75Y9qKTHGiwGN2GFkk3XR3ydo+6u+Hoa/
        batKI94D8N1a/5s8LI8NB47Dka/XI9RohQ==
X-Google-Smtp-Source: APXvYqyW3EfqMnUNsNo3usRHxEMALEf7H0OErCGsCtA0enMyZ431MF6m+mVoOpcCI/QS28bUcQAwWg==
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr18159468wrq.322.1570490702355;
        Mon, 07 Oct 2019 16:25:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a14sm798621wmm.44.2019.10.07.16.25.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 16:25:01 -0700 (PDT)
Message-ID: <5d9bc94d.1c69fb81.7fa88.4015@mx.google.com>
Date:   Mon, 07 Oct 2019 16:25:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.148
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 60 boots: 0 failed,
 59 passed with 1 conflict (v4.14.148)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 60 boots: 0 failed, 59 passed with 1 conflict (v4=
.14.148)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.148/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.148/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.148
Git Commit: 42327896f194f256e5a361e0069985bc8d209b42
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 15 SoC families, 13 builds out of 201

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
