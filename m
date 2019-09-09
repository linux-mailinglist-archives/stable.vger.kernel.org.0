Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA13ADF88
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405723AbfIITjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:39:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38629 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfIITjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:39:02 -0400
Received: by mail-pl1-f195.google.com with SMTP id p9so2344298plk.5;
        Mon, 09 Sep 2019 12:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4H6ftL4w/KG9uJvy2mrU/7QxzhtokGvQhKcpWq83rv0=;
        b=phKgBEnppdEopSh7fnlpu+7MGHjVjpCeCxu85/JATLxc72twyPGbMqbqFmmq774xaW
         jgycHgI8v3t4+YkD823P6ZuEBolXehjwDtTHgwEl3FrSEu0fQ/zAqKUy2nHsce517QK9
         ZBMKxwixwuGVW14mu0JiWq4D88HDH3rJjzT22Uws1AuEu0rFF72mRjpBEp563hQuOynH
         t2yQ1us/JmTl3fz/mqllh1lsjpHrZ/nJLXGY4H6Ha6A4cDpGWQJ7o7vLn427wgVirdQn
         iB8+zIjqp8R4zchvrBDciPH2a1NIRjpor7894rSesmhJ1N3jJ3QfGZnglcniFWITX8Hq
         7zDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4H6ftL4w/KG9uJvy2mrU/7QxzhtokGvQhKcpWq83rv0=;
        b=MPpfec9CeSTfl5JuPqZFaBSZuNVtCmfC47WlJmefjMEfr1j18bRenrNZFZJu6wk0gx
         kQHu8YtGfupeee3CG6HEvZYC1D1vG+/X72BpueQDAOKN+8TyJRndUOR+ZZ7rQP2bm2uJ
         4ycwkELrkgLRDyBvf7NIwgBqRCLSrobMsumPeJWvwRFa/JdPA1uB2j28DIVpJu5ZQNdh
         Zri1kwB8+JVZiRc03lkTna+m5kL6Hy+31jC4nDC+p0I+qe5W9VK7AhkbhlxSY7Ga2h5J
         V+kEh3AWoSekY7yDtukj20LTl5AQ/2aWOg1oUk5CFRrurR6IFnbGzPXBaz2HLXOOgrGV
         iPlQ==
X-Gm-Message-State: APjAAAVpbZxuHJdLRy8J++ni5XGRh8oD7+0qCbco7ODy9y/2eQ2aEflz
        2AxIcyfYzROvy4ga0unWAQQ=
X-Google-Smtp-Source: APXvYqwP+alHs6QiirEJm0wd5PErVpvWZTSxHWoH7MzFozdLcD3TL5dN4JIdmjcHY56IpGoCoGe95A==
X-Received: by 2002:a17:902:aa4a:: with SMTP id c10mr25255450plr.340.1568057940241;
        Mon, 09 Sep 2019 12:39:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b20sm19074312pff.158.2019.09.09.12.38.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 12:38:58 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:38:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/23] 4.4.192-stable review
Message-ID: <20190909193857.GA22633@roeck-us.net>
References: <20190908121052.898169328@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:41:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.192 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
