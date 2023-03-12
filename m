Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83B6B65D6
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 13:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCLMGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 08:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCLMGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 08:06:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA12C212A;
        Sun, 12 Mar 2023 05:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89D6BB80B01;
        Sun, 12 Mar 2023 12:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05E7C433EF;
        Sun, 12 Mar 2023 12:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678622762;
        bh=Q/ldCMrCGfGTco0Sl12AyoNJlMKJhtt2MH6rp55F/O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LdrGpE3p+t39oWdprpiQz8WAZamifCnf75WCojmAK2r/Cflzo6wLv4gIl0mCsg60a
         sY08BCscRinAmL5/GXx5SoAbPOJ1Cipi2PAoHXp5P8wSLp+tP+a6aCpVEFJfke32jI
         +g/0rgaZDemPNShCUfckoMst9aZ+rppcsPh65GwI=
Date:   Sun, 12 Mar 2023 13:05:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "A.P. Jo." <apjo@tuta.io>
Cc:     Stable <stable@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bricked LTS Kernel: Questionable i915 Commit
Message-ID: <ZA3AJ+dZgYOEkHSt@kroah.com>
References: <NQJqG8n--3-9@tuta.io>
 <ZA2zkz8J6fuJsisw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA2zkz8J6fuJsisw@kroah.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 12:12:19PM +0100, Greg KH wrote:
> On Sun, Mar 12, 2023 at 09:04:01AM +0100, A.P. Jo. wrote:
> > Dear Linux dev community,
> > 
> > 5.15.99 LTS and higher can't boot on many laptops using Intel graphics.
> > 
> > Originally spotted using Alpine Linux, see: https://gitlab.alpinelinux.org/alpine/aports/-/issues/14704.
> > Seems to have been traced to commit 4eb6789f9177a5fdb90e1b7cdd4b069d1fb9ce45, see i915 git issue: https://gitlab.freedesktop.org/drm/intel/-/issues/8284.
> > 
> > Suggest releasing with patch undone or fixed.
> 
> There's a second report of this here:
> 	https://lore.kernel.org/r/d955327b-cb1c-4646-76b9-b0499c0c64c6@manjaro.org
> I'll go revert this and push out a new release in an hour or so, thanks!

Should be fixed in 5.15.101.  If not, please let us know.

thanks,

greg k-h
