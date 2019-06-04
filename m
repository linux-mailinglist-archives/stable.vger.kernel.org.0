Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7F934555
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFDLVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:21:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42558 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfFDLVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 07:21:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id o12so8275616wrj.9
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 04:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WYg1fMj9JYGX7XK+JAAmHrUKZ42nwCsTcX43M3rNJww=;
        b=bAzyvjR/Lkoam3L+SBJubir9nqliSmZ4gMCLohNkvw5KzT8yirzsl6UoY4WBli57Ut
         eBqQMddNCweHLVqgCk/6a+y8W5ycp8VOnaIsz5bwsyW+OFPNeqGGOwQ1GHhKyCEW9s/Q
         iXR+UavgX+UASfHJEqpx/NbFL+lOSlxDAe+9MZEwi2aIhC1lagQqb1EwvksfjTZAcD+L
         cFt3llSr3WovEV0EgO9jKqVbO8KiYkMYx7Y8BtjFgrWj5IFD04UJ/9aVKLXEKKyJhheQ
         gFMWsufsCc1vjfItWca/UnH9Zf+l0ojbwns0vMVNlYdiRvl013HCL9k5jzDWQLTKQaCW
         UkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WYg1fMj9JYGX7XK+JAAmHrUKZ42nwCsTcX43M3rNJww=;
        b=bS4t0GgE+rjaDb7EptN00XthIEjLnTzbGFNtMRfUJIska6DWNI8qXLuBp5Lv/1Ib4w
         U1k+VDk6pgec285Hq0YiTe/RAKwbNim5uDrBvhq4cbcZudGqGLqgqAiHPv4EzwRwr9OM
         cdLy9DJ5/Wm7ECcKlFHOXW1+rHkMOB3ke+QfRj7Zdv89+HApN9H7RbouscqUWYcNj4dy
         a+O51sUHUDIdtoFVopSYAj+KPBIl8JvyEGLjawlusZFwrdmasYiNtMcGp3UUlQqBHXlK
         Ku0E3GP/+/hfp1UFN+86Yq1kw32GxGRsGCsYjWRWUDnTu96WmjGPCNEs/PP3pUEvUGKw
         6Mig==
X-Gm-Message-State: APjAAAU/kXYD5nbFP8hbPwt63gXjlh4D4Y5xb3Vh3cjYU9s05KahlAtk
        bWtc32N9Pi7dW9rea9qNXSDVEq8PYk7dZg==
X-Google-Smtp-Source: APXvYqwu2h7XIZcNyvIZFppQ5P+gPWIpwYlGdAvlTLqQqgQ/oEtlLZftKtwgglIr4mzWbVTIfRzPYg==
X-Received: by 2002:adf:9c8e:: with SMTP id d14mr20994106wre.215.1559647306564;
        Tue, 04 Jun 2019 04:21:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q14sm14737512wrw.60.2019.06.04.04.21.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 04:21:45 -0700 (PDT)
Message-ID: <5cf65449.1c69fb81.50c45.f9af@mx.google.com>
Date:   Tue, 04 Jun 2019 04:21:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 65 boots: 0 failed,
 64 passed with 1 untried/unknown (v4.19.48)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 65 boots: 0 failed, 64 passed with 1 untried/unkn=
own (v4.19.48)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.48/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.48/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.48
Git Commit: e109a984cf380b4b80418b7477c970bfeb428325
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 16 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
