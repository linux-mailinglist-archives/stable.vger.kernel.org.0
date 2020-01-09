Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2865135B16
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 15:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbgAIOKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 09:10:23 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:37261 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgAIOKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 09:10:23 -0500
Received: by mail-wr1-f52.google.com with SMTP id w15so7570081wru.4
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 06:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y3JswQ/tu1+H8Fu7CI+7OpMo0RICI63sufKx3lFhwi8=;
        b=maxPyATcLprYFfk8jdq9bArfa9s35y24bZ4fmHXjtH714Bq0XPPq2idaQk0dZQONol
         bAvP2qYbWOWeNd8Li3UaIxBpIul4HoTg7d1HBR6AY07c/ZdMevta7RAtiP4FM4eb1DDS
         NS4zE2f2fYsJRemU8YtiA64T8fibs2vh8zOCDUrBkRO1C99rwBkSc4AZUJJNmUejySfd
         oEruBt2N8LSslKM37MUDvAPqCUE55sAEjeBlbuL9Rs3012q/g4zuxmH94KufC8cF9WsK
         L5Z+LlzJ74dKOaOZQa6i0ZDa1b5NQWym66oBLohCnKhfr86fTIrt/KuDLbrESDltsApX
         jdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y3JswQ/tu1+H8Fu7CI+7OpMo0RICI63sufKx3lFhwi8=;
        b=SQxevOtr1EgRSaZsMRXozE/sV4O5cI91q6nZtMVnFNFeCUIhQ61m8CT5RMdq+qxmtn
         4VnkWwc4TZClH03v/o/X/khNvKKXph9+A9CIgFBJt+JDqhtTH6FbR7n/1FcOUqHhNmm+
         /8Z76nmNrYDKJXVz0UvybRaIXsGWEkreQ2NwtVzOEy60A7ohxf4FCLn9WRGdWlIvZfKP
         aD2AxEVW5sbgRCuZ5CgGsoHVCSL0zo/u9pKazLl6FGIV5GhP53Yi+9qoebGSlIZrV3uJ
         HSRmAepzC4PrLqolr7wnqT8qy908vzB5SZk0jABPzmlJi1xjxCT7zPFL9f/npbBzGTZ6
         SYog==
X-Gm-Message-State: APjAAAVpSnKr10wEW92mFeal7T6R9JM7iDjhslazwyitkVVjhxSB0MGA
        PypWM8QY+7o0wvsuBt6qtGRkbmNMD5SYzA==
X-Google-Smtp-Source: APXvYqzUZ6u3hsWDXw5MtbDsYqna6ThYbUDjVtKcokiOPUPVkhGP2aZjjWYyyCAYFuTQYuizCCKuhA==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr11572280wrb.22.1578579021213;
        Thu, 09 Jan 2020 06:10:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm8228427wrq.21.2020.01.09.06.10.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:10:20 -0800 (PST)
Message-ID: <5e17344c.1c69fb81.b5f90.832e@mx.google.com>
Date:   Thu, 09 Jan 2020 06:10:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.208
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 52 boots: 0 failed,
 51 passed with 1 untried/unknown (v4.9.208)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 52 boots: 0 failed, 51 passed with 1 untried/un=
known (v4.9.208)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.208/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.208/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.208
Git Commit: e77ff35fa79353a8bd85a33b83609bd3add65e4b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 28 unique boards, 11 SoC families, 11 builds out of 197

---
For more info write to <info@kernelci.org>
