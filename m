Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083114378E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbfFMPAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:00:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39137 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732594AbfFMOu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 10:50:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so18457460wrt.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 07:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=+RVryizvvLr6nOq3Y01zEZUNig98tyiJRX4i4NCALjE=;
        b=xBJv0v0TSyN8bw8PWIksiodNdVnS0bNOdkdaPCTrqfBtTUc/nGc7nWBbWif5k6JkXq
         usFYBwUlCOyMbDlh/FoSW9XPYjS4T230SW6n9glJj8zd5JdGL+GgQWRqNOvfecnA76gv
         6eOjIzXDXOs+yI9wxF61TSNQmk+Dle+G2T5o8kb0NZrAzMmngu8iOLmOkjEK49lMI4Io
         zdnTk84Bb3fx69dbQ9/Fn2Z2FpdvWpDdh+x02D6nyiegk/N69uYDNWkhDxMEvBPqyiDz
         FDXbZFHu8L6A4PJ4w7kFm8OQCfuuagTkO4ZSAHMS/2hCdvSIAqCXPk4TiTg+2fd06jFg
         yAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=+RVryizvvLr6nOq3Y01zEZUNig98tyiJRX4i4NCALjE=;
        b=rWYMbgaccR2ZiPEIvAmi+BYro13JBxJvj3hvQBNBxYalHkmwJhlxF+rVm+VAnmH2pR
         wRWxQGeXD/oyxC1XxV375L8hdjVt2rkt7OJKl033TkrCz8dUpaeg0E3RipJCbn0aOB7K
         G404nvokDMFrvBczO6iqicEqrGGTzkzELbUqV1Snc2NDYBqtZfIZmsIoNVgrlRzQKZe2
         4qmRjKzUqaWgvR+BWLw0YGWczc2rd/JQtrYzGrETZgRIOqmUi/WMzeVAYrZQZzzBk3eQ
         kRPFn0DFNtu1VNfiPybDXdLmlzsnxTV9h9coBMGjWP3tD6rROC3p5Q1RfcALtiLW5fxF
         1i/w==
X-Gm-Message-State: APjAAAWl61AojnRQLWOIlyB9LUs3e1dObHA1eKgEjgMNGQFgdrj68NoC
        k9coJAParaTtR1g89eT3CskFEmaEKQf9AA==
X-Google-Smtp-Source: APXvYqy/bH48WG2Ohg8ojqkK4a5frK9X1C6pgGv/KXkJRNWsBDmprDYicYLILR5YpvGxfREuljEXdg==
X-Received: by 2002:adf:f709:: with SMTP id r9mr28995624wrp.281.1560437425787;
        Thu, 13 Jun 2019 07:50:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j7sm5185106wru.54.2019.06.13.07.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 07:50:24 -0700 (PDT)
Message-ID: <5d0262b0.1c69fb81.7fca4.cf70@mx.google.com>
Date:   Thu, 13 Jun 2019 07:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-156-g10f90b20eaf9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 59 boots: 0 failed, 59 passed (v5.1.9-156-g10f9=
0b20eaf9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-156-g10f90b20eaf9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-156-g10f90b20eaf9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-156-g10f90b20eaf9
Git Commit: 10f90b20eaf9cf31c4ea0cbaf10dfdd807834a6c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 29 unique boards, 14 SoC families, 11 builds out of 209

---
For more info write to <info@kernelci.org>
