Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01351547B51
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 19:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiFLRtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 13:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiFLRtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 13:49:35 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6E617E39;
        Sun, 12 Jun 2022 10:49:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id D4F6F20188;
        Sun, 12 Jun 2022 19:49:29 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BSDcosFd3M4d; Sun, 12 Jun 2022 19:49:29 +0200 (CEST)
Received: from begin (anantes-655-1-33-15.w83-195.abo.wanadoo.fr [83.195.225.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 1FED420184;
        Sun, 12 Jun 2022 19:49:29 +0200 (CEST)
Received: from samy by begin with local (Exim 4.95)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1o0RiK-001SSp-VT;
        Sun, 12 Jun 2022 19:49:28 +0200
Date:   Sun, 12 Jun 2022 19:49:28 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        trix@redhat.com, salah.triki@gmail.com, speakup@linux-speakup.org
Subject: Re: [PATCH AUTOSEL 5.10 21/38] accessiblity: speakup: Add missing
 misc_deregister in softsynth_probe
Message-ID: <20220612174928.msxmjn67cngztfcc@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Sasha Levin <sashal@kernel.org>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        trix@redhat.com, salah.triki@gmail.com, speakup@linux-speakup.org
References: <20220607175835.480735-1-sashal@kernel.org>
 <20220607175835.480735-21-sashal@kernel.org>
 <20220608210830.GA1306@duo.ucw.cz>
 <YqYmt5wAXWt7Ggzu@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqYmt5wAXWt7Ggzu@sashalap>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin, le dim. 12 juin 2022 13:47:35 -0400, a ecrit:
> On Wed, Jun 08, 2022 at 11:08:30PM +0200, Pavel Machek wrote:
> > > From: Zheng Bin <zhengbin13@huawei.com>
> > > 
> > > [ Upstream commit 106101303eda8f93c65158e5d72b2cc6088ed034 ]
> > > 
> > > softsynth_probe misses a call misc_deregister() in an error path, this
> > > patch fixes that.
> > 
> > This seems incorrect. Registration failed, we can't really deregister.

The synthu_device registration failed, yes, but the patch is about
unregistering synth_device, which was registered just above (notice
synth_device != synthu_device)

Samuel
