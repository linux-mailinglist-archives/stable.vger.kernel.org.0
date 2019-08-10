Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962DE88773
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 03:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfHJBAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 21:00:22 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36549 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfHJBAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 21:00:22 -0400
Received: by mail-wr1-f45.google.com with SMTP id r3so5991191wrt.3
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 18:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HHy+2cJSbRc68A57z8lvs9rNy5fQ38oZMRXJSFzlHYY=;
        b=XxY2Caa6n1CPf2aFJctWQ0L4D1OO+pADFcigFMnB5cROB8vky4zAz55MZenx/0Piay
         wgbk50kExiGdvp7NA/80+Fp3soau9eS72U3hBHQyxz5skWZrKgibvRuCsy7KU4W6Xa/L
         favWI6rGiEVjlJ1YKGPDci+gKE0TvV1ahBL3UTjTwzBRVGrryf3MA9XDJX1pnuyEsgo1
         +Y4tP+sEL8JSRgHJA0EzrEMRHDVK/Innhhw/rrxFMKbzYTtOOd7zvUy82OTJRSlE9RHR
         KHsToxIfY75tF7JReza3z5rQwey+2laQn11xJIWjKaqXjYtYawZ9TZM+Ciwoww+F1sD/
         VzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HHy+2cJSbRc68A57z8lvs9rNy5fQ38oZMRXJSFzlHYY=;
        b=oDZTQIabDCmZm/+S4Cdn+uKNNobelPn2BRO4sGij7I//Soh6iaGNxuWFmAXniwhUJa
         nNEbZeZNrBjm9Ub3gfrChO2pqwmUz2s6R3aBSjmaZJyffnSARP1wgAjoGPgXm04rl+CI
         93FQBD0NR87dpv4cZ3if5+/v24LT228n48l43qtPoQbq1SjviKwhFbC8eShT4vSFYAvu
         zAZT25rgkvaA3ulbTPVX9pJMPquaDYwSd1Ary97NAmGIKYZZtB1GKwjC/a4mWKotaZsB
         cGo+87YB5YUvQeGCBYeaxfffTozb9D9DHCMHFc429pBV3ii+lL2a0IjwnnITk+LFRia9
         wkuQ==
X-Gm-Message-State: APjAAAWmnQ6GC+jEqlTddun5jXI77YjG0C5Av3l2ryy+OaJqM4KoFDIZ
        TjeLOJDDoKVSsf1I7kPnIq89itHnTwpVbQ==
X-Google-Smtp-Source: APXvYqyiz27zY2iWV/3OEbclkWbr+/ilG3W+DWribWu6EDtyGPwF+7oPd70jNcEwbQjT3NfBKF1+IQ==
X-Received: by 2002:adf:e841:: with SMTP id d1mr27045881wrn.204.1565398820059;
        Fri, 09 Aug 2019 18:00:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm11553722wrq.64.2019.08.09.18.00.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 18:00:19 -0700 (PDT)
Message-ID: <5d4e1723.1c69fb81.e52f4.ad06@mx.google.com>
Date:   Fri, 09 Aug 2019 18:00:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 62 boots: 0 failed, 62 passed (v4.14.138)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 62 boots: 0 failed, 62 passed (v4.14.138)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.138/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.138/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.138
Git Commit: 3ffe1e79c174b2093f7ee3df589a7705572c9620
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 15 SoC families, 10 builds out of 198

---
For more info write to <info@kernelci.org>
