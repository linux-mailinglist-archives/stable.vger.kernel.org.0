Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649228723A
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgJHKHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgJHKHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 06:07:20 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D99AC061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 03:07:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C6RhP00Qvz9sT6;
        Thu,  8 Oct 2020 21:07:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1602151637;
        bh=eNG1RyjqNmOm7441Ouc9ni/lGO8jgy6V8+FrXQf4kmE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ixnS8cV4Q4MSAGho2zjlIKJJgNmnrvBVFjwDxHWNwsbJaAGA8W9fiKzWBlwLQI+CW
         cP7//cRdNpcodhyaIIesDXI9Pytf38ooJ8OZ0kiqQ1uE6iaoKe9c7ZaEX3GPLjcsBm
         /h/SUVum41uWKLr66a0yv6Z+wABkvxDe7MHwVD5g5lLtfSwIW96KlDn3EtVudTeCzX
         inJNjToJOuirp0ZMHIqpBuSFG8TPtmlN0HZAGSFiwPMSixe472j2YL4rnD/HMGtvuS
         FxTMHwuDDUBdeRj1/Nfu+cZy9GV6fB+oVzI/ccDHkEAt/Kci6O2RJ+0CfjGQZuTNfm
         ltjSQgJfYQNtA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andrew Donnellan <ajd@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com, dja@axtens.net,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from userspace
In-Reply-To: <87v9fl117r.fsf@mpe.ellerman.id.au>
References: <20200820044512.7543-1-ajd@linux.ibm.com> <20200826135348.AD06422B4B@mail.kernel.org> <421cba41-20bf-f874-c81a-8b7f9944c845@linux.ibm.com> <87v9fl117r.fsf@mpe.ellerman.id.au>
Date:   Thu, 08 Oct 2020 21:07:16 +1100
Message-ID: <87sgap1163.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:
> Andrew Donnellan <ajd@linux.ibm.com> writes:
>> On 26/8/20 11:53 pm, Sasha Levin wrote:
>>> How should we proceed with this patch?
>>
>> mpe: I believe we came to the conclusion that we shouldn't put this in 
>> stable just yet?
>
> Yeah.
>
> Let's give it a little time to get some wider testing before we backport
> it.

So my fault for not dropping the Cc: stable on the commit, sorry.

cheers
