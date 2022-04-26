Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ACA510740
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343969AbiDZSlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 14:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241045AbiDZSlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 14:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7DB6A006;
        Tue, 26 Apr 2022 11:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95CF9B81DE7;
        Tue, 26 Apr 2022 18:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1324C385A0;
        Tue, 26 Apr 2022 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650998324;
        bh=Ybj8IchajmkzAQ5r0wEtBIPCgRxzxJki5uddLEvY3aY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iyLOsNSK6YJyUtSna1fyEzFOYk6Y7UP+F9+dhQOji8sEBX7rnC50SwvfR9hGGGUdX
         FBqn+ZmpzWJdI+e4vVj7ZFEbulOo7eIj5EZLwRBH7YliURljEovkvrO8BW5rNKveFx
         qkyG43CylYmlYxDHpCOaKDftmptA6lyTYshKXpGI=
Date:   Tue, 26 Apr 2022 20:38:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Donnelly <John.p.donnelly@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Message-ID: <Ymg8MSKq93nSS1rq@kroah.com>
References: <20220426081747.286685339@linuxfoundation.org>
 <09eb98b8-6200-20c2-faa2-ced7f0e4fc95@oracle.com>
 <Ymgxd6WGhUBuntkS@kroah.com>
 <e1eb47ea-7327-7565-3a8f-3d9cf4ee904c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1eb47ea-7327-7565-3a8f-3d9cf4ee904c@oracle.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 12:24:24PM -0500, John Donnelly wrote:
> On 4/26/22 12:52 PM, Greg Kroah-Hartman wrote:
> > On Tue, Apr 26, 2022 at 12:37:21PM -0500, john.p.donnelly@oracle.com wrote:
> > > 76723ed1fb89 2021-12-01 | locking/rwsem: Make handoff bit handling more
> > > consistent
> > > 
> > > In Linux 5.15.y.
> > 
> > That commit is in 5.15.6, released December 1, 2021.  And this just now
> > shows up?  How is this related to 5.15.36-rc1?
> 
> Hi,
> 
> This  was briefly discussed in :
> 
> Re: [PATCH v5] locking/rwsem: Make handoff bit handling more consistent

Have a lore.kernel.org link?  Why not continue it there?

> Additional testing shows the rwsem hang still exists.  It takes a 24hr fio
> soak test to show up.
> 
> It likely still exists in Linux 5.18.y too. We will be testing that in the
> future as time permits.

Can you test 5.17.y also as there is no 5.18.y yet :)

thanks,

greg k-h
