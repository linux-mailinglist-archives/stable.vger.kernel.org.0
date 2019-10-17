Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A987DB631
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404587AbfJQSbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:31:32 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21437 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbfJQSbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:31:32 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571337061; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=n2X1G2BUNp8cu7L6rDm7f49/bcr+rb7JOVb0KHhzpRRUsHaFxkyZR+Bsfdc9RyYg/eFH9QFeHLjBqzTqtzBwFaTFk05dDWvmwVf+CN8FoGLVyrYuuFEbMokqydJKfg6s2fFqaXL7kWgxAw+fYAvsQkr9gz24xsrxNnlUb4rUjyI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1571337061; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uaBh355qz7rKIhWBpp2WVxLpaXjQT3pukq/t3NvpAsk=; 
        b=hfuWQ2EcPKn8gvSVHPiN4+gGmmbMsuHfgtGY0z1WcYhvWVrKsmrA2LTvOX9QhbQTkVqj1fmL0yvtFzV8If/AvbNtCcSfRXUKOolSakNKpmcci+f4foZwdLc/kymjqTZzDagzoVAxqR/N4FHpZRA8NNi6HUJ1lUWJ4+I88yd1qiw=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1571337061;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=855; bh=uaBh355qz7rKIhWBpp2WVxLpaXjQT3pukq/t3NvpAsk=;
        b=u/2vQM9agltTpTJ3k8zqaO+n/gXrIx8wBKrwiN/oFm8ytxFs81Tb2CFJG+Im+NwY
        9E8z+lljmlU7GtuOF1zQJ925Y7Oi4rhrFuoKH/qD+OoWisoU+p2Fpiv295nZYRa76En
        womDnUdDzXQgB99lNQlkVGS12+wTtXHFWQ4yvZno=
Received: from thinkpad-e420s (120.188.94.47 [120.188.94.47]) by mx.zohomail.com
        with SMTPS id 1571337060282419.81738443610436; Thu, 17 Oct 2019 11:31:00 -0700 (PDT)
Date:   Fri, 18 Oct 2019 01:30:48 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017183048.GA9506@thinkpad-e420s>
References: <20191016214844.038848564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:49:52PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.7 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
 
Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan 

