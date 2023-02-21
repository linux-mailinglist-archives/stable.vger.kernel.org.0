Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9035969E8A9
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjBUT5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBUT5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:57:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DCB23843;
        Tue, 21 Feb 2023 11:57:33 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 18BEA1EC064A;
        Tue, 21 Feb 2023 20:57:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677009452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=orwG1USf0gQnFslqagr7EV9qfLr3a8LHTumtxJ1eG7s=;
        b=lo9nVnJICQRiKT1MgvE9XJSYzdRre19L1hNDxPmJoXvZPfj6K5/bWoWxU1bSQu4Q3mgiGV
        Ct2XDDr5h8N7oQsgkHtNB7pxUIoFn4PfyIrVuMyoMWfvgJ1UilolJHZlZ3mWv3tmvp7ko5
        OG1D6M1lqT/yvmw4Pi1C0hQH8tw45s4=
Date:   Tue, 21 Feb 2023 20:57:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net, bp@suse.de,
        linyujun809@huawei.com, jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/UiJmv7j12hOe0k@zn.tnic>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/UbqiHQ2/aczPzg@kroah.com>
 <CACYkzJ7pLhJ+NfUq36PaMxadkgv-cPtO60TW=g_Nh7vU1vEWqA@mail.gmail.com>
 <Y/Uf2lnU/VcsFs1O@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/Uf2lnU/VcsFs1O@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 08:47:38PM +0100, Greg KH wrote:
> Why does anyone need to "drop stable" from a patch discussion?  That's
> not a problem, we _WANT_ to see the patch review and discussion also
> copied there to be aware of what is coming down the pipeline.  So
> whomever said that is not correct, sorry.

Someone dropped stable because you used to send automated formletter
mails that this is not how one should submit a patch to stable. I guess
that is not needed anymore so I'll stop dropping stable.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
