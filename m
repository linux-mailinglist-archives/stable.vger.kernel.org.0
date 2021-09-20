Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F784111FC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhITJlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbhITJlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 05:41:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39085C061764;
        Mon, 20 Sep 2021 02:39:09 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a2a0063d0dab944a9c04a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2a00:63d0:dab9:44a9:c04a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BD9AA1EC0287;
        Mon, 20 Sep 2021 11:39:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632130743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qjO2xRf02NNWauQIz6XEzlkghXmGsDJ5dp1Bk7wS1xc=;
        b=TkrLW8/x/yu6eCxsiTAVVip/KZk5JBnVao0yQOJmjm/tpPc4pMHhrmXWkZ50HJBtJMUmqs
        5YzRtENb8jGwVbXm4MFf3mS94X5kD3fK2dX1DzrNtnS45aeNWWD12fxXLVrbfEHVrUTFnF
        Y1EdIDLMPtSW5efQ/e64pOZMJFbUi1M=
Date:   Mon, 20 Sep 2021 11:38:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, marmarek@invisiblethingslab.com,
        Juergen Gross <jgross@suse.com>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUhWsOM1y3EEQWWH@zn.tnic>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdtm8hVH0ps18BK@linux.ibm.com>
 <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
 <YUhTwPhva5olB87d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YUhTwPhva5olB87d@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 12:26:24PM +0300, Mike Rapoport wrote:
> Can't say anything caught my eye, except the early microcode update.
> Just to rule that out, can you try booting without the early microcode
> update?

That should be unrelated but sure, worth a try, you can boot with
"dis_ucode_ldr" on the cmdline.

-- 
Regards/Gruss,
    Boris.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
