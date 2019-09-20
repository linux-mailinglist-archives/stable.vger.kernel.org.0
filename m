Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA7B89C2
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389424AbfITDho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:37:44 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:34029 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389114AbfITDho (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:37:44 -0400
Received: by mail-wr1-f41.google.com with SMTP id a11so5266784wrx.1
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JxSuNDRTNY122iXEX/hS5NZ0dE0XPc1tRWWP3rVxMFQ=;
        b=ywUGHjNNWT9T2tWgbzSWvCzUEIVrxFbKjZLSdeFi3nRrb8oYYY40woCHQyLpyhBgck
         6vsS9wqxgg6pZ99C60RBs19EXF0s6ph5SmMD7lkv3Bga7yjZGS+Qd1Z3hvnng6HWh+sz
         rydmDEEs9Lva/CY2ULXxfVhil6VYtEpEkz0ijyzCT48Zklkpi7FqgW+4DNd7+0TvTLwK
         M8STecsUychEDEeQ9NQ9NlMjUj5Fwx6CXefR9gEp4/zhMNtgy7Lv/yvv7VW3nB3V2lXx
         vXHKpDb3ihEyq+0Il8ntZ6lOhI/vqhJnfqscgW9tX86zZZpkeOnUdLQ56gQqFgfzmoY1
         nt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JxSuNDRTNY122iXEX/hS5NZ0dE0XPc1tRWWP3rVxMFQ=;
        b=B2ilinuxfekHcttXZYnNQx0z4GJrTR2uLPlDUwO63YorzLcHLaUZs6tkFqMebVoOVH
         7kURzwkRbrfnkS1sqfKsRBPos994clDlvedshwu7pinytJ+NULDbtBvFitMpB1HyHRQa
         9CBWV4XjAJ+pfKR1L9qTFmNbya2+DySfVcYthYRYNfm9Jrl4A9Ym3Vj/KfQGd07JM5VD
         5mHA8xBUY6mB2rrfl81BHv9cw70zGQhS1j/JUIw13eP/+Qv68k+HTYqn4WMFZEDWoUB4
         v27epoPKTmPrp48hWbEhmJ8FpqSUFNK97w9KKMsPvSP67O+neDLhh/E7l64u4ESzbGAm
         2Vww==
X-Gm-Message-State: APjAAAV21S7LCtXBzh0TWIbsxrNckQ0IyGzkngN0k1pmiCQmpaYwI2G8
        e4O9BSj6XLfjKl5jxWrV0jZuh5YyHJQ7+A==
X-Google-Smtp-Source: APXvYqzJNdXcjyA3y1LzD+yCwWyTg9KNotR7XgTH38Qs4FsQiJO/ZhSM2k5gNC/ihryp1HyE3sjP8w==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr10626779wru.284.1568950662406;
        Thu, 19 Sep 2019 20:37:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b184sm743032wmg.47.2019.09.19.20.37.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:37:41 -0700 (PDT)
Message-ID: <5d844985.1c69fb81.30731.28b9@mx.google.com>
Date:   Thu, 19 Sep 2019 20:37:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.74-80-g42a609acc1b2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 68 boots: 0 failed,
 68 passed (v4.19.74-80-g42a609acc1b2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 68 passed (v4.19.74-80-g42=
a609acc1b2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.74-80-g42a609acc1b2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.74-80-g42a609acc1b2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.74-80-g42a609acc1b2
Git Commit: 42a609acc1b2b5a744dd9ad3d3eb6a71906e4bcc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
