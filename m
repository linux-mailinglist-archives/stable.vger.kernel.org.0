Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AAC521218
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbiEJKZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239069AbiEJKZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A857311160;
        Tue, 10 May 2022 03:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 622D7B81CAA;
        Tue, 10 May 2022 10:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B8C385A6;
        Tue, 10 May 2022 10:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652178112;
        bh=gAjifDgmErvB7Ohd5eWWNEANiA0Fs18UZL4x6ru3AH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2BKH1JPob8OCiPbFTU9lGdfN+p/tSG1yduIfAYT9gzhO1rdAnmI8yoSRknzARcKcr
         CKvhkitNdhOf9Y3C7i6+9UMCd5GZS9z5SWp2YvHhiMIS+dktk3B7Za+kUID3qLfi5N
         VimKNEaXLezKTUlBAQzoztiOuAM0vOJ2ePx4kdxs=
Date:   Tue, 10 May 2022 12:21:49 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>,
        Ricky WU <ricky_wu@realtek.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Message-ID: <Yno8va9rzRfXnRDG@kroah.com>
References: <fb7cda69c5c244dfa579229ee2f0da83@realtek.com>
 <CAPDyKFrYWgCbwk6-hNZjtx4mdn7Sx1NJLie+f8wEjS==_HXR5Q@mail.gmail.com>
 <add6c326a5b04525965ffa1e9e96ea41@hyperstone.com>
 <YnjjR8pouD4KtHtT@kroah.com>
 <050affc68f7f4861b35a1ab96e228fec@hyperstone.com>
 <CAPDyKFqh15PFKza8vQpaq7HK_DH3w4q8AvpskZv=vzNYfSdqJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFqh15PFKza8vQpaq7HK_DH3w4q8AvpskZv=vzNYfSdqJQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 11:56:38AM +0200, Ulf Hansson wrote:
> On Mon, 9 May 2022 at 12:12, Christian Löhle <CLoehle@hyperstone.com> wrote:
> >
> > >> Can we get 1f311c94aabdb419c28e3147bcc8ab89269f1a7e merged into the stable tree?
> > >
> > >Which stable branches do you want this added to?
> > >
> > >thanks,
> > >
> > >greg k-h
> >
> > From what I can tell the issue is present since the addition of the driver in ff984e57d36e8
> > So I would suggest adding them to all? Maybe Ricky and Ulf could comment?
> 
> That seems correct.
> 
> Although, it's likely that 1f311c94aabd doesn't apply to older stable
> trees, but I guess we can try and see how it goes.
> 
> Perhaps an even better option is that you submit a backported patch to
> Greg for those stable kernels you want it to be applied to.

It only applies cleanly to 5.17.y and 5.15.y, so I've added it there.
If anyone wants it to be added to older kernels, they need to provide
working backports.

thanks,

greg k-h
