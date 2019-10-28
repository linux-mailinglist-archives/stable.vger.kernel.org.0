Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A67CE6EAB
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 10:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732219AbfJ1JGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 05:06:39 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21418 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbfJ1JGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 05:06:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1572253564; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=F09oQE3p9AvSYAU6ZP45hYqMl1KwUhzPPqjZxZMGYTqh25UAowJXarzkAeiUNkUVavJ0cGcVZUUYE8XG9QMVkMtMgpBI4wE5XP/cQw4LLo5v5cSORxf16IQyNrrWLOnBvETlhOlWwqlOlgJw7N9WNOy5GX4pdqH2MzH2Gyrqgs8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1572253564; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OtEBa+nJstrwEGctb7Il855BWPHxLBRuyFqEtkLzyRQ=; 
        b=lcUUbrYenTSXbtvhkljhqtr54rJGXKs3yANTGdQU9HT4cnvPnn+snbN7yNmG79EPdjouorOnuB8MBGK05eAX/gFoK9pfDXMH+W/q9IHCjIte+68td5g3eC5jwR8/laXlytq969Rg+8HFOOGrs+KDxGFAZGwuZ055NrhqldI7Z50=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1572253564;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=858; bh=OtEBa+nJstrwEGctb7Il855BWPHxLBRuyFqEtkLzyRQ=;
        b=Alp0z3evuXDB4dsbepyHlXuOJXngmC02BDBrL0M2g0MsbnhcEQgsXMu3qRIsnpmL
        H/LU1TYgz0fr/LabpDIPmdaYpbttJaR3W0MkI8OBASIgkK0SHYUiHzGTcelJRxbx9/X
        TKoYWTeL+WBa6wCTPLisgeolHxzNtVu+tIffRalI=
Received: from notebook (117.102.74.82 [117.102.74.82]) by mx.zohomail.com
        with SMTPS id 1572253562421208.7168821106485; Mon, 28 Oct 2019 02:06:02 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:05:55 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/49] 4.9.198-stable review
Message-ID: <20191028090555.GB3678@notebook>
References: <20191027203119.468466356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 10:00:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.198 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan

