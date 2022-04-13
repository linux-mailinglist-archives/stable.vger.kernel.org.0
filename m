Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888B24FEFC5
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 08:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiDMG0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiDMG0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 02:26:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12554BFE7
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757CE61CEB
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFD3C385A3;
        Wed, 13 Apr 2022 06:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649831038;
        bh=s1yYvWdl4tcp0I9Zb1BbpKILR9qzAE1I9gtNCnd4ijE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JIzBKtaKgHsSL+rjwgZvKd55nNnwingr3FnC+ze4nyEP8EU8nhBWHOsdXPGuBuxdB
         lmYiWp5Gxe6VQLeZYtJcJL9PuQ0qpDj5l8MC1wy/nm0nZtTQwfsoFMF6Z5nDny+RL3
         267t2hTxzKtpebk3vTI/ht0viqvPLRsYPb78F5fk=
Date:   Wed, 13 Apr 2022 08:23:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     skt-results-master@redhat.com, stable@vger.kernel.org,
        Memory Management <mm-qe@redhat.com>,
        Li Wang <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        Filip Suba <fsuba@redhat.com>,
        Fendy Tjahjadi <ftjahjad@redhat.com>,
        Yi Zhang <yizhan@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Bruno Goncalves <bgoncalv@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.17.2 (stable-queue, eabfed45)
Message-ID: <YlZse4JgKRqMBdJ1@kroah.com>
References: <cki.LEF6Q6V9CU1O7JTZ58AW@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.LEF6Q6V9CU1O7JTZ58AW@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 06:03:14AM -0000, CKI Project wrote:
> 
> 
> Check out this report and any autotriaged failures in our web dashboard:
>     https://datawarehouse.cki-project.org/kcidb/checkouts/38921
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: eabfed45bc7c - io_uring: drop the old style inflight file tracking

It's alive!

> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>     Targeted tests: NO

But things are failing.

Is this the CKI tool's issue, or is it the patches in the stable queue's
issue?

Given that CKI has been dead for so long, I'll guess it's a CKI issue
unless you all say otherwise.

thanks,

greg k-h
