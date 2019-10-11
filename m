Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC90D4B1C
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 01:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfJKXmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 19:42:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35416 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKXmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 19:42:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so11616335wmi.0
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 16:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iSemPz+q/Tgqo5jpoawtbPa4U7tuKze8cnmR6pQdWOs=;
        b=K0HWuda1WTU0gNbTWNXNINNkYgAoiYJTnZcX339D+cmEari4JkljYfHjmIL83euvBn
         vKU6HE66Rhvbmx4U7v7gxoRbkI6TVKK7djwN5+RKE+cZG8Bu0e4GnQPggP8CkR5uNxao
         i3Z5b4/RX6+TEi+JRvwLZiKajZhdwY83v5JKBXwRq2EPjnFv/cR+iL7iisRQi93cnvll
         W4MjBE4FslPXOhuiEUudVjekV0Q/y8NgH7BggCrmeKLY9dKFgI2+iBUfMEnExgLX/L4S
         K62IuBk849CHjdMx0FOYog+b9Hnpipiac5PT+4nnkYe3anSWk85H1y9ssZS1ol1+EYFn
         hl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iSemPz+q/Tgqo5jpoawtbPa4U7tuKze8cnmR6pQdWOs=;
        b=JEQVTZxIEQCKww5CNBuKX26bxsq+Ve/GpNjNJzMSdC1vUNoSDcZDgQkgH4EIwmM4Gt
         6CLp0GahHMVJSCOg24PWrwPfBaedma/1h9I5/548II60h6hCqqKkbuJifxLHOhDfckcE
         rpukd0lAXYSPt4x1YUprq5fWMo1XgnD+nYxaFPkm7kiFlDOo4ZUyhC9SFSbB8zK2gCMn
         uU8r/CSykgAD+jq4lQy01M8KNgwu3cu/EKAOt9MAPBNmHUPET1pSaTkOcXF7xZHD7x8j
         3byerszBH8LnQjkiluOumKWOrUqm97eJfRHrd3dp//RY47B1+YFaW3dr0tDY5fjMCwAi
         W65w==
X-Gm-Message-State: APjAAAWo15RJ6g2N2yIlsJztlHAn9+IwvwWWM+E9he1KaFf4Al7+7PC8
        vWQCEhv8FP1pudTDNlhyTTTfyx3dvHnVxg==
X-Google-Smtp-Source: APXvYqymMkGGTSQlcSOizVr+H3MXGGyhzrxB1PAuy/PetScTOlGhxgYpGCBtpXrcXa4b1Z/F0TYuFQ==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr4809750wmb.49.1570837322699;
        Fri, 11 Oct 2019 16:42:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm17343976wmg.8.2019.10.11.16.42.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 16:42:02 -0700 (PDT)
Message-ID: <5da1134a.1c69fb81.ca3c7.5da2@mx.google.com>
Date:   Fri, 11 Oct 2019 16:42:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79
Subject: stable/linux-4.19.y boot: 72 boots: 0 failed, 72 passed (v4.19.79)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 72 boots: 0 failed, 72 passed (v4.19.79)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.79/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.79/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.79
Git Commit: dafd634415a7f9892a6fcc99c540fe567ab42c92
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 17 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
