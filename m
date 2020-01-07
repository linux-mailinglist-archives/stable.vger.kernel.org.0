Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F16213343B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgAGVYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:40 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38002 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbgAGVYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 16:24:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so493902pfc.5;
        Tue, 07 Jan 2020 13:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ChcPdsdS9VGVsNLtdTOuWHWVcSN3lEieq0DFAH4Ts9s=;
        b=CuCRGwThXc1osGY0Xfb21CElwWLVJREYbekDCFiDFhYRRZAeW/1dwjv3O0/mSzDU8F
         R6ufgzbKArsZ8G35c+RLdwfQ6qoEZafxDEblhRLL2DS4eICBO8UJ8Ib1pnmaRO34flAv
         vvzydiwo/KJKdRXHrSJCAgbS1fSGtydd6H6exBTnt+iqJWChu5wPOiufpIxxjYawrjfI
         9vS+E2CtbJVUWFRMeCnJfFAEuh+LygBNhSAqd3cZyEAfQ8+zOXM6xesvPmv9qai9/D8p
         Rwh7rR5cpPl+vGEGVCXDhJwzPJJEz70gPgANcFqmrlkhTdRgtD472SlKJydR2Gm1kbM+
         PJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ChcPdsdS9VGVsNLtdTOuWHWVcSN3lEieq0DFAH4Ts9s=;
        b=j1FgVBdJ64SY6rFkoEWjH26NF/URz5E5Pg7hrUcAjIsKiGH9/knPo8Mm4Ku0v/LTny
         38V2/OCH2c9S0CFGmwlDe9r7D5aPbjjGypAe0QgPqMGSxvcnBTB23eAOqJ0OM5wu0bRF
         FQZWumjkaAfeV7js1RzzsqOc6tbi1xeSxmySxK+90gaClHpGSWQzodcywpEdLA8hi2N8
         GZNk+Y6di91S7iLXjYQs8sv0rl3/WyNUSrZQo/ovukKx9v9UXWlsOxNfBIMp5iGt82jz
         zpTSV29nhrQMu9r7eZVDgOarY2BPJN2y7p2kR1G/8uSJrsinb+WvxL5f5y1b4ywKAj3U
         0xgg==
X-Gm-Message-State: APjAAAWZY/0HVpO2iyd2vjiOLp1teyE+H7L1lure9AEgJbZmcNg4gae8
        I9S+DNHf6WrHJdaaPIg3UBg=
X-Google-Smtp-Source: APXvYqzRJMipEtd8UAW7X43YQuqABNkCkcIiKryfhUo8tJN+E6zzAZoKei3yP4vBI9cRsr7rm9QPhQ==
X-Received: by 2002:aa7:96b6:: with SMTP id g22mr1364465pfk.206.1578432277766;
        Tue, 07 Jan 2020 13:24:37 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 189sm515006pfw.73.2020.01.07.13.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 13:24:37 -0800 (PST)
Date:   Tue, 7 Jan 2020 13:24:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
Message-ID: <20200107212436.GA18475@roeck-us.net>
References: <20200107205332.984228665@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:52:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.9 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
[ ... ]

> Ming Lei <ming.lei@redhat.com>
>     block: fix splitting segments on boundary masks
> 

This patch causes a regression. See:

https://lore.kernel.org/linux-block/20200107181145.GA22076@roeck-us.net/T/#m4607a04fde9ef2ed80d45efacef01c0b0e8d2bfd

Guenter
