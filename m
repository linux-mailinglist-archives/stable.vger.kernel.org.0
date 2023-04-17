Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA0B6E4F60
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjDQRjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDQRjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE37140F4;
        Mon, 17 Apr 2023 10:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35AE8623B4;
        Mon, 17 Apr 2023 17:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D56CC433EF;
        Mon, 17 Apr 2023 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681753135;
        bh=VmFo9RF+5gO7x2+6qKIPKlEJzH3jAZPRynaqFPpq+A4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYK70BbFf2XoEX2mwZXmzjzOWbZ6b6vOFV+7V/GPSKTEEJMlqqWDda64jNn95fCOS
         CR4jAkaHmhmFSF9d+WS27r2ylKNZ4E7fr0ULTAkwvnB+TLayf9smEzlBZISH3srWkT
         IQ4ollC4wjbXwEC48y7YSElUBvMS2jNKb8Ufwe0s=
Date:   Mon, 17 Apr 2023 19:38:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?0KDRg9GB0LXQsiDQn9GD0YLQuNC9?= 
        <rockeraliexpress@gmail.com>
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: REGRESSION: ThinkPad W530 dim backlight with recent changes
 introduced in Linux 6.1.24
Message-ID: <2023041711-overcoat-fantastic-c817@gregkh>
References: <CAK4BXn0ngZRmzx1bodAF8nmYj0PWdUXzPGHofRrsyZj8MBpcVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK4BXn0ngZRmzx1bodAF8nmYj0PWdUXzPGHofRrsyZj8MBpcVA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 10:18:32PM +0530, Русев Путин wrote:
> Due to recent commit a5b2781dcab2c77979a4b8adda781d2543580901 , I'm
> facing an issue where the backlight is dimmer than before
> in comparison to the backlight pre-commit on my Thinkpad W530.

Any reason why you didn't cc: the developers of that commit?

> Downgrading to an older kernel version fixes the issue.
> 
> I also realise that this recent commit replaces the intel_backlight
> folder in /sys/class/backlight with acpi_video0.

That's what this commit does, right?

Do you also have this issue on the latest 6.3-rc release?

thanks,
greg k-h
