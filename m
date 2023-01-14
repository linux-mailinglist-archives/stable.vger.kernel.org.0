Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA1066ABDD
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 15:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjANOIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 09:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjANOIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 09:08:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E867EE3
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:08:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2107460B49
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 14:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACE6C433D2;
        Sat, 14 Jan 2023 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673705312;
        bh=VYQg5ge1aG5lhlcUOt67yT41sRJ3UYFI5+qz/APhFhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yhXXwCkkfxeKmCPtbA0Dwt1KcYBuLzHxL8hkSwjAD2226gcME3AY6DEKz78VvYlW1
         5I0AuY116e9t7hpPj4Zb5nH+mEYu+Xbn4toWNwTPUsf/JHCyeveAvyMoCiaA/ngeeP
         xhrlTdTak7FxfvDJgriJZLucttuIKO9Jvpq4+2Hg=
Date:   Sat, 14 Jan 2023 15:08:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Yury Zhuravlev <stalkerg@gmail.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Asher Song <Asher.Song@amd.com>
Subject: Re: [PATCH] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan
 speed pwm for vega10 properly""
Message-ID: <Y8K3Wv/12g4jyA3y@kroah.com>
References: <20230113190302.2210187-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113190302.2210187-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 02:03:02PM -0500, Alex Deucher wrote:
> This reverts commit 9ccd11718d76b95c69aa773f2abedef560776037.
> 
> The original commit 16fb4dca95daa ("drm/amdgpu: getting fan speed pwm for vega10 properly")
> was reverted in commit 4545ae2ed3f2 ("drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"").
> but the test that resulted in the revert was wrong and was fixed so the
> revert was reverted in commit 30b8e7b8ee3b ("Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""").
> That should have been the end of it, but then Sasha picked up the
> original revert again and it was committed as 9ccd11718d76.  So drop
> that commit so we get back to where we need to be.

Now queued up, sorry for the mess.

greg k-h
