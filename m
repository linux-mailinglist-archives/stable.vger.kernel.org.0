Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E374DC39D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiCQKH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiCQKHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:07:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5790E1DBABC;
        Thu, 17 Mar 2022 03:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0AF5B80E8A;
        Thu, 17 Mar 2022 10:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B811C340E9;
        Thu, 17 Mar 2022 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647511593;
        bh=px6N+3L1W6rCGtC2z+1yqqc5/8aVLrE5nuJqMaroHUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x7y1bu7S72kL5BF5aps/zyC1ZwT99JT/tjM4upmWdwtZFF4Yvr9ZCm9brTkuAlUb0
         tUi/2uLKSNIpVqVN1IQX8dbyooUCZHLHBioyJm8f+vk/v00XTyT+SNWwTRV2BEanor
         phZMBJ9N7kWXS5YHM4xKN1nzzikXzHE4fA8lvEd4=
Date:   Thu, 17 Mar 2022 11:06:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4.19 0/3] sched/topology: Fix missing scheduling
 domain levels
Message-ID: <YjMIJRWklprJMVh4@kroah.com>
References: <20220316164808.569272-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316164808.569272-1-dann.frazier@canonical.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 10:48:05AM -0600, dann frazier wrote:
> This is a 4.19.y version of a patch series I submitted earlier for
> 5.4.y/5.10.y.
> 
> Change from v1:
>  - Fix build failure on ia64 in patch 3/3.
> 

Now queued up, again :)

thanks,

greg k-h
