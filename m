Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA99F5EE
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 00:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfH0WUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 18:20:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52078 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfH0WUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 18:20:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id k1so648244wmi.1
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 15:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f6T7Et0Fg6F9HE+2ULY4Y1tT/EHv2ExC0BUe7MX4V1k=;
        b=ZU+zVpAYbGpWS8vLYomLwa3iu/QG+nUaJ8boyRDy2H136J1dnLLXzGFP0cvlWN+NBM
         y1WE/JJByYM/c0TZnXijt+Wxu24W0a/amCOEQ75Q2/jR4wsWH95o5zCGRf5EtmPdmiRI
         aVs2ben+NR5NHnRmKuylOxvwahTDOZ6yIRJlrNYoHJl49hASePc8336yePfreKjfe9sp
         qtqZBfuR3qCE/CGs7/WIUHhfaiZvXKY1H4cUujqg2WC28B2KwW6vvNVaSonnoj8S42Zt
         aYBh+6PsGB4rc2YEGRoXXv5cwAj5/2Vy/GhWAoUlegJlgITm9CIuxcWUuahh8tcsFcHH
         91/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f6T7Et0Fg6F9HE+2ULY4Y1tT/EHv2ExC0BUe7MX4V1k=;
        b=ObOvQFlJFviRzv2I832JeFUkstzC8K4SxpnnLe4Zp+oDLHoO+U66Qh+T8j/G/TpKbW
         sZuaFcGduFpli/jpSX0cJNLh7L3ZuxXRkd7oj5pLrAjXpYiAm+unPPzUCEsQ8305e5tn
         dJJRYm6e+O5MKmDq1WjGtkobS8jYFd9oukv/x9BTx2tJtGOunpzyj7EttTnLFpWuRNxn
         4QywlvJxIpv+QpWSZz6onZ7wtm6r8GIij8a2oDzvlO4niVqnCypOGxFvrf2HAisnSNs6
         oZQ0ujAcBt3cztlveZlzp1tqkKpFqiLW8EqbtdmH0Q0yCJmnIVxSj7OM+ohqCpy2LCCz
         /WbA==
X-Gm-Message-State: APjAAAWGuA7CuUID4kSQIaneRW0s/PegMZXM1WZw3T0sLDRHSKVVPPf3
        eV6mbQK0/5WL/i3rmR0bHrw9ex73Ff8zFA==
X-Google-Smtp-Source: APXvYqzhQM4wwpMj18y8r1ODzCBCN9JNVsEAZ1gdQsWdNmxAe9vJY+iyhq1r8Z9oJ6a8ilKyAU0Z+A==
X-Received: by 2002:a1c:238d:: with SMTP id j135mr750564wmj.39.1566944398863;
        Tue, 27 Aug 2019 15:19:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f6sm836767wrh.30.2019.08.27.15.19.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 15:19:58 -0700 (PDT)
Message-ID: <5d65ac8e.1c69fb81.aab44.480f@mx.google.com>
Date:   Tue, 27 Aug 2019 15:19:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.10
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 87 boots: 1 failed,
 85 passed with 1 untried/unknown (v5.2.10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 87 boots: 1 failed, 85 passed with 1 untried/unkno=
wn (v5.2.10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.10/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.10/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.10
Git Commit: f7d5b3dc4792a5fe0a4d6b8106a8f3eb20c3c24c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 47 unique boards, 18 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v5.2.9)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
