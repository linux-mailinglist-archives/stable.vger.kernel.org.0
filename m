Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85245851FF
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiG2PBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiG2PBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BEEE3E;
        Fri, 29 Jul 2022 08:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3F09B82816;
        Fri, 29 Jul 2022 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC98C433D6;
        Fri, 29 Jul 2022 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659106897;
        bh=gvGQ7NTGk5qetg2gI/0pv0OgxdfQzvabuNEhhUUQnzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zb287PPCDNAAFcHzpMAy0hAMGUlfPegDUwrdwFSxdOmLlUAR0fKIF8AAuUSYlitX3
         rCQ15eahpJ0DN2udcZVMxENvmygbE4NFNIs7Z+jh25FxpFmBBnobWnhzxciYTrYPU1
         PzlBKkF6hTna7kGZfk4CLmFmnKK2Unxs7GnlcOH0=
Date:   Fri, 29 Jul 2022 17:01:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: [PATCH 5.10 010/105] net: make free_netdev() more lenient with
 unregistering devices
Message-ID: <YuP2TjD6S74zkx9E@kroah.com>
References: <20220727161012.056867467@linuxfoundation.org>
 <20220727161012.480155559@linuxfoundation.org>
 <20220728210011.GA4108@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728210011.GA4108@duo.ucw.cz>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 11:00:11PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Fedor Pchelkin <pchelkin@ispras.ru>
> > 
> > From: Jakub Kicinski <kuba@kernel.org>
> > 
> > commit c269a24ce057abfc31130960e96ab197ef6ab196 upstream.
> ...
> > Simplify the error paths which are currently doing gymnastics
> > around free_netdev() handling.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Patches 10..15: there's something wrong with From: field here; it is
> present twice and sign-off does not match from.

Ick, sorry, my tool's fault, I've now fixed that up.

greg k-h
