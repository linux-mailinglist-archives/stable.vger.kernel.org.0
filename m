Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DA6E73DC
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjDSHU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDSHU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086AF49C6
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 00:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A6856134C
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 07:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20F5C433D2;
        Wed, 19 Apr 2023 07:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681888825;
        bh=XjCfwVwUI2LH+Nnyq/tPRe5xpJ3sphKp0WCIq0G0wME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqVZ4QyUM7tgrMUrI3tLxKelEa0+Hz31JbNw/pn9WOiiVPGDKMMMFcSIJCHuuOGmj
         Gv5wTZIvCbaxBa+V3TvsoRKSY2QO3TfEywZUeF9xO0H3rfgWNkeb0pBn4ss/tvdEdt
         ksU0O1ARxIOUXFsf+PyBEBZaglxUIU044QLhj4YM=
Date:   Wed, 19 Apr 2023 09:20:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Subject: Re: [PATCH 5.15 1/3] cgroup/cpuset: Skip spread flags update on v2
Message-ID: <2023041902-giddily-obliged-32ce@gregkh>
References: <20230417153647.3374211-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417153647.3374211-1-longman@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 11:36:45AM -0400, Waiman Long wrote:
> commit 18f9a4d47527772515ad6cbdac796422566e6440 upstream.
> 
> Cpuset v2 has no spread flags to set. So we can skip spread
> flags update if cpuset v2 is being used. Also change the name to
> cpuset_update_task_spread_flags() to indicate that there are multiple
> spread flags.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup/cpuset.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 

Same as the 5.10.y series, I've dropped all of these due to build
errors.

thanks,

greg k-h
