Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AF4BCE26
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiBTLcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:32:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBTLcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:32:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9511F6375
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155526104A
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 11:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74A1C340E8;
        Sun, 20 Feb 2022 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645356710;
        bh=ydOUXiTeRLIpHVEMvgTk4+NjzBxKYKWIGNVhobYnY24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MN3upePsbyCUqnwU8Lc8h5lEZVEKW56u9uIhw4YRYxLGifjcDy5QMH293j8rykS7E
         iW6LZASzwIkfv6txoMY7IwuhuFAcDbKUhxXD42liwP0ryry2p3YBbG1MiDo0OvpQWW
         vF8+LmBzTi6rE5LLY791tWgyBLj/7fjneimfL5Cw=
Date:   Sun, 20 Feb 2022 12:31:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] Backport an UFS error handler fix to the 5.15 stable
 tree
Message-ID: <YhImo57XCnJrst0E@kroah.com>
References: <20220218180439.19858-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218180439.19858-1-bvanassche@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 10:04:37AM -0800, Bart Van Assche wrote:
> Hi Greg,
> 
> This series includes two patches:
> - A backport of "scsi: ufs: Remove dead code".
> - A backport of "scsi: ufs: Fix a deadlock in the error handler"
> 
> Although the first patch is a code cleanup patch, I have included it in this
> series because the second patch depends on it.
> 
> An Android developer requested a backport of the second patch to the
> android13-5.15 stable tree.
> 
> Please consider these patches for inclusion in the 5.15 stable tree.

They also are required in the 5.16 stable tree, so that no one upgrades
kernel versions and hits a regression.  I have added them there as well.

thanks,

greg k-h
