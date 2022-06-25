Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2355AB26
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiFYOuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiFYOuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:50:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D8218340
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB513B80B7C
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FFAC3411C;
        Sat, 25 Jun 2022 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656168601;
        bh=x3DPTa75GBvuzhPG639KRvsscLxLhn01IUzodQvWzb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qcZ5+OZ9jUzm7odfxeO9DH70Fj1x8MYHH1oM21zF2akXa7IqC4AaTSSa4T0rqgynH
         nLtcbDCN/KfigvHRx/YIvIRTQI0rMCIhAVE1ZrC5MwfOgy4bylzL3cg59NpM83IzcA
         16jxVPfn7XqjymquQ9o+N2f/C8VFqgodUqX/9/Og=
Date:   Sat, 25 Jun 2022 16:49:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ron Economos <re@w6rz.net>
Subject: Re: [PATCH stable 5.4 4.19 4.14 4.9] random: quiet urandom warning
 ratelimit suppression message
Message-ID: <YrcglmecXSMWPMgU@kroah.com>
References: <1656165226250179@kroah.com>
 <20220625144152.46307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625144152.46307-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 04:41:52PM +0200, Jason A. Donenfeld wrote:
> commit c01d4d0a82b71857be7449380338bc53dde2da92 upstream.

Thanks, now queued up.

greg k-h
