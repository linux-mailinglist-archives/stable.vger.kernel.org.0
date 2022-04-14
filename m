Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3E500B3F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbiDNKis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242371AbiDNKir (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:38:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769374860
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E1F61EE9
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C5EC385A5;
        Thu, 14 Apr 2022 10:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649932582;
        bh=ZhhGmJaZcQtFuQK1n7HqvL93GazqK2XFR/RMbB7cNug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dFbXnGBnuTBVc79cbfVFTh56i0VX+aAooFLSne5LwUswQWuJ4ZCAoXISz4XHST36W
         PRTno8vjhMUMapEyxQtXiUUOfi9TwW1UpfTII+I9KiZzbzLB1QJwVoLwFTLnk1dUsT
         SEoVsQhTd9+GltBFXcSd8syPKY+ZpCxJ8KQJxpy4=
Date:   Thu, 14 Apr 2022 12:35:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
Subject: Re: [PATCH 4.14 0/3] cgroup: backports for CVE-2021-4197
Message-ID: <Ylf4+BhLeQ86wGKi@kroah.com>
References: <20220414092421.2730403-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414092421.2730403-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 12:24:18PM +0300, Ovidiu Panait wrote:
> Backport summary
> ----------------
> 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> 	* Cherry pick from 4.19-stable, no modifications.
> 
> 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
> 	* Cherry-pick from 4.19-stable, minor contextual adjustement.
> 
> e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
> 	* Cherry-pick from 4.19-stable, no modifications.
> 
> Testing
> -------
> There are no cgroup selftests in 4.14, but when running the ones from 4.19 on
> the 4.14 kernel, all selftests pass:

THanks for these, all now queued up!

greg k-h
