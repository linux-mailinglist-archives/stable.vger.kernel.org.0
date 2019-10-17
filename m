Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4315ADB5B8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438338AbfJQSS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:18:58 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21412 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438465AbfJQSS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571336301; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=lagggj9ZXvDDIV7/derIiQExwv5MI/xc+UOh4ezgQDExS+e69htC0j1LdG0HVtmhv6ln2ZyYCQ+RqWcJzaJAsjr9Ty6qdOWWyOYBAVKfWRa70zq+N9VeB4r3ObtV3im93CfvTt1G4Mb+P9aBYWdJSe0s7Y4ZGprySexbizifByg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1571336301; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=e+DmBc0k0wkI4KLvSKQhrZ/7KcWo1MMr/deLd6MWJZw=; 
        b=DEQm9onx0wvrGf0Sm1Orwas4WGPoFuhShAwcodKfRhhnKfQrJSNFSWVzO2p4x9dBHAIpQefkpuyV0wo18pYmNCtWZftC+sSe9ZCAraU/+gB8bVoY8ByPtYoMIQyXzng+Ozi9szULxQ5+u9eATzE98Vd1D4/zQvKFNfi7Hd8XpB8=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1571336301;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=858; bh=e+DmBc0k0wkI4KLvSKQhrZ/7KcWo1MMr/deLd6MWJZw=;
        b=BKsGMwn/vwAMgIMD/sdhSg9h7UfVgn9L1HdJMnoPBM55UzU9rRITVizYVXGzWtwA
        tSv3c/gsToA0d1NGvSSEnmhKqTYTkSscye0W4Yn0iGosn6c9z0CEUr5ZdbvmbSCD/oJ
        ncmTvHP6HmUINU5tN+/Ydsl+dOCH19ZRMZFC134M=
Received: from thinkpad-e420s (120.188.94.47 [120.188.94.47]) by mx.zohomail.com
        with SMTPS id 1571336299478949.125726423069; Thu, 17 Oct 2019 11:18:19 -0700 (PDT)
Date:   Fri, 18 Oct 2019 01:18:08 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/79] 4.4.197-stable review
Message-ID: <20191017181808.GA8883@thinkpad-e420s>
References: <20191016214729.758892904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:49:35PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.197 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
 
Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan 

