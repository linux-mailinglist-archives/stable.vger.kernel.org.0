Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5E9500B36
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiDNKgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiDNKgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:36:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65F4C74
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81835B82827
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF069C385A1;
        Thu, 14 Apr 2022 10:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649932459;
        bh=2RXVXbWZJsSqCvA6iyhGpb9Ek60A4MVY/Z0DbWnkg4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QppSeGRken+ipHl/535ioL644GZPqsTErX2dgOnOdE7o/qrCx4VyLYd0GSbHDBxIo
         F/bp9fvE/8wO4Iz2EWx2OXTsR40617Op3vv4N9lfGbFMe81FEesWGo8A13wAvN64sf
         +daHN3Gt42zuGlySnfVdeyEycKinq1DAz0RUUCXg=
Date:   Thu, 14 Apr 2022 12:34:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
Subject: Re: [PATCH 4.19 0/6] cgroup: backports for CVE-2021-4197
Message-ID: <Ylf4pBUE03VVSvu8@kroah.com>
References: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 12:06:54PM +0300, Ovidiu Panait wrote:
> Backport summary
> ----------------
> 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> 	* Cherry pick for 5.4-stable, no modifications.
> 
> 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
> 	* Cherry-pick from 5.4-stable.
> 	* Backport to v4.19: drop changes to cgroup_pressure_*() functions -
> 	  psi monitor feature is not available in 4.19.
> 
> e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
> 	* Cherry-pick from 5.4-stable, no modifications.
> 
> b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
> 613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
> 	* Minor contextual adjustments.
> 
> bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
> 	* Minor contextual adjustments and added wait.h
> 	  and fcntl.h includes to fix compilation.

All now queued up, thanks!

greg k-h
