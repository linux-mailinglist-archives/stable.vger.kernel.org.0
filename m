Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1947369ADD1
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBQOUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBQOUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B9572B5;
        Fri, 17 Feb 2023 06:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6F361C21;
        Fri, 17 Feb 2023 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD6C433EF;
        Fri, 17 Feb 2023 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676643649;
        bh=PxG8WjVWQrbJIDjndkkPVdR8kR3DHaqtLSKBANf2ASU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rsgV8psU6vBtnazummH9PFOC//0QrTnqXjpchOMD7m7o0cL+SmEYCXIkCRPmRQ6Fk
         JTaPu2qXRnrosZBuFpcM+TFBhP73QorD2ljLjOEphhptSlxNN+55FoqGzKg1TS0EP0
         XdZNl55XkzOGm0ZhALHLCXtnCBGLH8ZZP/JiQnzU=
Date:   Fri, 17 Feb 2023 15:20:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/25] xfs stable candidate patches for 5.4.y (from
 v5.10)
Message-ID: <Y++NPiL78wdT6Y46@kroah.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 16, 2023 at 10:49:54AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.10. The patchset
> has been acked by Darrick.

All now queued up, thanks.

greg k-h
