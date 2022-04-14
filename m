Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEEA500E67
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiDNNPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243717AbiDNNPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:15:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF52A8BF65
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A1C9B82929
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 13:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB40C385A1;
        Thu, 14 Apr 2022 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649941973;
        bh=5l92DEsOguBCpoA43vRq17Z/TEMDNH8g3jV/G/0p2/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oglzUIU3Yh7sOk5YaVInxzPrEPXi9vf7goFf5j2YX4OSqQHHQf3TBZLKSGSowtlQC
         UK7E5HWp8wRTA7+PRz3MV0zC3+UNvkeKvgui+rMe951WF7UpItiYikNc9YdqS725Ag
         oFwlltQbRtEVZn1djN7BdsVqorda2QWtJLeko0Ow=
Date:   Thu, 14 Apr 2022 15:12:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Allow playing dead in C3 for 5.15.y
Message-ID: <Ylgd0ntrAM/y4eLk@kroah.com>
References: <BL1PR12MB5157E3D352FB769DB61E2D0DE2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <Ylf+DcjOorOMYnkN@kroah.com>
 <BL1PR12MB5157EDD7F142FB7F214E179CE2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5157EDD7F142FB7F214E179CE2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 12:59:09PM +0000, Limonciello, Mario wrote:
> [AMD Official Use Only]
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Thursday, April 14, 2022 05:57
> > To: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Cc: stable@vger.kernel.org; Gong, Richard <Richard.Gong@amd.com>
> > Subject: Re: Allow playing dead in C3 for 5.15.y
> > 
> > On Tue, Apr 12, 2022 at 10:15:37PM +0000, Limonciello, Mario wrote:
> > > [Public]
> > >
> > > Hi,
> > >
> > > A change went into 5.17 to allow CPUs to play dead in the C3 state which
> > fixed freezes on s2idle entry if a CPU is offlined by a user.
> > > This has had some time to bake now, and a regression was identified on an
> > ancient machine that is now fixed.
> > >
> > > Can you please backport these commits to 5.15.y to fix that problem and
> > avoid the regression?
> > > commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1 ("ACPI: processor
> > idle: Allow playing dead in C3 state")
> > 
> > Now queued up.
> > 
> > > commit 0f00b1b00a44bf3b5e905dabfde2d51c490678ad ("ACPI: processor:
> > idle: fix lockup regression on 32-bit ThinkPad T40").
> 
> My apologies; I must have had two references in my tree.  The correct hash is 
> bfe55a1f7fd6bfede16078bf04c6250fbca11588

That worked, thanks.
