Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F621304EA
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 23:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgADWXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 17:23:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43382 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgADWXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 17:23:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so45676233wre.10
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 14:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cLIWQnZvHYzyOvdC/CwU9DX2PZeFV3hpYWbWaEe0I8c=;
        b=uUgJ/Y91EY65iP7DZ1aV35owmzAWKNYA8h4zf9o2ZhnAUoL/1oq+TaEAV/rIXimKU+
         maKHTKVEeHwvre5Qfs9Ez7v1xiNhsO8iCFmQKhOeNsnu5dOQdgB20qGaDejXfFmFnNrl
         P1JZTrQH4NXzvWuaNboUWDcJkoMLqS/mZz0V/NTvSqDsoiiqhPlqboHzrLd0tdcxSiTV
         JuiHSLHdVIQBRKbhjTAfBynFEMcjB6Y31hK5iV2W4e+Q6yuBQSSdMc+GLn2/y3cHdjzv
         pGQEpYl/7O92LLcwy+2VayCxcrtQ7gN/szoOaFzIfgCCZ+Zp2kCIir4i5Fip2jZm5w/k
         XwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cLIWQnZvHYzyOvdC/CwU9DX2PZeFV3hpYWbWaEe0I8c=;
        b=LM7omestZE5Zp+5N+JbVKY6PhV0a/V8RjmZE00uzlsniakQgBkrV0SCBhMFlxJH0Di
         3SpCdpJ7lsQ+F/NMkzgtnuEaNaz1JTTKFc8MAQsbJe9KlwbzgNikFgoH8EOJkzYHMYmI
         Cz0wLFAgJN05k9PpdkCqDC/60JC/yBNpJUQdZTQqtr1sTgibS2YB4+cq809BnhffvL//
         aOpWF1bUz0O4Ik4H4rv+LMGKOZaX3IWRHqNUl8t/u+qFpItE8Ol4njkUAR3HCEoRCONM
         esRRsdhauI3rcl0xVWDuz35agAuBT/3uzEsPMWmyuorcAH9pLLBNyAhw4sP9MF0bK1SD
         tP0g==
X-Gm-Message-State: APjAAAVCYbDnKH+4LYSL938DImfDEE5FSKtJnnVZBiD+bz2dJxTQ1NOc
        0n/m8kTephJ8HS8SPIpmrojXzCoFmGE=
X-Google-Smtp-Source: APXvYqxO2IqdZBnmLUYb9it+XE3leiUg5EkPT5/tjyjXZLE0lQ1JYyDEJtSI/UhC04r8eTYaJvD/LA==
X-Received: by 2002:adf:dfc9:: with SMTP id q9mr101781972wrn.219.1578176588799;
        Sat, 04 Jan 2020 14:23:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g23sm16875862wmk.14.2020.01.04.14.23.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 14:23:08 -0800 (PST)
Message-ID: <5e11104c.1c69fb81.9ec1f.b7d9@mx.google.com>
Date:   Sat, 04 Jan 2020 14:23:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.162
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 66 boots: 1 failed,
 64 passed with 1 untried/unknown (v4.14.162)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 66 boots: 1 failed, 64 passed with 1 untried/unkn=
own (v4.14.162)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.162/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.162/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.162
Git Commit: 84f5ad468100f86d70096799e4ee716a17c2962f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 14 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
