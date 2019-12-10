Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6BA119624
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLJVZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:25:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54996 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbfLJVKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:10:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so4780142wmj.4;
        Tue, 10 Dec 2019 13:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=3lgD8jI6V5laG2eEECBwIbFtUGhgPn+ozPUojDMHqx4=;
        b=EvTKnWTq8dZZ+JzmB3oNlj4jYRmncO6LtV2eHrWcEUvQzmOLCdvdxfLinZ1vWQkJMN
         h9Q4h4G8PzKQAItd/lPKtLSTn//Kpz4pY5S6G2YSXs19uouHqvYBSo1akqwSGG+ZXkq9
         FTzwYu2NMGgKYpB8EWOt6KefPIcdpagWOzvq6NcRpb1w/eTNC5BhGZVqAYYVnDtcsmib
         gZ7awzraVnHRdlemSNkV1e8FKNMjAZ+SQwpD+2VAntEbHeaHiZNm7TdP36yn0AtPQZQx
         O6xY5TARQ5NwllwJFXBrxYjE5YAdwX7zseLKGO38UITPF9MLuZ+6VAJgJTtoMVh9kbqO
         RqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=3lgD8jI6V5laG2eEECBwIbFtUGhgPn+ozPUojDMHqx4=;
        b=kWWwkWM5T9BUhyWcAZrnqKZ21XL9SYfcAfWRRcQQTygbV6WyHGqc/DaiEL506VobIk
         ERrk6O8mSw4ng0ONRgyNZvmZsmro6pGKnXyxR2iSRQNqehcQb5uaNc19m0kMNn/wL59P
         +e51iYpur89OSp7+a77lTcTnaZtNHT1bDC1sVn+9vDV+S/LGyBQMX/tZONhoGww4nWFS
         U2g9RBZ6R854350BLX0vZZc5afvV9P5jIvb8yJyEOo5BdECIqRw/douO0DEosMLISBUY
         mNvAe+7u8pLoL2Nv0rDPZz1pUYChPErhQ0b1pSs2XmgyC+X1w+0u89uSe8h4dp+ozrna
         3Kag==
X-Gm-Message-State: APjAAAUL0a1gNYoXbrCrRNhyVY1QtaE7yV36ufqIU0HiyjjcH7fsUiXs
        AjCfmOop4tnoivITav4C2Zm4/aTy
X-Google-Smtp-Source: APXvYqw3Ke5ppL3tva3mALmj9rj/Z74YJD974mLulEIZXmTMjI+uBFvIrc41p13nkh2y/MCBE5uRIw==
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr7712589wma.91.1576012239150;
        Tue, 10 Dec 2019 13:10:39 -0800 (PST)
Received: from [192.168.43.162] ([109.126.132.112])
        by smtp.gmail.com with ESMTPSA id x1sm4580972wru.50.2019.12.10.13.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 13:10:38 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
Message-ID: <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
Date:   Wed, 11 Dec 2019 00:10:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210155742.5844-2-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WPtea0RmqwL8vRuuunHx6gJJuxyyHbIOM"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WPtea0RmqwL8vRuuunHx6gJJuxyyHbIOM
Content-Type: multipart/mixed; boundary="hbIioaicp1o7VIClmS6XTY4dSEqHxojMa";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: stable@vger.kernel.org, =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
Message-ID: <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
In-Reply-To: <20191210155742.5844-2-axboe@kernel.dk>

--hbIioaicp1o7VIClmS6XTY4dSEqHxojMa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Apart from debug code (see comments below) io_uring part of
the patchset looks good.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

On 10/12/2019 18:57, Jens Axboe wrote:
> Some commands will invariably end in a failure in the sense that the
> completion result will be less than zero. One such example is timeouts
> that don't have a completion count set, they will always complete with
> -ETIME unless cancelled.
>=20
> For linked commands, we sever links and fail the rest of the chain if
> the result is less than zero. Since we have commands where we know that=

> will happen, add IOSQE_IO_HARDLINK as a stronger link that doesn't seve=
r
> regardless of the completion result. Note that the link will still seve=
r
> if we fail submitting the parent request, hard links are only resilient=

> in the presence of completion results for requests that did submit
> correctly.
>=20
> Cc: stable@vger.kernel.org # v5.4
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Reported-by: =E6=9D=8E=E9=80=9A=E6=B4=B2 <carter.li@eoitek.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c                 | 96 ++++++++++++++++++++---------------=

>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 56 insertions(+), 41 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 405be10da73d..4cda61fe67da 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -377,6 +377,7 @@ struct io_kiocb {
>  #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
>  #define REQ_F_INFLIGHT		16384	/* on inflight list */
>  #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
> +#define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
>  	u64			user_data;
>  	u32			result;
>  	u32			sequence;
> @@ -1292,6 +1293,12 @@ static void kiocb_end_write(struct io_kiocb *req=
)
>  	file_end_write(req->file);
>  }
> =20
> +static inline void req_set_fail_links(struct io_kiocb *req)
> +{
> +	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) =3D=3D REQ_F_LINK)
> +		req->flags |=3D REQ_F_FAIL_LINK;
> +}
> +
>  static void io_complete_rw_common(struct kiocb *kiocb, long res)
>  {
>  	struct io_kiocb *req =3D container_of(kiocb, struct io_kiocb, rw);
> @@ -1299,8 +1306,8 @@ static void io_complete_rw_common(struct kiocb *k=
iocb, long res)
>  	if (kiocb->ki_flags & IOCB_WRITE)
>  		kiocb_end_write(req);
> =20
> -	if ((req->flags & REQ_F_LINK) && res !=3D req->result)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (res !=3D req->result)
> +		req_set_fail_links(req);
>  	io_cqring_add_event(req, res);
>  }
> =20
> @@ -1330,8 +1337,8 @@ static void io_complete_rw_iopoll(struct kiocb *k=
iocb, long res, long res2)
>  	if (kiocb->ki_flags & IOCB_WRITE)
>  		kiocb_end_write(req);
> =20
> -	if ((req->flags & REQ_F_LINK) && res !=3D req->result)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (res !=3D req->result)
> +		req_set_fail_links(req);
>  	req->result =3D res;
>  	if (res !=3D -EAGAIN)
>  		req->flags |=3D REQ_F_IOPOLL_COMPLETED;
> @@ -1956,8 +1963,8 @@ static int io_fsync(struct io_kiocb *req, const s=
truct io_uring_sqe *sqe,
>  				end > 0 ? end : LLONG_MAX,
>  				fsync_flags & IORING_FSYNC_DATASYNC);
> =20
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_cqring_add_event(req, ret);
>  	io_put_req_find_next(req, nxt);
>  	return 0;
> @@ -2003,8 +2010,8 @@ static int io_sync_file_range(struct io_kiocb *re=
q,
> =20
>  	ret =3D sync_file_range(req->rw.ki_filp, sqe_off, sqe_len, flags);
> =20
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_cqring_add_event(req, ret);
>  	io_put_req_find_next(req, nxt);
>  	return 0;
> @@ -2079,8 +2086,8 @@ static int io_sendmsg(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe,
> =20
>  out:
>  	io_cqring_add_event(req, ret);
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req_find_next(req, nxt);
>  	return 0;
>  #else
> @@ -2161,8 +2168,8 @@ static int io_recvmsg(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe,
> =20
>  out:
>  	io_cqring_add_event(req, ret);
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req_find_next(req, nxt);
>  	return 0;
>  #else
> @@ -2196,8 +2203,8 @@ static int io_accept(struct io_kiocb *req, const =
struct io_uring_sqe *sqe,
>  	}
>  	if (ret =3D=3D -ERESTARTSYS)
>  		ret =3D -EINTR;
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_cqring_add_event(req, ret);
>  	io_put_req_find_next(req, nxt);
>  	return 0;
> @@ -2263,8 +2270,8 @@ static int io_connect(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe,
>  	if (ret =3D=3D -ERESTARTSYS)
>  		ret =3D -EINTR;
>  out:
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_cqring_add_event(req, ret);
>  	io_put_req_find_next(req, nxt);this and
>  	return 0;
> @@ -2340,8 +2347,8 @@ static int io_poll_remove(struct io_kiocb *req, c=
onst struct io_uring_sqe *sqe)
>  	spin_unlock_irq(&ctx->completion_lock);
> =20
>  	io_cqring_add_event(req, ret);
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req(req);
>  	return 0;
>  }
> @@ -2399,8 +2406,8 @@ static void io_poll_complete_work(struct io_wq_wo=
rk **workptr)
> =20
>  	io_cqring_ev_posted(ctx);
> =20
> -	if (ret < 0 && req->flags & REQ_F_LINK)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req_find_next(req, &nxt);
>  	if (nxt)
>  		*workptr =3D &nxt->work;
> @@ -2582,8 +2589,7 @@ static enum hrtimer_restart io_timeout_fn(struct =
hrtimer *timer)
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> =20
>  	io_cqring_ev_posted(ctx);
> -	if (req->flags & REQ_F_LINK)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	req_set_fail_links(req);
>  	io_put_req(req);
>  	return HRTIMER_NORESTART;
>  }
> @@ -2608,8 +2614,7 @@ static int io_timeout_cancel(struct io_ring_ctx *=
ctx, __u64 user_data)
>  	if (ret =3D=3D -1)
>  		return -EALREADY;
> =20
> -	if (req->flags & REQ_F_LINK)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	req_set_fail_links(req);
>  	io_cqring_fill_event(req, -ECANCELED);
>  	io_put_req(req);
>  	return 0;
> @@ -2640,8 +2645,8 @@ static int io_timeout_remove(struct io_kiocb *req=
,
>  	io_commit_cqring(ctx);
>  	spin_unlock_irq(&ctx->completion_lock);
>  	io_cqring_ev_posted(ctx);
> -	if (ret < 0 && req->flags & REQ_F_LINK)
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req(req);
>  	return 0;
>  }
> @@ -2655,13 +2660,19 @@ static int io_timeout_prep(struct io_kiocb *req=
, struct io_async_ctx *io,
> =20
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> -	if (sqe->ioprio || sqe->buf_index || sqe->len !=3D 1)
> +	if (sqe->ioprio || sqe->buf_index || sqe->len !=3D 1) {
> +		printk("1\n");

debug output

>  		return -EINVAL;
> -	if (sqe->off && is_timeout_link)
> +	}
> +	if (sqe->off && is_timeout_link) {
> +		printk("2\n");

same

>  		return -EINVAL;
> +	}
>  	flags =3D READ_ONCE(sqe->timeout_flags);
> -	if (flags & ~IORING_TIMEOUT_ABS)
> +	if (flags & ~IORING_TIMEOUT_ABS) {
> +		printk("3\n");

same

>  		return -EINVAL;
> +	}
> =20
>  	data =3D &io->timeout;
>  	data->req =3D req;
> @@ -2822,8 +2833,8 @@ static void io_async_find_and_cancel(struct io_ri=
ng_ctx *ctx,
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>  	io_cqring_ev_posted(ctx);
> =20
> -	if (ret < 0 && (req->flags & REQ_F_LINK))
> -		req->flags |=3D REQ_F_FAIL_LINK;
> +	if (ret < 0)
> +		req_set_fail_links(req);
>  	io_put_req_find_next(req, nxt);
>  }
> =20
> @@ -3044,8 +3055,7 @@ static void io_wq_submit_work(struct io_wq_work *=
*workptr)
>  	io_put_req(req);
> =20
>  	if (ret) {
> -		if (req->flags & REQ_F_LINK)
> -			req->flags |=3D REQ_F_FAIL_LINK;
> +		req_set_fail_links(req);
>  		io_cqring_add_event(req, ret);
>  		io_put_req(req);
>  	}
> @@ -3179,8 +3189,7 @@ static enum hrtimer_restart io_link_timeout_fn(st=
ruct hrtimer *timer)
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> =20
>  	if (prev) {
> -		if (prev->flags & REQ_F_LINK)
> -			prev->flags |=3D REQ_F_FAIL_LINK;
> +		req_set_fail_links(prev);
>  		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
>  						-ETIME);
>  		io_put_req(prev);
> @@ -3273,8 +3282,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  	/* and drop final reference, if we failed */
>  	if (ret) {
>  		io_cqring_add_event(req, ret);
> -		if (req->flags & REQ_F_LINK)
> -			req->flags |=3D REQ_F_FAIL_LINK;
> +		req_set_fail_links(req);
>  		io_put_req(req);
>  	}
>  }
> @@ -3293,8 +3301,7 @@ static void io_queue_sqe(struct io_kiocb *req)
>  	if (ret) {
>  		if (ret !=3D -EIOCBQUEUED) {
>  			io_cqring_add_event(req, ret);
> -			if (req->flags & REQ_F_LINK)
> -				req->flags |=3D REQ_F_FAIL_LINK;
> +			req_set_fail_links(req);
>  			io_double_put_req(req);
>  		}
>  	} else
> @@ -3311,7 +3318,8 @@ static inline void io_queue_link_head(struct io_k=
iocb *req)
>  }
> =20
> =20
> -#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK=
)
> +#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK=
|	\
> +				IOSQE_IO_HARDLINK)
> =20
>  static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state=
 *state,
>  			  struct io_kiocb **link)
> @@ -3349,6 +3357,9 @@ static bool io_submit_sqe(struct io_kiocb *req, s=
truct io_submit_state *state,
>  		if (req->sqe->flags & IOSQE_IO_DRAIN)
>  			(*link)->flags |=3D REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
> =20
> +		if (req->sqe->flags & IOSQE_IO_HARDLINK)
> +			req->flags |=3D REQ_F_HARDLINK;
> +
>  		io =3D kmalloc(sizeof(*io), GFP_KERNEL);
>  		if (!io) {
>  			ret =3D -EAGAIN;
> @@ -3358,13 +3369,16 @@ static bool io_submit_sqe(struct io_kiocb *req,=
 struct io_submit_state *state,
>  		ret =3D io_req_defer_prep(req, io);
>  		if (ret) {
>  			kfree(io);
> +			/* fail even hard links since we don't submit */
>  			prev->flags |=3D REQ_F_FAIL_LINK;
>  			goto err_req;
>  		}
>  		trace_io_uring_link(ctx, req, prev);
>  		list_add_tail(&req->link_list, &prev->link_list);
> -	} else if (req->sqe->flags & IOSQE_IO_LINK) {
> +	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  		req->flags |=3D REQ_F_LINK;
> +		if (req->sqe->flags & IOSQE_IO_HARDLINK)
> +			req->flags |=3D REQ_F_HARDLINK;
> =20
>  		INIT_LIST_HEAD(&req->link_list);
>  		*link =3D req;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_urin=
g.h
> index eabccb46edd1..ea231366f5fd 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -48,6 +48,7 @@ struct io_uring_sqe {
>  #define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
>  #define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
>  #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
> +#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
> =20
>  /*
>   * io_uring_setup() flags
>=20

--=20
Pavel Begunkov


--hbIioaicp1o7VIClmS6XTY4dSEqHxojMa--

--WPtea0RmqwL8vRuuunHx6gJJuxyyHbIOM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3wCboACgkQWt5b1Glr
+6VB/xAAg6V7B3sthNbu8aKaRYoU/6HxkWb7Jhzp8mgr1D08dEkGPAhq2Wul25TT
DsafMHUO7O/x2MHAauGH44uYwxhHwACBqpnOwBVcgcrqEqTqaYxTpFZxPwBsXHmR
OkSqYFo40LabYyaIsYWM0erS8UbwKp/Jr6QVvqSdM8otloIlZdvTqkjYsbKsYPal
7L0nGvU6IAhP47BZqn9nt9RGbqqAnlvU9GkUWKl0ZJNTk0EZRmCRWher45BWxuiL
VtAL7hRYsULayEhuFd8lSVsnlSZEeHe40EmE3sicNU9d7hYv3U/DCb0JwkJSKdrr
GsshrUXodQHoNROUqkliB1Ec5gWVVDSOGdlQrw6+qh7qMxzVSonc4BRbBpZ2S7Ew
xLjvj0TZ7PMYpoxk9G0+1NXDaPLBvEBQ5mzNEjugFULsHPEJZ620/rT1YdFcCyHC
IJ/hxuwHenZQuYn6Os3cQ9RT2SkID28zlyDSA5B7YYASRN+uDlggC0fg1psZxrUE
GfNagKiFZZvTDITvuGCMAEbjVBrvsqUQMtqbpHp/u7PFY6LCtmOhoPrGo+Mz3rUq
UX1WqCJ2K/e1CfdvqQphzLYt3pmcvpGyhM7c5QzUZJmVoCHTep91CflXoDuV2YYx
/97nw8SZQTUEObbk2Z99p9OjKB1prebV0JFg+02uc/nB4D779ns=
=VcDo
-----END PGP SIGNATURE-----

--WPtea0RmqwL8vRuuunHx6gJJuxyyHbIOM--
