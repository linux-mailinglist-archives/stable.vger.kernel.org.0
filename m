Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D1B478DB5
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhLQOXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:23:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57692 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbhLQOXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:23:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 618FCB82877
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 14:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94B8C36AE7;
        Fri, 17 Dec 2021 14:23:03 +0000 (UTC)
Date:   Fri, 17 Dec 2021 15:23:01 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     gregkh@linuxfoundation.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ceph: fix up non-directory creation in
 SGID directories" failed to apply to 5.10-stable tree
Message-ID: <20211217142301.a5y45b54ut3ika4v@wittgenstein>
References: <163974910684103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <163974910684103@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 02:51:46PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oh? I just applied the patch on top of:

commit 272aedd4a305 ("Linux 5.10.87")

without any issues. Not sure what failed for you.

Thanks!
Christian
