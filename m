Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159AD4DC2A1
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 10:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiCQJ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 05:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiCQJ2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 05:28:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BA41D4C0A;
        Thu, 17 Mar 2022 02:27:28 -0700 (PDT)
Received: from zn.tnic (p200300ea971561b0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61b0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 80B0D1EC0576;
        Thu, 17 Mar 2022 10:27:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647509243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/RQrguJ3cKjr+bWjA/6e8aVvTohMSMRaWDTYbIX/dH8=;
        b=i+kn3NRUeKo+NkVaSmoJYziJGSO3+q5T+7oduZrys964Cz0hU7XIqxwWCoHt9Jkf/RXZyk
        +7AjyVtRs2t7A9mGrqqvDIptjzpi4qcGy84NAUnSO0hdXL/ELlUhmnvPksB3QzV0iNsvnk
        Akuqq5MI5rP5rq8i37CQx8WsWc9MAoM=
Date:   Thu, 17 Mar 2022 10:27:18 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        David.Laight@aculab.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, x86@kernel.org
Subject: Re: [PATCH v5 0/2] Two x86 fixes
Message-ID: <YjL+9sUPLvE57GE0@zn.tnic>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <CAFBCWQLJ6vCWePF0W4U7mont=Jn4QfDUq-8UpOcm37yqtbkQ8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFBCWQLJ6vCWePF0W4U7mont=Jn4QfDUq-8UpOcm37yqtbkQ8Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 03:19:07PM +0700, Ammar Faizi wrote:
> On Thu, Mar 10, 2022 at 8:53 AM Ammar Faizi wrote:
> > Two x86 fixes in this series.
> >
> > 1) x86/delay: Fix the wrong Assembly constraint in delay_loop() function.
> > 2) x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails.
> 
> Ping (1)!
> Borislav? Thomas?

Yes, what's up?

Are those urgent fixes which break some use case or can you simply sit
patiently and wait?

Because we have an upcoming merge window and we need to prepare for
that. And there are real bugs that need fixing too.

So what's the rush here?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
