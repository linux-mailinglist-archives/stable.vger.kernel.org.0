Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28115A4416
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiH2Hon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiH2Hom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB24F1B7;
        Mon, 29 Aug 2022 00:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C666112E;
        Mon, 29 Aug 2022 07:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B814DC433D6;
        Mon, 29 Aug 2022 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661759080;
        bh=00t5wHTvz51utbPGJygEKXuRE1eRby5ZijJFCGeaNTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcA/15zh/W7l4v1oIx0UXNFWTUmIxGgChJttuUHo9+PBOL0LkrffSqEGwp5+hs4iE
         /fFeiIcXJ4XNmLEH/HPh2PaZenMZ3gkm6wLK/cTx3Teo+KMOQvOafxP+Dgb9FMbRTH
         Ql63gugv1TeR1DWay+DJeRDSnt+HDgBjFlmL69oM=
Date:   Mon, 29 Aug 2022 09:44:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: cifs backport request
Message-ID: <YwxuZfeLJV7IEidp@kroah.com>
References: <87r110nocu.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r110nocu.fsf@cjr.nz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 28, 2022 at 04:45:53PM -0300, Paulo Alcantara wrote:
> Hi Greg,
> 
> Could you please pick these commits for >= linux-5.7.y
> 
>         ef605e868212 ("cifs: skip trailing separators of prefix paths")
>         ee3c8019cce2 ("cifs: fix uninitialized pointer in error case in dfs_cache_get_tgt_share")

These do not apply at all to any of those kernels.  Please provide a
backported and tested set of patches and we will be glad to queue them
up.

thanks,

greg k-h-
