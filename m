Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3786824D8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHES2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 14:28:42 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38944 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHES2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 14:28:42 -0400
Received: by mail-wr1-f52.google.com with SMTP id x4so32200057wrt.6
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 11:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zonXc3/aq46YHRaoY/iCK1+k43XKTgCzmG0UQJgG+z8=;
        b=kOqGZtVdpqTDuf89Ap7yOswqWOLUWUodg+pncQAkeBQVdPFQAnSVssr8GPpPZPqqMn
         QQH9gcoUg3BXs8BUjcqyrnMbUcZz0os2czG3YdXeMnCph0lTOKH0Xphr7wkOVDnJkri9
         8w7hZVGkHIQuOI+7++zaGd97SbfnPJ/l+41de6Vj9TyuKIue5OCffLvffsJwkfVnDaCD
         PAJcZjqJe3iCnb2cbPMBR+R+jOETycjDor88CPAs3gNQf2HqkbqrY5YN32wTJDxXpqeu
         nqLNzM/fXehRyJ6DDyUQDgW5hFkFespByK8NZ3dVQY37Qaiei6qznsgmKaNTe8xSryC7
         mKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zonXc3/aq46YHRaoY/iCK1+k43XKTgCzmG0UQJgG+z8=;
        b=efsmJ5+ViBw8LHECnUy9EhF9lqz/zYFyquLweUQerQ5JrTCX5Uv/F6imsJnx7Vz4tk
         kq90u4Lj2TjLfqrMLn3Vw8B/yfjs71fjauIeK8XdL/SXGAyvRnbHr2L/VCrq62KRK8hI
         qgNUxTlJO35Al446lvousuknF8xtocL+AqcS9bukH6e8UwxvUmz9jZ5ij4Mi+8Q456iF
         7jMZ+IOPOHIJx7wf3+o7BFW2cc/FHYm545ei1SWV3k+9pJgX9Y3ipizq5YtelOooUzBf
         o+vqdvCUNl5dGMvI1ELl2OQOyaT3OW7HxX+dNQJFfSRjcDNPxMmY3t7ErAwNo2Q3LVp8
         1Wew==
X-Gm-Message-State: APjAAAWTbNzx9RZ3HLtHsl4mRvcN+GQ3MWaFhIQ3ATCmujS11u3ZXZsJ
        v7A6HHsQqpHz3xS09+9zClB+uMwp6og=
X-Google-Smtp-Source: APXvYqzkvsc8rxmeP/ciu1j71Y6n7MEY2ZcFQjeBJ1p4zxPV3uNoD4Kv6HDv19fzqq20ZZQ5d6ft+w==
X-Received: by 2002:adf:f40b:: with SMTP id g11mr11874313wro.81.1565029720680;
        Mon, 05 Aug 2019 11:28:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v16sm81273582wrn.28.2019.08.05.11.28.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 11:28:39 -0700 (PDT)
Message-ID: <5d487557.1c69fb81.19d4e.a42f@mx.google.com>
Date:   Mon, 05 Aug 2019 11:28:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.64-75-g27e5d9acda64
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 65 boots: 1 failed,
 64 passed (v4.19.64-75-g27e5d9acda64)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 65 boots: 1 failed, 64 passed (v4.19.64-75-g27=
e5d9acda64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.64-75-g27e5d9acda64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.64-75-g27e5d9acda64/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.64-75-g27e5d9acda64
Git Commit: 27e5d9acda64f19f64a7db74e3bff765c11248bf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 17 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.19.64)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

---
For more info write to <info@kernelci.org>
