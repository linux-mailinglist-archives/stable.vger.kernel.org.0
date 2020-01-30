Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF414DEA0
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgA3QNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:13:13 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:34778 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgA3QNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:13:12 -0500
Received: by mail-wm1-f41.google.com with SMTP id s144so6771530wme.1
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FKOxgBA6VPlEmbdQGiKyOLrbZx48PHawIhzomuBmKpA=;
        b=CvwOALxCQ1bFBKIsA/v9bgU2S7xM53+QV6FMkGliX4S/60Y1JdN3O0apNGjkMALD9z
         XCQbKgaF8v9kHSqDWYIlSWutXkcntP143Pnagpch/UFYnA70dYm3+AMF7uOXcPx4zDT6
         TQPlEGXv964u16fWmZPdiwJvRIonxpCsLhvzHuyMb9kMJcotnCltiajmPDo/jaJtRUaQ
         5L7FdV66vYTiBUEfNvn5fe3iauQEAGgfc8N5esHaC44AZApcHReJlb5V2QqyuQLlzBgW
         +qgxSAWB+IJd7PCRIN2ndCrObpEZSfSRQe6mNIZTGNvpMp6eGOl50t7pJU8wvuZ9C38k
         kIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FKOxgBA6VPlEmbdQGiKyOLrbZx48PHawIhzomuBmKpA=;
        b=oPjNAenGUXBlcH0pV1fp4CjIEKoDb2e7nTx3+pdTTpLCrU/ZHA0D9Hz9/plG+SoZAi
         e8ZFo1MJZu/zapWWOwOrRQFYcqSR5IW3gUDGaraFTBG+burxMKr8nVe1IYqld18wrm4f
         sxDLLP3x1KhVILSphwCfr8VKFvdrsTjy+CSJErgJa0h2lXokKC9cXUrvvVpvJyMv5/GO
         QW2834t5nXnkAH6OXyoiIhz0w0zSXrKewxyH0lHcXxsKGutcDEKfG14yl/UWJhIk94zy
         aG57fD8SdOzifgmx1EHbcElBrEcBS0/CeAP733PxYxhRn9zgElGnLHVXmbeLHqf8ER7e
         a6jA==
X-Gm-Message-State: APjAAAVTD77r3NnoX7U55ErBeuygpwBMtbhJ4FOAxUNUObhCgrFMzGPJ
        oPQm7NrbWTvZzBBsuf8D/eV99XyPcWcgFg==
X-Google-Smtp-Source: APXvYqy/YjGEnE1KiBRkM/pQfvCns3ne2hz4LMZZLsfCsUNkrmOZ/IZPGqKqs6PlkjZeM117oom5/A==
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr6493154wml.180.1580400790517;
        Thu, 30 Jan 2020 08:13:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e17sm6601225wma.12.2020.01.30.08.13.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 08:13:10 -0800 (PST)
Message-ID: <5e330096.1c69fb81.2b3fb.e38a@mx.google.com>
Date:   Thu, 30 Jan 2020 08:13:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.100
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 53 boots: 0 failed, 53 passed (v4.19.100)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 53 boots: 0 failed, 53 passed (v4.19.100)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.100/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.100/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.100
Git Commit: 7cdefde351b6911ec5ef39322980296c091f6c52
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 10 SoC families, 9 builds out of 192

---
For more info write to <info@kernelci.org>
