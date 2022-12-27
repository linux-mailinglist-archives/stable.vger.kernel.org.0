Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638D76567EF
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 08:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiL0HsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 02:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiL0HsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 02:48:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A9E1A
        for <stable@vger.kernel.org>; Mon, 26 Dec 2022 23:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C407E60FA2
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD06CC433D2;
        Tue, 27 Dec 2022 07:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672127300;
        bh=TZrpbTLaQHdP8MDzzljjfHdoOV7+NRmpH/AF21u5ep4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8vMWompKS5oLTYY1etJ/J5+G2BUMVXrPDt93tZscZV9jF+TdMErWouBWi2xoYbSz
         tCAqXy1iOxqqWiH6egSB4esORSNpHrlesJSnsdVitXisegw0AbZM+/n+XrTKcvGNlI
         kdlOZXHfUmeCsUhqoScoFaO3yfLl/fLh5uBKa7Yc=
Date:   Tue, 27 Dec 2022 08:48:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     stable@vger.kernel.org
Subject: Re: queue-6.1 drop
 perf-stat-display-event-stats-using-aggr-counts.patch please
Message-ID: <Y6qjQXB626ZnaSjw@kroah.com>
References: <20221227082544.AC63.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227082544.AC63.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 08:25:45AM +0800, Wang Yugui wrote:
> Hi,
> 
> drop perf-stat-display-event-stats-using-aggr-counts.patch
> from queue-6.1 please.
> 
> It failed to compile on 6.1.y now.

Why not just also queue up b89761351089 ("perf stat: Update event skip
condition for system-wide per-thread mode and merged uncore and hybrid
events")?

thanks,

greg k-h
