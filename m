Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0C112F1BF
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgABXRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:17:13 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40285 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgABXRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 18:17:13 -0500
Received: by mail-wr1-f48.google.com with SMTP id c14so40845884wrn.7
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 15:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=noZNbpiIRr2TlAW1MR9hU5J+AQIBw2OSa5XsIh8KHMs=;
        b=gBSoruWdJ7wtUvYp1mGrxhz6j3R9pEX9nTDYEvrt+KFDxiKv2I7/xv8o//O7eisTS7
         LQ20Mzq7DAQLbPFsLr1Cb0vBY5pcNmOu8wC4TEMXqufhotYARyIPK+nuWkD1XsRJaThk
         Klijtm79uXvyhx+67B3R80poPi0VahBwrFp6uGDaobemAyv4PeId+jjDW2JmH/4+4wcI
         rEdSpmGDhiFGDBJfJjT9C5JH0jocu4bHSvebSZ7DF0ZKxLGmK7SCvLZKcxmRMqyIP+DR
         d4tWt7u3ejX42iteQtq+OnI37eLaq8efML4kX0H0ntpvCoT0BL9ZA+lBbcfMusiK+F6e
         iUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=noZNbpiIRr2TlAW1MR9hU5J+AQIBw2OSa5XsIh8KHMs=;
        b=NJDkZZO+2s+PZ9hKQTi8wmPPEJshBCfRH92fH2JrErR1Hki6pKHMax64jdt6KDUWOP
         25ZFQlHE00DGa2i9gLC0aQvJVxMNMuo3cCXS2oGOn0dDVmuyoqPmNvzs9iGGFLEgRP1x
         +3vvoqua3Zkp7zoX86OXwDznQF9+M5C7wUFiJDnFPtN1Cd5yoZDDCIg79Ami6ZEFTlfo
         C5LORpIgef2LDdbiROtGQzMEgCNRoWurMh9NMzbq9TO9UkncsSh6OUaSmwMtsPzcsIc+
         FcMGC6GxZLIvRS6qrF/HhDNcy9th9eupjW4Q4f5JqmIORs18a4QtgyiMIqADH23wKn5o
         tw9w==
X-Gm-Message-State: APjAAAULr0uZ1m4BUPkh2jZU87gankil0IwC6u3WyhprivBHJiKB+UC+
        3tzP7EK9Mpg2zUlff0UzmR9s1xUXZG943A==
X-Google-Smtp-Source: APXvYqzr+CKgfWKW5jvfNzArS5rf9eHPHlA9LszGn/UJvxCQFD9HuzhE+jLxqSu6qWjlKAW9oWuY/Q==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr86225724wrm.241.1578007031190;
        Thu, 02 Jan 2020 15:17:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w8sm8843506wmd.2.2020.01.02.15.17.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 15:17:10 -0800 (PST)
Message-ID: <5e0e79f6.1c69fb81.7992c.9591@mx.google.com>
Date:   Thu, 02 Jan 2020 15:17:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-172-g65d549b9533d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 39 boots: 0 failed,
 38 passed with 1 untried/unknown (v4.9.207-172-g65d549b9533d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 39 boots: 0 failed, 38 passed with 1 untried/un=
known (v4.9.207-172-g65d549b9533d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-172-g65d549b9533d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-172-g65d549b9533d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-172-g65d549b9533d
Git Commit: 65d549b9533d801010dd2ec911310eaf0ef400ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
