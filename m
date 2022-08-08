Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E071658C96B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbiHHN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbiHHN2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:28:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367C4A462
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 06:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1146B80E84
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 13:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA52C433D6;
        Mon,  8 Aug 2022 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659965312;
        bh=Oib6Kqe9X+xupZNFliGRXSFpKQ3+Mlm/9Ff+a16/1oM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kao42x/JUxfvPK+7RSRmtHAlUKKgoByIF+35HTjt/qNjxl2KemdH2q/fBUa19tLlu
         LViSwp4+dwyowMM1I1GYP0hT4i81/2/1OBrwtfkBiSciUWYFqpdemXMVCjRXt7/Xo9
         sXtUonXjaHZ68EkB2SL6bxdrfM//R0DcMSNSibYc=
Date:   Mon, 8 Aug 2022 15:28:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Message-ID: <YvEPfSBGdBV0ZohA@kroah.com>
References: <20220808115922.331003-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808115922.331003-1-theflamefire89@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 01:59:21PM +0200, Alexander Grund wrote:
> This backports a commit from upstream which I would consider a cleanup
> as well as a (minor) performance fix due to less memory being used and
> avoiding an unneccessary pointer dereferencing, i.e. the change
> from `sbsec->sb->s_root` to `sb->s_root`.
> 
> However as it changes the `superblock_security_struct` please check if
> this violates any API/ABI stability requirements which I'm not aware of.

There is no internal stable API/ABI in the kernel, including in the
stable releases.

But, we only take patches that actually do something.  This one doesn't
do anything at all, and has no measurable performance or bugfix that I
can determine at all.

So no need for it, sorry,

greg k-h
