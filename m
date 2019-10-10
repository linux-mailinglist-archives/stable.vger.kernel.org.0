Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE7D34A6
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 01:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfJJXvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 19:51:05 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21449 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 19:51:05 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1570751433; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=hT7cVdAi4Ogoe87/LMc1zcAwrULZmjt3BrSAcC8PTLi07sakUdVtriCqJoMc8eG8HQHYo4+w4+QQ6xqExcbY8gnq3xk1Rjl1RWd+Dv9ifEABjZ7MDrvS4WPl6FXW6Kx3M4UUM6Ut8lnwhVZm+q1rFOrVTbjmvW2XMItcdTTI7UM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1570751433; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yN70WGu1foiEfKceIyoLTb0NvXxZwFhRCRnJxip6P9M=; 
        b=LtfdSbYVp3wu5n2pzvkIEkD5k4Kx7UJ8qfMvP6QoJ8lC7mx46tXDaStWpTq1eJkM+M/2njPtPz3XWf4pWeCyCjBInvwt051H63fiz89kkL3LHi5boGEEsfg9PgAZU8vrzIh+AHS6nIVRuyDdMy5zHdClC3pzceM6H/HIs+WC8bY=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1570751433;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=864; bh=yN70WGu1foiEfKceIyoLTb0NvXxZwFhRCRnJxip6P9M=;
        b=yqmdtRH7FQ66gm9S6CGLpMoqbJsb3LmjRr0fRpv2T08/63b9EGONtJftxBIO9g3h
        D+DUIyiUl3vE8z766vmnmyYtd1FnM1sB1QnswbDQmnAqgMwWpXCiCzmldZcSCiuflWW
        2KBtrZqjcDZ6bKcXA42voazzZAdo4978ureT2heE=
Received: from thinkpad-e420s (120.188.6.98 [120.188.6.98]) by mx.zohomail.com
        with SMTPS id 1570751432403510.0797825909775; Thu, 10 Oct 2019 16:50:32 -0700 (PDT)
Date:   Fri, 11 Oct 2019 06:50:20 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
Message-ID: <20191010235020.GA23813@thinkpad-e420s>
References: <20191010083449.500442342@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:36:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.149 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
 
Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan

