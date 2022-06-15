Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E273F54C711
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348481AbiFOLCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 07:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349180AbiFOLA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 07:00:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B373527EB;
        Wed, 15 Jun 2022 04:00:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4B5871F385;
        Wed, 15 Jun 2022 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655290823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r4Xgkiz28fr7+QgqidS11r+u0JdfTJrBzbaVks+Q0jM=;
        b=zg/rOjLLT2fpOGRhWYY2YGBT979qo85Ocm1hqui8j5X4gOs7RjAckvWGBLOY+SV4Mjjo4s
        D2+xY3C1Bys8xpXIbAMrhKzIrxhHtI/WTJCojuxaOcDPA7jrsknnFuO9qDfbxYjaOB6KMx
        Qe/BCbHo5XMDXLGBB9/+qLe1+hu36XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655290823;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r4Xgkiz28fr7+QgqidS11r+u0JdfTJrBzbaVks+Q0jM=;
        b=PzX0gwI6ZxCo8Mip8nRs3IhgpusPyUyUhWNDs1rXPD1M9Sbwyub346IboU1/K/10EW8vvS
        uUh1OQYXh7gG9GBQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 223792C141;
        Wed, 15 Jun 2022 11:00:23 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B3F52A062E; Wed, 15 Jun 2022 13:00:22 +0200 (CEST)
Date:   Wed, 15 Jun 2022 13:00:22 +0200
From:   Jan Kara <jack@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, Jan Kara <jack@suse.cz>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220615110022.yifrsvzxjsz2wky5@quack3.lan>
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
 <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
 <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 14-06-22 12:00:22, Linus Torvalds wrote:
> On Tue, Jun 14, 2022 at 11:51 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Or just make sure that noop_backing_dev_info is fully initialized
> > before it's used.
> 
> I don't see any real reason why that
> 
>     err = bdi_init(&noop_backing_dev_info);
> 
> couldn't just be done very early. Maybe as the first call in
> driver_init(), before the whole devtmpfs_init() etc.

I've checked the dependencies and cgroups (which are the only non-trivial
dependency besides per-CPU infrastructure) are initialized early enough so
it should work fine. So let's try that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
