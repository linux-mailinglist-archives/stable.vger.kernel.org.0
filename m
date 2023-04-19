Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA96E73DB
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjDSHUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjDSHUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:20:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C806E9D
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 00:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94EF0634FE
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 07:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E1EC433D2;
        Wed, 19 Apr 2023 07:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681888799;
        bh=jksFfGTqdZ3atDmhJa9S00eZuoqLKxskdbcFR1KIS1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmHTekfPuAP5hFbkfEulzJtGLJwfjoq1Y8V+pNWXb9WYCVEo07RvYzzYgpnywCHWe
         /E7Ei7InRZ2mV7cB/TiyQA83fxU4sszrvK4ZxRUVkx+mZ3BmJNKTtvvG0ORenhfxMw
         uZ46L1/NA1/ThFaOUHdM/VyfGIUxs2//80b10wlk=
Date:   Wed, 19 Apr 2023 09:19:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Subject: Re: [PATCH 5.10 1/4] cgroup/cpuset: Change references of
 cpuset_mutex to cpuset_rwsem
Message-ID: <2023041924-endurance-chalice-9669@gregkh>
References: <20230417171958.3389333-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417171958.3389333-1-longman@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 01:19:55PM -0400, Waiman Long wrote:
> Commit b94f9ac79a7395c2d6171cc753cc27942df0be73 upstream.
> 
> Since commit 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to
> percpu_rwsem"), cpuset_mutex has been replaced by cpuset_rwsem which is
> a percpu rwsem. However, the comments in kernel/cgroup/cpuset.c still
> reference cpuset_mutex which are now incorrect.
> 
> Change all the references of cpuset_mutex to cpuset_rwsem.
> 
> Fixes: 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to percpu_rwsem")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup/cpuset.c | 56 ++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 27 deletions(-)

Due to all of the build problems with this series, I've now dropped all
of these from the 5.10.y queue.  Please fix that up and resend if you
want to see them in this kernel release.

thanks,

greg k-h
