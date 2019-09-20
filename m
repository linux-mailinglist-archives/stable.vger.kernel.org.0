Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBA6B89D8
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 06:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfITEAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 00:00:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37992 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfITEAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 00:00:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id l11so5252164wrx.5
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 21:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=bYhxAbC1GFuGSLHe3pFEpx4f5zgzfkqdI7JWdaIteJI=;
        b=a2eQU3UbZbnNoSY3AOO9JtevqKAE3tCzJjJkL/rHXzCXPXc9RAtdJnG+WEg7MFXFcX
         2eXy0ULnFBQAIH5HLCOaA1QVQc05q0dHwLUt6AluqP8+tmzRa6oTM+Zk5usRb9CZ7C9b
         B2+VKiHSMgC4KVa4qNpeCGpzcG/pQSpQYIstBJN2hh7XNw4OGHpbpkbIepbnNaBEVI6c
         dfopqNZbAZybivcNGNPqci2df5gYOsrIspjYX585sgg9gZFNaiE7c00MlrZfnZI6GOy0
         E0Dw8q/7UNFcIrEj3tCK/uA8MZkjWEoIfFOoW3skscJoZxr3ivbolKmZ5no7lD5iPhrF
         MCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=bYhxAbC1GFuGSLHe3pFEpx4f5zgzfkqdI7JWdaIteJI=;
        b=RoxuSo0jEivitDarpcSuBPnbXjtArrmUZ0+RjKc4FRFWNN6AHQrc7KQ4TI3Avi6pqk
         zZob1fUdzJEDFMGpUsFccQ5SyPL/g/UvYZT3bvDIt5CAX6AEpNtoWIE6UH8lYC6oGzSH
         e5L6dGCCeGdW/r6BFnsfNIs7QOudGkMUgULqE0uk+90V5H4bWRQfhQptS0mLPnIXfCMZ
         MJaEXWuyPmR4N9itL75H1xfl7xzNskAvUj4E/VV/Tfu/Eut8oBYr9WpoNhczFC/86jpc
         +Txzu5FGWNhZKrCDmxoroXqwtcQZR7REr3UCBBif8Xlj70iwoNIl9ycJP1jTSCfbV1wh
         e/Tw==
X-Gm-Message-State: APjAAAUz8qEwHpfEjgmpDPRp/RSXn1m1sTchshb3x4cPjHUTKhY3xf4K
        9AqFkDD22v60YLfcT1XNmfv8OQ==
X-Google-Smtp-Source: APXvYqw2sPttgwbDF05qKJ9AMT+4s0QfMwclj+w3z1tZ1FXCwQUpoe65Y7T6MENvtJ15sdm//5Y8gg==
X-Received: by 2002:a5d:4251:: with SMTP id s17mr4751983wrr.126.1568952003391;
        Thu, 19 Sep 2019 21:00:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o19sm768174wro.50.2019.09.19.21.00.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 21:00:02 -0700 (PDT)
Message-ID: <5d844ec2.1c69fb81.3f53.2d40@mx.google.com>
Date:   Thu, 19 Sep 2019 21:00:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.16-125-g690411952b3d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
Subject: Re: [PATCH 5.2 000/124] 5.2.17-stable review
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

stable-rc/linux-5.2.y boot: 72 boots: 0 failed, 71 passed with 1 conflict (=
v5.2.16-125-g690411952b3d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.16-125-g690411952b3d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.16-125-g690411952b3d/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.16-125-g690411952b3d
Git Commit: 690411952b3d8cab079b16af04292f93643bb864
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 16 SoC families, 12 builds out of 209

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
