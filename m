Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA0D0549
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 03:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfJIBik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 21:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfJIBik (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 21:38:40 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA80A2070B;
        Wed,  9 Oct 2019 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570585119;
        bh=MpXlhIkhf/Mek/wxcrUbCVFSCvb0g4/oh/mqdHzktTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mc91Ke4vVSCqqPZcEGlonZW75iCB9LZtxWShfBf1+UFHsK78oxiNn21kXPox7aPc/
         QnWXnwRu4irYkIPaZ6E4XwS12q2MhmHoWWE8C0KWNm35ng14SsKtYbf2O7WlPLxOkj
         FDBPvRat/isHbF0inHhM0Pu3I8ZQNhW4rM2IoCfc=
Date:   Tue, 8 Oct 2019 21:23:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     gregkh@linuxfoundation.org, vincent.chen@sifive.com,
        david.abdurachmanov@sifive.com, palmer@sifive.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously
 enabled in" failed to apply to 5.3-stable tree
Message-ID: <20191009012335.GR1396@sasha-vm>
References: <1570555664182195@kroah.com>
 <20191009005252.GQ1396@sasha-vm>
 <alpine.DEB.2.21.9999.1910081759550.972@viisi.sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.9999.1910081759550.972@viisi.sifive.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 06:00:36PM -0700, Paul Walmsley wrote:
>On Tue, 8 Oct 2019, Sasha Levin wrote:
>
>> I might be missing something here, but wasn't the label "1" already
>> declared a few lines above?
>
>See the "Local Labels" section of
>
>https://sourceware.org/binutils/docs-2.24/as/Symbol-Names.html#Symbol-Names

Thanks!

I've fixed the patch to compensate for not having 4f3f90084673f ("riscv:
Using CSR numbers to access CSRs") and queued it for 5.4 and 4.19.

-- 
Thanks,
Sasha
