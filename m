Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F6FEC99
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 15:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfKPOKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 09:10:24 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46561 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfKPOKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 09:10:24 -0500
Received: by mail-wr1-f42.google.com with SMTP id b3so13998593wrs.13
        for <stable@vger.kernel.org>; Sat, 16 Nov 2019 06:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nvnyn7PQ+Vh/NS1vSFIIrtNvkYEBblg7IbkmnjttzLY=;
        b=prDRzNxahXBkcuVNyxqYNHdWs+w7aDkUBLbMl47YX6fSiRLX2BeHSsv3GQA1jep3Z8
         APhe5xf1DIRlUo2DvJLNS5Wr89ZAED6uzn/TzxGqZxFtpOpFCr06DPpVWyZpvQFso0m/
         9SxLauX2+9JhYclNHkIOO5VF6lFAnKelOC1XEIz8I5biJubfnpj7yHdZvJgxGRLi8XDH
         1mC6d9UJwR+cHJaj6Gx8cMEruXMi8M0xr80IPpMIhcxtMhdbLyKkb6wV38CY5gIatSmJ
         ZNhWryxQrn7hmAIpiJxsO89SRwlLr5uYKfQexHQznaWMn4YHr5a2nwD1hR69BQgVhPn3
         TJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nvnyn7PQ+Vh/NS1vSFIIrtNvkYEBblg7IbkmnjttzLY=;
        b=Rhix1BPo2OxNllDiD00xZb993XINWw/MU/LjhROtK8X7I/+oRXD07scoxY3ZT9vK42
         9p9OsZBqjW3LuEgwdR3QwT2SJNnAwZaLguPCFY+fOmnZnVs0U3sudcFrRXa3Txt5ySV/
         xOPJV8l1kOPdzLgLB4aupVVJf/yuyWoN5D6z8q9xddp3SGgzbcLKedbHgrBxavZidHF3
         5q/G1pR8NQKGwZ9qOyhsxQ46or+bY3pp5oxhC5WZIWpS16FVEHyRRVMOxN1WGA7z+8QO
         NchlA9c2vDfLbWumOXYW45/tld0YDeI+Z66Mt/HP2EbUzsA2HZRRZCkoIsoWVJ3qwJVj
         rd6w==
X-Gm-Message-State: APjAAAW70Zwrw+x66FbzXeXMBUDR3bV9SZl8jqALalFgB/kIA6+BhmOT
        10xHQDtB4+w6nm4AQSXFKPTba3//xco=
X-Google-Smtp-Source: APXvYqx/T0OqmS4wFIomuhN0Sbaq9RI6f4DM/ElNl2/PRkeoHPzFRjs4ntne9qTcmTT7O4VXW7hlsA==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr20688806wru.30.1573913422467;
        Sat, 16 Nov 2019 06:10:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f19sm17728456wrf.23.2019.11.16.06.10.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 06:10:22 -0800 (PST)
Message-ID: <5dd0034e.1c69fb81.4d2e2.35c8@mx.google.com>
Date:   Sat, 16 Nov 2019 06:10:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.202
Subject: stable/linux-4.9.y boot: 50 boots: 0 failed, 50 passed (v4.9.202)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 50 boots: 0 failed, 50 passed (v4.9.202)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.202/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.202/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.202
Git Commit: a86e4a77b558b9bdbae1192188ea744a3cf84176
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
