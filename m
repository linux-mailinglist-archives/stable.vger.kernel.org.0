Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A2610770B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKVSMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:12:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39440 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKVSMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:12:53 -0500
Received: by mail-ot1-f68.google.com with SMTP id w24so6972251otk.6;
        Fri, 22 Nov 2019 10:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LbBeEobsz4S0LFGMIMH+H3mQPLYBzbcsiCNXRc3XsUE=;
        b=UDH9tjOVODOSByFsaieInwQyk4OzVHBe0OZWjg0ugAAC7lEd+c3Y/l8Zl5gwC0jGRl
         SZLbHfAC9mKpT8Ap/ihDuKBuZPwilu6wAChta7moMcm5w08ALS5BAauys8/gdm1E2ZQu
         9+dqZDwtJNL9lPPBuF6Xd5+K7E1c+bP/wOrZtm6lKtl85286hX5v2iCaG7QMSDVcu28e
         835g/vYqwz6jthgDGXpXw9pnp6i0k9sIJYZphfBLIcHsLhDko8g3PxXMdAaa8Lf+onpO
         ulKWdfIVv8N0akxCmTlVqXo6w3zyVAbbqBm+fuI6K1Iae5pOp5B1yDHDZH4bvxp1AL4q
         +GmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LbBeEobsz4S0LFGMIMH+H3mQPLYBzbcsiCNXRc3XsUE=;
        b=G6xIDkfAOi7cXLgN/q3OV49AUySvSeHX/zgtmLVOeh0NnYLW/tPevNO6Po3MCGKpcO
         6Gb1lMrbPOsb1g53FFWEshBgULUb05VuZhJDC7y7tzdNes5wvfKFWCtIZk6WWGOIXFJn
         QEAqCXqmrzOoCwnuWEmE+l61nP9yj/efETNbvKTRmCkTPx1o0D0FRWEqOEjefQOWEyaR
         uhkLVoOuTmIjcumbGfSM7Zonkt5qwupCUSGvfNfXKR8j2zto991ey95jxPtXOl8bUSGh
         R2o+uQWonpWauchqSo5BETQBS8/XVlbvvlLv2NeYlZlQzTGOB8q0ebzdKXL96ABZ0fwV
         wXgQ==
X-Gm-Message-State: APjAAAVJ1Oj4KU0Vt1OcrRh/uCieY0ymlKjbMOGElT1CnEP5YmazF5xV
        PNmrJnihnsgIQDEw462lnj4=
X-Google-Smtp-Source: APXvYqz8z75oREf6uxIOKcQLk2lwxIgbfK1hNWeQqS2O9SVT8tV73+K05b7lW0j50IPaPGJJmZ7H5A==
X-Received: by 2002:a9d:648f:: with SMTP id g15mr11857332otl.195.1574446372290;
        Fri, 22 Nov 2019 10:12:52 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d205sm2258606oig.28.2019.11.22.10.12.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Nov 2019 10:12:51 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:12:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/122] 4.14.156-stable review
Message-ID: <20191122181250.GC13514@roeck-us.net>
References: <20191122100722.177052205@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 11:27:33AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.156 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 

Results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

As already reported, there is a new suspicious RCU usage warning
in idr_get_next().

Guenter
