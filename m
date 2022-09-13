Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946725B6C65
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiIMLao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIMLan (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32FD56B8E
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82F9DB80920
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0363AC433D6;
        Tue, 13 Sep 2022 11:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068640;
        bh=Q2puAMKnqSxU6kDprbRCPisJ1Y9JFrhxx6nf5InmpgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZwbMtOhj/eVguiOOxhsGtHHnxIIZW/rxkPXfzYiHN4SXkTArufBBLl6NKIEbhQr5q
         /UbNSCuX4/JK93Epowsg/hZLyXebavqbiR9JaYbWXL+h6bKT6wq8v1g2WJnLtiYWb+
         jSLJ65Mog4h3J5uAH1dZ5pNWi5wB+5YdFPNJuEsM=
Date:   Tue, 13 Sep 2022 13:31:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Pham <quic_jackp@quicinc.com>
Cc:     jleng@ambarella.com, stable@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: gadget: f_uac2: fix superspeed
 transfer" failed to apply to 5.15-stable tree
Message-ID: <YyBp+biMkAUoarlO@kroah.com>
References: <1662463814122169@kroah.com>
 <20220913054306.GA31201@jackp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913054306.GA31201@jackp-linux.qualcomm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 10:43:06PM -0700, Jack Pham wrote:
> On Tue, Sep 06, 2022 at 01:30:14PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Ah ok, for 5.15 this patch doesn't apply due to broken indentation that
> was later fixed.  So could we also backport commit 18d6b39ee895 ("usb:
> gadget: f_uac2: clean up some inconsistent indenting") first or should
> this patch just be fixed up to apply standalone?

Which ever you want to do is fine with me.  But whitespace cleanup
patches might be easier to take to handle backports over the long-run.

thanks,

greg k-h
