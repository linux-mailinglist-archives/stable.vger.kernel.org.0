Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DC2B89CF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbfITDvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:51:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35573 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403998AbfITDvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:51:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so5262123wrt.2
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bYhxAbC1GFuGSLHe3pFEpx4f5zgzfkqdI7JWdaIteJI=;
        b=adgOT7nfbtZKzyPU+z7plKMmWix/1b7Ag1OWGOgo6VzX31M8PgoPHfssjahvjul5xg
         AoH/T0ct6oXrscg8sn8B51Y1eirC3TZK0r9mdlgWvJEEreIZMlLbfbnyPXKADkikbPZr
         60QqKJ69g6QjEa2NFmOIcUuSeIUTvxQWuSYw3CnskPXxzZRNECQdONfRlFN9eTi9aDj7
         8Af1quPaw7jq7bVnL942KACmFVbdSCzrvluQdNt3TmrA7Gw0K2js7jdt+DWe7oyU12Js
         EudxfnrMT6cSectUIb9UomtIGna6T7wI6UwpJaMgBC4fPdd1NR3t8VkkpYQ3k6fc8b4L
         zmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bYhxAbC1GFuGSLHe3pFEpx4f5zgzfkqdI7JWdaIteJI=;
        b=M8uNcDfY3wGdB1Hj11+yDWFuqnyweAksZ+rK6LFB25mu9/J1AtPMitKQmo5jUAqBBq
         tKQRpCswMBpF2Djqhw4pckVWWXo2AOHz6oe1amzRIuJS17Eo15uPPXH+t3cq4vqEGKxY
         q2slf2qZRwDL3fkCCtSkVti3Brq60A3fWOqHFWmFw7tJQoGzaikYN16YdW1tz2MvFRC1
         uxd1FRp8qXiWkq6KmK4S+2rGTwao3yKqO21jY/EaXBH5ndmbQnNRWqAgTnpT3soTWmaX
         qkmJtdd96wsx+tM6vdYCtVKFYMzBGl95tSSLGcV1T6iQRoDY+9ype1sA4dYsoq/xLuLM
         CMBg==
X-Gm-Message-State: APjAAAUphst2kDVUUo8QxY1fXNL6M09+2I/BGhXyvcbvKj/GaMfpHOFZ
        k16Ne7cMOmBoOefUDt4gxLwlBJ6qpiHzeQ==
X-Google-Smtp-Source: APXvYqxKuvbT/8Zu6IzlWgTH6R6k088zSa9LJP33UzzjmDicNkqZ/9WiCFyZQydDXyCrt9gRtdl/fA==
X-Received: by 2002:a5d:4745:: with SMTP id o5mr9536113wrs.125.1568951488819;
        Thu, 19 Sep 2019 20:51:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g4sm698880wrw.9.2019.09.19.20.51.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:51:28 -0700 (PDT)
Message-ID: <5d844cc0.1c69fb81.7a70d.2a5b@mx.google.com>
Date:   Thu, 19 Sep 2019 20:51:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.16-125-g690411952b3d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 72 boots: 0 failed,
 71 passed with 1 conflict (v5.2.16-125-g690411952b3d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 72 boots: 0 failed, 71 passed with 1 conflict (=
v5.2.16-125-g690411952b3d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.16-125-g690411952b3d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.16-125-g690411952b3d/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.16-125-g690411952b3d
Git Commit: 690411952b3d8cab079b16af04292f93643bb864
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 16 SoC families, 12 builds out of 209

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
