Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8647D596DF5
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 14:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiHQMCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 08:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbiHQMCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 08:02:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1D484EFC
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86884614FF
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9214CC433D6;
        Wed, 17 Aug 2022 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660737767;
        bh=3zqqLyW0FrDvSZVfY/mGeZ7CLtQy+VNZGlRtSns63w4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ilxVZwc6hbGfHfyWacUP1OSCXrHeEOvUHv9flkpPz2nd1sasSsDPfu9NOUJkdbzdU
         7EWR13pPmQRi/teuHEmz7xXcfTMZP9eE/N6Eeca628fy8eHLM8P0Br7YkECsYvwGyU
         BUiZDLVLJerIZcf8NzKprnvuP3iXS4xsxvBLGdJM=
Date:   Wed, 17 Aug 2022 14:02:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     coxu@redhat.com, bhe@redhat.com, msuchanek@suse.de,
        will@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <YvzY5BOwFTkQd3IM@kroah.com>
References: <166057758347124@kroah.com>
 <ebb3e67f78a8d7ab0e359517eadb3f39247a358f.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebb3e67f78a8d7ab0e359517eadb3f39247a358f.camel@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 02:11:44PM -0400, Mimi Zohar wrote:
> Hi Greg,
> 
> On Mon, 2022-08-15 at 17:33 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The commits contained in the 88b61b130334 ("Merge remote-tracking
> branch 'linux-integrity/kexec-keyrings' into next-integrity") should be
> applied in the proper order to avoid merge conflicts.  
> 
> The third patch has a dependency on the first two commits, which were
> initially in Andrew's tree.   The third commit says, "Note later
> patches are dependent on this patch so it should be backported to the
> stable tree as well."

I need git commit ids of those commits please.  Otherwise this is
impossible to determine given the huge number of commits in the tree.

thanks,

greg k-h
