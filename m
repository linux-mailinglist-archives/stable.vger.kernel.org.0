Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41D160E3C6
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 16:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiJZOx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 10:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbiJZOx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 10:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B10B5140;
        Wed, 26 Oct 2022 07:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EC6CB822BF;
        Wed, 26 Oct 2022 14:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A8C43470;
        Wed, 26 Oct 2022 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796004;
        bh=QgBBNZ1KOOtGwgC1zPEFHN+sTA0MyRZJYpxfJjkgY88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/K2aOpdhaNrr1ZhP8W/kHNHXka7iV7PT8tz+RfxAM+8meBmBzeun0yOUJW+H8Dbp
         at375gvFz2b107YPzCJyL+Nj4zjZ4yBvg0N92BrAHgBMlQ0B6llZv9jFMbja02QenU
         e5zG2mbQSjB5UIYMG7OL+jEnF8Y63H00KxJUgZTk=
Date:   Wed, 26 Oct 2022 16:52:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/26] xfs stable candidate patches for 5.4.y (from
 v5.7)
Message-ID: <Y1lJqHOSKuAMrSTS@kroah.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 11:58:17AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.7. The patchset
> has been acked by Darrick.

All now queued up, thanks.

greg k-h
