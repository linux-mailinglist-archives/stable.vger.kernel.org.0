Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910416671B2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjALMJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjALMIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:08:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3578512ACA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:03:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3D8DB81DD5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306C7C433EF;
        Thu, 12 Jan 2023 12:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673525014;
        bh=YCYQyWhqi6w/WhD+5lXT1Wk65cORS99TwD4ueJ9/7tE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kyj+UjW1J55IU3qfi3bAyyvM/xVMWfnBh8WZ6yc+SlkRftL75ATJp6Yg9p1myz1ON
         tZumMAzlp2E4YbQHnqG1qjzffAUG2ei+hvOJHTOTnBlZMI9DxEqBJ0GWWUt5QvlTQ/
         xusS3nSDSjQAgzo/wQUi5i7PxSnJA6KGsKoQ9+MY=
Date:   Thu, 12 Jan 2023 13:03:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH] parisc stable patch
Message-ID: <Y7/3CxYR89QoCjsC@kroah.com>
References: <Y723f4h9g03wn7pU@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y723f4h9g03wn7pU@p100>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 08:07:43PM +0100, Helge Deller wrote:
> Hi Greg,
> can you please consider adding this patch to the 6.1-stable series?
> Upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a010

Now queued up.

greg k-h
