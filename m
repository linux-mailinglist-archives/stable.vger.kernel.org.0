Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36E680AB0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjA3KVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjA3KVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:21:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7B6B44B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 02:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB182B80EC6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 10:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C773C433EF;
        Mon, 30 Jan 2023 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675074103;
        bh=J+SNC5+3fpXdxSso3fd/qUGZzOXOisaXrUdFAGvST7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UV1MmBbyP94EXzy9H/81r7YW5JlnBbgN08cFof0HT+lnlUh3qbM7Q4fo/1QSQMVsP
         sfgQ+DN8Ro8eFzokWgZlVbmRvVV0hwVF8CxS7vs/G2SzK/KJocJjGUKA02wb6ixj3L
         s1HqR3RgkevvhCQGaRHwvSQljkV7JPN6jeSZaV8Y=
Date:   Mon, 30 Jan 2023 11:21:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15 v2 1/2] cpufreq: Move to_gov_attr_set() to cpufreq.h
Message-ID: <Y9eaNAQZ5q23mn+W@kroah.com>
References: <20230122144055.3275512-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122144055.3275512-1-haokexin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 10:40:54PM +0800, Kevin Hao wrote:
> commit ae26508651272695a3ab353f75ab9a8daf3da324 stream.
> 
> So it can be reused by other codes.
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> v2: This prerequisite commit was missed in the v1.

Both now queued up, thanks.

greg k-h
