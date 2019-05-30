Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B892F8FF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfE3JJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 05:09:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34841 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfE3JJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 05:09:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so405806wml.0
        for <stable@vger.kernel.org>; Thu, 30 May 2019 02:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=KwLKUN8slvjd04RjjPvWvOTD/dy+wDNN+lQ29SfJmq4=;
        b=L3vsTD4glvbgj+ev/qNkSGIHk38D/C0vapNjbxrqQqhWTtevSyBB7sezZi+YFslVPb
         Z+TdCTChr6AkL0LY0EE1YtcIdq9NqNwNTDRIPh3orJzdDhMhuELqabzftd8KndtwMtCR
         xtk78PyeTXV+gD4WhL/8qbrCfJzRxw+WKkSpA00yTX2Mc32dQf+PzXckLi02AsK1+i+7
         04cU2H5SMFUDIueO4cERLqRS0G07TnWunrUljpfoOaH09C8dtWEQ0UexORZzw5GxvNf0
         pqTfY9vcrL314KxOLBamiUl+008zAyBrUEmN6LPegxce0Rz7xwomjVyHK6KPY7MgcwH+
         /bsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=KwLKUN8slvjd04RjjPvWvOTD/dy+wDNN+lQ29SfJmq4=;
        b=qastCr64fgc42GxIG6+K+167sui+v7cQ7jH4iO2qDkWs7+6RnidDLgSBUcKCSYDVRB
         ELtXgSEulOMTu875A4pV0kEDcInhKBHb54C136RLO0JQFzS3YV7shMs39Zt/xTgxzojt
         1Isudrz6+nbXJZxwKl8SZZtePm4BrznqQXygWhGa4wrazWYkIobgi0KMdsUyNa/9uHZP
         91jYDBK3NtQsURC7ROqx3FnBjD/2+VkfoCHh0Ilf7YYZGznLRnp1lZPNsHwnwcDsOsPa
         haaZz7zcoL9dbFYcBjJdzPHXLh0BlY664YqL/9c1ScwwtchVIpy6e2h+Jr1Q3sXUMVhT
         oMoQ==
X-Gm-Message-State: APjAAAVwA/+5LOghOT/YPXqGt+N+FZJuPpMNxWhTjosOxiCXTrTgW8ll
        sbEtB/r3Gja99zDe/kaUWXoWzjKXMeEJAg==
X-Google-Smtp-Source: APXvYqyvjde5WbkcI/hQFOanzLzO4AKbZ9BWC5gqEJdyP/xXB7rVQgkQzXOsdGOrF2ETwAW2uxXwRg==
X-Received: by 2002:a1c:6154:: with SMTP id v81mr1445550wmb.92.1559207346390;
        Thu, 30 May 2019 02:09:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h90sm6699497wrh.15.2019.05.30.02.09.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:09:05 -0700 (PDT)
Message-ID: <5cef9db1.1c69fb81.12cc6.0ca6@mx.google.com>
Date:   Thu, 30 May 2019 02:09:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179-129-g545b59ea794c
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/128] 4.9.180-stable review
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

stable-rc/linux-4.9.y boot: 103 boots: 0 failed, 103 passed (v4.9.179-129-g=
545b59ea794c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.179-129-g545b59ea794c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.179-129-g545b59ea794c/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.179-129-g545b59ea794c
Git Commit: 545b59ea794cfbac3646ccfab4a34c9f7753621e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
