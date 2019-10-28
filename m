Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044D6E6AB2
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfJ1CPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:15:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35059 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfJ1CPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:15:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id x5so214738wmi.0
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=i7hxXFjzlLlfZoUF0cIxBXjoGMu+HjgbjoJFWkOWFb8=;
        b=IRGnyH5vI0xjfD5UgCH3+WIYXqfh6rDR7+dBsj/WQh6MhxdnqKccl2YxMj+xHV8Pau
         JVP0+iv2gUw4hs/v1K345MyLB5ziK5M/BxZ5VdmqZhJcOSQ/+G2UXsTdTXG1WNhtQKUG
         pvGEn4PR4Y/8QoVlaLpytppW2W55+X72Azn0+nwQmOgfp53BKa6nSYl9B1rhcLpL7zWI
         EfZZWt6Ei2TqR+z8I5QJcXZxRz/uOoeGhIgCFHR6VIo8nb5dkI408EaRi7Wi05oWmJv6
         izJlWbPc/u+DM/IpvytOLRGbvGv7ArqKXIUgUIdCZvVzaOOmNSBnZgzqVu+yhMrohCFC
         8WRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=i7hxXFjzlLlfZoUF0cIxBXjoGMu+HjgbjoJFWkOWFb8=;
        b=RgOZ5atQlNRkVTP9atw+bM0jbsF0QRmgme/2H0JUQrlRFcbgYU+heAExrxPmMIt7gd
         dGr/ApneGAcP1T5CLhgcgp54ka3d6lzhEyu8ubUWoOmYkrQ9lY1rWNWboWb9BZf/TaYJ
         CWLU50/vkhokhZJVF2dI7XJxoRKykbvXVV9hLS2NV4oteUgZ/3ftgH75bjIzn04Cphmw
         3ly4ZFYL+IM6qVM9j9f8MoaV0qDZNIQ+DoLfbD6Ak5P2qxegtm0hfyITfjOj+cEPN1Xf
         vgcWiJaFOtzmHMOLtPjS6/ADgUTc3NJJ6PQfLBs0hALltflWFY7qGPN5V5zvTShdTG6P
         5UUQ==
X-Gm-Message-State: APjAAAWWt4hKszi+xhWB2K5RLyJWM8PA+6z6qguwayvFLNtsWywLGyEE
        Vsz3fyalYdGFJipl74lEB/zK9XoG3Ro=
X-Google-Smtp-Source: APXvYqxBw19VLhqQlCRcK/j/B9zOCkgcQ4EXtWu5Kl70IfUUpVZRLt9Ov+ocOUZIrXcCXVkMkGaDRQ==
X-Received: by 2002:a1c:60d7:: with SMTP id u206mr5251812wmb.101.1572228939303;
        Sun, 27 Oct 2019 19:15:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm11689366wrr.5.2019.10.27.19.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:15:38 -0700 (PDT)
Message-ID: <5db64f4a.1c69fb81.efac1.abfb@mx.google.com>
Date:   Sun, 27 Oct 2019 19:15:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.7-198-g740177dc0d52
X-Kernelci-Report-Type: boot
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
Subject: Re: [PATCH 5.3 000/197] 5.3.8-stable review
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

stable-rc/linux-5.3.y boot: 141 boots: 0 failed, 134 passed with 7 offline =
(v5.3.7-198-g740177dc0d52)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.7-198-g740177dc0d52/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.7-198-g740177dc0d52/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.7-198-g740177dc0d52
Git Commit: 740177dc0d52947b60a2566de1f76404c4466c6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 25 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
