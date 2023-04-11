Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D576DDCD7
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDKNzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDKNzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:55:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F3910FE
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C79C1626E8
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF4CC433D2;
        Tue, 11 Apr 2023 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681221306;
        bh=V+1Ugp9rgEkKm/Yy9OeMJ4Bdfto/jY5I/yshRt7Od7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bdqi3zjZP9CL5lYHapSrmpDeTfZLi3x+UdOssnj5N5lwiw4ZcYkBEWfdi9CsHjC24
         +Y0WCwbpb7ahKvMc8YA8n4gJTsb9iFYPrHhvNDTjRuw9bRmTLM76E3G/4HJ/H1EFLc
         01nrkQc8chnjKJlN3NXx8c3CCcWMckCIW8Ctr/EM=
Date:   Tue, 11 Apr 2023 15:55:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: MST Unplugged during suspend
Message-ID: <2023041155-schilling-employee-8339@gregkh>
References: <MN0PR12MB6101092DDDD6B1BEF8AF271DE2909@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101092DDDD6B1BEF8AF271DE2909@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 10:13:54PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> There is a bug present in 6.2.y and 6.1.y where if a dock that supports MST is unplugged during suspend it's not possible to get MST working after resume.  This is because the cleanup/error path doesn't actually clear the MST tree.
> 
> It's fixed in 6.3 with:
> 
> 3f6752b4de41 ("drm/amd/display: Clear MST topology if it fails to resume")
> 
> Can this please be backported to 6.2.y and 6.1.y?

Now queued up, thanks.

greg k-h
