Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AB65B3ECB
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiIIS1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiIIS07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E841117489
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2FB9B82613
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 18:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CE8C433C1;
        Fri,  9 Sep 2022 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662748016;
        bh=WVMx0W2o/QpZY+oDoc/DUFWbmGZQ12I15EboMsaaXeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vMqdWP6CaTQJeclCELZR7M5ml05isMuEd3xBUBFmQXtQo5jxYppmO177wUWzlRfgX
         fFq/mOiNIuUY4u/Zu/Aiq0miJG0IXZnJUO4mrDnIEGsPePh8ZVGB8Yk47jhy7uEQt9
         MuEw3vx0L+WDYuypabgzfMvCSqbSslcgdCEeUTV8=
Date:   Fri, 9 Sep 2022 20:26:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, surajjs@amazon.com, mbacco@amazon.com
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Message-ID: <YxuFbryl3wqVMOjY@kroah.com>
References: <20220909181351.23983-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909181351.23983-1-risbhat@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 09, 2022 at 06:13:42PM +0000, Rishabh Bhatnagar wrote:
> This patch series backports a few VM preemption_status, steal_time and
> PV TLB flushing fixes to 5.10 stable kernel.
> 
> Most of the changes backport cleanly except i had to work around a few
> becauseof missing support/APIs in 5.10 kernel. I have captured those in
> the changelog as well in the individual patches.

Any reason you didn't cc: the KVM maintainer on this patch series?  All
stable backports of KVM code require their review before they can be
accepted.

Please fix up and resend.

thanks,

greg k-h
