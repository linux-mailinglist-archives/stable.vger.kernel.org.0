Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF086B3B5E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCJJxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCJJxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:53:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F005C115;
        Fri, 10 Mar 2023 01:53:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18A02612A8;
        Fri, 10 Mar 2023 09:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082F8C433EF;
        Fri, 10 Mar 2023 09:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678442000;
        bh=O+JWxf5jtc5BK4m+Tf9y0SQFJSX2Jhk1I5UXaxpYuMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBhdWPPLFmf9+chVjt2b48y1rwt+nfuK6C67wgdpvRdZyldUgd9LxLyMiFbekiUnU
         ij99N6oYtqlQ/CxdBrg23YgsB6BDq0/ZnNL1kzvt5X+rAM2jQVAgpk7v3iCAIUoLB6
         mOPwJxWk9LTB369AMaMJ8htfhAvH1tQA4kvGAK04=
Date:   Fri, 10 Mar 2023 10:53:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Finkelstein <fnkl.kernel@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the
 board name.
Message-ID: <ZAr+DWZ9bt3ZxpCs@kroah.com>
References: <20230224-btbcm-wtf-v1-1-d2dbd7ca7ae4@gmail.com>
 <ZArmD064NVhNS96C@kroah.com>
 <CAMT+MTT1RE2M0Fn3k+EXO=WNgAvNGPGHpidpTp0Jdus61M5UPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMT+MTT1RE2M0Fn3k+EXO=WNgAvNGPGHpidpTp0Jdus61M5UPw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 10:41:28AM +0100, Sasha Finkelstein wrote:
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> >
> > </formletter>
> Sorry about that, let's just skip the stable tree part for now then.

That's not how to solve the problem, if it's a bug that needs to be
fixed in stable kernels, submit it properly and it will automatically be
propagated there as the documentation states.

thanks,

greg k-h
