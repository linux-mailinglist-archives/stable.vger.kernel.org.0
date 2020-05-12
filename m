Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6C1CEF7D
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 10:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgELIw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 04:52:28 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33467 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728912AbgELIw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 04:52:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 29DC068A;
        Tue, 12 May 2020 04:52:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 04:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=E18WmbzeT1bm182Fg9GxvyijgHO
        er2CSWp3rFmp48hg=; b=NeMHfYNWVOyVndoMO9YsJ5eKDle6RGbpRnk/zPEz9zb
        5d833rpMCx0QlwU7w1iVY9IgfjNd2fgthZ8ijUyn0GWdFLTAvHuksgYLINiUKYQ7
        0S3kisgsQ49PdzPfoBGense5OdMlTlqF6cEralGJMdiAT6F5DSm2SR1OaDQIZtKk
        LOzjCURSVb4JKwUEJE6Nm/sLBRYKyNflW0uN3khznWEEJwMvNN3XwN/XJgjswBX4
        D8pz0m4aZC9e7II5EQi5kuOJlk+AYu67f+0s7v9YyENWLhRRonUd+EWstOSRnSe0
        b45ZYZEBKXTcamuEIzcC2BcZ1Sr37j1Ne4HfVuRDWOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E18Wmb
        zeT1bm182Fg9GxvyijgHOer2CSWp3rFmp48hg=; b=Hm/CfgBSbRg47TsYuwngZ1
        +rRbH2/0X299dGg2Ni3eslDhLSpZtTPCCTPW04qDon/8kcv0e+oIppgnTkfpsWbF
        vj7G0wXdFJx1DjV694F2M1BvPBo4rhW6hMJX3L17b6dY7vRWSvHFdHzY552lFf0R
        f3o+Yr+xFsnfGbrYBfEifQPiBfQJIH9BRc4VnO4N6exX2pYbecAFjqwTGZ4f0sY4
        zt/PfEoTC1ByjrMsKgK+OqY4u1aOxphv2FnfPLhT5rDQm8v66iwgUX6DhyLJkueR
        NUJmfiz+XysWy4ZHxM0KjH0aG+/7YQlc6n0YfOJWxh68Fj8qoKeWeHwwb7XT6SmA
        ==
X-ME-Sender: <xms:yWO6Xm8fv_juZ2UHsPRafhdzxe8Yw_auOQ01u8-AXvtljiN7GA2POQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:yWO6Xms46CO1bFvDuGpCwzr2czQV0qcgLXzvfiqefcpaHuptr1oq0g>
    <xmx:yWO6XsB_lLB0vca3_jVWAA_6oWnNhYV4pafSRtpl3AVGfP_VPOXREA>
    <xmx:yWO6XudQ5CPQSxsskMANSJO8C1R-7gDYbD8hGMkdhJqqmixDhc1CzQ>
    <xmx:yWO6Xm2djpTUmgCtbwznISTOQqzYxpTFH7u1O-0MwXk4rcMG1MLlMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09FF3328005A;
        Tue, 12 May 2020 04:52:24 -0400 (EDT)
Date:   Tue, 12 May 2020 10:52:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Charan Teja Reddy <charante@codeaurora.org>
Cc:     sumit.semwal@linaro.org, ghackmann@google.com, fengc@google.com,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
Message-ID: <20200512085221.GB3557007@kroah.com>
References: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 12:11:03PM +0530, Charan Teja Reddy wrote:
> The following race occurs while accessing the dmabuf object exported as
> file:
> P1				P2
> dma_buf_release()          dmabuffs_dname()
> 			   [say lsof reading /proc/<P1 pid>/fd/<num>]
> 
> 			   read dmabuf stored in dentry->d_fsdata
> Free the dmabuf object
> 			   Start accessing the dmabuf structure
> 
> In the above description, the dmabuf object freed in P1 is being
> accessed from P2 which is resulting into the use-after-free. Below is
> the dump stack reported.
> 
> We are reading the dmabuf object stored in the dentry->d_fsdata but
> there is no binding between the dentry and the dmabuf which means that
> the dmabuf can be freed while it is being read from ->d_fsdata and
> inuse. Reviews on the patch V1 says that protecting the dmabuf inuse
> with an extra refcount is not a viable solution as the exported dmabuf
> is already under file's refcount and keeping the multiple refcounts on
> the same object coordinated is not possible.
> 
> As we are reading the dmabuf in ->d_fsdata just to get the user passed
> name, we can directly store the name in d_fsdata thus can avoid the
> reading of dmabuf altogether.
> 
> Call Trace:
>  kasan_report+0x12/0x20
>  __asan_report_load8_noabort+0x14/0x20
>  dmabuffs_dname+0x4f4/0x560
>  tomoyo_realpath_from_path+0x165/0x660
>  tomoyo_get_realpath
>  tomoyo_check_open_permission+0x2a3/0x3e0
>  tomoyo_file_open
>  tomoyo_file_open+0xa9/0xd0
>  security_file_open+0x71/0x300
>  do_dentry_open+0x37a/0x1380
>  vfs_open+0xa0/0xd0
>  path_openat+0x12ee/0x3490
>  do_filp_open+0x192/0x260
>  do_sys_openat2+0x5eb/0x7e0
>  do_sys_open+0xf2/0x180
> 
> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> [5.3+]
> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
> ---
> 
> Changes in v2: 
> 
> - Pass the user passed name in ->d_fsdata instead of dmabuf
> - Improve the commit message
> 
> Changes in v1: (https://patchwork.kernel.org/patch/11514063/)
> 
>  drivers/dma-buf/dma-buf.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 01ce125..0071f7d 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -25,6 +25,7 @@
>  #include <linux/mm.h>
>  #include <linux/mount.h>
>  #include <linux/pseudo_fs.h>
> +#include <linux/dcache.h>
>  
>  #include <uapi/linux/dma-buf.h>
>  #include <uapi/linux/magic.h>
> @@ -40,15 +41,13 @@ struct dma_buf_list {
>  
>  static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>  {
> -	struct dma_buf *dmabuf;
>  	char name[DMA_BUF_NAME_LEN];
>  	size_t ret = 0;
>  
> -	dmabuf = dentry->d_fsdata;
> -	dma_resv_lock(dmabuf->resv, NULL);
> -	if (dmabuf->name)
> -		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
> -	dma_resv_unlock(dmabuf->resv);
> +	spin_lock(&dentry->d_lock);

Are you sure this lock always protects d_fsdata?

> +	if (dentry->d_fsdata)
> +		ret = strlcpy(name, dentry->d_fsdata, DMA_BUF_NAME_LEN);
> +	spin_unlock(&dentry->d_lock);
>  
>  	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
>  			     dentry->d_name.name, ret > 0 ? name : "");

If the above check fails the name will be what?  How could d_name.name
be valid but d_fsdata not be valid?


> @@ -80,12 +79,16 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
>  static int dma_buf_release(struct inode *inode, struct file *file)
>  {
>  	struct dma_buf *dmabuf;
> +	struct dentry *dentry = file->f_path.dentry;
>  
>  	if (!is_dma_buf_file(file))
>  		return -EINVAL;
>  
>  	dmabuf = file->private_data;
>  
> +	spin_lock(&dentry->d_lock);
> +	dentry->d_fsdata = NULL;
> +	spin_unlock(&dentry->d_lock);
>  	BUG_ON(dmabuf->vmapping_counter);
>  
>  	/*
> @@ -343,6 +346,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>  	}
>  	kfree(dmabuf->name);
>  	dmabuf->name = name;
> +	dmabuf->file->f_path.dentry->d_fsdata = name;

You are just changing the use of d_fsdata from being a pointer to the
dmabuf to being a pointer to the name string?  What's to keep that name
string around and not have the same reference counting issues that the
dmabuf structure itself has?  Who frees that string memory?

thanks,

greg k-h
