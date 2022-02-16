Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E284B8F63
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 18:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbiBPRl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 12:41:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbiBPRl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 12:41:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B08C2B0B2E;
        Wed, 16 Feb 2022 09:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C47C160AFF;
        Wed, 16 Feb 2022 17:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD3BC004E1;
        Wed, 16 Feb 2022 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645033273;
        bh=BBA8tsO6WSeLAkqWG8BW63QrUWk7tyH6R7J9vwRx050=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2eY/pRyJtrOfUA++Tg/IsHDcor2a7KygZBJ3+059S+Nd9mAfyNQk/zFrIrluMfgX
         hRbY6RNNmcYPRCFzQamUuWg2u9L6MJS+IiStNj+iynqkuA37hKWV5MVuqMn6Zerxg/
         N83brOlTGxyRtAKu/MCTQo3WLE3bNZoHRNn/nDgY=
Date:   Wed, 16 Feb 2022 18:41:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: missing patch in 5.15? {drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL}
Message-ID: <Yg03NpL7WDMtQWmK@kroah.com>
References: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 12:37:55PM -0300, Gerardo Exequiel Pozzi wrote:
> Hi
> 
> Can apply {drm/i915: Workaround broken BIOS DBUF configuration on TGL/RKL}
> [#1], that is now in 5.16.10, in 5.15 branch? According to commit message is
> valid for v5.14+.
> 
> Take care.
> 
> 
> [#1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/releases/5.16.10/drm-i915-workaround-broken-bios-dbuf-configuration-on-tgl-rkl.patch?id=154ad098b73bccab3b91cef33f0aec2678ced71a


As previously reported, it does not apply to the 5.15.y kernel branch
right now, as it breaks the build.

How did you test this on 5.15 to verify that it solves the problem for
you?  Do you have a working patch?  If so, please forward it to us so
that we can apply it.

thanks,

greg k-h
