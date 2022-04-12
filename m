Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E034FCEA0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbiDLFOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiDLFOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:14:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8564F344D5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 22:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2211561811
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 05:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D9EC385AB;
        Tue, 12 Apr 2022 05:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649740354;
        bh=FvG6Iouh1vJZ/wSQGtdpoD60rj3eRIjuiU0lE9Tug5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+Pr3wuixJJoMedPJeSQruuH+kEUnAt8CwJzwCj1ueH5H9Z9A3TSqc/ru1OmNtEDY
         I9rKTJylzmVySgB36hdpnirtWbUo75VRiX/13Elj0wBHd0bIdtrCBCGkAtgNClT2Um
         jrFRoPhnwq2+lf8sKrBBEEXbmlBOljtcEiEMYDDw=
Date:   Tue, 12 Apr 2022 07:12:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: move read/write file prep state
 into actual opcode" failed to apply to 5.17-stable tree
Message-ID: <YlUKQAqfzOhPb0PI@kroah.com>
References: <1649663067150210@kroah.com>
 <5e7dc467-9736-5ae7-b198-3830a544d51d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7dc467-9736-5ae7-b198-3830a544d51d@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 01:50:16PM -0600, Jens Axboe wrote:
> On 4/11/22 1:44 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.17-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's this one and the following ones marked for 5.17-stable. The first
> two it looks like you, this is the rest.

Now queued up, thanks!

greg k-h
