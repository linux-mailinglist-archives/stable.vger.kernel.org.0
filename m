Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05EB6A453B
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjB0Oxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB0Oxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:53:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BD940C8;
        Mon, 27 Feb 2023 06:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B78B80CA7;
        Mon, 27 Feb 2023 14:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE29C433EF;
        Mon, 27 Feb 2023 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677509609;
        bh=HUh/TOcWldEf0kpiteJc+751xV2EMLrl6kAWU8003eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BjzK7Wm1fQl1MjvbvO45lOlkbyfIVxxuwHVSLG836pmGrcXMuF4dcDjV1m5nXEPxV
         nGdWtn/rVZ2xNut3iLalRtUYjSlV5BZOW7QoNGG+Xhx6/06ZxDSfUqdFj0W1v9LW3a
         PBHlwIGxKKH1MZTV/+Ud1iNvTpRGXH2HEw0CM/Ng=
Date:   Mon, 27 Feb 2023 15:53:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     stable@vger.kernel.org,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please backport commit a449dfbfc089 (PM: sleep: Avoid using
 pr_cont() in the tasks freezing code)
Message-ID: <Y/zD5q5a0QcfgWs+@kroah.com>
References: <f6b073ce-6d78-f00f-9f6d-499df4bb6255@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6b073ce-6d78-f00f-9f6d-499df4bb6255@molgen.mpg.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 01:44:17PM +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> It’d be great if you could apply the commit below [1], present in Linux
> since 6.2-rc1, to at least the Linux 6.1 LTS series.

Sure, now queued up, thanks.

greg k-h
