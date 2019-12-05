Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8211149CA
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 00:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfLEXX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 18:23:26 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50979 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLEXX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 18:23:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so5907325wmg.0
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 15:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s5B4IFv39Uq6TeuwTRt1p7p6miMKcTZ+Fw+iq83BEkw=;
        b=lquT/N877pMMarWo1mYkIjYpb10Y8g/LxCkyv6CYzlAHp1+6FL28u1LvX2tzE9AL8M
         R9mhDwkuhwRQqlVjEAQpa7p/lysPLGtE4Q8jKGbPc1tv610wXIpp1ry2JqsayFABbTCu
         wJGOtPh6vEdYa0PVQLg0fR5xhT/3WbMezvlkU/Pt7JP6d5TCefACoHVJ+KTNv+M8Zgxs
         XJMGRpIJFVmbdqB4J3o8JTnVA5zLjPcIeDADTyuHN/bWCLUc7g4n7cJBKajKc/EIsAT6
         iC++TxX7ugjidJlNHa8V4ojoO/8nDmadu1i7Bk2zZFJRBBOaA4T8HJCU/F/7nJjYgGFz
         2SLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s5B4IFv39Uq6TeuwTRt1p7p6miMKcTZ+Fw+iq83BEkw=;
        b=OWTFI184U60E7IEIOYTP3lpAR6JmijA8TpcACGi+RS3BQRNm2buWtafJK7PDArGpJ9
         rQCqGKXfoaMnNV8RE47qaQ4usjVmU+hmSU42RvQ7c/ccw88f+FPnEff7ElZXhe+814vI
         nw97BdzdAQu92U12ufD8e41Ed2lS9NFtjKqI28JqnbpxLT70rOBh/mtRYDpWToOZkz67
         I8tX5vPTCnKRJoRt+6E6F73aS3QLXAjUBf3vHY02Pc/5pM9ouSbgi9G9mYIg5qN6P0mM
         3uulu5OqxtGovqxPAHfX/ToANmQTTO2vSHx2gWPQGi3bLPfdA0VQWQmxj++qHc4gFkZ5
         uhYA==
X-Gm-Message-State: APjAAAX6on4G8NyqZL60mOE0DX/F/xYjsY57RbGeEyL7T3Xw/f4cZJ5C
        35wwgG1sGuGNIxCNlXip+jDczZ2Y2yNmmg==
X-Google-Smtp-Source: APXvYqznSUle1sbS1U8RxmO2Ev7kutpVpJR34SNP0hZwHKbTKuPgwh3AmuxQGJbRsRCVI4t4kLP2vg==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr7500034wmi.152.1575588203946;
        Thu, 05 Dec 2019 15:23:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l6sm1406036wme.42.2019.12.05.15.23.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 15:23:23 -0800 (PST)
Message-ID: <5de9916b.1c69fb81.86dde.8675@mx.google.com>
Date:   Thu, 05 Dec 2019 15:23:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 61 boots: 0 failed,
 60 passed with 1 untried/unknown (v4.9.206)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 61 boots: 0 failed, 60 passed with 1 untried/unkno=
wn (v4.9.206)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.206/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.206/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.206
Git Commit: de84c554e33b28d68e09bbd0ce5447b8a85853ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 13 SoC families, 12 builds out of 196

---
For more info write to <info@kernelci.org>
