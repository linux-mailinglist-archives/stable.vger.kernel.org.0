Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1162F1EF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfE3EQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:16:43 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52301 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbfE3EQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 00:16:43 -0400
Received: by mail-wm1-f53.google.com with SMTP id y3so2968024wmm.2
        for <stable@vger.kernel.org>; Wed, 29 May 2019 21:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8q99QYQ3/qccpBuIOzdtA2azAngownMHH8X0G3QBkjE=;
        b=Yhml9/Uy3O+Viu406732IpvIVmu/RvErBAQjoo4bkpvsdvfkKiaU7iMaSfVirOl7/d
         dnLr1Cy4b+bnicQq6ZlZ9O70q85FqV/I24FuP83M+pHdfhr0qw3aQBz3rS8/xIzDBM6p
         c0QsQ1NwlMEv1HCR5iDP1b9X2k/GFhD2WSkUBFOGL3uYJDdfGiMCqO70kFyCjr2RPIGl
         zpvp3enlW8+4UOHgFf5JTPnAHv2nLVksLESlPwccG86SCrrmsmdsQc6if2YmFLpmt2iT
         jISFyi27rwI6pMZL8yAZ96B+q9XEUr/LCWrAF5G78jDolhcoWBywtRXL8t4XV2HXg7L7
         RgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8q99QYQ3/qccpBuIOzdtA2azAngownMHH8X0G3QBkjE=;
        b=RCdxEbp/Q0pHIaNgMbantU0jSZfXZ2daJZZUapQtJPrEHa3Img9+LHwWf9H6nNrh2F
         u2kdUO8KQ5iTnA3gK/RDhC+EP1z/zqk7sKx53MhaQwFQILiR3L1OzfOwQKQzw++0diHT
         Z/6alBS+JZziahmywCbcFuX6ViB00SnXYXOTQbZorUqRDEpP1PDPVUMM9xq1eTop/hUN
         03YNH5mfx7FXIXUuwVRg2AotiLVy/uhvgUtHoTVBc6xKo6hwIqKs840VHzpt/TBh/fa/
         Ty+Yg4JHkKYS9yq46h0qn6S30N/n8K5bFYOxX3+bYaxtRGgwyM0pXCf4jQyCpeUQqkZ/
         dQJQ==
X-Gm-Message-State: APjAAAVL2DCk0JKzARYy88ToJEu9FTIgLPigO9SnKtUe5BZ+RNDW1g2Z
        pbvsD7SUmZ6vs8WXJy54vkG9Ftw/chvVuQ==
X-Google-Smtp-Source: APXvYqwmSTUKn4dcLVYjh6WxDuhwJrd7PN9DnksfCfbLJbeO5cD+aspQOvAL8JIqBnm3L1cS38qFvA==
X-Received: by 2002:a1c:4484:: with SMTP id r126mr813746wma.27.1559189800871;
        Wed, 29 May 2019 21:16:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l13sm1095210wme.37.2019.05.29.21.16.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 21:16:40 -0700 (PDT)
Message-ID: <5cef5928.1c69fb81.4146f.5813@mx.google.com>
Date:   Wed, 29 May 2019 21:16:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5-45-gefb81a29c9d2
Subject: stable-rc/linux-5.1.y boot: 126 boots: 1 failed,
 125 passed (v5.1.5-45-gefb81a29c9d2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 126 boots: 1 failed, 125 passed (v5.1.5-45-gefb=
81a29c9d2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5-45-gefb81a29c9d2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5-45-gefb81a29c9d2/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5-45-gefb81a29c9d2
Git Commit: efb81a29c9d28b6d7df879c6f623c529d9976925
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
