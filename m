Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C61A1985
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfH2MFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:05:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33233 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfH2MFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:05:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so3198101wrr.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iBZBknW9STKXFye67wz4a2dk/IxdRaMVXopAcZVG1EQ=;
        b=w0TKA6HGYDlAm0uoFrV6gjdQAempa0VToN8vvQ+51rSGLpOz8P2OkgMc8p4gEJ5jpg
         rPwiyFXkEcBW3QYjheklg9sGpYeSbNcn/wC3mXLqo8syKvUZB1N4TNSMpexx6IXoCXU+
         aw86vlVAU/jwmlh691QvlRc9AJOKIRESIUXe1+nnoST2fAc4V+hqyFJ/rf7jO6xBc/6K
         4mgsdD+HN62JQ6RTf4Agx7LUs2Ru5AfZUwGrHvYTtDd37rNMZ8Boh9x45HZivUI95IjI
         3nIqm0Fwg2ZaIsNwdL0P6gzK0Jz6rJp9aWbUtvV52lbJw19VlyJbh9/yz6o2q2dHbQDK
         da5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iBZBknW9STKXFye67wz4a2dk/IxdRaMVXopAcZVG1EQ=;
        b=U2g91TXTILc3epr+qR2lorXx8C3lGb7TLo5x+PmdutBfsZplYlwUvDWrgzYrNDu0Zf
         eLtFZybJdPPRuxuT7Fncml+SNYxM67MXtVYfpn65P26EEX49MQnMK1qBN/BWuoZ+sFT3
         H3dpKduIPQptfAm5kVGBW8GaMq5WgJFUvH5WnaTBU1zsxsqtXIEdAKapfZ/dB1Y2ETTv
         JBTjY5o19eB0cShAeFsTPKGtkEHJ7GVUqkQ9YFX7NYaLhYDjLHbG9UC99Ff45V9LvSdr
         hvYu1hTFcso8RJFTExqx/aNT0bNAqLCcWlc/PvSu6xT940z/BdprmQsDjVZrbTbYmsvt
         Mh2A==
X-Gm-Message-State: APjAAAVrjIaP5Jwv2stbnrcgUNlxE57MI+v/lLRrY2wuvKHa2DhbOViy
        IF7PBWnJS/E+pV+yUM6XaOJBDidgRWRAEw==
X-Google-Smtp-Source: APXvYqxxZ5VG89zmA/IkVfEIAWFMiYXj3y2boKn1Tow4jNj6axm1bbr70MkWW5wgLgrgwZDpgSIHIg==
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr11464942wrw.304.1567080300086;
        Thu, 29 Aug 2019 05:05:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u129sm2672088wmb.12.2019.08.29.05.04.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 05:04:59 -0700 (PDT)
Message-ID: <5d67bf6b.1c69fb81.af6bd.c6e1@mx.google.com>
Date:   Thu, 29 Aug 2019 05:04:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.11
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 83 boots: 1 failed, 82 passed (v5.2.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 83 boots: 1 failed, 82 passed (v5.2.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.11/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.11/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.11
Git Commit: c3915fe1bf1235dbf3b0bced734c960202915bd5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 18 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
