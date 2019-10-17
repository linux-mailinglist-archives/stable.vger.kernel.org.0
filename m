Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F09DB61D
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbfJQS2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:28:42 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21438 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfJQS2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:28:42 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571336886; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=MhuZhCQgJHYDrgw8cC//3uQq8vZWxyB9CGvOMjItBylHiicLr4jP3Uc/GnVgmWnf8BUKGDCNMNRpUcCMANfDhS8/6WUeajstUUtyjgmzvqR+/vwJARAZmIvoaAANEd/B13p15qA+LkTEq/nudGePZ8peQuXjFfIVNskCX6z1i6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1571336886; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=F+liBd7cRQPKt5qsBRXr+b5y8EgSj8dkms2tEibAHsA=; 
        b=EFKxlzp2Ve0OaGyBAlFWWJmOBjLlBIyMVyWWEuYBb3jaQPSGWeJb3xGB71LVjIoXi/uioaVwdfXwfi2seY90MfKGwJ62QincRacCTXKKwxVxrxi86FfJhpACaQrWOPWrXm3gaw9PjUjvRptbgx3sGvxu7IPW7kZLJyntdccjIOo=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1571336886;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=861; bh=F+liBd7cRQPKt5qsBRXr+b5y8EgSj8dkms2tEibAHsA=;
        b=jNyQSO+bdQk11LRLVcEqqZSc5wCY9BFK1kdRuzX/mjqsJoDDzxNKrCFSrE0b37hC
        MRI4hRepOK/w8ORAZaBJmfTPwYIubqgKw1Lp9JOK+R02dY2OMQZPjmeBLJipKWd82FN
        son1eG/8BKlITZHZMwkpEJf8QxT0Nx8JNDkZHK2k=
Received: from thinkpad-e420s (120.188.94.47 [120.188.94.47]) by mx.zohomail.com
        with SMTPS id 15713368863401022.4214258563576; Thu, 17 Oct 2019 11:28:06 -0700 (PDT)
Date:   Fri, 18 Oct 2019 01:27:57 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/65] 4.14.150-stable review
Message-ID: <20191017182757.GA9339@thinkpad-e420s>
References: <20191016214756.457746573@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:50:14PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.150 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
 
Compiled, booted, and no regressions found on my x86_64 system.

Thanks,
Didik Setiawan 

