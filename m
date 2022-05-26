Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41296534E8F
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiEZLsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 07:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347276AbiEZLsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 07:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781C056755
        for <stable@vger.kernel.org>; Thu, 26 May 2022 04:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 189FEB81D2D
        for <stable@vger.kernel.org>; Thu, 26 May 2022 11:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526A3C385A9;
        Thu, 26 May 2022 11:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653565609;
        bh=oUl/uI1opB2xwlnP4oBPqq50nczn685O/UQhmES9OsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Mv7sVyIRo+XPh7tXQimqze3ADO4slqONQf1Q5NpJ7+jO99bqvlqdle/gTDG/iCEb
         gX/4dkbcm4TEyF1IJASidQfAdXr4rFY4j3gT9esc037paP2ABmRHBAWLoe3fldlH/G
         XrsMgCS22cKBc2x+VX3w0PupxV9L+wQGTVhMVbY8=
Date:   Thu, 26 May 2022 13:46:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: AMD SFH sensor discovery
Message-ID: <Yo9op+9hgd+JfqDG@kroah.com>
References: <MN0PR12MB6101243B86EAF100FE859714E2D69@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101243B86EAF100FE859714E2D69@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 07:23:59PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> The firmware on some OEM laptops with AMD SOCs advertise that they have sensors connected to AMD SFH but they really don't
> physically have them. In 5.19 a commit has gone in that discovers this case and prevents the driver from advertising this sensor
> to userspace.  This might not seem like a big deal to have sensors advertised that aren't really there, but AMD has observed
> that specifically on orientation sensors the random garbage data associated can cause userspace to interpret a screen rotation
> during resume from suspend.  
> 
> As GNOME has a daemon running that interprets these events I've seen first hand that it can cause the display go upside down
> without a lot of recourse other than command line tools or rebooting.
> 
> Can you please backport this commit to 5.15.y+ and later to fix this:
> commit b5d7f43e97dabfa04a4be5ff027ce7da119332be ("HID: amd_sfh: Add support for sensor discovery")

How queued up, thanks.

greg k-h
