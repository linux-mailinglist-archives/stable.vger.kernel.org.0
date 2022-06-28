Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D553855DAC3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiF1KWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbiF1KWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB02F3B5
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 03:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5CA1B81DBB
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 10:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E8AC3411D;
        Tue, 28 Jun 2022 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656411769;
        bh=/4gd1fa45fJO1t2xWZKzREgPdCfRnxDUKzal4P9bewM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FT/uAq6WW41QDDDyjB5vTBKNb3iioj/h6ciB1MN63GMAinVCKYOCXAYEc3KdNEbwN
         /tobJ/CJ0ESopDsRaGjn6gtlyN46z4W1uU0b24lcinVdj6Y1Av/m2u9l1mkvMMQ7Wp
         lvwS7N7R28ZvqvDcMNEfdyZIdw6CSbnAY/RLVf0L+J7m6WA1K94RZ5eQHzTEyiiP0j
         FcB2i0/fplKwEhTEaFVLZ3tYAtmk1JJwfP4o7SzkUea7dii7VlxF29vCdAxg5HSuhu
         UKqcvgNdcxzm7LKJ23iIsOzN8QWtd+e75+Ce5hqxYofFPM0/CLreG1isFwXAwIeXQ0
         UXBcpv+8d+Kqg==
Date:   Tue, 28 Jun 2022 12:22:44 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     cyphar@cyphar.com, hch@lst.de, sforshee@digitalocean.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] fs: account for group membership" failed
 to apply to 5.15-stable tree
Message-ID: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <165571901496212@kroah.com>
 <20220627172408.h5zfvcksmd5ftnst@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627172408.h5zfvcksmd5ftnst@wittgenstein>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 07:24:18PM +0200, Christian Brauner wrote:
> On Mon, Jun 20, 2022 at 11:56:54AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hm, I just tried on top of v5.15.50:
> 
> git cherry-pick -S 168f912893407a5acb798a4a5
> 
> and it applied cleanly. Can you try and backport this again, please?
> Or tell me how to reproduce the failure you're seeing so I can fix it
> and give you an applicable version?

It's a build problem. I'll give you a series that makes this patch
apply. I'll backport a few more patches if you don't mind.

Thanks!
Christian
