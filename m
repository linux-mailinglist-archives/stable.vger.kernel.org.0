Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B8E4BA931
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiBQTFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:05:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiBQTFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:05:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF378093F
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04D461C4F
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 19:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC07C340EB;
        Thu, 17 Feb 2022 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124691;
        bh=6kcD57kRUOOiOVbnUfO/eoXh3wI6zoKF/grBPaHnbOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vw8OzdLuyDW++aQ45cfiIfonfYpeU5CIRPDnb9mn1QjMIoQfLQh+KBGciYBTJ+ep7
         CSB6dU6jpbjPSk8kVfn/8Is9YbKUd3sOsIYl2BaDV8FU99uaAddg1sL1RELYlyrL1U
         TnB53bnxwvnvpIgtgf6cOwYZ7MSF2QTx2B3lvfsU=
Date:   Thu, 17 Feb 2022 20:04:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Backport Request: scsi: lpfc: Fix mailbox command failure during
 driver initialization
Message-ID: <Yg6cS5XyZaiOi+Ho@kroah.com>
References: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 11:06:44AM -0800, James Smart wrote:
> Please backport the following patch to the 5.10 and 5.15 kernels. It is
> currently in the 5.16 kernel.
> 
> scsi: lpfc: Fix mailbox command failure during driver initialization
> commit	efe1dc571a5b
> 
> The error being corrected causes failure of adapter initialization and
> attachment.

Now queued up, thanks.

greg k-h
