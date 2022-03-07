Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0AA4CF428
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 09:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiCGJA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiCGJA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:00:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31EC60CFB
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 00:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC8A60F78
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 08:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFDC340E9;
        Mon,  7 Mar 2022 08:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646643573;
        bh=x2zMQOz5RNnWAOIIvWYBUfsodo6H20UJkSuV+dN1Ctk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W6Kv+kMVxFewxCGKAIpRz+h5reSJTbo0Gx/+YuYhbQ+QHLWiS5yN/Lvh1M/anm+Az
         ZVZ5rZmNVaBlJjqfLkDjW4WAIiKYP/phhJvpm7AbxT8iVFuxR+//DJY5FnjVEreAhq
         d7TvLL9paWdY25Y6ooWOuvG+dVLzTFeBT8h49XEI=
Date:   Mon, 7 Mar 2022 09:59:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to have commits applied to stable/4.14
Message-ID: <YiXJck0e4456PaD1@kroah.com>
References: <77220306-bc8c-92f8-e5f9-8d8a7120d6e0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77220306-bc8c-92f8-e5f9-8d8a7120d6e0@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 09:36:03AM +0100, Hans Westgaard Ry wrote:
> I would request three commits to be backported to stable/4.14
> c75ab8a55ac1 ("net/rds: remove user triggered WARN_ON in rds_sendmsg")
> 7dba92037baf ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
> bdc2ab5c61a5 ("net/rds: Fix a use after free in rds_message_map_pages")
> 
> 
> The commits fix bug where input-parameters to 'rds_message_alloc_sgs()'
> are just tested with WARN_ON instead of error-return

What about 4.19.y?  Those should also get these, right?

And did you test that these will properly cherry-pick?  I just did and
they fail, so how did you test that these work properly?  Please
resubmit a working set of backported patches to have these be applied.

thanks,

greg k-h
