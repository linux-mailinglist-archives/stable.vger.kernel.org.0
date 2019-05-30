Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862682F8E4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfE3I5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:57:04 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:35844 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfE3I5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 04:57:03 -0400
Received: by mail-wr1-f52.google.com with SMTP id n4so575717wrs.3
        for <stable@vger.kernel.org>; Thu, 30 May 2019 01:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KwLKUN8slvjd04RjjPvWvOTD/dy+wDNN+lQ29SfJmq4=;
        b=XNa5CcPbtogf5vzEceHgWQVQjmO/5SjQ0bwQgxORBLK2Trq+cGRkrG/cG6nWRfU655
         4M0FXDNkDCX9xhB6bu9jmM5SI+ePN/07KFjOnKfZZ7cyciH59rtNrdCPDM6qAwyefrWu
         zB7kfIMVsNLJzeY48lPgAZjhy9h+AQznkDVFrxK2MAGwN675J7oMqqlQ3PhQAJtJfjvj
         /k2RooOZwsSvuOH4OQkq9m6JZrpYAZC+XTw0IzoI6/UAPJsWb5tLLuCh3tmj1oVLOLG1
         OEzzAETOjUoPXVZ+DfEjOOO9raw5AGhtHn8MrGIaT1hkRknNJ/vOfiV4QzEYkRqKHZ5x
         m/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KwLKUN8slvjd04RjjPvWvOTD/dy+wDNN+lQ29SfJmq4=;
        b=ast2lOYuxaNVut8J21no+dmBFUIu0eT+HARz3o0wsUbTqNeCjt9GDgwjR03u1NR2Oy
         3ZSWZKRHYTTRXTvd9ATeIdsLMdKhXTiWDnml3swxo9akfcYPi/QA+kQu/qSDMbzhaRjP
         M+afyZRAAX1XWRGtUjXzz9Ltc0BTieD3UMlMhi22ApPbJRzDOIHGmdzq6ScSRExYjYij
         qwd0G1MeUhfNBHqJoE05bGK1keMK6suD66heKQYKm8vr+ZO0HZkhBUXSG8XbfKc3cx1Q
         jbu6S7ghZXcfiLE6ehfPa6tRXSvyVlt5A5HDgZF50HPKFIwY2/WLPUYIHbvtEbrRlViA
         2WFA==
X-Gm-Message-State: APjAAAWyvIyv60KjlAs2bYg0vFVTL2WV6I/K4VaQP4zejWGULTpRfKHA
        1eBwglfADO/qKkJWfsysaOC7xHgG20tzyA==
X-Google-Smtp-Source: APXvYqw3rQJFuuHqO2Wsp4Dsk6h4hCqfeWyOrun+RTLIj/5VovPfVJ5F2nzXLrrEpbfqGcG1DdM2Eg==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr1781662wrr.7.1559206622173;
        Thu, 30 May 2019 01:57:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l8sm1432019wrw.56.2019.05.30.01.57.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:57:01 -0700 (PDT)
Message-ID: <5cef9add.1c69fb81.b5cbe.6ecc@mx.google.com>
Date:   Thu, 30 May 2019 01:57:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179-129-g545b59ea794c
Subject: stable-rc/linux-4.9.y boot: 103 boots: 0 failed,
 103 passed (v4.9.179-129-g545b59ea794c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
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
