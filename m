Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792B1161CF2
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 22:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgBQVsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 16:48:15 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41759 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgBQVsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 16:48:15 -0500
Received: by mail-wr1-f46.google.com with SMTP id c9so21533435wrw.8
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 13:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BPozxEpEwDOXz4UCyjh1NCCklqZJLk38YRRHaZrLI2Q=;
        b=phEfGbXJtJfJZGUHCqKLZR3YN9XfKoUUVsCW9ygyG1S6+3RGFSp9hh6o/GPNj6CS8E
         3gCosot1mFF9hScGGsankRizJUjhWGWZS2u3mCYwzHXsXFB8X3KZXwW1++Z6L4MQfEBK
         NE3gEdUr8kpyecRwi4uUGMPJLYv5WquWnYkYG6dJnyNhg8tKMOL70TMx2RsdceZqNOCJ
         OAaIxWwurEBSTz6GlE/N76U9JpZdkHXGFUYY2bLxU4hJBDNn5ModQjN0CrJux9Fe7CvA
         j2PucSQml6C+VbyP9KHRhnv60EWSs0+OeZXAukQyyzsDAlCd0Vr79F38ot1NJ2rljEJh
         PwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BPozxEpEwDOXz4UCyjh1NCCklqZJLk38YRRHaZrLI2Q=;
        b=Rt2HmevYsl8+LHGheC1blYo4pmiD+NEVfmxFDPFEZBrocJ/2HlsIq48WNSGoW3t3CD
         Bfb22i11jDEERk4knqjLj/CTHfopARBeheiGJ+fr07uRcgA/RP8ySFeQeJeHnLTyguL4
         N8ZlCB9epMg4QB9t5GcJN9Ja0M1DUu3YY5j12xqo2CbXGa60Tp2tpW+gYGVdZNSAY2LQ
         2ubS3ACR3f3fj9g5uB7TGAyFooeh5uD4vG+h7uufIae2my3PJ//jsvtfyVyzFo0iMxFA
         9NnT/kWIO2JHjZO3g3pyfNZSAv6iigMU1KzxAX8zUHEDFJCMHghzqDiZei/keOqz30Hs
         FCjQ==
X-Gm-Message-State: APjAAAVEFI5ELxq6KOwA8YIBR8S4ipoKUeAaRKAQnfu0etwtXOlMldgA
        m7OgHPVlMmbGSvdV49Ovo6HPExRxG0S/WQ==
X-Google-Smtp-Source: APXvYqzOzyrpT2rm711RtCxe7HgjinFk+a4UOyoPHwZPbg9fj8LdElXZ8dj4LWpgLTocp+a9xGOAhA==
X-Received: by 2002:adf:f349:: with SMTP id e9mr933566wrp.394.1581976093937;
        Mon, 17 Feb 2020 13:48:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j14sm2813715wrn.32.2020.02.17.13.48.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 13:48:13 -0800 (PST)
Message-ID: <5e4b0a1d.1c69fb81.8b29d.df06@mx.google.com>
Date:   Mon, 17 Feb 2020 13:48:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.104
Subject: stable-rc/linux-4.19.y boot: 65 boots: 0 failed,
 62 passed with 3 offline (v4.19.104)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 65 boots: 0 failed, 62 passed with 3 offline (=
v4.19.104)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.104/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.104/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.104
Git Commit: 9b15f7fae677336e04b9e026ff91854e43165455
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 16 SoC families, 6 builds out of 131

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.103-54-g5=
04347304f1a)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
