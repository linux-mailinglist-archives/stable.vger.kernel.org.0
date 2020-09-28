Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2F127B054
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgI1OwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgI1OwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:52:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601304731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJU0r/PAK2mgw0yQKK07zn+s+oIn+bBBFmBJP1r2lng=;
        b=DKu2qx5AhoK1NvM2FHsZdUwRpTMZNhvOiFYWSt7WV+rbMTlEva8sCDd6w0FqEnyVlEkuyz
        MSpaqhuL/RsN+NLwiIx5Hlui9ubj8DzFRBxbs3xnCVTaBhhnpFywmfpL69q0sAK05ky7rQ
        vL5L3jbN6SKVJZ6FQbw4BzJPiDz8SUI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-XLbQvCGVOUuGjtnr8CSmYQ-1; Mon, 28 Sep 2020 10:52:09 -0400
X-MC-Unique: XLbQvCGVOUuGjtnr8CSmYQ-1
Received: by mail-wr1-f69.google.com with SMTP id f18so499202wrv.19
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 07:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJU0r/PAK2mgw0yQKK07zn+s+oIn+bBBFmBJP1r2lng=;
        b=rPmc6eaBRirXDUJsAIklsApm7WezpIqGLRAZjPQH+3Upcjv+IVZnyK1w1xgm45MQ+s
         +czGkVMLSZtb96RF8LRgUni2DWYu2O01DREiz5GWROTKLGe243UvqbAGwbNqAlisSWAW
         J5oXzpfncsYHL5E0mFSBf0NMaoQLziUbBSERqEokeSImGIhxbz517YpavPLieVShp03q
         WlF2+pSaa8tLAKEgI3e/zCo8bfkzx8FLAvdwJGpwbRx9MrDxGuQiLBcA02BQIMvRXnyE
         LoG+CQADtN/2LS+j5ygIWXmxUXBK735CTgvLOoIXNvSvWcr+//TNLvbZZLmJWsBeq5tH
         MuXg==
X-Gm-Message-State: AOAM533W6DcV4EyhKhc4HKsz93q0gRWLSrMHYj/6ejuyHFv1RDqbIRTJ
        qrJ9joBIr2N57/2Tldh5Q19gK1Nv0uJ46J8A1YEuOeCUbVloqsDecsEDv/T1Ba1KFtJpcPbsidm
        juA9TuOOFgSnRc4X8
X-Received: by 2002:a1c:bb06:: with SMTP id l6mr2089691wmf.175.1601304728357;
        Mon, 28 Sep 2020 07:52:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHN4bGETpXiv5ZQj2cENGByWnva+13LogKnBri+IrtfQYnrG07MiMtZT3cJOAUwwU/Ez05ag==
X-Received: by 2002:a1c:bb06:: with SMTP id l6mr2089661wmf.175.1601304728084;
        Mon, 28 Sep 2020 07:52:08 -0700 (PDT)
Received: from steredhat (host-79-13-204-53.retail.telecomitalia.it. [79.13.204.53])
        by smtp.gmail.com with ESMTPSA id h3sm1980682wrq.0.2020.09.28.07.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 07:52:07 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:52:04 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     axboe@kernel.dk
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure open/openat2 name is
 cleaned on cancelation" failed to apply to 5.8-stable tree
Message-ID: <20200928145204.2kgheql4qfffz5s3@steredhat>
References: <1601301865177128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601301865177128@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jens, if you want I can do the backport for 5.8.

Stefano

On Mon, Sep 28, 2020 at 04:04:25PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From f3cd4850504ff612d0ea77a0aaf29b66c98fcefe Mon Sep 17 00:00:00 2001
> From: Jens Axboe <axboe@kernel.dk>
> Date: Thu, 24 Sep 2020 14:55:54 -0600
> Subject: [PATCH] io_uring: ensure open/openat2 name is cleaned on cancelation
> 
> If we cancel these requests, we'll leak the memory associated with the
> filename. Add them to the table of ops that need cleaning, if
> REQ_F_NEED_CLEANUP is set.
> 
> Cc: stable@vger.kernel.org
> Fixes: e62753e4e292 ("io_uring: call statx directly")
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e6004b92e553..0ab16df31288 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5671,6 +5671,11 @@ static void __io_clean_op(struct io_kiocb *req)
>  			io_put_file(req, req->splice.file_in,
>  				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
>  			break;
> +		case IORING_OP_OPENAT:
> +		case IORING_OP_OPENAT2:
> +			if (req->open.filename)
> +				putname(req->open.filename);
> +			break;
>  		}
>  		req->flags &= ~REQ_F_NEED_CLEANUP;
>  	}
> 

