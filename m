Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176A2E6EB1
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 10:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfJ1JI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 05:08:29 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21466 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfJ1JI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 05:08:29 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1572253676; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Moykj5B1WkkWHupL9r6DyGaoy35uM0AjUy18FK/f40nuy391tfpGT6KMsFIEDKYWkMAQtxFqdYcJ446SE7zfL66lTx0yc83qoeNxrbl06LQ02Zhc81v1RCVXNP9sHHQocTCiDqNfI6RYoyNz5Snhc6x72gArUnpwIn3d2sEiMdc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1572253676; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ByZHeiiRbDCAualSxq60IBfLlVYMklrFoMjUG2DW5xM=; 
        b=QW5eyPyFDShxKjIqRDjb4WTFKgnIDgt7M6x0TK347GB4wrpGEnzzfDLXfZrfoF3shucXuZ9YTeq4u1umDgzcxhbW9iu3Y8YOW7zO+713IccW4bDPA0fB6pThUWErQp+4SOhiWIKdNTcdJ7Dmp0riZT2y07e/0oQUIylAzicH1Yk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=didiksetiawan.com;
        spf=pass  smtp.mailfrom=ds@didiksetiawan.com;
        dmarc=pass header.from=<ds@didiksetiawan.com> header.from=<ds@didiksetiawan.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1572253676;
        s=zoho; d=didiksetiawan.com; i=ds@didiksetiawan.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=858; bh=ByZHeiiRbDCAualSxq60IBfLlVYMklrFoMjUG2DW5xM=;
        b=Bg+h1meVd4CC4+BWonNHt5yFaROEdS6hi5kCQAswwkqECDuWl/17hsSZFC0Y1IZA
        aAph9lv07wR0VUqHLjT1P9oEBiqjUD27YCsguXGa/2v469t2U9WVVs8vj6AkDZkFLLO
        yYE5IRLnwFOIycQZXZgUAnwDx7Z+pIlHHfwKoEu4=
Received: from notebook (117.102.74.82 [117.102.74.82]) by mx.zohomail.com
        with SMTPS id 1572253675682152.35703934118305; Mon, 28 Oct 2019 02:07:55 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:07:50 +0700
From:   Didik Setiawan <ds@didiksetiawan.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
Message-ID: <20191028090750.GC3678@notebook>
References: <20191027203056.220821342@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 10:00:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.198 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.198-rc1.gz
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

