Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704756E5ECB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDRKbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjDRKbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8094218
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 03:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A4DE62FCB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 10:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DF9C433EF;
        Tue, 18 Apr 2023 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681813860;
        bh=kU26V+itNkikXoSqPzgE8iQwsoaAttbdcC4lNPyTTNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojiyTROz22Je4lXkLEGJt/h2MczwxIK4LMap8aDw/KSRvjJr4ID4yUADbzkr1JEXJ
         uaXP2NqolgCnR04HS2EPpKBXSWNcRDa0YKcRmH2LpiWLedxUd0Qa1jj52gpFjq3rvK
         T4HevhYIaBctDEcG3N86+BFKYtl4LTZC3f35+flw=
Date:   Tue, 18 Apr 2023 12:30:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH RESEND 7/7] sched/fair: Fixes for capacity inversion
 detection
Message-ID: <2023041842-treachery-esophagus-7727@gregkh>
References: <20230318193302.3194615-1-qyousef@layalina.io>
 <20230318193302.3194615-8-qyousef@layalina.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318193302.3194615-8-qyousef@layalina.io>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 18, 2023 at 07:33:02PM +0000, Qais Yousef wrote:
> commit da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.

As this is in 6.2, what about 6.1.y for this series?  We can't have
people upgrading to a new kernel tree and have regressions, right?

So can you please also make up a 6.1.y series of patches and then resend
all of these (5.10.y, 5.15.y, and 6.1.y), and then we can properly queue
them all up at the same time.

thanks,

greg k-h
