Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA00251FB2
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHYTTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:19:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8669BC061574;
        Tue, 25 Aug 2020 12:19:33 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so7492999pgl.11;
        Tue, 25 Aug 2020 12:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cQlHqlc1tK1iEWmUufJf/eq4OirISs+gpFvJgf67QNk=;
        b=CD9OUsxdm52u8bG5e7uJkt+eG6cUJzOAB/gaE8afwN/Aa2Pad22Jm2uESi55wrAhYu
         karNaAW9Qk8Cqcw54T7D/y9ZFzvqeZFxnxutSkR4PGGFXUKhPnC0/Y5WAnDeKhEkQF5w
         ckKZrJrg6LHPQCnUN2yWpDdQoBbNRE0VInc7dx7jril0IBNT/OJATwLFz6941Mh5DqzC
         nW1iK7ZYxObFMOJ+Y9cK5K3FElueeEzkkgDRDYW6GnNpjYHli/e8Nxi7VKBaVuPp/yfo
         4Sdsor15HCVnUWrJlq8ksM6r3DNh/8Khah7V8eJZmBKxGLExxhYFnULe4Pi3bBt/OoRV
         T2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cQlHqlc1tK1iEWmUufJf/eq4OirISs+gpFvJgf67QNk=;
        b=Tv4dbEq+8dFVDZxhVqy8baFaGnKPbRz8BD3FteyVxrxp3sB0+VhVQdjPRncPK/Rh9D
         cNlAWiVV7OCMa403Wyr283rYadbBAsCI/q4NIRf6fn6CRvPAg336hOXVRKGnMd6DAsWm
         I2sJX4sM7NBAIn+gh+PcA10KASlMvwe5qpfBDY14WgHo9I88FgPK9s+ja7rVPjlWquoJ
         PL0RSF7tAGvGyJkcsqWskLQJPSIwdUR/92fA/N7EVs/+DPT6MwFNHvBzATKWuiSY2kKN
         7CHbFEVlJkjiAvmZODL4/gHWzwxCo++q+2sQ2jgsOT65HyJwbZAxjh06TbELLdTp7dVi
         6Kqg==
X-Gm-Message-State: AOAM533YZxpOvk7u3IqlvC8cvgX1XPulCb3aNuFIGNavwq63RMKd9qEU
        9FaTsH/zjXa0nQAzbLsFW5DfGTMyc+M=
X-Google-Smtp-Source: ABdhPJzNcNP7Ayh6nnN0MrZn1K7s3rdVQ3AMbrAXAC9/UWLHkQgBgjscMiu+JeAxYpR5fROGay1VVA==
X-Received: by 2002:a63:31d0:: with SMTP id x199mr7184877pgx.99.1598383173141;
        Tue, 25 Aug 2020 12:19:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b20sm16156232pfp.140.2020.08.25.12.19.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 12:19:32 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:19:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/39] 4.9.234-rc2 review
Message-ID: <20200825191931.GB36661@roeck-us.net>
References: <20200824164720.742523552@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824164720.742523552@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:49:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.234 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
