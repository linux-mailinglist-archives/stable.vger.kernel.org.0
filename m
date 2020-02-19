Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927B7164D54
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBSSIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:08:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36335 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBSSIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 13:08:47 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so491303pgu.3;
        Wed, 19 Feb 2020 10:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aDlAiDkLNZZHtzRW9HWTJOzKn3LqLil9fUD3GqWmFKg=;
        b=WmaW14ZZlPih7rNfsOIQAcFFlakDmm/L9hjSA6RWF6DdwtdrKHwnvLd2PGeRrL9d0o
         OL0PSd08+rj+kH2Z03YudjX/LZkZh5g/7JvBW5TN/JJZBxqOGC7B0Y17liAXC9H0fkWI
         /6H943Q+P7WCtbFAtoh2xR8M3duX6PN4VdCR5BQrL8kytuPRZx5bVUCLqjbk7oOmnquL
         XozF3L27Uk1cLTmTDbzHHb8lzTmcajcrIZLCevrdRdYLjzzHPvNz9uG3E+XTOR+b5wOw
         eBVh9pqXbsNOHOhLrixZ7q7xu66cA8cDZdK46QPJfVzT2LRJfA113RVOqQ25aHKsXDIv
         mvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aDlAiDkLNZZHtzRW9HWTJOzKn3LqLil9fUD3GqWmFKg=;
        b=bzZk/LAACBT5b/jScEx+J8JxBWfRuqKyIVr8f1mOk5pSgJ/aiW53uain8sdrDk9iDy
         lRy+hSIJDT7UGmH8GynThdFsvVRY405ixJ/ZzUhA54ZGjGCeXUYkII0TAQuDZ8oAPx9o
         NpmSSGlNHSKXdDuIZwvHVEih/0EzgOzhLeYNZLuuyC6JXHHhvBWDUBhuYuTITtE0i80G
         vNFwhaY828E/SfQGy5f2RB/Xw2IGMScn3OCXHcNW1I4UvNzQZWH2V4Ilg5oFXFov3aYJ
         R7i1vqxHIqI7g/9B13c2mmuvicaY0rwo+DSMNx03+EUvk3pmArrGFJRQFg5UlFTtwcgl
         48IQ==
X-Gm-Message-State: APjAAAW5Tho4fv9G12GILMZiB9Z4z421JPGDzqrw67OFa8uHeN4MqJx7
        tmN7ln1FwExRvPdDheKP3Ln0+ntl
X-Google-Smtp-Source: APXvYqxGt2EYOA9Z5oFErfiRjcgPT1UdemXHAJBnar4aKLpKmCquseEX6H9fw/FI/Z2kfJRJxouimQ==
X-Received: by 2002:a65:4305:: with SMTP id j5mr30264507pgq.315.1582135727196;
        Wed, 19 Feb 2020 10:08:47 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x197sm308852pfc.1.2020.02.19.10.08.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Feb 2020 10:08:46 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:08:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.105-stable review
Message-ID: <20200219180844.GA26169@roeck-us.net>
References: <20200218190418.536430858@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 08:54:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.105 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 403 pass: 403 fail: 0

Guenter
