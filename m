Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFAD473556
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbhLMTzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbhLMTze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:55:34 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BFC061574;
        Mon, 13 Dec 2021 11:55:34 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s139so24530880oie.13;
        Mon, 13 Dec 2021 11:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F8NRzTPRoNhTU0JMcwB4jnq4atGhx8hv6jGjEqbd9pk=;
        b=KXFHzm94vGd9N/Iyl03it8dsU4BX0XPIizrdjHmbovcztZjJUeT+/sq7/zjiV1Rzkp
         XwFb23t4j8Cy1BjvGHZP0OqMsIe5vrq6j1a2vyJgkzaG7vjHPN/b5iIb12sgyPQ1IViP
         bYTQacJmO748EndghA5aeyIr0xm/ZBiKTbiauiN/zdHiUtjHt83ovO4Ad/82YYDevC3X
         XaIU7puF5VJ7gWsuYwZBfzQfyqjntTRqoqi3V8hKHJz9of7oCrO/8WDyQad7geCrHtQe
         GJwkbvKugau/RQimYwZ8Izs73wJiUf0OKqwqUnrry5HttpPjpUrlzNr8dieOEAQcIbpb
         fl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=F8NRzTPRoNhTU0JMcwB4jnq4atGhx8hv6jGjEqbd9pk=;
        b=LXV8pcb7x7gaT969vr4nxIsKKbQ1rVG0q2bGNNK28HBlAa3G60fEvJh30vupdoGKyA
         XHV/GamTg3nPlWL+f1G+Lc9t42TICcC2Fk4eakq8sudadP7GUTo1NV4RE3K5a1IHGVW6
         ivGXU+5XFSglqIwPKkBbxC79PfVyLjmO6hfdFBZu4DGQnC1X+DUwAGtZ8pANwaIWog/y
         V2SRbGIdA3KPi9pBHlNaqM9DYxijMT5pST8mn0um41BRbEF4qpbUxDHqUmHpuhsyNK4g
         QQCvR3O7VcJ+zb/RwQyjfmeHov1ErJPo12TaRzIcJyd9LHqnQjll8e+Eo56ofYFlPZ0I
         ea4Q==
X-Gm-Message-State: AOAM530/MWeCsSmVGBk+0b5Bf1IBIt08VLLksOrES7F11la0AwGoRXVw
        sz3JGkKjza8+Uu6fURpmiWI=
X-Google-Smtp-Source: ABdhPJyn1cy7IgO7Ehv2VJPJwN6dqgb5PEWOPIF7NhFAlSuavAhElyBMQQiLz5OIl76rDqp4VBk+3w==
X-Received: by 2002:a05:6808:168d:: with SMTP id bb13mr671020oib.94.1639425333913;
        Mon, 13 Dec 2021 11:55:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v20sm2301362otj.27.2021.12.13.11.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:55:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:55:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
Message-ID: <20211213195532.GD2950232@roeck-us.net>
References: <20211213092930.763200615@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.221 release.  There
> are 74 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
