Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2356C78F
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 08:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiGIGeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 02:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIGeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 02:34:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CDA1DA7D;
        Fri,  8 Jul 2022 23:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0C29CE2E99;
        Sat,  9 Jul 2022 06:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956ECC3411C;
        Sat,  9 Jul 2022 06:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657348453;
        bh=2uTm3WC6wxy89V7V/4cci/5HmlCO92Cyj+BDgD/BNfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCBWD3s4U8kA4iVEWKblTdkSCNRCHOfNLpLNLmDlorBjcJyIIsm6Gg0jieTau6y2+
         8NJEmjoY7DtJ39rJgF+Ovd3Vjg3gGv+U+Cq/3gBKuYUi2DOiWvfQBqfzG06nMU2Qu+
         8UgwaK/hNQT6DH23pMYCoeHk+UPWkW14mhefAbi0=
Date:   Sat, 9 Jul 2022 08:34:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Juergen Gross <jgross@suse.com>,
        Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: Re: gntdev warning fixes
Message-ID: <YskhYmJFg2KgYF3n@kroah.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708163750.2005-1-demi@invisiblethingslab.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 12:37:44PM -0400, Demi Marie Obenour wrote:
> The recent gntdev fixes introduced two incorrect WARN_ON()s, which
> triggered immediately on my system.  Patches for master and all
> supported stable versions follow.
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
