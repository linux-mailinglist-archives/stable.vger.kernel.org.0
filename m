Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4046E73E5
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjDSHWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjDSHWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D1420A;
        Wed, 19 Apr 2023 00:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B41C9632CF;
        Wed, 19 Apr 2023 07:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9FDC433EF;
        Wed, 19 Apr 2023 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681888960;
        bh=lRsxaahob87Hi5F08OqWph7rJPP7IDkdOdnQsILSUUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXUDMqFtm4c4iL/4vC6/oHGo2NSb8emzekf8XJ6QVmwoCa+nHqXxxnBaBgi0DbsG4
         Vz0oVBgMT9S1jo6qswRTrpL4XfgXpRkrhqgl67dRUPJMTB80RYFSEvXjMWkYi0mljm
         fv0yup02EXQlR5IVSHGK5/gulvKA9GE7SudD5OYY=
Date:   Wed, 19 Apr 2023 09:22:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <2023041918-gravitate-reformat-9a34@gregkh>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
 <20230418165105.q5s77yew2imkamsb@oracle.com>
 <ZD9rfsteIrXIwezR@debian.me>
 <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 10:56:22PM -0600, Yu Zhao wrote:
> On Tue, Apr 18, 2023 at 10:18 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> >
> > On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > > > Tom Saeger identified that the below commit moves it out of ifdef.
> > > >
> > > > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > > > Author: Yu Zhao <yuzhao@google.com>
> > > > Date:   Sun Sep 18 02:00:07 2022 -0600
> > > >
> > > >     mm: multi-gen LRU: kill switch
> > > >
> > > FWIW - partially backporting (location of cgroup_mutex extern) from:
> > > 354ed5974429 ("mm: multi-gen LRU: kill switch")
> > >
> > > fixes x86_64 build for me.
> > >
> > > Regards,
> > >
> > > --Tom
> > >
> > > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> 
> ...
> 
> > Yu, would you like to provide formal backport?
> 
> Are you suggesting backporting the entire MGLRU patchset (>30 patches)?
> 
> I do have the backport ready for 5.15 and multiple distros have taken
> it. But I don't think Greg would welcome it. I'd be happy to be wrong
> though.

I'm just going to drop all of these patches from the queues now, and let
the original submitter resend them after they are fixed up properly.

thanks,

greg k-h
