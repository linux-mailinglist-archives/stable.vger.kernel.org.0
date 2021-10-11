Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FBB428938
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhJKI5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 04:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235347AbhJKI47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 04:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1939C60F38;
        Mon, 11 Oct 2021 08:54:56 +0000 (UTC)
Date:   Mon, 11 Oct 2021 10:54:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] vfs: Check fd has read access in
 kernel_read_file_from_fd()
Message-ID: <20211011085454.63yjvaugzsgi6ubd@wittgenstein>
References: <20211007220110.600005-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211007220110.600005-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 11:01:10PM +0100, Matthew Wilcox wrote:
> If we open a file without read access and then pass the fd to a syscall
> whose implementation calls kernel_read_file_from_fd(), we get a warning
> from __kernel_read():
> 
>         if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))
> 
> This currently affects both finit_module() and kexec_file_load(), but
> it could affect other syscalls in the future.
> 
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Fixes: b844f0ecbc56 ("vfs: define kernel_copy_file_from_fd()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Thanks!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
