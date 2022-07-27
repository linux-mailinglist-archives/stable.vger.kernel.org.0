Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1565821E8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiG0IRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiG0IRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A19D45054
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 01:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70EC061648
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 08:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E36C433D6;
        Wed, 27 Jul 2022 08:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658909847;
        bh=QPCs3QGTu/hJvJnWW/7RDslduZlyH73nXUsTBaMfjWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fIPAdPxTQzSIgLtyy/HdaTtGLvog3J71L/rNw8xVeQpfAiVo4TImDYnTTL11L8/gs
         Rl6z3aZW7XeKYFv9GPiM1BaKrgROKkn2Hc+GS/LMbi4sb7enhBbFt1X6R9jEIyOPHQ
         zeXLV/p0Wa8pKx+8n/mO4bRPQgEKT6Q2INRpliCA=
Date:   Wed, 27 Jul 2022 10:17:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: s0i3 fixes on Yellow Carp
Message-ID: <YuD0jRR9O4QoG/i5@kroah.com>
References: <MN0PR12MB61011ED7E1F26E842EEDC44AE2959@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61011ED7E1F26E842EEDC44AE2959@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 06:18:02PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Can you please backport the following fixes to 5.15.y?
> 
> 791255ca9fbe3 ("drm/amd/display: Reset DMCUB before HW init")
> 34316c1e561db ("drm/amd/display: Optimize bandwidth on following fast update")
> 62e5a7e2333a9 ("drm/amd/display: Fix surface optimization regression on Carrizo")
> 
> These help with some s0i3 cases on Yellow Carp (Rembrandt).

Now queued up, thanks.

greg k-h
