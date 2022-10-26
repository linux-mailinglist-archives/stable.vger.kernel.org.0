Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7639360E496
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiJZPer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiJZPep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:34:45 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F399E10DE
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:34:43 -0700 (PDT)
Received: (qmail 7277 invoked by uid 1000); 26 Oct 2022 11:34:43 -0400
Date:   Wed, 26 Oct 2022 11:34:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     gregkh@linuxfoundation.org
Cc:     linhaoguo86@gmail.com, mchehab@kernel.org, sean@mess.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: mceusb: Use new
 usb_control_msg_*() routines" failed to apply to 6.0-stable tree
Message-ID: <Y1lTk7Gn0XGdLfa7@rowland.harvard.edu>
References: <166679706424177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166679706424177@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 05:11:04PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 41fd1cb61514 ("media: mceusb: Use new usb_control_msg_*() routines")

Greg:

I can submit a patch for the -stable trees that fixes the problem 
reported by syzbot without converting the mceusb driver to use the new 
usb_control_msg_*() routines.  Would that be okay?  Or do you prefer 
simply not to include this patch (which merely fixes a warning) in the 
stable kernels?

Alan Stern
