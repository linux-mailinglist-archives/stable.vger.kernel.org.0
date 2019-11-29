Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0D210D63F
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfK2NoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:44:11 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44715 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfK2NoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:44:11 -0500
Received: by mail-wr1-f51.google.com with SMTP id i12so35166743wrn.11
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 05:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=opOx9MBtTpegfFS+Y3De6k3yRwB0C7Aq7Op30sgDxA0=;
        b=y3xfELwJ0n8Y4VUwBT4/AMKfDeKZXJ+wxS1iIvI8qNh+u9S4Ft+BovqNfh4Kukpfoc
         yg7WrWC7z9gE09nplpPA0tRoKbEjYGTS1Z3UGAIbExoqx5ImDOtpyR83BC8m9QIwp0R8
         VFEAKDRyMSvojHISj9mEf087BGt7Ur6xxfmCHEI0b/V1fICa4wK7iDkOnCGW4NX7Kj8s
         gUN0EgdC3/E8liccUuUi3RqsAv+4iTXQrJ89R9F3YWGNj5qfaxxzDjEZq5+weMM22R7e
         RPEEytYw1aEw56hyGdA/xGKtK6pBdOHmePZioeIx3ECliys0O6Ls9ak/ddmehkRSLXV3
         JUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=opOx9MBtTpegfFS+Y3De6k3yRwB0C7Aq7Op30sgDxA0=;
        b=IcbEty8wOO6xbAD59BDhcW9heD6jKti1//so0K644qOY98h75vAZJGjZnyPlv4oZro
         LM1K4p5nFlxadyVvCTRQA3A/Q0vYz3MxOcE/k39fdU816hIwGr9Wm9QqVijHgznHBeIY
         7eyEldNdVQ2+h1CxYMa6DH0uWAeekVlo46jXYgY33ilJ9P4i2B7mKpep9QKUoQDCuby1
         F0UwG0sIEE0u2K904N2soA/83bPR+1Ienz4dDLdNtwlsL7Ei/4qJJOXG57e+1CHmp3iY
         q7oN248NMslGr0yyNQXFQj/bi6ciuHCZUMYx/CJIkBgnifI77QkMbkRtImaLayhR02Nn
         1SpA==
X-Gm-Message-State: APjAAAV/XQIWmy3BexvBXhXoAtRVIJQgwTjA4wBmdnGp/3vzPMX9KwSf
        hBfWHWCSaypsFTUn/ZDQotw8UB8LGflc7g==
X-Google-Smtp-Source: APXvYqzuMRKMCabEzjbk/JCFWXZ4G0nMwMdsRBxgl708vSckf64HvZcTQ9gDGzOIRU9/QFIB17Vdew==
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr36262739wrm.394.1575035047130;
        Fri, 29 Nov 2019 05:44:07 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s19sm9340916wmc.4.2019.11.29.05.44.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 05:44:06 -0800 (PST)
Message-ID: <5de120a6.1c69fb81.1154f.0a8b@mx.google.com>
Date:   Fri, 29 Nov 2019 05:44:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.205
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 55 boots: 0 failed, 55 passed (v4.9.205)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 55 boots: 0 failed, 55 passed (v4.9.205)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.205/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.205/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.205
Git Commit: 6620daa748cbad3de5824143e107a9a545f3c1df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
