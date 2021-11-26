Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E5A45E6E1
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358658AbhKZEff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243692AbhKZEde (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:33:34 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952C3C0617A1;
        Thu, 25 Nov 2021 20:14:32 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso12246352ota.5;
        Thu, 25 Nov 2021 20:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6g2bGJHJDYqsscr6k13vYfZczOYg10ecFdYkbErc0Mo=;
        b=HZO1VhnAXXtUps4i7h1TWuoFiYO4oDHy0Yc277UXO85LYF3eS4ZkBGkj106Go9YjgL
         7TlFZFa9T0uo/LrWich3BaUYXCj1NLs+iQy4hFTlgHJaBEqwwQL7QYcYX1nTuoqTHcOc
         gZuR3eX1D5VF4kO+G1fZYZaXKzTWVsEV1T/xNI9UTphgi/mdqKosAl9KPNsW9rm0kEwB
         rWINucQChMiG2lI91VpUnZ8lLWyK/yn9HcqZb1W0RL8FkB0cYrmyp1lFYABotFDaMf/V
         fE1t9/p7hyljmXYEFyNJgnqnG5CAwds6uZzHYDxyg47Gp2CfhXnCLfbIBLcc+ajBkwv5
         bKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6g2bGJHJDYqsscr6k13vYfZczOYg10ecFdYkbErc0Mo=;
        b=YmiS5Da38JXLNwDsWXzY7Q3lhkJCUDYVQoeaQW1WqPEkJ766B0E8hlxYtxAjngPOPr
         gLynHoD6TEpXy6xQVlUqc1581Nf6Oh6e/CJHizZuseVJaA0u7Fqzwlh7EornjhIfOTPs
         aJo019ClYREqb78W5+Fg/stgrRaJwiTMqlAZxo6jVJdgSwew1QxMHnKBtX6p9yFJHhAz
         iLWbMv+VBGX5exp2V4x/QAv7Xi+qJ3sYE+dYkvbGWD/i5wjsILjA2W3qqs2gIJ7v6/MD
         i/2d9k1tQCSJOqgvNEt+BObWMNPGkMr1UZbiYO9glZ3BNTwNQJ1zftgOKC41JviCfMIR
         73sA==
X-Gm-Message-State: AOAM530hwqzVUsT7jHPwJAYYLA5ev5NgYEtZyOPs2orQLOixMq6h5AL/
        FCTUZUOjhu8yc31QTWK1bxQ=
X-Google-Smtp-Source: ABdhPJxmotREqYKKIyZfbVP5FVbaldaDGzSfX5be8wX0VE6/ckN1ZauioX2a+4hrn6f/F26cXszP3g==
X-Received: by 2002:a05:6830:439f:: with SMTP id s31mr25159382otv.272.1637900072010;
        Thu, 25 Nov 2021 20:14:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bl33sm1070187oib.47.2021.11.25.20.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:14:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:14:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/320] 4.19.218-rc3 review
Message-ID: <20211126041430.GD1376219@roeck-us.net>
References: <20211125160544.661624121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125160544.661624121@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 05:07:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
