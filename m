Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD56561956
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiF3Lhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbiF3Lhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:37:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C255A447
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04AF860FC1
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5C6C3411E;
        Thu, 30 Jun 2022 11:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656589053;
        bh=1Ur/UV+GlNRe9zkFBhuri9p2wBQp1wfTfFekZz/qZ/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d3m4Npotkms0nwNaVNTLS9MryaQA0lT0hcHeL16729WMlwX0XqRzuTDt8jL2IiXwQ
         2+RCHy9qqynlmmUHk6BDR9vjWP508Jaa/JTt/pxV7xHBF/pQt/WUxekv8H/q9AefpZ
         PO2uQm2mNfKHkAfGyxUVNaA95g1VsDh7lSKe1BVQ=
Date:   Thu, 30 Jun 2022 13:37:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/12] attr: group fix backport
Message-ID: <Yr2K61JnS88XADK6@kroah.com>
References: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
 <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628121620.188722-1-brauner@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 02:16:08PM +0200, Christian Brauner wrote:
> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> 
> Hey Greg,
> 
> As promised, here is a series that allows to backport the fix which
> failed to build for you. This backports a few patches that are required
> to make this work. I decided to backport them instead of rolling a
> custom fix for this. That would've been smaller but there is future
> hardening work that I would like to backport and this enables this.
> 
> I've run xfstests for ext4, xfs, and btrfs as well as LTP with:
> runltp -f fs_perms_simple,fs_bind,containers,cap_bounds,cve,uevent,filecaps
> and I see no regressions. There is an xfs failure but that is related to
> a - for obvious reasons - missing stable backport.

Thanks for these, all now queued up.

greg k-h
