Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED44E63A7
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 13:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347548AbiCXMwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 08:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350331AbiCXMwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 08:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD00A9977
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 05:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4BAB60DF5
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8365C340EC;
        Thu, 24 Mar 2022 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648126282;
        bh=Z6/VsL8Hry/rUzNNxRliFB7esiBbVf40HuHqH3GHTtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzsfk0ozaJnmF5falMvI+WGH4o10jUJoh7PCBpIc/5w6IjTQJTKxc7FB8efoPtpPw
         TJ2px5YcmLshesCBBwFjftwgyvFTJn4hyvMkkRVFe+o+HkceobALvbLIT/lT3my41K
         PrzkTveRFzQycCDeTe0FyKte5a0CfEY1ZlyMMvvI=
Date:   Thu, 24 Mar 2022 13:51:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Jordy Zomer <jordy@pwning.systems>, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [External] : Re: [PATCH] nfc: st21nfca: Fix potential buffer
 overflows in EVT_TRANSACTION
Message-ID: <YjxpR4JFk8dGzXwV@kroah.com>
References: <20220111164451.3232987-1-jordy@pwning.systems>
 <20220321174006.47972-1-denis.e.efremov@oracle.com>
 <Yjl2pJ5zL4kw+5eT@kroah.com>
 <c5bd1f13-e106-77ef-8fdb-ea95d78baeeb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5bd1f13-e106-77ef-8fdb-ea95d78baeeb@oracle.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 11:58:04AM +0300, Denis Efremov wrote:
> 
> 
> On 3/22/22 10:11, Greg KH wrote:
> > On Mon, Mar 21, 2022 at 08:40:06PM +0300, Denis Efremov wrote:
> 
> >> CVE-2022-26490 was assigned to this patch. It looks like it's not in
> >> the stable trees yet. I only added Link:/Fixes:/Cc: stable... to the
> >> commit's message.
> >>
> >>  drivers/nfc/st21nfca/se.c | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> > 
> > What is the git commit id of this patch in Linus's tree?
> > 
> 
> commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.

Now queued up, thanks.

greg k-h
