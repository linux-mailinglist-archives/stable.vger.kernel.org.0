Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B96577AA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiL1OWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiL1OWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:22:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DECE0E6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:22:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9066D614D0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F38C433EF;
        Wed, 28 Dec 2022 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672237326;
        bh=oRqTWNfSKnZKX8FjiX2JFDtL8vzlWKcmjGgmPACTQRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQhmaDlJxfPPEOEhcMxG78tBUdmeG09hum9uRbHy0JlM2Cka9evRbdxt3H0qNvZD4
         K+gHQbEQ2hvJqyeZ+3/49BY7ek7qFu9irljb+IBcibCm1pQ/v1hvkOIyCfVnNeTSvP
         gAuVJ5SWgShFqafbsWmsRJYbvgv0qWa/OuLAlu/c=
Date:   Wed, 28 Dec 2022 15:22:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     stable@vger.kernel.org
Subject: Re: queue-6.1 drop
 perf-stat-display-event-stats-using-aggr-counts.patch please
Message-ID: <Y6xRC6RjHkSHgSQQ@kroah.com>
References: <20221227082544.AC63.409509F4@e16-tech.com>
 <Y6qjQXB626ZnaSjw@kroah.com>
 <20221227172742.10DE.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227172742.10DE.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 05:27:43PM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Tue, Dec 27, 2022 at 08:25:45AM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > drop perf-stat-display-event-stats-using-aggr-counts.patch
> > > from queue-6.1 please.
> > > 
> > > It failed to compile on 6.1.y now.
> > 
> > Why not just also queue up b89761351089 ("perf stat: Update event skip
> > condition for system-wide per-thread mode and merged uncore and hybrid
> > events")?
> 
> We could add 
> ca68b374d040 (perf stat: Add struct perf_stat_aggr to perf_stat_evsel)
> 
> to queue-6.1 before the patch 'perf-stat-display-event-stats-using-aggr-counts.patch'
> 
> to fix the build error.
> util/stat-display.c: In function 'print_counter_aggrdata':
> util/stat-display.c:690:35: error: 'struct perf_stat_evsel' has no member named 'aggr'
>   struct perf_stat_aggr *aggr = &ps->aggr[s];

Ok, that got messy fast, as things didn't apply.

I've dropped the original commit here now, can you send a backported
series to us for inclusion in 6.1 that will work properly?

thanks,

greg k-h
