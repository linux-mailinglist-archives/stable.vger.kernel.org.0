Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB21608A8F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiJVJAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiJVI7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C00295B14
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 01:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40F3060AE9
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 08:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473AEC433D7;
        Sat, 22 Oct 2022 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426529;
        bh=tvhlpNVqugcH5x2RysaIKkN9m6aKWhtFN7epyyHegjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsFzLglwE87L4ZW7+UvayHPLVq+ya0MQOVrSxKkJ6OEiSW3mRG7y/40lOK9p67MTN
         IhiuIr8VgkDvxvazGCCgfTNClfLGcs9JyR5dh9ZWEqAvSk88q0zQgU54Sa/4PN35pg
         mNp1vWzLaNtuXs5I7oIwNlOsYLNYbnBwwXuXfkhc=
Date:   Sat, 22 Oct 2022 09:40:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix pinctrl-amd warnings introduced in 6.0
Message-ID: <Y1OeYechnSwD1dtx@kroah.com>
References: <0dc9d84a-6afb-4d5a-f2a5-3d44646ea5c2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc9d84a-6afb-4d5a-f2a5-3d44646ea5c2@amd.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 07:49:51AM -0500, Mario Limonciello wrote:
> Hi,
> 
> 79bb5c7fe84b3 ("pinctrl: amd: Add amd_get_iomux_res function") introduced a
> new possible warning for pinmux resources.  On some systems that didn't
> support the feature this warning popped up and users have reported it (IE
> https://bugzilla.kernel.org/show_bug.cgi?id=216594).
> 
> The warning is downgraded to debug to not alarm users in 6.1-rc1 with this
> commit:
> 
> 3160b37e5cb69 ("pinctrl: amd: change dev_warn to dev_dbg for additional
> feature support")
> 
> Can we take that back to 6.0 too?

Now queued up, thanks.

greg k-h
