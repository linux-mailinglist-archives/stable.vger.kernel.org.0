Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9969D66476B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAJR35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjAJR34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C77F58D03
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:29:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21C5DB818DF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53524C433D2;
        Tue, 10 Jan 2023 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673371792;
        bh=+2v7MwVBii5fBJ3/LuS7URFhc7PVnmac8UMOMo7xfxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EG+YNVOCe1mnUIyG500F6ouGpck6adxmXVc7oF/2vdy4n7xZUU9juOJKVJmZc4g9C
         Ec8WuHgSfStkKfHTWau2DKzmRLK239ZGSTpoaLy2BYGnU+FlOHVcQhTLbYZYMgZnUh
         +nN0wn3N5lh971KKe+qNujjTSkIDpU0PVxFx0DuU=
Date:   Tue, 10 Jan 2023 18:29:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Pearson <mpearson@lenovo.com>,
        "Pananchikkal, Renjith" <Renjith.Pananchikkal@amd.com>
Subject: Re: WoWLAN issue under s0i3 w/ some Qualcomm cards
Message-ID: <Y72gjORZrly02ePp@kroah.com>
References: <MN0PR12MB6101476B9F5D767D1BAE8A1DE2FA9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101476B9F5D767D1BAE8A1DE2FA9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 02:58:45PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> The following commit fixes some s2idle wakeup problems with certain firmware on AMD Rembrandt systems with Qualcomm WLAN cards.
> 
> 3f9b09ccf7d5 ("wifi: ath11k: Send PME message during wakeup from D3cold")
> 
> Can you please bring this to 6.1.y?

Now queued up, thanks.

greg k-h
