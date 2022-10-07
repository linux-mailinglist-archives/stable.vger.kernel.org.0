Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC8A5F7452
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 08:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJGGqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 02:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJGGqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 02:46:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6113C4581;
        Thu,  6 Oct 2022 23:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB82B82208;
        Fri,  7 Oct 2022 06:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C42C433D7;
        Fri,  7 Oct 2022 06:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665125193;
        bh=2R565puu3jSvZEU5YxKdHU+f3N7E1A0C+trOmuYcd7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2oxYsOZEtN6bZBXUIasaOa0HMbiNmYZa+Pug9zlHBg+9TECHFW0p+K3YVM/Masn72
         9Fbr6g2AguG+4tt3QmywYrtVhyh6iS8OuTR2HpUUijIPZHB+vMpsT1sDOYqfM8c3vs
         l1T3cvovLvA4FwvAZAKC5AODuy0rnLQEleo8ftFs=
Date:   Fri, 7 Oct 2022 08:47:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-kernel@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH RESEND stable 5.4] perf tools: Fixup
 get_current_dir_name() compilation
Message-ID: <Yz/LcYbEwz4smq1H@kroah.com>
References: <20221005204028.4066674-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005204028.4066674-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 01:40:28PM -0700, Florian Fainelli wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> commit 128dbd78bd673f9edbc4413072b23efb6657feb0 upstream
> 
> strdup() prototype doesn't live in stdlib.h .
> 
> Add limits.h for PATH_MAX definition as well.
> 
> This fixes the build on Android.
> 
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Link: http://lore.kernel.org/lkml/YRukaQbrgDWhiwGr@localhost.localdomain
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> This patch is necessary to build perf with a musl-libc toolchain, not
> just Android's bionic.
> 
> Resending because missed stable the first time

Both backports now queued up, thanks.

greg k-h
