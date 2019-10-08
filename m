Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5BCCFCAA
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfJHOov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:44:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52610 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfJHOou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:44:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so3479469wmh.2
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 07:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o2yV/optF3NskgVXzITH3UGnDwlxeZ31q5CWtjgLPh0=;
        b=MnnCQyFJ8kwUZL4h/LAiw2dOW1A4Wecz2TBpvRf29yBc8y6eBDdQ8aurt5FQOSgMFc
         XB1Per9JW6KUwc+3LJ0JUm4bb9NBEQs5cYkBkL7ID3vS/659fcPxfj7r2jfRvgpJGbZL
         tbWsD+x0HITUJwFhHeVJTPDd2xxDQo2+50VHXbpFKuHg27hOM7R6B3COlsEP4h7ksnwL
         jSEyP41YwAk38ydRAZnZh5lkykXekgYlG2JlkR6L8gdmZp5mgWnmGpHjQLBFEaL+il6i
         fMagS5DTAW6SYiGw/G8rLJwtD+f4oWXAD/UOZTTscfVJZ/KCTldoBUqL1mATbvoYGA66
         oGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o2yV/optF3NskgVXzITH3UGnDwlxeZ31q5CWtjgLPh0=;
        b=XoXu4QftE0dlFpGR56IsGz9bqEt1clGTtzaaVVvncLm/WtlJw6lvVOFkmbdN3b3M3w
         ZOrXF42kPj61Dai3KNMtUTIz9mpmcCnBQIwd02pbfSKDOcT8RpQznWpw0It/II0z0m4q
         yG30ZsGJ7Vg81iVkwFD5UyndgQgUJFMGZRY6nKf2L23mOBvKu/fa3w+bt0KJYlUnc+99
         ABzN20ez5PFHrd8om7QFwvsbkpdjD3teMP2cTNLUUo1C1rVS9XhpvB/OXaFw05H92duM
         c9E9I0EVRa1jKpXQXyn3eWdqfoiWD1aEIWSoQMiTs1JccAY4FbO0Z9p7jWMuQrlxCUqS
         fxnA==
X-Gm-Message-State: APjAAAVBPpTorgfL3kQcLCs+t0ZwHiPPBltVBbGMzAb3ztH3TShwAjbC
        TgN5tO8E/qi1bK2RbePt6vIQ0x1ji8tpaw==
X-Google-Smtp-Source: APXvYqzheOXU0nHRB2SQbOP7cwK21IiRKJKk//D4gk3hQthYaZVw2U/Hoyv7dZ/8fjGzdUviaKczzg==
X-Received: by 2002:a7b:c631:: with SMTP id p17mr4191350wmk.165.1570545888677;
        Tue, 08 Oct 2019 07:44:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r12sm20624573wrq.88.2019.10.08.07.44.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 07:44:48 -0700 (PDT)
Message-ID: <5d9ca0e0.1c69fb81.3a337.cce8@mx.google.com>
Date:   Tue, 08 Oct 2019 07:44:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.148
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 58 boots: 0 failed, 58 passed (v4.14.148)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 58 boots: 0 failed, 58 passed (v4.14.148)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.148/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.148/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.148
Git Commit: 42327896f194f256e5a361e0069985bc8d209b42
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 15 SoC families, 13 builds out of 201

---
For more info write to <info@kernelci.org>
