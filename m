Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A90229F56
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfEXTss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:48:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34007 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbfEXTss (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 15:48:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so4558028plz.1
        for <stable@vger.kernel.org>; Fri, 24 May 2019 12:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Kk/YxPQI8pjQg2ClWfvPmzY4EAH0NW1JSdFr4PlUXcM=;
        b=G2CUD+lTa53s9XEHdAu6Uz1rrPmqDKQpcYpqWKb/xMf8WKCTpK8myE/lnyy4PfAr2N
         8femmjlLFP+9ZFA/5GZ0MD5H6avuMvPZoaU9r3IxE0TslHKV2vhuA+vZdTMbBW1RX9Kn
         imV6EDEmvzFX/hrtSokafkqBj1ZoClk4vZmYcFlbZz1s786qS9Npj6R3v4iuIbZM8fQk
         fQqWd4gR5XdWt0R/MZbMEhDrW30G7cE6/6e0yuLeDdajN8wIOGUAvcztTVzSIL+v/n6k
         koFdUzGyjBFPkGPQLkN4CyNPI4jCxURji5Iiry1JNnQ6le0ACb4GB1ftZWez0n9kCm9h
         cN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Kk/YxPQI8pjQg2ClWfvPmzY4EAH0NW1JSdFr4PlUXcM=;
        b=SQcGQySObptl8SGNksJIsu9j6LQ3b1shOcTIgf/hdDmkAK5WGBpC2FxUD/hQwv7VQv
         RU6lvPssOuj/1wR08Hrw7LA7dEXfJ59OC40OXHeRoZxST1w3vbt91Q/smPvXsjkimhIm
         HnnzfsZeCoon9s9cc+9/4m9HNCyLu0EH6+ajxVNCOjZo96lrwJO+83nGPtlhwr318nox
         +bM4R4pvYMUajrrpQeDFK35Xa0ruspPOisukJxDo35VLMMJ+EIWufWW75XOvJwBJbw18
         oAcSz1tu4Iez96dFDOhecp7NTg49E//PwcMTtFWtqbBQNGYYvPBAH/gTRSHpYg3TKcFW
         viyw==
X-Gm-Message-State: APjAAAU4o0/g6b9wis2LameaGLmWDW8P77XFxPXfGjxzWnJZHj6UPjkO
        3SwCHY3tI70q+nydrDCvBNY0Og==
X-Google-Smtp-Source: APXvYqw5/u338biK4FyupPkQJCokUaMWyzX5A6yHD9gzUPih/c1K3aPdHPLszkcKKfzpGfpbIW1kDg==
X-Received: by 2002:a17:902:8214:: with SMTP id x20mr85789356pln.308.1558727327582;
        Fri, 24 May 2019 12:48:47 -0700 (PDT)
Received: from localhost ([2601:602:9200:a1a5:ed4f:2717:3604:bb3f])
        by smtp.googlemail.com with ESMTPSA id x5sm3383819pjp.21.2019.05.24.12.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 12:48:45 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
In-Reply-To: <5ce727ee.1c69fb81.fbeca.2a40@mx.google.com>
References: <20190523181705.091418060@linuxfoundation.org> <5ce727ee.1c69fb81.fbeca.2a40@mx.google.com>
Date:   Fri, 24 May 2019 12:48:44 -0700
Message-ID: <7h7eaf1vmr.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> stable-rc/linux-5.1.y boot: 138 boots: 1 failed, 121 passed with 14 offline, 2 untried/unknown (v5.1.4-123-gad8ad5ad6200)
>
> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.1.y/kernel/v5.1.4-123-gad8ad5ad6200/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y/kernel/v5.1.4-123-gad8ad5ad6200/
>
> Tree: stable-rc
> Branch: linux-5.1.y
> Git Describe: v5.1.4-123-gad8ad5ad6200
> Git Commit: ad8ad5ad6200a933bc774415620bb31dd8b2da66
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 76 unique boards, 24 SoC families, 14 builds out of 209
>
> Boot Failure Detected:
>
> arm:
>     multi_v7_defconfig:
>         gcc-8:
>             bcm4708-smartrg-sr400ac: 1 failed lab

FYI, this one has a fix submitted to mainline (and tagged for stable)
this week.

Kevin
