Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3CD57061D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiGKOs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiGKOs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954C8DF62;
        Mon, 11 Jul 2022 07:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC04B8100B;
        Mon, 11 Jul 2022 14:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D50C34115;
        Mon, 11 Jul 2022 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657550934;
        bh=gxTtK+SYR2AfOa39kLnqaxhyb6TpzCaEzgH5q1lxWT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKJXRjQsdvqKxdu1tJ5JXkkSJKBTl8qR9JrCUBPzfA/0/bD7mzvTw8sSRWXoCim3W
         L9vN7j9EunzT/JSpWx7oC/TPZhWW1WPlYtO0ClUKYLQuTBySwdgUx+GRC4YLXJPpRU
         Ow1tcAXFLnL8MTHjLSTlBfx3+O1ECdOeE0SGduSw=
Date:   Mon, 11 Jul 2022 16:48:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Message-ID: <Ysw4VMoYvMaWNgq0@kroah.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090607.978575207@linuxfoundation.org>
 <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
 <BL1PR12MB514417DBBDC4502936002F8BF7879@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB514417DBBDC4502936002F8BF7879@BL1PR12MB5144.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 02:01:50PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Koenig, Christian <Christian.Koenig@amd.com>
> > Sent: Monday, July 11, 2022 5:30 AM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org; Sasha Levin <sashal@kernel.org>
> > Subject: Re: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI
> > diplay class device
> > 
> > Hi Greg & Alex
> > 
> > why is that patch picked up for stable? Or are we backporting IP based
> > discovery?
> > 
> 
> Looks like Sasha picked it up.  This should not go to stable.

Ok, will go and drop it now, thanks for letting us know.

greg k-h
