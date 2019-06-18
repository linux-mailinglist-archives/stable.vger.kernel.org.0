Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3485496B0
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 03:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfFRBav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 21:30:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44251 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRBav (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 21:30:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16so11997491wrl.11
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 18:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=XpVeh+sz8l0MglOFihLIUBQe1u4nS2JU8kbEBnBdz+E=;
        b=pWeo/B2eO7lNBNG+NGf1psnaK9Bz1g9gqlU6XOHEXehvJkTdsYz159HFRSlbRe08rj
         Ug2Vty8V/cDv8kEDe+jl3jL8botZBCVTLKWUqrNA1jCmwGL5tAkAFlVW+9yKegVrIaMi
         549Miw4N5mxxTIFnhg9U6ZeLF8EiYX7gB3VgjlBr+yH4/lHZZdJCrc9jCstsXEXziIM8
         lE63JAB491FehYFjdM8w8oYGoOWP8/3FjlgwRff/fX2LMZyvhKrVsllzZEIzr7tWyn3r
         rb0ZSual4VS01ywLbfCjyv179uoBsedHGiwjBkMX4/uZUxLyVmMoFvU9O9qheqEPMJ+H
         hsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=XpVeh+sz8l0MglOFihLIUBQe1u4nS2JU8kbEBnBdz+E=;
        b=iUk22a23J0AZ08Qt1nCxyZAFN65BsIe16qCS/ZI4pR0ibUKdEibLD8zupr/n1j4sW6
         bShvKdKgzHge4B9cJrfR1sAZN/pqiSAgyLaFT59+SruogMNXafNbv6F07MuqLCuOlA+5
         MOKRlJ6rkecKw87E0uBTj9rPUaiTYYKtocKO2V84HqViG7NwomfYVpRzZthHhjC7KpuT
         QUdIbBCoLMMLBN9sLtcC0DLCD2wcnMXRGnmdVtqhqKc8GELejdIqFm5FlYwrnbgnWUbr
         wp9lcM1E0+gr+H/Yh1M/2ffiyj5jByjJi6l/xNLpHfQlSkA/qn9ieqyyB+1lkXqaG4Va
         4qOw==
X-Gm-Message-State: APjAAAWYNGmCLIrBuFpzIgxlFTkXLxdeIU7A67GUf/i2RY2FqX9wUmM3
        ew7czeWXwjz6NVKxL48ulNa4/A==
X-Google-Smtp-Source: APXvYqxXH1WiGUiS4USOydi2PH6JSND1aSmufIk12JiYjaB/PpKwr4NasNi7bhWPzwo3l5BPwoxs8Q==
X-Received: by 2002:adf:fc45:: with SMTP id e5mr30375644wrs.240.1560821448873;
        Mon, 17 Jun 2019 18:30:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t6sm734906wmb.29.2019.06.17.18.30.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 18:30:48 -0700 (PDT)
Message-ID: <5d083ec8.1c69fb81.9934b.416c@mx.google.com>
Date:   Mon, 17 Jun 2019 18:30:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.127-54-g1ed3ad23f285
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/53] 4.14.128-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 0 failed, 105 passed (v4.14.127-54-=
g1ed3ad23f285)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.127-54-g1ed3ad23f285/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.127-54-g1ed3ad23f285/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.127-54-g1ed3ad23f285
Git Commit: 1ed3ad23f2853e59a94e55528b42112d3e00c842
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 24 SoC families, 15 builds out of 201

---
For more info write to <info@kernelci.org>
