Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E721B62909
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390941AbfGHTMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:12:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52322 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731387AbfGHTMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:12:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so608675wms.2
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=K91t+FtsfBSUcSDS3x3jNNU8zFh5v/uXYLs4sWDTadg=;
        b=JQ1dItqNHVtvJ3YcIF4UShPyQ5LAqp4n/nsKRJQCM2pkOwKj72l6twA+nroOhRwRST
         RR3jHx+WQxM4rL+ygMsWSqlzfiUk4hjHW1Fit7t8+9PQzB9+E+9mf0EHI5cjx2Ogd2Ou
         wQ88bPOzy1VaAv9b2lDcyUYXOPv+u6fdUt0a37HibTbu1bBYxoSMiaDG63NLDJWq/5vE
         XGjR+3jhgH3WleyLhL4wHIAehCmYmvQ5YK48BDuyp4XAhjz2u1jsqqudrknK0FG/axzl
         4ZVKDFNTlj7sc74PSIxlXc9qnJowPgRcehUZfhjvi79lJWiByxtELbAqVn2WZlh+6nqj
         frpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=K91t+FtsfBSUcSDS3x3jNNU8zFh5v/uXYLs4sWDTadg=;
        b=LiH63/5i3Lt+5gsDFn7dbLlJqz8ngtxaR2DnU8Ne10RX851s/yIs0VvF+0EnSQukDC
         bRtMZQJq2aQQXzi2oBWo/gNVDaK5phUpLZEuaGShgCVVLYGbwJKO2zKNtTbWKbr5dvWc
         Ti71XYWDyDwaVNGdpgjdqBQi/TVGMMNMkOkO6gyvN/KG4ofL3WOFtl0R63ecCuI8eU9y
         aEpqWuh429xWVgWlFWDwgzw6V1p3SDrwvS1kMdfXMQtntuYtR7elh7frD6WRZE0in/8t
         d0nY1qha2byju59Dm8F81CxJxjynsakWlNh7w6S2SNe6Ud6dz76PiXaGVmjVzsLt0kNR
         lqmA==
X-Gm-Message-State: APjAAAXgATKJIYhYKXMclAno2QU7tFXYGDqUfquly5VMbVqU0GPJY7GA
        3GRcb8RyFKxnwSSGxoahgkrJ0OWUVPSlVA==
X-Google-Smtp-Source: APXvYqze2ejGTZU+LIj/GN7jDGL5U4KMBJsrIA0HOLHCTbE/A6UpepKmCzUp4TCuRFyDOgqXwg51bQ==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr18206495wma.46.1562613161948;
        Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u186sm771409wmu.26.2019.07.08.12.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Message-ID: <5d2395a9.1c69fb81.41685.4bf6@mx.google.com>
Date:   Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-102-gf075c4e9d730
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/102] 4.9.185-stable review
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

stable-rc/linux-4.9.y boot: 94 boots: 2 failed, 92 passed (v4.9.184-102-gf0=
75c4e9d730)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-102-gf075c4e9d730/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-102-gf075c4e9d730/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-102-gf075c4e9d730
Git Commit: f075c4e9d7301b229ebc16b6ae51dd5094802c48
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
