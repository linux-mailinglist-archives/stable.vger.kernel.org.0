Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ACC6E2F60
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDOGsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 02:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOGsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 02:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A2E2719
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 23:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DE3061047
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 06:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962DFC433EF;
        Sat, 15 Apr 2023 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681541318;
        bh=mD3Nt+uB7GlweAaBeCbl7cT0pZu3PM6W7Fnsdi2Ob/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z/qRdgtK2lKs1/wSX26C5azxPQtyOmrmmHyG2JnCka34KRXYa9r1I7GjSKzAk33Ym
         s3SFg5pbv6IGkQIx3F59pZZziCnaKMymKQ6eLt7jZOOhvxAgF4G2i4bCYge48HNFjl
         omCzJmPG0dn2IDpXpGi1dcqT+CYRsbRoYH2ksscA=
Date:   Sat, 15 Apr 2023 08:48:36 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Fix regression from 6.1.23 / 6.2.10
Message-ID: <2023041529-speak-blizzard-21d5@gregkh>
References: <MN0PR12MB6101320AE0809F672AAFD25EE2999@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101320AE0809F672AAFD25EE2999@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 08:39:40PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> A regression was introduced in kernel 6.1.y and 6.2.y from 
> 
> 5.15.y: 6c1bc7b50e02 ("pinctrl: amd: Disable and mask interrupts on resume")
> 6.1.y: d9c63daa576b ("pinctrl: amd: Disable and mask interrupts on resume")
> 6.2.7: 7ecbc2275a13 ("pinctrl: amd: Disable and mask interrupts on resume")
> 
> The commit that caused it has been reverted upstream as:
> 
> 534e465845eb ("Revert "pinctrl: amd: Disable and mask interrupts on resume"")
> 
> Can you please revert in the 3 stable trees that picked it up as well?

Now queued up, thanks.

greg k-h
