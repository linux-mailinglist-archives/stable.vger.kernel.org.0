Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1F4983F8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243231AbiAXQAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbiAXQAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:00:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EEDC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24E3B81104
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA10AC340E7;
        Mon, 24 Jan 2022 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643040003;
        bh=jUJO85fjU+/S3kfkCgZi8jn6WJKBMSP3iL708ExO6Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1t6ujZVpxGji+4GaSCLpSd1Z9UImenEeUWvQWjnGLv+FUY2TdPLiX6eEY1lV6ukU
         ZcMWcXZ9lA4OsJlpaqqqi3NsiMkrk5qNmT6deyL2fNnncZOfQK8Yh6dhP7VlqlSCZa
         s32ZfggABhuJ4dSca1MOT2GiwYOOQ3pZEanFH+FQ=
Date:   Mon, 24 Jan 2022 17:00:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Andy Spencer <aspencer@spacex.com>,
        Michael Braun <michael-dev@fami-braun.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [stable 4.9,4.14] gianfar rx fixes
Message-ID: <Ye7NAJhKCGZQYFL/@kroah.com>
References: <Ye7JF4yOYE3y8QEJ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7JF4yOYE3y8QEJ@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:43:19PM +0100, Ben Hutchings wrote:
> Please pick the following commits for 4.9 and 4.14.  They should apply
> cleanly.
> 
> commit d903ec77118c09f93a610b384d83a6df33a64fe6
> Author: Andy Spencer <aspencer@spacex.com>
> Date:   Thu Feb 22 11:05:33 2018 -0800
> 
>     gianfar: simplify FCS handling and fix memory leak
> 
> commit d8861bab48b6c1fc3cdbcab8ff9d1eaea43afe7f
> Author: Michael Braun <michael-dev@fami-braun.de>
> Date:   Thu Mar 4 20:52:52 2021 +0100
> 
>     gianfar: fix jumbo packets+napi+rx overrun crash
> 
> Ben.

All now queued up, thanks!

greg k-h
