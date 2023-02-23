Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4F16A0510
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjBWJil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbjBWJiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:38:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70617149BD
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:37:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2650BB8198A
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95159C433EF;
        Thu, 23 Feb 2023 09:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145074;
        bh=x42G3E1ITzkNyu7AKRSHSgXljVu2FD6X6E8VeahfkBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0len5J+Ky7C4gYnT3BYZxgBL1S9kCHDwCxBoAgTGLVleiH1OLe5CDTl3lN2geB8AP
         aobpUdBNag1Awo5WI73R0oTvqbRcFNBPfWVestXoX/EXU4yjPck1ZWcA63AnzdRy1K
         E3dxnFMxqdWKmpC3CJCZf1NtxlmjU9d5kotytRwA=
Date:   Thu, 23 Feb 2023 10:37:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Martinez, Juan" <Juan.Martinez@amd.com>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Missing IDs for WCN6855
Message-ID: <Y/cz8PXSHwgD6Zwt@kroah.com>
References: <MN0PR12MB61013F4BA09A9838F86174D0E2A49@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61013F4BA09A9838F86174D0E2A49@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 07:50:41PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> We had noticed some WCN6855 hardware we have BT wasn't working in the LTS kernel.  The IDs for the variants we have were introduced in 6.2.
> 
> Can you please add this to 6.1.y?
> 
> ca2a99447e17 ("Bluetooth: btusb: Add more device IDs for WCN6855")

Now queued up, thanks.


greg k-h
