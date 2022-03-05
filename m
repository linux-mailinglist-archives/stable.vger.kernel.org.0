Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEA94CE47B
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 12:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiCELUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 06:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCELUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 06:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E278D1B79D
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 03:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B1FB80B95
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F6DC004E1;
        Sat,  5 Mar 2022 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646479161;
        bh=5rO2EVT8n4Xx4GkQrBvZ0WE03sKrVXzFn+4DsehWPuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUai63Yzb/FJ1EAxtlhypsSOwbCBBP/lntLH3i2ij+kOWJdDkifBpIK84dfaXqh05
         aNUg636Ks3gFSCBSFwAwh17iD0FsM7z7LwK6viuuy+ZlKNHaNsMEjur7vkAY9wS6Zj
         NqmkJE7CnWyigkhTi+Km1XYUUrrkvoRY7SQ/Ftik=
Date:   Sat, 5 Mar 2022 12:19:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] drm/amd/display: Reduce dmesg error to a debug print
Message-ID: <YiNHNpDK9kkaI34K@kroah.com>
References: <20220301060414.1543486-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301060414.1543486-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 12:04:13AM -0600, Mario Limonciello wrote:
> From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>
> 
> [Why & How]
> Dmesg errors are found on dcn3.1 during reset test, but it's not
> a really failure. So reduce it to a debug print.
> 
> Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 1d925758ba1a5d2716a847903e2fd04efcbd9862)
> ---
> Add explicit definition for macro not present in 5.15.y currently
> 
> Backport to 5.15.y only, different backport for newer kernel.

You forgot your signed-off-by :(

Anyway, both now queued up.

greg k-h
