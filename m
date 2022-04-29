Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13425144F3
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356195AbiD2JBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347883AbiD2JBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 05:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBE8C12FE;
        Fri, 29 Apr 2022 01:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 171ED621E9;
        Fri, 29 Apr 2022 08:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078EAC385AD;
        Fri, 29 Apr 2022 08:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651222712;
        bh=mK0/oqxyOfTusxSAel3Y9dGNGJyYCZbD4rWGlYY9E3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMjC13RWT70mSDfOpBp292Z/ZRmSCasAsrAnVAs1Ffo8yVMO4uMFlsW98AcC5h5E6
         kcolv9OBnBGGIrkn232IUe+qQyDH1Ei9qxxz9M3gMJ0jPSs+SaQd/c/PAwnm+eI+/9
         nqA6i1Wl43rjv5M5U1KXwk9C/UANU7bjxU6p3HrA=
Date:   Fri, 29 Apr 2022 10:58:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19.y 0/3] ia64: kprobes: Fix build error on ia64
Message-ID: <YmuotYMpzs1tJ13g@kroah.com>
References: <202204130102.JZPa6KCQ-lkp@intel.com>
 <165098315444.1366179.5950180330185498273.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165098315444.1366179.5950180330185498273.stgit@devnote2>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 11:25:54PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Kernel test bot reported that the ia64 build error on stable 4.19.y because
> of the commit d3380de483d5 ("ia64: kprobes: Use generic kretprobe trampoline
> handler").
> I also found that this commit was involved by the backporting of commit
> f5f96e3643dc ("ia64: kprobes: Fix to pass correct trampoline address to the
> handler"), and this 2nd commit was backported wrong way. Actually, this 2nd
> commit aimed to use dereference_function_descriptor() in kprobes@ia64, but
> the comment (and Fixes tag) points the 1st commit. Thus I guess this mistake
> happened.
> 
> So I re-backport the upstream commit a7fe2378454c ("ia64: kprobes: Fix to
> pass correct trampoline address to the handler") correctly, without involving
> the 1st commit.
> 
> Thank you,

All now queued up, thanks.

greg k-h
