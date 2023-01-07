Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0A660DE8
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 11:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjAGK3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 05:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjAGK2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 05:28:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D899B87F33;
        Sat,  7 Jan 2023 02:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4186F60B72;
        Sat,  7 Jan 2023 10:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1591CC433EF;
        Sat,  7 Jan 2023 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673087271;
        bh=9aSwaVo2ASINUIF5kxH/VwbRD8ciZ/eswbsN74JDSOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFqULiuqPuR7caQBBJhPi0uCa02+SSlhQpb8HRgRRV32XmQABwjCsMyf90jSDtD6f
         v9CxmAN42nEdBgUKed619kswN9VLOBSP4PRjaxNRlc349ixrLH9Pu0WqIQUEN5iR9i
         /diqwXucno0TdkY5Pxvs38jSD/YjthrW2tHdTGag=
Date:   Sat, 7 Jan 2023 11:27:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     nathan@kernel.org, marcus.folkesson@gmail.com,
        cuigaosheng1@huawei.com, andriy.shevchenko@linux.intel.com,
        m.szyprowski@samsung.com, jack@suse.cz, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Message-ID: <Y7lJJEhK3W3joZv6@kroah.com>
References: <20230105125334.727282894@linuxfoundation.org>
 <Y7cpWKbQlNW5qEeO@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cpWKbQlNW5qEeO@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 08:47:36PM +0100, Pavel Machek wrote:
> This one is okay in mainline, but contains wrong error handling in the
> 4.9 backport. 4.19 seems okay. It needs to "goto out_unlock", not
> return directly.
> 
> > Jan Kara <jack@suse.cz>
> >     ext4: initialize quota before expanding inode in setproject ioctl

I've fixed this up, good catch.  The rest I've left as they seem
reasonable to be in the tree as-is.

thanks,

greg k-h
