Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C956A9882
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjCCNf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 08:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjCCNfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 08:35:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD833442;
        Fri,  3 Mar 2023 05:35:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B47EB818C8;
        Fri,  3 Mar 2023 13:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF15DC433D2;
        Fri,  3 Mar 2023 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677850543;
        bh=Htqk16fIqSRpYOBmEt0mm+UstJGITrQgQKDJK8WYUQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rwn6xV/xVM7MS4fgI9Q2TGJnRAmU+wb4TW7rXrZbY2wg0c5fVLcLXPrDvkFLjWB7q
         yJotfNV0VK2Sotzxf0qJkuSskFSywcMbGQQgCz4z2+xTXPb7zJYLKJY6BoeClq+944
         NLerBvzMhLzfHcmpNGjryMChXJ00mLVrSzZNIP7M=
Date:   Fri, 3 Mar 2023 14:35:40 +0100
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
Message-ID: <ZAH3rLIHE1wIY9c+@kroah.com>
References: <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com>
 <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
 <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
 <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
 <ZAG8dla274kYfxoK@kroah.com>
 <28afc90c1b8b51a36ced5b6026d1a64aeb7c0b14.camel@redhat.com>
 <ZAHdrhY2P+sBI+xX@kroah.com>
 <d593e9434dba16a869ec48fcdfe8a3fe540c8a82.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d593e9434dba16a869ec48fcdfe8a3fe540c8a82.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 01:41:00PM +0100, Paolo Abeni wrote:
> On Fri, 2023-03-03 at 12:44 +0100, Greg Kroah-Hartman wrote:
> > On Fri, Mar 03, 2023 at 12:39:07PM +0100, Paolo Abeni wrote:
> > > Additionally, some self-tests check for known bugs/regressions. Running
> > > them on older kernel will cause real trouble, and checking for bug
> > > presence in the running kernel would be problematic at best, I think.
> > 
> > No, not at all, why wouldn't you want to test for know bugs and
> > regressions and fail?  That's a great thing to do, and so you will know
> > to backport those bugfixes to those older kernels if you have to use
> > them.
> 
> I'm sorry, I likely was not clear at all. What I mean is that the self-
> test for a bug may trigger e.g. memory corruption on the bugged kernel
> (or more specifically to networking, the infamous, recurring
> "unregister_netdevice: waiting for ...") which in turn could cause
> random failures later.
> 
> If that specific case runs on older (unpatched) kernel will screw the
> overall tests results. The same could happen in less-detectable way for
> old bugs non explicitly checked by any test, but still triggered by the
> test-suite. As a consequence I expect that the results observed running
> newer self-tests on older kernel are unreliable. 

For the stable/LTS kernel trees, they should _never_ be unreliable,
otherwise that means we have missed a needed fix and so we need to
resolve that.

Which is why I always recommend running the latest selftests on all
older kernels, and have for a very long time now.

thanks,

greg k-h
