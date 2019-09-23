Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1796BBBE0
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 20:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfIWS44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 14:56:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46853 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbfIWS4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 14:56:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so9635611pfg.13
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 11:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CsMc2OBbadsF5+TBj7fbouJIZuD/T7daovw5hMpIMNM=;
        b=A0fvyNz0dJYbt8WldJjdAyaAoG02SFZIB0jGAqxLBHmrKGDZbBYceILw9++VGQNfws
         jPGJC0kExLnyTbzAa+JvU3bCPJn4R7JaRednWtyMjqd1oeiIH1+FYH/ZlHN7L0TKfifP
         rp3gXi0Wgqo+PQe6rFS9K/K7UkO1EyBQDeDyO7I4u1xwZCUpGnL38peAc7JLw3iLzgBb
         vUIsWzhxZQnubTBKjQKzbfpC7bFOZq90nBo6G7EE5YeBDsFodj6psMuaRRT/uN3ZRDsK
         KHO4rejh4bN8A9ZvD1fMefRJU+P0Zhy7EiDbHlKbdVUn9BrxnKQDfFa5hgoAMKlA1erB
         pyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CsMc2OBbadsF5+TBj7fbouJIZuD/T7daovw5hMpIMNM=;
        b=pR+ds3LpAoiZ2nmpyhlqRRsWoSu4Mw8zNqGc9MeeKYuwVwVjasWDJkw4xsXDANTWjL
         Dq46DJU+yWCO6eTZax67yXJ5oAARO+/jpdCifQOWpAMfiTwzPLuZj9lgmG4pBlwuACC8
         uupl2hsbei/js7bZGigj84KJjb6tQ0QFVF1g0WY36vR0rzQNG9hYEDI9t1uwwmePV+Rf
         nqKs2CHt9y0/BRyuIL9e6jZyGBv05tg9Lp4BFxUxbBEWG94zjIobKtcpuEHsBahch113
         tVAfFpcCUIvuhwnzMFRVcqOv+ffTZmDndJXt87MJ6HLOG2YHIM27Gsa6bGJkwmPmIIOU
         CIAg==
X-Gm-Message-State: APjAAAX+mwdEPFLlH/BaQEkRp5ADQ5qX646tDu2zSVpJbM5v0jECQw9g
        81SMm6HTTxPYgAzGAYg9mRKJSYix1rU=
X-Google-Smtp-Source: APXvYqwneQoUpghuUhOTZoR96inZCxNiBb0kHtbFd6BnedAcnXY3e/YuwpBwLaXm8+kvMPnmEBsRXg==
X-Received: by 2002:a63:6c89:: with SMTP id h131mr1424775pgc.322.1569265014534;
        Mon, 23 Sep 2019 11:56:54 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m2sm9484201pgc.19.2019.09.23.11.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 11:56:53 -0700 (PDT)
Subject: Re: [PATCH] Revert "ARM: bcm283x: Switch V3D over to using the PM
 driver instead of firmware."
To:     Stefan Wahren <wahrenst@gmx.net>, Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        boris.brezillon@bootlin.com
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <26e101ad-8b5b-edef-4437-778bc57ae81f@gmail.com>
Date:   Mon, 23 Sep 2019 11:56:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/8/2019 8:44 AM, Stefan Wahren wrote:
> Since release of the new BCM2835 PM driver there has been several reports
> of V3D probing issues. This is caused by timeouts during powering-up the
> GRAFX PM domain:
> 
>   bcm2835-power: Timeout waiting for grafx power OK
> 
> I was able to reproduce this reliable on my Raspberry Pi 3B+ after setting
> force_turbo=1 in the firmware configuration. Since there are no issues
> using the firmware PM driver with the same setup, there must be an issue
> in the BCM2835 PM driver.
> 
> Unfortunately there hasn't been much progress in identifying the root cause
> since June (mostly in the lack of documentation), so i decided to switch
> back until the issue in the BCM2835 PM driver is fixed.
> 
> Link: https://github.com/raspberrypi/linux/issues/3046
> Fixes: e1dc2b2e1bef (" ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>

Applied to devicetree/fixes, thanks!
-- 
Florian
