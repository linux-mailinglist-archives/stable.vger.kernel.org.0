Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB85A00E1
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 19:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiHXR6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 13:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbiHXR63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 13:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2D4D83C;
        Wed, 24 Aug 2022 10:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6433D6171C;
        Wed, 24 Aug 2022 17:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D78CC433D6;
        Wed, 24 Aug 2022 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661363903;
        bh=SF9MpmKrkhm4N4zj5pYtfBiBQo+XAO7tLY54KFyZaZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knXzyhff/X1fMETmOqnyx+uSvMoClzsz0FJyci3gSw+AAZE/IbE5pUdIJj5pvOevU
         5MzbH9fnqM9+aadyO6VKxsORR4ulb9CdysEhOYOGUU3dG2Yxwxi30pdS33VyHLK34q
         fPYs30AmZcsRNGeQ6Tw0imewmt3Qw6AUiRJRBhRE=
Date:   Wed, 24 Aug 2022 19:58:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: "Fixes:" vs. "Cc: stable ..."
Message-ID: <YwZmu1ZTbjVqIY/C@kroah.com>
References: <CAH2r5muO1OkOV0jjJo89Zpvj43u_X95smuujg66-emQFgSXfgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muO1OkOV0jjJo89Zpvj43u_X95smuujg66-emQFgSXfgQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 12:14:12PM -0500, Steve French wrote:
> Do changesets that already included the "Fixes:" tag in the commit
> description also need to include the "Cc: stable@vger.kernel.org" in
> order to be included in stable?

As per the documentation:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

You should be putting cc: stable@... on the patch.

But as not all maintainers do, we have to dig through those with Fixes:
in order to actually catch all bugfixes :(

So please, use cc: stable.

thanks,

greg k-h
