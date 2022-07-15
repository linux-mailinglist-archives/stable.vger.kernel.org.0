Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662365763C5
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiGOOlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiGOOlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:41:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9FA74DCC
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92F4BB82C77
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 14:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13F2C34115;
        Fri, 15 Jul 2022 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657896101;
        bh=6a5pstgtBvD7M/pukjH7D8ya7KNO0l9j/63Fp/sDUY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ffhI+wLilcckOd3NzE7oOmuta0G5ySMZ24gxpanAi35nQ4eAN8VBZUga+GP/0vseV
         uyTKspFEWLLbZZNOM015D0piGfPJ1o8ENTKnScWBV+Uv080Hk2QkSA0sj4E/4v6Q6x
         aoGuI1T835dP+IND0Qfw+mRUFWvZLUSu50jmhZpc=
Date:   Fri, 15 Jul 2022 16:41:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mathias.nyman@linux.intel.com, quic_pkondeti@quicinc.com,
        s.shtylyov@omp.ru, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: make xhci_handshake timeout for
 xhci_reset() adjustable" failed to apply to 4.14-stable tree
Message-ID: <YtF8oge9p6e1VG+d@kroah.com>
References: <164871736680140@kroah.com>
 <Ys8Y7NBN9FaWUSrc@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys8Y7NBN9FaWUSrc@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 08:11:40PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Mar 31, 2022 at 11:02:46AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with 72ae194704da ("xhci: bail out early if
> driver can't accress host in resume") to make the backporting little
> easier.

Now queued up, thanks.

greg k-h
