Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCF620092
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfEPHsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 03:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfEPHsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 03:48:53 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D9820862;
        Thu, 16 May 2019 07:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557992932;
        bh=u3nBaEAiGEFBZvcIuNfN6cg4cedso58GmRC8f4wo5lM=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=oa6ko67NC+Hi5cLWrfdKjKEBsbeS46lj+7gUkl4eAS0JxXxHG5Aw/3hHZ35rqCGDR
         czYKCPaXPBdSPza4jP2PxeEsFd/PjAot5OcGjuqzY9GIKPHjUxIoPRoEfBeC6ivNgq
         2jnX9gm1G8hJJYXSIh9zptGFSpyUFw9/nb5L8Hpo=
Date:   Thu, 16 May 2019 09:48:37 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpu/speculation: Warn on unsupported mitigations=
 parameter
In-Reply-To: <20190516070935.22546-1-geert@linux-m68k.org>
Message-ID: <nycvar.YFH.7.76.1905160947210.22183@cbobk.fhfr.pm>
References: <20190516070935.22546-1-geert@linux-m68k.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 May 2019, Geert Uytterhoeven wrote:

> Currently, if the user specifies an unsupported mitigation strategy on
> the kernel command line, it will be ignored silently.  The code will
> fall back to the default strategy, possibly leaving the system more
> vulnerable than expected.

Honestly, I am not convinced. We are not doing this for vast majority of 
other cmdline options either, if for any at all.

Thanks,

-- 
Jiri Kosina
SUSE Labs

