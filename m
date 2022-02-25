Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82F4C44A8
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbiBYMeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiBYMeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:34:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECA51F634B
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3BD2B82F52
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 12:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8A8C340E7;
        Fri, 25 Feb 2022 12:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645792425;
        bh=EVEtbPxAui7VXoT1a/xcd1jvFp/KHuwDg3a/lwjjR58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ff+E8DjnipbnWoNVASGud7Wrai8PUwsHfffrSqqE/qHfqTCqu9XbsruGN4l41c37d
         kVfZfIdhjpSX0eOKOkXyQpnM99B+/9AJHRHknYLs3Hbs/h4tPb6AbST3ftT82iq24G
         HTVDS77qmrDKBYwvlS9O4H9WH1u9toRbtk9ilogc=
Date:   Fri, 25 Feb 2022 13:33:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Messaging verbosity backport
Message-ID: <YhjMpqwE6BDjzNj7@kroah.com>
References: <BL1PR12MB51572C542F61E7C087C729D5E23C9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <YhjK4RMbHjFc6xal@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhjK4RMbHjFc6xal@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 01:26:09PM +0100, Greg KH wrote:
> On Wed, Feb 23, 2022 at 11:06:47PM +0000, Limonciello, Mario wrote:
> > [Public]
> > 
> > Hi,
> > 
> > By default some laptops show this on every boot.  It's not useful and was degraded to debug in a future kernel.
> > 
> > [drm:dp_retrieve_lttpr_cap [amdgpu]] *ERROR* dp_retrieve_lttpr_cap: Read LTTPR caps data failed.
> > 
> > Please backport
> > 
> > commit 1d925758ba1a5d2716a847903e2fd04efcbd9862 ("drm/amd/display: Reduce dmesg error to a debug print") to decrease verbosity.
> 
> Now queued up, thanks.

No, not at all, it breaks the build.  Did you try this yourself?

dropped.

greg k-h
