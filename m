Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7878CD9CA
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfJGABU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:01:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37648 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfJGABU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 20:01:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id p14so12137092wro.4
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 17:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=8A/b/buLvgq885sAoN7Nr0i+KAjyO9HJlZWwmpkzPBM=;
        b=WaZ49LUblvFIfMvFw/zQrha2Gu/0bUasotvpoLH54PdQvaMX/AQvQJVxby8EgF8dPA
         51DU9Ote9sOvhs4/jic85DXGz3anNOfxGyjkgbeSVVoNRMnSdd4kcsS5sThQmwUnUGl7
         4ieJL/UUJcyUEH/fplSBvI1UkJ9x0bb63Wv2o4xsx73OxOfG3NNAtbwWwKvtQgv+jwK0
         rN/RcVwZMD8YKit9FDMYntFrFq64TyExgRiOefxXJuhB6VGcR92nuJdJ9KrxFvMUKQws
         gzHp5En3AXRq3c6r81BM+xp85LwQxnGtCovaEHFL0moUb/ROyj72Ict6En/aN9s0od1f
         A6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=8A/b/buLvgq885sAoN7Nr0i+KAjyO9HJlZWwmpkzPBM=;
        b=ugzQr3j9kaz7yltE1WXPX99rnxEMHeVUKGyh2JPGzAObbKRxjW3i+b2v9VfZecpJs1
         N9g6zTH1Dk3YMcgNuDA/GQ3wHCzcGCV/NALUyZmlo1B6oLRLmwjS5K+v0o2AWWreCGdK
         VCEZF4I0EIqWOLdDLJIYE8OQNYpelfO4/aYIcNF/nk0NBP63BXsQMkexkU9v4DpWzZnJ
         jQqPqC9WqN6TUKN1JgfTVcWEfI0wf9JcA5r2WzwI/IykXdkAzkVPde/2hr7j6Wjqy6uB
         r47nlZKkDF60+PwUlAnQ7HFE6Av2abdU22lb1Hf5YFy1kIJWczHgINe8HKH2rWtf/dBz
         pv+Q==
X-Gm-Message-State: APjAAAVQl/l9++ctlieJYqa+PK4c3mGmj7XuvaArNQZALMWIxzYcCAjE
        7ujn1FJ36LaAHqxRFRVFEo8LFg==
X-Google-Smtp-Source: APXvYqyT+osXHm4zxc/ZrBzht6GDZ1DzEJEIwzpu3A3usSFzEHJfzlJBvMXFUdidEn07lEqvd/mYIw==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr11221308wrj.153.1570406478717;
        Sun, 06 Oct 2019 17:01:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm25830666wre.91.2019.10.06.17.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 17:01:18 -0700 (PDT)
Message-ID: <5d9a804e.1c69fb81.cf4b6.33e6@mx.google.com>
Date:   Sun, 06 Oct 2019 17:01:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.77-107-g61e72e79b84d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/106] 4.19.78-stable review
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

stable-rc/linux-4.19.y boot: 56 boots: 0 failed, 56 passed (v4.19.77-107-g6=
1e72e79b84d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.77-107-g61e72e79b84d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.77-107-g61e72e79b84d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.77-107-g61e72e79b84d
Git Commit: 61e72e79b84d3a2519ad88c10964d7e4fa11ef1d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
