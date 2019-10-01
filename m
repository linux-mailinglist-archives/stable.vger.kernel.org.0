Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FB8C4077
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 20:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfJASzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 14:55:22 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:36430 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfJASzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 14:55:22 -0400
Received: by mail-wr1-f53.google.com with SMTP id y19so16805424wrd.3
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 11:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yFV1AKsyfk3K0QQwe5r12YoQOkOMd6fjwRXJoAK6NI0=;
        b=RIw5RCdPYkngltcBw9YYOjWbDAs4nH4CjQXjZ7Ec0y7RziN4oaRPBuEqqpcA+VknYM
         n/6ha3XtCgCK9khDKEEIBL7VForQh788jKIhoHTs2KTIXwdsqZe1PJ/EypcWWplPy1uV
         wFcmtgmkBSniIoBffX5jesC0CUGfxLu41Cp8Cxb0Sojedz7V/fklnQSFDLmyvs432F3r
         ekuahF6AmljgV3FnHLU32saV1JHoz2OmavgGv2KeNSXTcY/kXemRz+8x+MzOLnBuPXAj
         grmfRcrs1IHsgKve21mKyIZwqCK2/NrRAsBnCsQ4NRJeXCK+KtEq6tH7o++Gpwqwezd7
         1a4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yFV1AKsyfk3K0QQwe5r12YoQOkOMd6fjwRXJoAK6NI0=;
        b=TjlBK/VN3/ey5on3VkwHyDL1XXkHL4MEU/KOW35zWriO//qXgGYp8FE7Qa+vUa3OnC
         8m/KlPuAc2Ntj0OwMBJuSsvNZ7CqQiuRJQKjw2pturF8IwOnbJNaRNuXdVPQM8VphDoQ
         +2Z0M+OxUCu9odi/owGbWs1JYLXbviWr00bTtv7pva7S+J8Y7tle7qH+QSGLv6zvbq1+
         LvHFhmBzBxWGFKP1DMTz2Jlbznuy0z8lxwKoVKBhftKyn603tfvy3sUGTaxADTi/XqNp
         E1TZYBN55YdbsH83GGnIlf+MJmdZyQQ1G2o94ASsOzwlkL2ahlncVof4rJ4EupjbmMNI
         F7jA==
X-Gm-Message-State: APjAAAU/42mAMZ5qhwIBj7nwnyjEz6vWW7APGgz0LvxY1Y/f3EoH3HcT
        EUltpCcsu/VCAzM/ggOArSGtQsIjV03M6Q==
X-Google-Smtp-Source: APXvYqx0WQdqysYuqcghz2gZTZv43ibvnincCzL6NKDPbCpJhGU1ZwQss1S+zZymvkHUZ0NSEuNDKQ==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr18571528wrq.292.1569956119307;
        Tue, 01 Oct 2019 11:55:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm16633071wru.33.2019.10.01.11.55.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:55:18 -0700 (PDT)
Message-ID: <5d93a116.1c69fb81.4ea2.cc4f@mx.google.com>
Date:   Tue, 01 Oct 2019 11:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 81 boots: 0 failed, 81 passed (v4.19.76)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 0 failed, 81 passed (v4.19.76)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76
Git Commit: 555161ee1b7a74e77ca70fd14ed8a5137c8108ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
