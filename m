Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273A9150E6D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBCRMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 12:12:30 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:35282 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgBCRMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 12:12:30 -0500
Received: by mail-wm1-f44.google.com with SMTP id b17so154054wmb.0
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 09:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=70Wr0Lm4wPlsX01F5q+GSECqw9D5+j/Bsmf6YZgJjlg=;
        b=jIqjgT/aaeOaHZhQ1wbHSUEdScsRtHOUwDkPr5wtjaQux72JNTSeOnYIlrgZdKaY8D
         K5sCxZgREinfFhDo8rnADveXkxrexlqY3Tu2mrq4Gxu3mcLIa65PWD6jBN/QU8mEdD2Q
         VsTrBiHssMAp4b9Dy8ZAwFnyZOWWpwEP1nYoGsjsI+QuKWQvFWy+O31gM/XTncJd9XV4
         hUlM4bvXJRWRlzqyaNWdcsGVsVpCNdcS4nvkGCn7JMmn6Au7t/N4S8uIocf8jY4N4x/f
         P3gJ/JwHVY43d86gCrX7ubxivf+ndglpSrv/rX+c1xXgxQRlcAvXBKpAC0lRm996qUaN
         FLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=70Wr0Lm4wPlsX01F5q+GSECqw9D5+j/Bsmf6YZgJjlg=;
        b=FHI563OuWEWacmXAMZ4V3u6y0yWVd9x3MKp0gR/BziQ94imGozRqhnoUpv4aQLm5z2
         oWDzVJ1eMj8gRPp6q5kZnU2Su55sSvkRvtaSCF06/5nlW+qpx42caTHqmarfhnkSkjXq
         g18jev09Mgl13WaXOFKUaUpUw8Ucm0wT5Z5eWjchzZd5cIpP7/yDSiSMV9/Kgv2JXKi1
         3P/QF4sGBG+QB8uS3HwtuoLft77lsRWLK70KsJrlJYhwvTHcDVjuihPAVwKh3bMekQJX
         XVCek+U+MBsuiaBYxDCszCc7xlx3EJaLd2ZdIrcFZ0zBTb2he+xkolnsmCpr50/jTmd7
         DDOw==
X-Gm-Message-State: APjAAAW3r0Yli29eRK3Q+o9T41cUc8GmxCkrM8tVVPiEZjxEB4Kdj6LJ
        PSJa4w1EBbGn7pSUsENlbh1bYV6XwGk=
X-Google-Smtp-Source: APXvYqxj5lAaS4aKJe/UTkOYudvWHMggkVk57qIibJi7XN0aa4knXcGcY44KRrrarCS/qCvTE0HWOg==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr36850wmi.101.1580749946917;
        Mon, 03 Feb 2020 09:12:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 11sm50318wmb.14.2020.02.03.09.12.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:12:25 -0800 (PST)
Message-ID: <5e385479.1c69fb81.8ed49.054f@mx.google.com>
Date:   Mon, 03 Feb 2020 09:12:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.101
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 82 boots: 0 failed,
 81 passed with 1 offline (v4.19.101)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 82 boots: 0 failed, 81 passed with 1 offline (=
v4.19.101)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.101/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.101/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.101
Git Commit: 32ee7492f104d82b01a44fc4b4ae17d5d2bb237b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 19 SoC families, 15 builds out of 177

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
