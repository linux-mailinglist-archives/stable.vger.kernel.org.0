Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61A6A96A6
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjCCLoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCCLov (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:44:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C0018AAF;
        Fri,  3 Mar 2023 03:44:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43DF61802;
        Fri,  3 Mar 2023 11:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F839C433D2;
        Fri,  3 Mar 2023 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677843889;
        bh=F4RrA5WPsZsbzw+U1mjjdICbEFuwxtrNykHfFUyhUvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hCKu5LRKWvGifmZspsKoPxF973tZQEUSIp9YRO16nLIRX5cK6fWfwqIPn7eoKYzBm
         wjluU9he+p2i0VFSAes6As7bkkxuZyf01UUGITMC324XfeovfNWhW7FWru4wqNbayZ
         mpxDC6QQ7hXIbl7VJROJYGfKOlg+oKi1M9Rc5K8A=
Date:   Fri, 3 Mar 2023 12:44:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZAHdrhY2P+sBI+xX@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
 <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com>
 <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
 <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
 <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
 <ZAG8dla274kYfxoK@kroah.com>
 <28afc90c1b8b51a36ced5b6026d1a64aeb7c0b14.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28afc90c1b8b51a36ced5b6026d1a64aeb7c0b14.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 12:39:07PM +0100, Paolo Abeni wrote:
> On Fri, 2023-03-03 at 10:23 +0100, Greg Kroah-Hartman wrote:
> > On Fri, Mar 03, 2023 at 02:34:05PM +0530, Naresh Kamboju wrote:
> > > On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
> > > > I read the above as you are running self-tests from 6.2.1 on top of an
> > > > older (6.1) kernel. Is that correct?
> > > 
> > > correct.
> > > 
> > > > If so failures are expected;
> > 
> > Shouldn't the test be able to know that "new features" are not present
> > and properly skip the test for when that happens?  
> 
> I was not aware that running self-tests on older kernels is a common
> practice. I'm surprised that hits mptcp specifically. I think most
> networking tests have the same problem.
> 
> Additionally, some self-tests check for known bugs/regressions. Running
> them on older kernel will cause real trouble, and checking for bug
> presence in the running kernel would be problematic at best, I think.

No, not at all, why wouldn't you want to test for know bugs and
regressions and fail?  That's a great thing to do, and so you will know
to backport those bugfixes to those older kernels if you have to use
them.

> > Otherwise this feels
> > like a problem going forward as no one will know if this feature can be
> > used or not (assuming it is a new feature and not just a functional
> > change.)
> 
> I don't understand this later part, could you please re-phrase?
> 
> Users should look at release notes and/or official documentation to
> know the supported features, not to self-tests output ?!?

How can a program "read a release note"?

Features in the kernel should be able to be detected if they are present
or not, in some way, right?  Syscalls work this way, as does sysfs
entries and other ways of interacting with the kernel.

If there is no way for a program to "know" if a feature is present or
not, how can it detect the difference between "this failed because of
something I did wrong", vs. "this failed because it is not present in
this kernel at all".

thanks,

greg k-h
