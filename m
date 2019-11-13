Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A7FFA43C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfKMCPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:15:24 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36732 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729608AbfKMB4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 20:56:52 -0500
Received: by mail-wr1-f45.google.com with SMTP id r10so451735wrx.3
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 17:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x+Vz01mUoaGklNFwGB/fAwsDnbVK6mHRTjpZuhvd4H0=;
        b=YgEeB6ua2AYcdfQwmRI5MyHABbyV5RuhyOLJpbudQp8OQZBDlow8bhEVY75UsC4U1D
         VHl9N3JdfLafZdIVAR00Zkk0ZDxJPmgL/nD8Or3lbWep7Avc0YBlKpFVV07tcekR3cyy
         AKcR4XzgNaS3HCvW0zbxtr2soMpzWf3lmTN5tB94y/dMk/c5rp7LLOuZSLNFpzzRS6hq
         ZiTW3qGOnJjJomukfh2uTV1tfDLGok1qIu3cQzZhvFdAvevBWGXlHwNrsS2sGsDyJ0fK
         hwKtkIzTBPqbN0YB/dhlpXM0LeWYperT1xfQNjQXsLFfleayPv7egHcgTM+0KSaRwRkf
         mF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x+Vz01mUoaGklNFwGB/fAwsDnbVK6mHRTjpZuhvd4H0=;
        b=sM0T6SKq2bVNJHIPPmE2PQddKvvQk1VbdWNTZyBtjRyyKu4m2zbS3Sk4MLZvyWQRN8
         c26BPEkwscIJYkTbCZ//F//Z4tBqCSFUhDtJQ+90GOuyvIyiu1rozTsrNLRTOCKnDzru
         2UzquBnp3CcL/bC3iaPQ/ZB/x14IozcU0i+2y64nF1aHU55GvJoRtFrB4DpA2uB0rks4
         bZacQhdXbVSRzx1CoQpKD3Rsqn+xW23gWqv53dUmd4TYSwgv6TkcPzKW5BOVg/DZc+kK
         INwg7I4W7S7WegODatkxNX2ey1jj53ueIgoc72A0vbzWUeMevxjuXf1Oip+PNQ8GYkJR
         0XHA==
X-Gm-Message-State: APjAAAVB83AV0xyl9IqZ64zmsqpsMS0B7NNn6Ubl4BnlzXB9kmdS56hD
        keYopxCZmQbM0uaV+pFx9Fsg4Y6pjDfmYw==
X-Google-Smtp-Source: APXvYqzH2sPOsjijkoq99ABZiXcpKNS8vb0qh3pY46avx1uk4wlivtZ2NPlVP/oZ/dSV/c4kMST51w==
X-Received: by 2002:adf:fd4b:: with SMTP id h11mr275230wrs.191.1573610210427;
        Tue, 12 Nov 2019 17:56:50 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p15sm510764wmb.10.2019.11.12.17.56.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 17:56:49 -0800 (PST)
Message-ID: <5dcb62e1.1c69fb81.aac86.2122@mx.google.com>
Date:   Tue, 12 Nov 2019 17:56:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201
Subject: stable/linux-4.9.y boot: 45 boots: 0 failed, 45 passed (v4.9.201)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 45 boots: 0 failed, 45 passed (v4.9.201)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.201/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.201/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.201
Git Commit: 9829ecfd824adba0396cf5fa8dcc813f4c0ff754
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
