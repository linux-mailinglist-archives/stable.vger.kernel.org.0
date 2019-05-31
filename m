Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9E31528
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 21:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfEaTSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 15:18:50 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:55424 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbfEaTSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 15:18:50 -0400
Received: by mail-wm1-f48.google.com with SMTP id 16so2256581wmg.5
        for <stable@vger.kernel.org>; Fri, 31 May 2019 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gUtOQo0w/csD3SQ4BRemNqAQpXWnezF29/hLrr1Hqzg=;
        b=YQFqU0oWQ1ZwmTdOd4fHJVOZbV6mHLqpcvEZm0AVF4XwwNufIEoB+R5vE+LvFubdUM
         niPYFhsa6HT6UTADIqQ2BaTAWIaf6+GMEpK0rto/hjVlztkkNgegpHd8vBgemoYroRSy
         wZsabgQP/w7ghpgERtAThpka0I42vor+Mp20sc53iVXLzdHoHMziLUgGuYfGQZxWqS/Q
         bVUF0KlR+FCHFKeWrLaes+WJ1uzGHzY86lDeOFsww9Lnx8q6MHRJ7qU5dYKrauI74yit
         zcl5O8xNfsbA2Nx09ZFyrShiLhhutqwGbr3ufHD+T9d1aV1wMY0hEuZzaqQnMpv9sLTS
         L+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gUtOQo0w/csD3SQ4BRemNqAQpXWnezF29/hLrr1Hqzg=;
        b=ImZzsgzgBaz51aWJie6EAoKMIInIk2tg1LAVO1XOb98Hf8xDtR+b9QITjTBYc30S5o
         z7Bjvb09fUXvhLeM4kZd1PbY+Jkor/MWqMIm5T4uMfC8e9S6jh7FfZU2c+rFZi8FeCcx
         G4atX0Te2FgRBE3JeU5ulBZvT6eAbC7xXEXdu0fvasnDamPjcsg9XqA6NCT3w6FF735q
         5wzJDoCGmf+11hMSFj2COOfMJklGEFz8RwLhivmb5hyO0iHBCo3pcC/XzT48W6xg00MM
         IXNjeX+WSZBiJfkxBY6+UHcrVbT69x2ShjvEDn49KlYjiXQKZul8dhsENElzSrZSZFb4
         O53g==
X-Gm-Message-State: APjAAAX1jpdfbAeqyuuH2TYk4Os1+kz5P/hH013Xxmy8ckkIc1Pm/9G7
        HPJnT5gF2Ytl5jYmuS2YjRYaa7meYnaxCA==
X-Google-Smtp-Source: APXvYqzfm+e0zRQPgaQ5d4ufnIIsTk9EgVFT1JSsvPXSwb1tLBqnfOWgXz385M5NJRoftbVTgVtmGQ==
X-Received: by 2002:a7b:c159:: with SMTP id z25mr6894721wmi.105.1559330328132;
        Fri, 31 May 2019 12:18:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b69sm3102074wme.44.2019.05.31.12.18.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 12:18:47 -0700 (PDT)
Message-ID: <5cf17e17.1c69fb81.eaf58.0d4d@mx.google.com>
Date:   Fri, 31 May 2019 12:18:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 59 boots: 0 failed,
 57 passed with 2 untried/unknown (v4.14.123)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 59 boots: 0 failed, 57 passed with 2 untried/unkn=
own (v4.14.123)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.123/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.123/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.123
Git Commit: 8cb1239889087368a792c655de99529eec219bfc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
