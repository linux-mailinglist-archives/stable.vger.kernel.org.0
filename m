Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E4B667C6E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 18:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjALRUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 12:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbjALRUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 12:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB1460CFD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B54B81E9B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B8C433D2;
        Thu, 12 Jan 2023 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673542147;
        bh=VQBygNuP8yrIEuw0qYWh/djMhCafZON+WlX6T9VzRik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJ2uK8ydeG+r7kGt3EX8LMB0MXD+CCkIr5sg71RfxpDSNcQgbn9ypA23TA9xOarvL
         tPk7a4w9h9nYlnM3w7FoHZR9Qx/hVjrXaDv2jvUh8QSIqCtUMnTZNtVl5nZ3hgp58H
         kIEIaYGpY9ru6uyZoiL/Ktp5/iBwZqx4U7osI2z0=
Date:   Thu, 12 Jan 2023 17:49:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luben Tuikov <luben.tuikov@amd.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alex Deucher <Alexander.Deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        AMD Graphics <amd-gfx@lists.freedesktop.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 108/148] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Message-ID: <Y8A6AC9DrYfO1c4+@kroah.com>
References: <20230110180017.145591678@linuxfoundation.org>
 <20230110180020.610387724@linuxfoundation.org>
 <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 11:25:08AM -0500, Luben Tuikov wrote:
> Hi Greg,
> 
> The patch in the link is a Fixes patch of the quoted patch, and should also go in:
> 
> https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/

Is that in Linus's tree already?  if so, what is the git commit id?

thanks,

greg k-h
