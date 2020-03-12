Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC50E18264D
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 01:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbgCLAme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 20:42:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42784 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731476AbgCLAmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 20:42:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id x2so1940210pfn.9
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 17:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n6vqmFexrjRMHF24EHko3R6amau89Pr9e5W2XFivMrI=;
        b=1AzIz+tj2VeYB0Thsm/u3EDfwkxRtJnbmmowSfyjIfLFwQP2Jc8o5uVa/x/vFilwEK
         cwUnfHU0+y/ikxjv6KZ8XlxTReakg+W6lvadlJX92EMsGaRDBWwcC7LW6tkx3FGJt11x
         oZPKwqVBldCEb+QiJyMdL7+gUP7w1vQTpwLFPbQQerndaugmNIQuMcX3q9i1QJHpz75v
         JTJ/UMFUoJxK+yhUhrH3t6+d4iB4oTzF+vf3h52sxUi7SzKvq19e+CxTQwQwR2za4GU9
         UIqdvZ3J61yT+qNhIszsM/kxDOYJsLbnCGrTXpLhlc70QTLPJoU1bkuwvZRJE59I4oNq
         tl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n6vqmFexrjRMHF24EHko3R6amau89Pr9e5W2XFivMrI=;
        b=O0iKjTXNTZaVQzvubKhUGoTrMBq+oXp4pj+82v9dV5ozqysQdJZV4aEja/OMCprO/G
         DKtweoQ40C7HmytOs3Y3upN7Y/+yrX2457u0xP/dBvadOn3af5UW4LD5mI+iP6BXoWBl
         NLQdK2aodXL3qoJExRUSh20VFdt3/dHC+7Ngo0HP46fzLHEXHUQneTXkWuzpaEjRf5C3
         9HiWuUdXFyV8/Z8QUdvGVYUi5n6F570koTMs1e/JVx7gBlBlq8+nWW67CYoSZuPfPJEv
         azo0xeC9VBeIS6zD5Hn/OljBIkydMkxDt7G7JwB0Zo+pgo7BGrLrH/GPRoNLAKCNyB6b
         8llQ==
X-Gm-Message-State: ANhLgQ1tqgu8UdzADfQurSAy82T4WWyu32adfTo+U1PxXAQqfKRiBiAa
        gv3yZtmS52qrLdZnIpCZh7kKrWzxYW0=
X-Google-Smtp-Source: ADFU+vtlwXevYni92eA6JE00wK/JJqJOzGKnAfYVNwF38aGvYzA/NUA0Dk7jnxZgl7hfkSqQJ0TamA==
X-Received: by 2002:a62:1b51:: with SMTP id b78mr5349719pfb.23.1583973752319;
        Wed, 11 Mar 2020 17:42:32 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v125sm610100pfv.160.2020.03.11.17.42.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 17:42:31 -0700 (PDT)
Message-ID: <5e698577.1c69fb81.635d5.2edf@mx.google.com>
Date:   Wed, 11 Mar 2020 17:42:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.173
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 47 boots: 2 failed,
 44 passed with 1 untried/unknown (v4.14.173)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 47 boots: 2 failed, 44 passed with 1 untried/unkn=
own (v4.14.173)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.173/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.173/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.173
Git Commit: 12cd844a39ed16aa183a820a54fe6f9a0bb4cd14
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 14 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 48 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
