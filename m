Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE82F7BC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 09:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfE3HJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 03:09:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54057 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfE3HJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 03:09:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id d17so3180113wmb.3
        for <stable@vger.kernel.org>; Thu, 30 May 2019 00:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=JMEyUWmXaaJsTdIjDAGpIIBvFDGVzyT1a58p8wvMwLA=;
        b=O+nkNooXREb8oEHsMe4D0xQ021puf5mtSoYotiMf+FTdvgEydXDuFgFLsz8UZIclME
         0d5hPZNAhJC1NG4ommMzDuA60ZDO4/2s02aTCn+jOZceRVaD8YiYPSYAMxEMuo3HCz3N
         pmWVYk3bGOxAJAy3e/+faKszONH5KOVeK1QzkE1jrUo7P7uGaxW2c8J+v6mXYtif0rna
         x+/RoTQ0d5MOuYLMwBwyT1LlMaCM63NlMzmMgdK+j2vhjtjIhuuaUv6bCuNiSZtnE7AI
         R4JbV35U62km7E1cAvJV9CnGtfy0ECDIlFBosVdOATdJ17XKRKT1wq1bim595H6OyvUG
         nLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=JMEyUWmXaaJsTdIjDAGpIIBvFDGVzyT1a58p8wvMwLA=;
        b=LuJmP+O0lM23qTzsMlY6FjgKIMqxUV9mh9Ye26eytan8lMeX+qBDdwjASuPeYbH4Zg
         Nt4VMapSZacrwDUKr+BIMJ0P7lLX+x8uyawcBnAiFzaMB1ODNZebwFXO5pcBzDDjw6TG
         Wi3rsZUeDjcHzSis3dFM3JkLgkH/JaUTtZCne06VffkwiYgrNXFkosbP2h3u00wVmOiJ
         P4uGNALOPuMx6/4q99ywg9UONjv4ok+DMkObIykj0/hW8F4ftxdwuvrVUG3RdaM9I4Gx
         ylopFKG1NmeVb4m1llZquU13aC72QujKsCbhxJcuE8ydObvYKKqNhemvQG35a9jHFDw2
         IQxg==
X-Gm-Message-State: APjAAAW6AKRYQf6lxDq38CNPw00ILT/6y9SYozFyN3c/TehyCQLWcLwU
        N0f4KqM5BO+sUviKSWkTRRQkLg==
X-Google-Smtp-Source: APXvYqyje7NIy69xSH10foyXe2FT8RiQoQNm5jxPmxP0XqGbJStZqZleNiblthw4qYhQuuRVNCsSBg==
X-Received: by 2002:a7b:c943:: with SMTP id i3mr1191110wml.128.1559200147022;
        Thu, 30 May 2019 00:09:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o12sm1603833wmh.12.2019.05.30.00.09.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 00:09:06 -0700 (PDT)
Message-ID: <5cef8192.1c69fb81.fdefc.7e69@mx.google.com>
Date:   Thu, 30 May 2019 00:09:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-277-g9c8c1a222a6b
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/276] 4.19.47-stable review
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

stable-rc/linux-4.19.y boot: 118 boots: 0 failed, 118 passed (v4.19.46-277-=
g9c8c1a222a6b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-277-g9c8c1a222a6b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-277-g9c8c1a222a6b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-277-g9c8c1a222a6b
Git Commit: 9c8c1a222a6b10169a5d95dd02011515ff85f709
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 22 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
