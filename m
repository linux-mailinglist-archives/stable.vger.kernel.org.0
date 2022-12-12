Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7612B64A225
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiLLNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiLLNta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:49:30 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011812620;
        Mon, 12 Dec 2022 05:49:21 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso5190276wme.5;
        Mon, 12 Dec 2022 05:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMzRkMMjSU4aJEZO827x0ihXjxjaMrKMObfU28boQDs=;
        b=jCu5h2zKA4iyuE40Ez5NWetZAH7PIzKMupyd2HvVqZe6FMX0rVFTes6g2VFr/yvawq
         HbWRXogz11Y+I47mhmUD4aznRTFoZEOZN6al56/nNlXeqktf+AjCGjpE4el9DtYKKmnQ
         sklm7vfhpGVN/ONsgrmQhCiHp+i8oOJpHXRMMeYjHEPEvZ39ZPq0giw0MTfNFvDfaK2Q
         BZi5Xz788a7eOxhKKu6mmoK2VLv5h9EiPGgKloJXzUiR+VSZrcK44VQdN4tuZ2o23jio
         MS1myL3FeeuSHWqv7ejq1dzEG+jds2q7wsi27EOOrIYUGwBjG/0AGjmkwZg+fx9dO9R/
         VJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMzRkMMjSU4aJEZO827x0ihXjxjaMrKMObfU28boQDs=;
        b=AhkBudamjPj2rKBketMLLw8b6JheRIpc6ULdSvyBLpnNGiHXB3zhZTZA5CgFHEF9oN
         X9RzxGyvkL0zofeui919vTEqRdVlyr65RkQtVjjZIx5KP7VLXhsQTzcToz9slNpqU1Ba
         Rj5to8VDawOs9lV6te+2uG8otwZz/NNDl5yIDiR6PSLNM6KQ0qFpaKX2YzchIHV3EQv2
         lWJ2njltcauG18TXXLBP+QQNhOEZaRb/LyB/HFVlS/eH51n6wJWSpdxhYWWpymZ9xryE
         QS0bKpB3yTdNmJXWVj+4YizI0bH/jGzmGi2udzl6nPAKFBwGKwrogY4Qy9SPRm1gTVox
         0Rew==
X-Gm-Message-State: ANoB5pnVoc6VhijGJODsWNaKzWJsyTbWUemX/yZYBXloEk45l0U+FZPB
        uT2HvkXw8S/X8IYRcSKPaDs=
X-Google-Smtp-Source: AA0mqf6maMa4WcXRcvhdMnv1l/9rgQcRIvpUePdM3Ur1GffCsn7GrZ98YsRPG5i6culYFniArIa9dg==
X-Received: by 2002:a05:600c:1d02:b0:3cf:d365:1ea3 with SMTP id l2-20020a05600c1d0200b003cfd3651ea3mr12833700wms.12.1670852960150;
        Mon, 12 Dec 2022 05:49:20 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b003cfaae07f68sm10137258wms.17.2022.12.12.05.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:49:19 -0800 (PST)
Date:   Mon, 12 Dec 2022 16:49:15 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y5cxW7xc+pegcbNv@kadam>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> Function pointer ki_complete() expects 'long' as its second
> argument, but we pass integer from ffs_user_copy_worker. This
> might cause a CFI failure, as ki_complete is an indirect call
> with mismatched prototype. Fix this by typecasting the second
> argument to long.
> 
> Cc: <stable@vger.kernel.org> # 5.15
> Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
> 
> ---
>  drivers/usb/gadget/function/f_fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 73dc10a7..9c26561 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -835,7 +835,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  		kthread_unuse_mm(io_data->mm);
>  	}
>  
> -	io_data->kiocb->ki_complete(io_data->kiocb, ret);
> +	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);

I don't understand this commit at all.  CFI is Control Flow Integrity
or Common Flash Interface depending on which subsystem we're talking
about.

I really think that Clang needs to be fixed if this really causes an
issue for Clang.  How on earth are we going to know where to add all
the casts?

The commit message says "this might cause a CFI" failure.  Either it
does or it doesn't.  Please someone test this so we can know what's
going on.

Why is it backported to 5.15?  I thought CFI was not going to backported
that far and I has seen people complaining about CFI backports.

regards,
dan carpenter

