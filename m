Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFEF135E15
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 17:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgAIQUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 11:20:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33845 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731343AbgAIQUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 11:20:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id w5so2405521wmi.1
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 08:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aNy/5yMDJQk4Y2dmjLxXBPeqcgOpHKp1qhE/kfRXnUQ=;
        b=DkufnZs9IZwVs9VHL0ojzwcHRKUYrRGzCXqN4j5V29KH1kF5mLuHmKGav3ovLbfjxB
         eaNdT5wdXMQ+QTYv/ZZXDOvaXfx6iqrL6BlgEbXO5fcv9xPZSnjBsM8mjBBdX0p3eDBn
         nQtV0Rgd0nNRL++sP2KbjmjIKhmyudvN8HkYQPzgoNPNXDTSnLgbxnAdpNJHzHmI587n
         92MB3zCCKCYTGdcWoHzdmPZDvSij8034Eg9gXFOCti1vLWRQ52tS94TDT17CUQdCEpml
         iZE4w4yk/pRFbZlAMf7j11UraF9i6bApWd+u0ehNTU+7JF9Xt7VBU6k/m46r9isu1ZVP
         pYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aNy/5yMDJQk4Y2dmjLxXBPeqcgOpHKp1qhE/kfRXnUQ=;
        b=b0YY6CTamjJlUkbVlWm7ckDF4cs5QD/+f8FlvIVtPCmhVeXCmN7qZn1N81bIY+Fiyx
         4ByHHd2FV3Km9f7KT8C9NN5JfN7xrAc2VvaK9YSAl//aPF0T8xmDNs1+fMIA4mfvn3BW
         xi4tQ0rf1nwXddzJWMLQqaP8ITemg3cDAtchi4EjhgOfSv5R2eno9pIeB3ufgxtK0h3y
         u9JMe5leTh5RG8dVhHXQzU5KYcnjKIpmdvazvjfaOO9QwKjtNDuwWeuEbudTons1eQyH
         BwJ5J9I5nAe/pLDC8wsFz8I0ysn0RbfA+x/KjD8JergS9wvJeRzj+nuY6R2XrI9WladC
         85mg==
X-Gm-Message-State: APjAAAUy5XwlmJyvcGqfYzNXV2bNo5HCbq6Dt0wHBmsxh/5z6HVCEh8y
        XLqXKAnJMdn2paWo9DgtRiIfBQb4ZNJuZg==
X-Google-Smtp-Source: APXvYqzSE74hJqftMkN4/xRk/sqD6PGlX1f1d9RYijrZJWcv1AoaxZkvWf6nQHxwBZKfqkmPJwT1pg==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr5787106wmo.123.1578586838894;
        Thu, 09 Jan 2020 08:20:38 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm8565070wrq.21.2020.01.09.08.20.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:20:38 -0800 (PST)
Message-ID: <5e1752d6.1c69fb81.b5f90.a310@mx.google.com>
Date:   Thu, 09 Jan 2020 08:20:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.208
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 45 boots: 1 failed, 44 passed (v4.4.208)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 45 boots: 1 failed, 44 passed (v4.4.208)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.208/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.208/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.208
Git Commit: 6a60263487c4a8543275bcc707561369522bacba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 10 SoC families, 10 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
