Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3E4504F6C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiDRLkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbiDRLkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:40:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076311583D
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FA7F60B1F
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 11:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A44C385A7;
        Mon, 18 Apr 2022 11:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650281852;
        bh=gB5k82IgYQj32OS1N5Ie+q2xQtDn4fGjj2uYo/6Q2kc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecE7oSgeiG0czonkNklcag20JEIJOOEZPHmPqZxWhXx9QdFGqXTmJICvuw+tCDisn
         Zf7rcSsebcdurtKS8evXoL3KR3wR2hGwD3jE1sxMMaxtalGEqw5rugY8ysvUaPQDQz
         19uLJsAeE1iZDLsIrAD6Dm0xkykgKE/SzAsosVsI=
Date:   Mon, 18 Apr 2022 13:37:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.17 1/1] ax25: Fix UAF bugs in ax25 timers
Message-ID: <Yl1NeWXO5/7/9lQb@kroah.com>
References: <20220415161317.1016672-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415161317.1016672-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 15, 2022 at 07:13:17PM +0300, Ovidiu Panait wrote:
> From: Duoming Zhou <duoming@zju.edu.cn>
> 
> commit 82e31755e55fbcea6a9dfaae5fe4860ade17cbc0 upstream.

<snip>

Any reason you are not cc: the original authors and maintainers of these
changes?

thanks,

greg k-h
