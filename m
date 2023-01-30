Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C31680A5C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbjA3KFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbjA3KEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:04:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F4305CB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 02:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2956CCE1294
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 10:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB915C433D2;
        Mon, 30 Jan 2023 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675073075;
        bh=FuVyjCgyz81oD+463b9FX+YBzoYetJ7I1IORv2eAJDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wXqWjX/SNXhvI8xAUboKkAh/lVrs7h6e36DB2bvCGCOuiOTx1MetwR5Kaf4sMRDtc
         jeQ0LvPy+JDymQDwrxsAaq71hbn7GXBEPM4xe+uJOR/d1JAkbr14YhGlA+ZDOTLyV+
         sc0cG1aKNurE/wgUG2jpT+cfHyOky+wAPjshxx+c=
Date:   Mon, 30 Jan 2023 11:04:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dylany@meta.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: always prep_async for drain
 requests" failed to apply to 6.1-stable tree
Message-ID: <Y9eWMNS9jxBPPZ5v@kroah.com>
References: <1674998787177121@kroah.com>
 <1aa4166f-c66b-5eea-e695-66f206482321@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1aa4166f-c66b-5eea-e695-66f206482321@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 12:40:11PM -0700, Jens Axboe wrote:
> On 1/29/23 6:26 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This should do it.

Looks like Sasha beat me to it :)

thanks for the backport!

greg k-h
