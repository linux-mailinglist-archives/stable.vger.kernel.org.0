Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE845EEBE
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 23:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGCVoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 17:44:10 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50369 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCVoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 17:44:10 -0400
Received: by mail-wm1-f46.google.com with SMTP id n9so3699369wmi.0
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 14:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/xHMBSCyNyPLQZbN+aXXXLknJNfd8kn7soj3OjAqskU=;
        b=rttFcL8Sdun6LKlpHmuWdXNVBZDkl2NSVD/6prONnHaWdveD2iwy5RRwuzb/wVGZk5
         OiP+blXs6xrSgY3hDfVz45TgX/KRsvY9Z/e4B13DpvuE/W/CpugKDsXBc4JcbeMxpQxT
         5+7Jpa5HHc+0nijnrTUUqrDJqUJH3UK7kyalZtti3BcI2Mrn62O4YW9EWcVziO3tKD8o
         UsUtaxffP9rX6sje+xIEDJ24dDUWt2OANTE1Jfk0YDZsl8WIYYkrJYCTbETCDrVoduUM
         iNEUi5DRNq8ySk+vK2a/D6RF9RjhaLTPvB1TyPAmF4J7BFJ97BxKueOo9ZMEg4Jk7MmM
         rr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/xHMBSCyNyPLQZbN+aXXXLknJNfd8kn7soj3OjAqskU=;
        b=O8IjekNJ1gj1btkCD8g/NH24x6Xr+fiSqKpwNKKxMuA0HN57s2j7B8pbyoGCUUOPAY
         ppfJ7MBYADvaHwfA6gYB21/UK6iUHuX3k4fxYhxviwYjsqjBW3pOeMl7YpxCh0r4GQIL
         8/hQTo5KfiP6KevwQyECq1pj6uJ5XbSPkjjJXnx3wMssUg5lACuH2at1rDhuQUmtZfsR
         NiiGU1ZU+GqQo3p9qHfjvziM74pltMRaMkA3bSDZUhjjr/oWiF9kH5W5PHUGnTjHD/8h
         OsB1k616BdHnPDu0b9y1RhwmAL4RW7Yksy3tPWyRYlRvHqUFYUiwNpmv7rzX/z5HZY+E
         aMrw==
X-Gm-Message-State: APjAAAW6Wspkdde0EvyxgQyLEfj714hqYWXg6YQsXa2a3Lt4c9tQbwya
        9yyeh2YfPF8aSIuhAuYfDThmhOt+/N4=
X-Google-Smtp-Source: APXvYqyx2HotBj81QND+p9g+olq49FREdpZa9MLtUpu/Zps8J8JlBhqBYEf/+h2LxIh5DPzO5OSSJQ==
X-Received: by 2002:a1c:f001:: with SMTP id a1mr9838279wmb.130.1562190248377;
        Wed, 03 Jul 2019 14:44:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r12sm4904585wrt.95.2019.07.03.14.44.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:44:07 -0700 (PDT)
Message-ID: <5d1d21a7.1c69fb81.545c2.d257@mx.google.com>
Date:   Wed, 03 Jul 2019 14:44:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-66-g79155cd391a8
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 108 boots: 2 failed,
 106 passed (v4.9.184-66-g79155cd391a8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 108 boots: 2 failed, 106 passed (v4.9.184-66-g7=
9155cd391a8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-66-g79155cd391a8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-66-g79155cd391a8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-66-g79155cd391a8
Git Commit: 79155cd391a84955f618da0334a3d04791a5e45a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 23 SoC families, 15 builds out of 197

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
