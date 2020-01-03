Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14BF12F443
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 06:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgACF3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 00:29:52 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41327 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACF3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 00:29:52 -0500
Received: by mail-wr1-f47.google.com with SMTP id c9so41335891wrw.8
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 21:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f7naSDozbCgRo/S3WnI3+s/65vDd76dcUpQHC/Z15xI=;
        b=gBNdPKdUMs4uejFsTqJkHHsNLvpo9fDyh8STrZjYZjlL7e0Iw+/QT+u4AcNsLW03WQ
         X5A9cTlUmUm0vcMk5bZUxtaphHXsJVxT0VxYKGGeVx8KkJLM36UT85HQiayb1+NKRdzo
         LSTKNgP6F+MoYm8C1l1eUCumRUqlBZE0PQvEJ2Ry6khBziwLadBOQdfrJSXXTwVn2iUG
         m9QOm8MSW9QskLMRO4FM3qx+QTtmFx2EvBGn8JAo23Svb41uIW8XXKgg4tNIEdsSsraM
         B/Vn49RuNlPRt9AR5RMszhL2g2RxjnNwp5xnhjk1JPDl9uqNbaymnSIj7OJUtoqoR6Yy
         uXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f7naSDozbCgRo/S3WnI3+s/65vDd76dcUpQHC/Z15xI=;
        b=qdtH+pxpID+RvMHXT2H3SsYIy5Dkhae+uhdjKjPduyxQWEMutm2fK/x0ZnAEDkiXqk
         fXBFDHGWo2dUEJkfkOJibGuFf1U8fIu8+TvVU52XdKhrf30FygJuk4eJ8OUwPXtbI3CV
         N5IDyRZDdpMTW0LQpGj6tl+K8xegu1qBdI2bPcHml/LWNzMFd5qX6m4JgJ8WG6he4IAo
         2fTVcDE60IOXpbqPDanuReNL6eptIaDgwRWKeEmUn/kItYl4lVk1pEE92NIFew2IcY2e
         7b+uLt7KYYFg9dmMyytw/FyJjwTQk/6/9hRE2CmcsDKkIasKbO3NuEI7pgoKw00lk5YQ
         mSjA==
X-Gm-Message-State: APjAAAV53OpFAf7tQgzYW5/xGkUZDS4hXUctyBWmEktzMMJyKpT59kpl
        NKEq4Y4nJMDqhzyjfTPLuguHaJAKjdW1ew==
X-Google-Smtp-Source: APXvYqxJU9WCDb73nmxzNGxnhlS5GJNqGUneyAr7WDsce9T0eLioI0jMLvSZsDvSAVk2waTJPTR9mA==
X-Received: by 2002:a5d:55d1:: with SMTP id i17mr83668706wrw.165.1578029389934;
        Thu, 02 Jan 2020 21:29:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p5sm59503554wrt.79.2020.01.02.21.29.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 21:29:49 -0800 (PST)
Message-ID: <5e0ed14d.1c69fb81.90ae.0e2e@mx.google.com>
Date:   Thu, 02 Jan 2020 21:29:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-172-gea0b96c2917e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 39 boots: 0 failed,
 38 passed with 1 untried/unknown (v4.9.207-172-gea0b96c2917e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 39 boots: 0 failed, 38 passed with 1 untried/un=
known (v4.9.207-172-gea0b96c2917e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-172-gea0b96c2917e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-172-gea0b96c2917e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-172-gea0b96c2917e
Git Commit: ea0b96c2917ea73aa7b141bc3b5be3b157aea5c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
