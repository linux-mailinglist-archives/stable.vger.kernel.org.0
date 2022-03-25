Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9C4E7403
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 14:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbiCYNPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 09:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346490AbiCYNPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 09:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793523BBDA
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 06:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E53F61A5C
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 13:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97550C340E9;
        Fri, 25 Mar 2022 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648214042;
        bh=imX68mN56nvlRMQ+HbQyNSRGRbhaynTQVcpfy4dJ83A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=obtbYWdDrx9MrgZRxew7XYMHhIMzsVnvVs8dygI4Al2M7eMu0vV2gcQp6lsLA7RPO
         2qEH03kDuL8cAhy0z/2TCMHsxGOlsK7Rf+8Xf6iq6wmcXpkcnkcDPhYZk7Acq+70A4
         jfZ0kTwh52jIMA39VrZLdvctovbO6Q2zvZiTDJbY=
Date:   Fri, 25 Mar 2022 14:13:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     stable@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: FAILED: patch "[PATCH] crypto: qat - disable registration of
 algorithms" failed to apply to 4.9-stable tree
Message-ID: <Yj3AF/h7UDkpYGIt@kroah.com>
References: <16482055719285@kroah.com>
 <Yj20vfqmn3xQ0D7Y@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj20vfqmn3xQ0D7Y@silpixa00400314>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 12:25:44PM +0000, Giovanni Cabiddu wrote:
> Hi Greg,
> 
> On Fri, Mar 25, 2022 at 11:52:51AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> Below a backport that applies to kernels from 4.9 to 5.10.
>

Thanks, now queued up.

greg k-h
