Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC60119EAF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfLJW5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:57:46 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46241 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfLJW5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 17:57:46 -0500
Received: by mail-pf1-f181.google.com with SMTP id y14so595002pfm.13
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 14:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=//MG1hWdtde3AR1XpFYXX4Mv/dNbMfrJc4LbRxHuhcA=;
        b=pEWcwhpXjFFqbjjmF3r87143Q5SAPL2euzyqjpuiwM/z9VqADRg7V1waGwfFGs7u0b
         lZiB5oyy5uXsfW9T6Bylrp2/wK9oyNdrH0X5fnrsATZg0NJErEM8UoEbebPjQKpxCWM5
         a22XhbiEHYh6Rupaj2Wk7qLG9aN4E0zTvF9rUQAB5fx+T1alEOHuVNfN67hj7P0A44Zh
         wGocofa9MW3v0qZWnenOU/COPa8ZitGVaTREeCTypz9hYI/tFB/Kz7OMC6VZPUV+lYuh
         Nvo4SYOhkPRqm/+G3CAos6YXNo54NIZl/snic+UU+GGACEHesGDeopEvSuhnYlu0w18/
         a3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=//MG1hWdtde3AR1XpFYXX4Mv/dNbMfrJc4LbRxHuhcA=;
        b=tAzLIwE4zkl3MtVStpmGpJ/KvEyERPvaLqbwyPKe12kNmJKP+0qel9GOBbeM7g0Huu
         uVOOimKne3Xfon859ctkJ7pF2GlrCnHRDf83VaZgM0imCxFS1WfgEjpVvthJphTrb7ue
         eHyFK4eMg8XZ3J6T9MQMtjb0rsHhnrMxxE/OKtPknGFi0XSLURcSg7nDiE/NLjJyZKxy
         b46UxzeSvlpVWf+p2IDccwzdQ8/GLDGh42s+yvfwQg54+toI3GbrTEwMLQg97EA8JEn4
         H8jVH6m1/HZT9Tf7wLhwUnMv04oRP/6lHpedJkR3wZwTJ1Jor7J6nPD9h3tVXE0wtqas
         OUww==
X-Gm-Message-State: APjAAAWQ9TKdyLgkWWV050ty2bZPKJ1Yi/zen/CVw7tQ+mxRa9YRYtgA
        ZUedDIOKiNhMjAI7wMGujv+J5gnS
X-Google-Smtp-Source: APXvYqw1lERAsMJEWqPI/1ZRe6tCIAd9D1EWW/rzlzZXHkQrLPJahitK2aY7tFvt60O10YrphFD6TQ==
X-Received: by 2002:a63:9e12:: with SMTP id s18mr568616pgd.380.1576018665568;
        Tue, 10 Dec 2019 14:57:45 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i4sm29750pjw.28.2019.12.10.14.57.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 14:57:44 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:57:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Subject: stable RC build breakages (4.14.y, 4.19.y)
Message-ID: <20191210225743.GA4443@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4.14.y:

arm64:defconfig:

arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts:5:10: fatal error:
	dt-bindings/input/gpio-keys.h: No such file or directory

i386:allyesconfig:

drivers/crypto/geode-aes.c:174:2: error:
	implicit declaration of function 'crypto_sync_skcipher_clear_flags

and several similar errors.


---
v4.19.y:

arm64:defconfig:

arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7 Label or path codec not found
arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14 Label or path codec_analog not found
arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5 Label or path dai not found
arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7 Label or path sound not found

i386:allyesconfig:

Same as v4.14.y.

Guenter
