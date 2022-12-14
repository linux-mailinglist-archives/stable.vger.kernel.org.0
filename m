Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60CF64CD98
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 17:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbiLNQAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 11:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238923AbiLNQAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 11:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6882A271
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 07:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48AE261AA2
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 15:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4673EC433EF;
        Wed, 14 Dec 2022 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671033526;
        bh=FSzI9ZvvfxPQmWRbohbWucMskgML+DqMUAysRYLSk7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uw9RxbEzWdMh3j6cgTnQfocwOw+njg4bQHxsv4gt8z6njmDBYdHWLUpnxhkQSHMn1
         RrU1tPyWBqyYrgr3wF1ih60dUIhy9+ODd36N9S2RRxqNhs4aexJl2/u0fudeJZw6P+
         VwxfU7BYJSVa6yBDDvK3Pb6hl+L3CrYV+3iL4cg0=
Date:   Wed, 14 Dec 2022 16:58:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Namjae Jeon <linkinjeon@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 044/124] vfs: fix copy_file_range() averts filesystem
 freeze protection
Message-ID: <Y5nys0X8X9havZ4G@kroah.com>
References: <20221205190808.422385173@linuxfoundation.org>
 <20221205190809.690922836@linuxfoundation.org>
 <CAOQ4uxhmZ4RnG0mGaMivyQjS43cUykyO-oVtCLX4AFyrnTXrVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhmZ4RnG0mGaMivyQjS43cUykyO-oVtCLX4AFyrnTXrVA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 10:03:02AM +0200, Amir Goldstein wrote:
> On Mon, Dec 5, 2022 at 9:24 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Amir Goldstein <amir73il@gmail.com>
> >
> > [ Upstream commit 10bc8e4af65946b727728d7479c028742321b60a ]
> >
> > Commit 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs
> > copies") removed fallback to generic_copy_file_range() for cross-fs
> > cases inside vfs_copy_file_range().
> 
> Hi Greg,
> 
> The regressing commit is in v5.15.53.
> Please apply this fix to 5.15.y.

This commit does not apply to 5.15.y as-is (breaks the build), can you
provide a working backport?

thanks,

greg k-h
