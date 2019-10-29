Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B29E8BAC
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 16:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbfJ2PT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 11:19:27 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35349 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfJ2PT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 11:19:26 -0400
Received: by mail-wr1-f44.google.com with SMTP id l10so14098287wrb.2
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 08:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=epiY+V3hucmYFVzL5GuDKnf/gBS2805t3xn4atxwxe8=;
        b=KJbYgH8REC/XtOJaZ8It469eFojszDkDqwmv08vugvSUdgY0XjdCJ7CKVv5c9oG4eO
         BMFwDownQjc/WAgWTkX7pXgGGc+TkFLz07TrYJaWr9CQz9rk6hQ5uLoNJhECXlareLJD
         vS+v0QUY8X3KBn0I3aNW5SIuklpSYaorJV59yPD5BtJ/CJHZ4vAj5Ll7KxBiiCkOwxqs
         3AILEofFcKo0DV776DFP7mk01s7FpSKzuAiZtNlLU3i295e3JCSatYKrT0yUfTnM5HNZ
         JBY9aku4gtn9jOdY/ORlWTdGsXWyubNcWr95vhdTrK++tkff+rYiY2r0UpRika4/lqMf
         lxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=epiY+V3hucmYFVzL5GuDKnf/gBS2805t3xn4atxwxe8=;
        b=sqP1qWPQE3S2w9tTXMec1hYFQpsPtzlzgBBvRgOCFv0M+RVtaFs11WNS9cr7bh88lV
         FYw0nGnPFWhVo6xHb3xDE1+/Wob0X+QlnuwXvgkHnEfvunNYyo8tSB1FLI0HVwEUD65f
         JaMVB0Oy6cr0J2X7BiCZploHlQsne03m0jx9xsi8yXzdUAEOytnlBLt1cCtP1BdGBGga
         /tNzgEaCPj+p1oKMDDqoN6dQH+tub1CldcH6eTEX+QTbgDshZVO+VK6OON7a+gGXXQ6S
         qYRKeilKEx0BMOgiWJrgdYQsxVXIhWEe/ZQEcP5KMho9mNUuSk4F1gzGTa8GEbgviW0Q
         jAIA==
X-Gm-Message-State: APjAAAWVjiJ+JCJMwORlcodrvr9G7YJxXD+K9CK90rRh00v5ndRAQg70
        2iWwUopERe3zEThh7pN3M0viwji6dN2bcw==
X-Google-Smtp-Source: APXvYqx4kPikjexyxstVXy/4Ml+jgt5eN+zwB23fWvyO79GErkGL38fGt0Sr5SC0bfCOQcYgoF751Q==
X-Received: by 2002:a05:6000:351:: with SMTP id e17mr19251185wre.96.1572362365239;
        Tue, 29 Oct 2019 08:19:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t10sm15166779wrw.23.2019.10.29.08.19.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 08:19:24 -0700 (PDT)
Message-ID: <5db8587c.1c69fb81.726c0.d9e8@mx.google.com>
Date:   Tue, 29 Oct 2019 08:19:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.198
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 86 boots: 0 failed,
 79 passed with 7 offline (v4.4.198)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 0 failed, 79 passed with 7 offline (v=
4.4.198)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.198/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.198/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.198
Git Commit: da259d0284b69e084d65200b69462bed9b86a4c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
