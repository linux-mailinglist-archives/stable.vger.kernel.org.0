Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8582E04BA
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 04:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgLVD1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 22:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgLVD1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 22:27:17 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B055C0613D3;
        Mon, 21 Dec 2020 19:26:37 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krYJl-0037Dw-Lf; Tue, 22 Dec 2020 03:26:33 +0000
Date:   Tue, 22 Dec 2020 03:26:33 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, joseph.qi@linux.alibaba.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] ovl: fix  dentry leak in ovl_get_redirect
Message-ID: <20201222032633.GS3579531@ZenIV.linux.org.uk>
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 11:06:26AM +0800, Liangyan wrote:

> Cc: <stable@vger.kernel.org>
> Fixes: a6c606551141 ("ovl: redirect on rename-dir")
> Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>

Fine by me...  I can put it through vfs.git#fixes, but IMO
that would be better off in overlayfs tree.
