Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4666B4E638D
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 13:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350276AbiCXMqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 08:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbiCXMqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 08:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8083A5C1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 05:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7804260AD7
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718B6C340ED;
        Thu, 24 Mar 2022 12:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648125868;
        bh=24DmMFHA8QMOXVWiL9Lil/8VZhc/k02G6iIc/s9TMs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wrDF4DD6v3cwCkrpS6hQ2XwmJtWTsI7Hh3T/KNbGyOqr6pVqvsXeQlYBc+EWFN3zc
         fu0MMDkSP+5dyHXsluW8DKpAZh2eHaTkzjws+R6C0bCg0StSG0PHAhzwrY0hQKL+r3
         42SJkRoM6LgWTUzPSuAcayUoQmM2C1bqgszI8t/Y=
Date:   Thu, 24 Mar 2022 13:44:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khazhy Kumykov <khazhy@google.com>
Cc:     stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>
Subject: Re: nfsd patches to fix deadlock
Message-ID: <YjxnqsyOAWRCq+Vp@kroah.com>
References: <CACGdZY+hyR5j=Hwzt_Utd5MgPh6EHotri5atqzrzgi7Nbp+vFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGdZY+hyR5j=Hwzt_Utd5MgPh6EHotri5atqzrzgi7Nbp+vFA@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 01:01:58PM -0700, Khazhy Kumykov wrote:
> Please consider the following 2 patches for stable 5.4. They applied
> cleanly to 5.4.y for me, and fix a deadlock we have experienced. (See
> discussion at https://lore.kernel.org/linux-nfs/a9cf9bcd72a187127b73042a9369e17bd5a0e93d.camel@hammerspace.com
> ). These patches are from 5.5, so newer kernels should not need it. I
> looked at 4.19, and it looks like this issue should not exist in that
> kernel (we don't have filecache.c and it's associated shrinker). I
> have not looked at older kernels, but presume the issue also does not
> apply there.
> 
> 9542e6a643fc ("nfsd: Containerise filecache laundrette")
> 36ebbdb96b69 ("nfsd: cleanup nfsd_file_lru_dispose()")

Now queued up, thanks.

greg k-h
