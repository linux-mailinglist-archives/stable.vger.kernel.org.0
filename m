Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A406BAB38
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCOIyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjCOIyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A186A6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CE661C0D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE90C433D2;
        Wed, 15 Mar 2023 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678870438;
        bh=ur4kAP/wtcC9DWv1573BR9Km7pSEgTQ2vIRp+M0neAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aarYKYHiZAjj6KeY8E4hmOZs6fzNGHUkkeiOxxvJJyvV7H+ANLF2AKOpIWcebvU92
         JslxPdhLOVdwXDKtpUelNl8XEI6BBj1UoIDTX/p/fHUS45hr3SA2kSnNA1o3Du4ZYG
         DeQfubLmLgrIvuDuw1UpgFb+26F+NTVAFZYaZMzM=
Date:   Wed, 15 Mar 2023 09:53:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <ZBGHpGccMmxHnUns@kroah.com>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBF74StdWaGP/KSP@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 09:03:45AM +0100, Greg KH wrote:
> On Wed, Mar 08, 2023 at 04:22:00PM +0000, Qais Yousef wrote:
> > Portion of the fixes were ported in 5.15 but missed some.
> > 
> > This ports the remainder of the fixes.
> > 
> > Based on 5.15.98.
> > 
> > Build tested on x86 with and without uclamp config enabled.
> 
> Now queued up, thanks.

Wait, should we also queue up a2e90611b9f4 ("sched/fair: Remove capacity
inversion detection") to 5.10 and 5.15 now as well?

thanks,

greg k-h
