Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC442A1A8
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 12:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhJLKIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 06:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235534AbhJLKIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 06:08:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D487360698;
        Tue, 12 Oct 2021 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634033183;
        bh=afRaiB2x46Dy5EwPdZ0GaOyJyMOe/U1RoFhf+sQW94k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1CdakWEr955c3rxOuGkNsleaaeIP4jvOURkXyKGQ16kXeHMi1IT07zKNSblMHbJLW
         y1/rppdbRKcWEjGQtBQVm9JrY9SSSVYlhhNCli9m4i6LNUBa+10tkPiE9D1rxzWUtM
         U9vIuE2/exPIfXhX/zREsXLN7fov6zO63Yxgsw88=
Date:   Tue, 12 Oct 2021 12:06:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     stable@vger.kernel.org, jannh@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com, hch@lst.de,
        oleg@redhat.com, kirill@shutemov.name, jack@suse.cz,
        willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Message-ID: <YWVeHbWp3kqf7Hyj@kroah.com>
References: <20211012015244.693594-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012015244.693594-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 06:52:44PM -0700, Suren Baghdasaryan wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.

Both backports now queued up, thanks.

greg k-h
