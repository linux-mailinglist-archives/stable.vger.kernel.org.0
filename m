Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F06F595DA9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiHPNsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiHPNse (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:48:34 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2B62186B6F
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 06:48:30 -0700 (PDT)
Received: (qmail 128862 invoked by uid 1000); 16 Aug 2022 09:48:29 -0400
Date:   Tue, 16 Aug 2022 09:48:29 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     nobuhiro1.iwamatsu@toshiba.co.jp, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+b0de012ceb1e2a97891b@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 103/779] USB: gadget: Fix use-after-free Read in
 usb_udc_uevent()
Message-ID: <YvugLT/jiE9g9ux4@rowland.harvard.edu>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180341.711918032@linuxfoundation.org>
 <TYWPR01MB94203CD9FB4E48250368E1D7926B9@TYWPR01MB9420.jpnprd01.prod.outlook.com>
 <YvtitluWL33RPxSW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvtitluWL33RPxSW@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 11:26:14AM +0200, Greg KH wrote:
> On Tue, Aug 16, 2022 at 01:43:11AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> > Hi,
> > 
> > This patch is related to "fc274c1e9973 "USB: gadget: Add a new bus for gadgets".
> > 5.15.y, 5.10.y, 5.5.y and 4.19.y tree doesn't include it, so it's unnecessary. Please drop each tree.
> 
> Ick, good catch, my scripts got confused here.  Now dropped from
> everywhere.

Sorry, my fault.  I forgot to add a "Fixes:" tag to the patch.

Alan Stern
