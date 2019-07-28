Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6505E77F5E
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 14:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfG1MFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 08:05:46 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:46381 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfG1MFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 08:05:46 -0400
Received: by mail-wr1-f51.google.com with SMTP id z1so58823312wru.13
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 05:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=REH37LnsssMPQHJb2nH3f8GxU6/3GpZb3P4JQOoYAXA=;
        b=PIqP024UNq3ZdNmlZ1au7Bi5b5NsdWZbBL/5reDHeFGW/sxlKWTU6yFNjiW41v5ltv
         nwjUbM17Q51ucN0kpyXnviES9srdjRhE+SL6hVcl+qC03qzVzXXq/bevG4vIRVzXceuW
         qPlU5v2tFAgot04U531Ieb4doi72W++dpN0++yXDMb8tDZltrNp5PD/9sVlZzIvTcfTI
         BmPug5LZYb+31BiWnZI/pNQ4SWN0J08JfeaEFxI+3P2bQXfNSZ/yFF9bLJMTSdvoPMzz
         2Ql443FQcj8Z5Jp0YPiY2OvPBC2T5NfdFK9kR821wFEwb3bXKzfAhJ6tYI/AZvI6Hcee
         3fdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=REH37LnsssMPQHJb2nH3f8GxU6/3GpZb3P4JQOoYAXA=;
        b=rsKHW61OoPsPYMR1v75inGNjDGk6rHIt85wnn21Kgm4A7QaMmGhljJMTCE60LOCkf/
         6MvoWKcZzY1Xy+vzHWNBC+lgkXjQRW4r5ZIcor2LVVMgLzNjPvRmPaDtkkrBlgNiRG+4
         Ps7TesexF2MhiMova+/IqwryxDfb1MrWfUqsOcg+3vwUOuVl9QkjDQX3Z0ilxThvIWfk
         6tH3w+ZnP3480qqVvTWhRlqHItSEOVpZebUQC2drN09P8STqOI6WVpqAagk0fVSMKHiA
         n5KrXlJOg6W+zbpvDP1CczNv+4kNLxfCX+Aquf+pOx4LupqRDq5Rclzg3WDjQYF9aWn2
         WYpw==
X-Gm-Message-State: APjAAAX+WCWeEvUAFIOwhU8tpqbmbVoeJwFOyC0qMNZ8vCm6vevGczyS
        d+J4c5tAMxT0LxmPnGADjKFQM69U
X-Google-Smtp-Source: APXvYqx3a1dU2hZFwaHX5oXf8FFSHvOPLISjB6xHCTvAOSAIO6AcvVgTLckCTRh153KhIi7505n/oA==
X-Received: by 2002:adf:c594:: with SMTP id m20mr88777417wrg.126.1564315544125;
        Sun, 28 Jul 2019 05:05:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a84sm72887969wmf.29.2019.07.28.05.05.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 05:05:43 -0700 (PDT)
Message-ID: <5d3d8f97.1c69fb81.14163.997f@mx.google.com>
Date:   Sun, 28 Jul 2019 05:05:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.62
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 33 boots: 0 failed, 33 passed (v4.19.62)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 33 boots: 0 failed, 33 passed (v4.19.62)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.62/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.62/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.62
Git Commit: 64f4694072aa4ac23eb9ad2feeb0a178d2a054da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 11 SoC families, 6 builds out of 206

---
For more info write to <info@kernelci.org>
