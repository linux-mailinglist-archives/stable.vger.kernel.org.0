Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94D16C9FA
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfGRHdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:33:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39941 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGRHdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:33:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so24535996wmj.5
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 00:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=1FvNEKtS8XUFhNrzpNnVepQzKVjJRHhKmZb07KcMWQ4=;
        b=evyqKc46e0e27fwP/OBf22xktDIrfkJhYz3mIxqdQ3oeMkQrERXln2AkExwJ1qAT6N
         OB9qkBiX6wJqfrRcw85JuLcluUw04YO1g5cS0odf1pN8cZjAVK3P/SimLNj5MaCu4TUq
         +e6yYxwx0rWFzjsU+7UWlgSP0wWV6Xp5yzryFf+VPLHIlkgctSA932x+5KEw4ArCz+HB
         E5KQiJYEHftWXGFb+1ZwxUIptQwk3e4JkHLkRz2IOpSN1ZcxbQ7E7XkA9jwYVPi1BmxN
         9vCm1mgZonKgekcIy0iM5xYgRfnysTeRJhUu5QadwwffX7ZHWZMSlqHiwrS5Xlz1uczf
         cc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=1FvNEKtS8XUFhNrzpNnVepQzKVjJRHhKmZb07KcMWQ4=;
        b=D1BCvY481h8OeTQUXenWLM8+S4NDPoJ6nUbBdpMYErDXhxsIPP+uJCbJhToJMyhI8N
         YL0KN7vhGcKxr3+UURliExVUrwwQ6YysjwveLrVJ5NaKwue1ZEd/wSprKhiaejreXH40
         tKV3jUclOkkm33vlKQ0aWLlAt8WMhR3H3NP8T8zxJsPA+83cAWJ4O7GR2RnpIMkRBSGw
         YaMDM/wNKVRIQKqMryoF4Xo8th+awyk0Iq9dC5FzPY/1IYp+sOIxiqV4HIn96c7MmPC0
         GiswLDKwz/BrxaJnpT/wGu9Pgptcor5cKFBneee4krKFq2BrzO3GN3FDKky/p0YutFcD
         DYMw==
X-Gm-Message-State: APjAAAWzZrV3rNJhNmb24DR0ravx/eWngssetDiPb4NeKyE972kf96Gv
        aZSNKCI5B9WTakRe7thiezs=
X-Google-Smtp-Source: APXvYqx8ZTbgTOcgcyF2LRPrV7Qrhotc/vxtv3JH5VVV/Vaix7qtZmMjXtf1ZWB8FF9DXYv/IFYdQw==
X-Received: by 2002:a1c:be11:: with SMTP id o17mr40349946wmf.115.1563435215103;
        Thu, 18 Jul 2019 00:33:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w67sm30063251wma.24.2019.07.18.00.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:33:34 -0700 (PDT)
Message-ID: <5d3020ce.1c69fb81.8d330.add5@mx.google.com>
Date:   Thu, 18 Jul 2019 00:33:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.185-41-g15ef347732a9
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/40] 4.4.186-stable review
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

stable-rc/linux-4.4.y boot: 98 boots: 2 failed, 96 passed (v4.4.185-41-g15e=
f347732a9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185-41-g15ef347732a9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185-41-g15ef347732a9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185-41-g15ef347732a9
Git Commit: 15ef347732a9cb126d0626155a1b1fc1dc15545e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
