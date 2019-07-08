Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3EA62A76
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 22:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404983AbfGHUj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 16:39:29 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42131 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404955AbfGHUj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 16:39:29 -0400
Received: by mail-wr1-f52.google.com with SMTP id a10so17475102wrp.9
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 13:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sehC/UQOJtAxNShW50HU5ZRsv8fxT9KU4/m/JNedXAY=;
        b=1Qq35J0FzcCNgIAN2KIdxPhctvCPE927Uy/oE3MCQoK29U+6RQUwXQpGKrDUhL4eMp
         aUOcu6zVd8maWVls4JY1SljCEidmANgnWKGWL0i6HWvihb5w4q6FRJKnAK3RAgvrVAaD
         5rqpmjXEi3SL/OZwWi9ZNc0mCuHaXJmxlYQE+5AcbdAlVPJf2fUNwxKp0zg0bcKkY6I2
         6vKsF1HaMR0sN3CIcoKx5dbUmkV/Z03zXxjMkbF8Qpnk18nd77GA1Hka0tJhEdF8LDDS
         mTbiGlRbl0sKE+vjqwE22l1PejessgXvb49MVeryPw1k5Kyxl1UOC/cOcIJ0Gm00fr3L
         UbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sehC/UQOJtAxNShW50HU5ZRsv8fxT9KU4/m/JNedXAY=;
        b=mkMubc+/yzQ4Qt5bK3aaQTpTFCOFzpHj/6lNgg44YDv0EpDnoNFluLZUyJvWA2c/+v
         nRbMTOSerHCbss91XObEBvN2JJhH3yECLgDw0OrHAL+Iv2Q1d+3NYGaMyko55SXu5MG5
         VBkcKLCZLWfHhVW8JBCQ/wI8xQnCBnUR1MQSZivTJjGy9VtD6jWPBqEPrnc9LmvhFwVl
         +Hi+S5yiJpd3PasOL1VQ1tH2y4rpqK22/080JnBuADOAIgFT2HiHNDn5Grm8Ms7Q9+yV
         TRK5XpKZLO8UTuz64wEPOcIcHHcBhseepX4yk6v7U9lAgisgL31t+0kZd1YWUTMPEBc2
         foAQ==
X-Gm-Message-State: APjAAAUJkJpBp1I0H3sMNPuWTRTuTFycsb1nHBBTfdRMYNvoEtPe4rq8
        30y7KGaPkITtS9Vcxy+fEXXUQ1iyaMgNIA==
X-Google-Smtp-Source: APXvYqzYwgUA0kNpzBAkoqU55DJkntozf7Ou4mZfhGBc3nyFV8KWzl4R+WAuYka4Hh9v1+kZdpobUQ==
X-Received: by 2002:a5d:4205:: with SMTP id n5mr2047544wrq.52.1562618367069;
        Mon, 08 Jul 2019 13:39:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g19sm22641626wrb.52.2019.07.08.13.39.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:39:26 -0700 (PDT)
Message-ID: <5d23a9fe.1c69fb81.89a0.1f7f@mx.google.com>
Date:   Mon, 08 Jul 2019 13:39:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-103-gbb7044a09b6b
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 93 boots: 2 failed,
 91 passed (v4.9.184-103-gbb7044a09b6b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 2 failed, 91 passed (v4.9.184-103-gbb=
7044a09b6b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-103-gbb7044a09b6b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-103-gbb7044a09b6b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-103-gbb7044a09b6b
Git Commit: bb7044a09b6bd0f3b0a78afd25a4eb42ca85f50d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
