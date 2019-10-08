Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F4CF0C7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 04:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfJHCVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 22:21:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41634 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHCVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 22:21:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id q9so17445582wrm.8
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 19:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JzhbMvyLUxFmZ6szjUKWU1Ac602vrJOzOZ0Ye0NEc8w=;
        b=jI7quCF0P2rsN5huqnPXmGTUm/iVhKFj0aSkIMYdPz9Ln3Ci0YBEyfHUXKAT/jkfa5
         oQgDotfhmMWF/GCg81E+9NzrSR39rAumGXh6lxASQoWFfFzuc20aH1AJQmbVMwxmqdIt
         yQP20e9BicgSY7tR5iw5S8Pii/vKAqc6NzyaBHcT6w6pH0Bm1ZGPBBIrZOvOTqwcz+C1
         45Z/lm4b6w8jPGZVM3uHI7+YTjRGfcp/szgsGFeq6NbtmGGUTfRKx1H4mhElzgsQvGpa
         D0U5Mk5/I6mUwIi1VytrzCr6k6k8cj+MG4RqWPjZLUOqWwv+SH6WumPjaXlaQOha38Cx
         Vsdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JzhbMvyLUxFmZ6szjUKWU1Ac602vrJOzOZ0Ye0NEc8w=;
        b=PgjjBICeZ9LIuAQU0DwYMSMkCN9qB6vaODiHfUFAk6kkORLJbIgDViB/igg+V+7FOM
         74HdqTltWkxgRSE1CS1b4oQIAxe3vm3VRO9CSTE3e50cnO7XiI7uSmJnrAV+cKnYh3PR
         Pc7TZ8Az2JLCUlVP9UBY07Blp53bQNPsYB1OWD4R1rwIYE+TkUae+jVbDfNKQyrbWHSB
         XlfaHJkfi3zfUaA4hdSdsR9CIyKKK8FGzKlVGzS9BOXlUndJlegkU5ArgCRGgo6hnpK2
         z7c/MTp+jBnQXAbct6d+CtTRdKvKL1bLYKRVSJnxXW4L4V0f2b6Xanj/Q78EsdrAfOAk
         C94Q==
X-Gm-Message-State: APjAAAVcrmBrJfS34PN+K7oEIY+QZWrAHLxGBt2WQiEzEbhXSyYwylcd
        Kvw8kUPXVblme+T5v9PQpg9WpIteUchbPw==
X-Google-Smtp-Source: APXvYqyrXlEIVEVpRFuiLpqED74gUUuJVxZLEpZdiqQ1yOYweph5vYJD1gs5hN2/7xyN4zhBKrLrCw==
X-Received: by 2002:adf:cc8a:: with SMTP id p10mr24307956wrj.321.1570501291595;
        Mon, 07 Oct 2019 19:21:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm29265855wrg.69.2019.10.07.19.21.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 19:21:31 -0700 (PDT)
Message-ID: <5d9bf2ab.1c69fb81.77319.9e95@mx.google.com>
Date:   Mon, 07 Oct 2019 19:21:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.20
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 76 boots: 1 failed, 75 passed (v5.2.20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 76 boots: 1 failed, 75 passed (v5.2.20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.20/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.20/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.20
Git Commit: 56fd0c9f54730c7049774c0aa2a73151b628b735
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 49 unique boards, 17 SoC families, 16 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: failing since 2 days (last pass: v5.2.18 - first f=
ail: v5.2.19)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

---
For more info write to <info@kernelci.org>
