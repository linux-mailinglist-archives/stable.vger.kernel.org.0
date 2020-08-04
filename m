Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5376F23C161
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHDVXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 17:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgHDVXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 17:23:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A099520842;
        Tue,  4 Aug 2020 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596576188;
        bh=FUi79Z6g4j3LKocBOkO8y606YrmtOIbAhq+x5CTTBNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nzPunqSGCcvCWrOS3UfFNLt+3r9GiHXOMQtWHfEax2kra8aOA4Uz1DLLHhkhRZqnK
         LPFNed+wKnuUOmyY2tB2Bi/Jr0htuIvLF5+m6T8pXHsQYJc+1IDtiVp+pVUVHlGEoW
         0Rmp+whXq5OFgLIh97TNxExjxQWgCPQfhaUDOwpc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k34Op-00HUEC-2X; Tue, 04 Aug 2020 22:23:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 Aug 2020 22:23:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
In-Reply-To: <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
References: <20200804072435.385370289@linuxfoundation.org>
 <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com>
 <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <c32ad2216ca3dd83d6d3d740512db9de@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, gregkh@linuxfoundation.org, naresh.kamboju@linaro.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org, stable@vger.kernel.org, arnd@arndb.de, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-04 19:33, Linus Torvalds wrote:
> On Tue, Aug 4, 2020 at 1:21 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> 
>> So Linus's tree is also broken here.
> 
> No, there's 835d1c3a9879 ("arm64: Drop unnecessary include from
> asm/smp.h") upstream.

My bet is that Greg ended up with this patch backported to
5.7, but doesn't have 62a679cb2825 ("arm64: simplify ptrauth
initialization") as the latter isn't a fix.

I don't think any of these two patches are worth backporting,
to be honest.

         M.
-- 
Jazz is not dead. It just smells funny...
