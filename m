Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47CA60FAFA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiJ0O6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 10:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiJ0O6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 10:58:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF1DD2CDD;
        Thu, 27 Oct 2022 07:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB3DFCE26FF;
        Thu, 27 Oct 2022 14:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A4DC433C1;
        Thu, 27 Oct 2022 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666882712;
        bh=vnfdv/JHPpdk3UjFO1IuB+dWmFZW4SW3MkeuY+v5KBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhvR9OgYZ9KKVxssEpB6q9sa1y71olxohwj3G4xYvOBd07+k5SkGYrybYsV5EWgFJ
         +HF7PyvbeSUboS4qeg1MTX+GVLfoYKe8uW+ZhCLFlWn8raYt9bJd0CuH7CEzOQ93xD
         phst21A77tly9WvBczym286rvFdE12nEEpZoBd1w=
Date:   Thu, 27 Oct 2022 16:58:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/26] xfs stable candidate patches for 5.4.y (from
 v5.7)
Message-ID: <Y1qclR0k6r386vl3@kroah.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
 <Y1lJqHOSKuAMrSTS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1lJqHOSKuAMrSTS@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 04:52:24PM +0200, Greg KH wrote:
> On Wed, Oct 26, 2022 at 11:58:17AM +0530, Chandan Babu R wrote:
> > Hi Greg,
> > 
> > This 5.4.y backport series contains XFS fixes from v5.7. The patchset
> > has been acked by Darrick.
> 
> All now queued up, thanks.

You forgot to look at fixes for these fixes :(

I count the following commits as also needed here, right:
	9c516e0e4554 ("xfs: finish dfops on every insert range shift iteration")
	c97738a960a8 ("xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush")
	5ffce3cc22a0 ("xfs: force the log after remapping a synchronous-writes file")

Hopefully you send these later...

thanks,

greg k-h
