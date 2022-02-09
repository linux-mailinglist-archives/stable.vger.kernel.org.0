Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E68D4AE994
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 06:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiBIFzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 00:55:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiBIFxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 00:53:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82DDC0F86BB
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 21:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF7761662
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 05:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B1DC340E7;
        Wed,  9 Feb 2022 05:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644386015;
        bh=VvvABKSf7EmdXM3jfCiVplBg/Mxv2XCCH05zJTbe57Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4Q3N/2equkYcXKMVfdmVuOLZWvEfsJdiTZ/1oFJCzpkC64WmNqt0BeLT41hdhSPR
         SA6QNc7j57XHIt6pGJC+DBBi3XCaM+Wjb2p6ShMorFrUpyWDzALhtjkPpjl9zBdMcA
         rjK1V52E9mR4NWNj2PhHPXx82NXZhUhTiZC5VBEU=
Date:   Wed, 9 Feb 2022 06:53:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     stable@vger.kernel.org, Tabitha Sable <tabitha.c.sable@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup-v1: Require capabilities to set release_agent
 (backport to v4.12)
Message-ID: <YgNW3CfJCBH17vnl@kroah.com>
References: <20220208182402.24674-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220208182402.24674-1-mkoutny@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 07:24:02PM +0100, Michal Koutný wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> The cgroup release_agent is called with call_usermodehelper.  The function
> call_usermodehelper starts the release_agent with a full set fo capabilities.
> Therefore require capabilities when setting the release_agaent.
> 
> [ Upstream commit 24f6008564183aa120d07c03d9289519c2fe02af ]
> 
> Reported-by: Tabitha Sable <tabitha.c.sable@gmail.com>
> Tested-by: Tabitha Sable <tabitha.c.sable@gmail.com>
> Fixes: 81a6a5cdd2c5 ("Task Control Groups: automatic userspace notification of idle cgroups")
> Cc: stable@vger.kernel.org # v2.6.24+
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> [mkoutny: Adjust for pre-fs_context, duplicate mount/remount check, drop log messages.]
> Acked-by: Michal Koutný <mkoutny@suse.com>
> ---
> 
> Hello,
> FWIW, I'm sharing v4.12 backport of the aforementioned patch (v4.12 is not
> actual stable but someone may find it useful).

What about 4.19 and 4.14 versions?  Those would be useful :)

thanks,

greg k-h
