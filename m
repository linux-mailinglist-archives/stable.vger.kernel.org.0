Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0303612DBCA
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 21:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfLaUOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 15:14:55 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43361 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLaUOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 15:14:55 -0500
Received: by mail-wr1-f41.google.com with SMTP id d16so35894586wre.10
        for <stable@vger.kernel.org>; Tue, 31 Dec 2019 12:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bomzr8f9aBu1I5bjtnv6MQkk78LIhJXJSWEUL4RVlQE=;
        b=QSvyKvgyrI+XvPYmoKty+BRz3OEU3ljF8Ba5d5CgZ7e9p+YC+UW8TfMKqWsw4bjm2M
         3AGkuQLKyYXBYr5jLyQoXMREQBB9HYnz9WhRW8kkQCVxMI56X+P226s+oFIY1qEvY2eD
         eGCEGlRHzGW5WuDR5T1cIXSgTfI6xqaUsx03NF/g7JOyCzh2jaIPVJDIICfOLWe5U+f6
         ZnAo8YjjxWlduwPmKJu78T/e2FHZ/hOeN/cayHwtGSOGN+SzXDCGZAEslVqSooI1t4tD
         zSI5ujxVMrKhic7EsNVxfg9ciBxaEJnjgWzb+0jKjTntrANTj+BFc8Duj59KKB4ZF91d
         xjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bomzr8f9aBu1I5bjtnv6MQkk78LIhJXJSWEUL4RVlQE=;
        b=jslVea0tcXA4zX2/Mi2thTVJlK5FWHMb34fFF1sbenjSauSIS1TdxBEWZcBBpqvCSp
         5Gx7nxEeEhy7vjdokrfaRcOWLFdk2KVJTyEt0fhmaWbu2sQIRkWOR/zsPFRDR4WOOQqk
         A5uFZ1NNNa33avBLnxavHb5dxdQJjs3AzpZa+bxKwsqbfQAhOKsZBMA8+kN/2QVAflBT
         RUrZqzxklXn9mmrk3PlCBtt+AKhqNRZOfEjy99MihGXsqyPajfG85440WHZcQRa8UEEQ
         FaI6KEA7A6e3XLoYOyb8R4OoE5aCwkfKkPpx08CwlmJTteYNnaVM9cyIKVHIAi/sApro
         uqXA==
X-Gm-Message-State: APjAAAW+QOQKo8O2BVR9yhzYMNI/74142sGiUAvEZ2SkuwX9bpe2mukH
        xNWEK3DdKDeEbiR/QPxKoIOV4sViBiitNQ==
X-Google-Smtp-Source: APXvYqzxSQ6DK++VOS2qdqtdimOImGxRZR6osU1+SVtDOQsZvVI9oEEVVhyuMRQ7/OC8RrMLairklQ==
X-Received: by 2002:adf:f789:: with SMTP id q9mr75485406wrp.103.1577823293475;
        Tue, 31 Dec 2019 12:14:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm51546639wrw.64.2019.12.31.12.14.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 12:14:52 -0800 (PST)
Message-ID: <5e0bac3c.1c69fb81.b551f.e1f7@mx.google.com>
Date:   Tue, 31 Dec 2019 12:14:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 79 boots: 0 failed,
 78 passed with 1 untried/unknown (v4.19.92)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 79 boots: 0 failed, 78 passed with 1 untried/unkn=
own (v4.19.92)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.92/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.92/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.92
Git Commit: c7ecf3e3a71c216327980f26b1e895ce9b07ad31
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 50 unique boards, 16 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
