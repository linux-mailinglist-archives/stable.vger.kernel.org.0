Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E3659577A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiHPKGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiHPKFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:05:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19105C6CD0;
        Tue, 16 Aug 2022 02:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F6161255;
        Tue, 16 Aug 2022 09:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7680CC433D6;
        Tue, 16 Aug 2022 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660641977;
        bh=HH0LKZi3cN9iX3f5XbyBtL6oi9LZPkk8/xXhG4QPW80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2ZnPky8rXQ5BjWdDQNabGVWclVBlCj+X50TlFjw93zEzKIv6w81vP4s9yU+ZwGVD
         x9GnxgBfA6hNlC05qTuaVoEbFTpnXIEMt9uLe1n0jwhnaNoTFepvrxqr+q+7r+v7Q6
         CRk3jGUp//ZprOKphnK7zXQq/brx/Mct2PIxjyb4=
Date:   Tue, 16 Aug 2022 11:26:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu,
        syzbot+b0de012ceb1e2a97891b@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 103/779] USB: gadget: Fix use-after-free Read in
 usb_udc_uevent()
Message-ID: <YvtitluWL33RPxSW@kroah.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180341.711918032@linuxfoundation.org>
 <TYWPR01MB94203CD9FB4E48250368E1D7926B9@TYWPR01MB9420.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYWPR01MB94203CD9FB4E48250368E1D7926B9@TYWPR01MB9420.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 01:43:11AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> This patch is related to "fc274c1e9973 "USB: gadget: Add a new bus for gadgets".
> 5.15.y, 5.10.y, 5.5.y and 4.19.y tree doesn't include it, so it's unnecessary. Please drop each tree.

Ick, good catch, my scripts got confused here.  Now dropped from
everywhere.

thanks,

greg k-h
