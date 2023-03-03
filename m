Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287DB6A9B2B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCCPvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCCPvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:51:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A2932506
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 07:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D8D1B818F8
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 15:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E88C433EF;
        Fri,  3 Mar 2023 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677858692;
        bh=/sZAE8iNeb5CsEwAkYY+xvdhfsE29OycC+Be+BydOnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w64UUSLA4kxixEBmIDvMHfQOlwIjBeXJjuhoqXoOVBOG4AJAaBJQjwMJQmtNCA9CK
         OvQPwrI37Fnk77Tl24u9XxwmJOca07YmgoHwtwf9e384A1k+PuAR8xPtiuoTE52E8v
         LuGXXqEvnrOmGf9aCG72jOjjQ6jmGiza6zQqA43s=
Date:   Fri, 3 Mar 2023 16:51:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Baoquan He <bhe@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Juri Lelli <jlelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 3/3] panic, kexec: make __crash_kexec() NMI safe
Message-ID: <ZAIXghGzIN/JXN9a@kroah.com>
References: <20230301162502.120413-1-wenyang.linux@foxmail.com>
 <tencent_23D2059843FC3C9F09AAC6A8678272270109@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_23D2059843FC3C9F09AAC6A8678272270109@qq.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 12:25:02AM +0800, wenyang.linux@foxmail.com wrote:
> From: Valentin Schneider <vschneid@redhat.com>
> 
> commit 811d581194f7412eda97acc03d17fc77824b561f upstream.

No it is not :(

Also, why is this needed for 5.10.y?  PREEMPT_RT is not in 5.10, right?

thanks,

greg k-h
