Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9B751F6CE
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiEIIMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiEIIJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:09:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960661D6774;
        Mon,  9 May 2022 01:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEFA6135F;
        Mon,  9 May 2022 08:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDB2C385A8;
        Mon,  9 May 2022 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652083476;
        bh=3wjcx/H6Uk19bMqCn1cAxyyBNx/H0v6RBLIJgYSYUPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PwTJfh6Rmur94pTzFA1G1OG9zVQXsWA7iVLfIt0+WmSXyh2s79L/+8goMWazd+E2j
         PDbIQdyElnfi109QssMKcD1ErklYetfLOYWVxbwwTMPJfFNv9k5Jdfcb0Z4Dl8HbdV
         m6PfE4g8LrfF0sX3jY24/5oCNdooTqTzx6oUT+aw=
Date:   Mon, 9 May 2022 10:04:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
Message-ID: <YnjLEU1UoyzNYOUd@kroah.com>
References: <20220429104048.459089941@linuxfoundation.org>
 <20220503141652.GA3698419@roeck-us.net>
 <YnE7aX7p4iQvOrZf@kroah.com>
 <fd8f1f86-1fb3-b4de-61f7-b7ec5aa2f95c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd8f1f86-1fb3-b4de-61f7-b7ec5aa2f95c@roeck-us.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 09:41:48AM -0700, Guenter Roeck wrote:
> On 5/3/22 07:25, Greg Kroah-Hartman wrote:
> > On Tue, May 03, 2022 at 07:16:52AM -0700, Guenter Roeck wrote:
> > > On Fri, Apr 29, 2022 at 12:41:17PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.241 release.
> > > > There are 12 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > No cc this time ?
> > 
> > You and Pavel said this, yet I see your response here:
> > 	https://lore.kernel.org/r/20220429234822.GB2444503@roeck-us.net
> > that you sent on Friday.
> > 
> > Did some old email get unstuck and resent somehow?
> > 
> > 4.19.241 was released on Sunday, I have not sent out new -rc
> > announcements yet.
> > 
> > confused,
> > 
> 
> No, it is me who is confused. I saw Pavel's e-mail, checked stable,
> found this announcement, and thought it was a new one since lore
> reordered it after Pavel's reply.
> 
> The problem I reported is for v4.19.241-49-g667276a8c00e,
> but is also affects v4.14.y.queue and v4.9.y.queue.

This should now be resolved.

thanks,

greg k-h
