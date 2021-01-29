Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27179308C6E
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhA2SZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbhA2SYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:24:03 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA6FC061797;
        Fri, 29 Jan 2021 10:23:18 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 63so9529858oty.0;
        Fri, 29 Jan 2021 10:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W63lPndANUPeIJpXLWwaCeMfpNBSwI1qhq4VamFL/U8=;
        b=N4mOgrTpwUKB1M3Ddob/pbecEgD8nPgCcXozTImzjINfdojbhcqn5scM/3roNBQg4U
         2Q92HSssQ3ByJDVUHZko/kdtdomn9TQ0ATmXlUD4QxyQv0xqpOqsyHwxHkz2KMt9pQjs
         wT9VksN1m7jP3uHBm30P1ceHupktQRI9Isoz7hLlm5oZYKrluHzeKodiQcpzlkIYjzNM
         4wppMLUl3MX7kojZ79ZvZQDPZyIHuNRudYv5hRr7ucFQv9xZQ7Nl7ow7xsL8yAxV1Flq
         hFJK3HFE/FuI0+TFLJwkhh4HDByUkrlWK9oP/r7UjgIwugGk7v6NLHzvvyj3vMKXl/fG
         aeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=W63lPndANUPeIJpXLWwaCeMfpNBSwI1qhq4VamFL/U8=;
        b=K/p0OQvwHnQbHRKmkoxN15SZf1eauBqx/i67conG5ITEEA8CxAeq3nJobYBBcQnjEo
         wbXTZ6njOYLtBqoUlZb9lrDytWNc5FFZ5RiYlOHPyVltSlLIjrprddcjxaLl2WpnIVlS
         QulTfvFzxtrW8sja+83JBF3e7q18QuCsD/sf9CZjiSmlVBfHkClk+CwaPog6rej1SMCb
         BEkn8gMMtf2V0C6S/99CitZPJ6Pi0c7mPJaBQcocRy3bfFyLWPCdROuX8v9gJH9P7DNh
         FM9zHrOE1INteqYJUpCw4eQkRJ7pC5/gKsauRswruyL7SaWZoZ4S2VKwwcislyzBH1X0
         Oslw==
X-Gm-Message-State: AOAM5300Gx9enBbz/bh3ylrf04NLb47lQOAZjfcRGf3zy+nEPbqiSBP3
        qT8wMF65mcxc22mLxBUGHQxwkDqfOM4=
X-Google-Smtp-Source: ABdhPJwJ8GkLAUdlTOXEryP8EpX6U4Xs6/mKAThnbCJRwOxXe9Xn7NTc/dWCKiyy++hs2N+p6Fp6sA==
X-Received: by 2002:a05:6830:92:: with SMTP id a18mr3716886oto.23.1611944597869;
        Fri, 29 Jan 2021 10:23:17 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f139sm157447oig.28.2021.01.29.10.23.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:23:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:23:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
Message-ID: <20210129182316.GF146143@roeck-us.net>
References: <20210129105912.628174874@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105912.628174874@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:07:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.12 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
