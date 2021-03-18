Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1B634007F
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 08:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCRHy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 03:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhCRHyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 03:54:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EC0C06174A
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 00:54:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g25so2949264wmh.0
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 00:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mxnnsJNyJ/djG/FNEdBUX5hkZ2I4xiEujOVt1/h4/bY=;
        b=ZGBqcyhobhatxNcOhANptkoT10We7BwTrh2qfDWGRunMpszFACGnzHrvUsqjexrWwk
         5/Vt3fTFoUeL0zsVFiAWCJpuSwljpNU1LatCbxc1zK0S4rbFsA+DoUMvAte8+LHp5QIX
         cUhDh+jmbPPydNV7LZAHrPCAxPQ9HDFEcuTr0cNy8trBkVcFtrnNnqNCNFQ8BbKfemMb
         IL+Gc0RKpmMj0vT29t6woEpHQk1kVEHTCRq4lNCH8Dv3JBNv6MBg8IgNP96gr0UnyGit
         XHBmpqkM++EOFdw1LEOGQk1tfSUWcU3KEzWc3f7CLqMmAUzZBDYeEV6xhLcuBE2tAukj
         TRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mxnnsJNyJ/djG/FNEdBUX5hkZ2I4xiEujOVt1/h4/bY=;
        b=pqeZMnFHuP1jETUUB5obYm366zYeD8ds+kSzbFB0o4gNEc6jlnuohmokQh/LCLRl2H
         mc4xtfX2pI2v83CZoZVzSZd+nYUFf+wHnWS1jDGYkIQOXSmbNLR/RbaGKS0Jw/RRWJeK
         zqdM1zkebzQCt9oDYgB5H8pPWhoJwsrw6yo7RNcqsqQ2IHDhzgYZa/Vd1TPEu50UzLdl
         P7v3NFodI7B2i15T0JW7o7FJPLJkQKqvVAOrX7paVQRAUU8yDy7PhvzeX7kBRfT4jEiv
         rZJWTtrtglS2h5LPlT8wpdwDPTOpwFV8vagm+2K0P07Qv9jwJyLBSYgWqYv341YTF98O
         I0GQ==
X-Gm-Message-State: AOAM532avpbYNNJXj30XP8DEHSGeOcIuIsYPu2/bT8QS/5TxE83CDl2l
        2GnenBE9KDXWRrufm+2ikR2CUQZCVvRqgg==
X-Google-Smtp-Source: ABdhPJwjcUijLFfU4VMh9M0BGYbaCtAHz64vKynX3d1CIiZIwyWlNBBhzK6AD0g1Nyq6PdPUXgLrOQ==
X-Received: by 2002:a1c:3c02:: with SMTP id j2mr2318365wma.92.1616054085668;
        Thu, 18 Mar 2021 00:54:45 -0700 (PDT)
Received: from dell ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j30sm2026587wrj.62.2021.03.18.00.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 00:54:45 -0700 (PDT)
Date:   Thu, 18 Mar 2021 07:54:43 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     stable@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
Message-ID: <20210318075443.GB2916463@dell>
References: <20210317235522.2497292-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317235522.2497292-1-gwendal@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Mar 2021, Gwendal Grignou wrote:

> commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.
> 
> Prevent memory scribble by checking that ioctl buffer size parameters
> are sane.
> Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
> .outsize the amount to scribble, we would overflow, allocate a small
> amounts and be able to write outside of the malloc'ed area.
> Adding a hard limit allows argument checking of the ioctl. With the
> current EC, it is expected .insize and .outsize to be at around 512 bytes
> or less.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
>  drivers/platform/chrome/cros_ec_proto.c | 4 ++--
>  include/linux/mfd/cros_ec.h             | 6 ++++--
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
> index 2b331d5b9e799..e16d82bb36a9d 100644
> --- a/drivers/platform/chrome/cros_ec_dev.c
> +++ b/drivers/platform/chrome/cros_ec_dev.c
> @@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
>  	if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
>  		return -EFAULT;
>  
> +	if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
> +	    (u_cmd.insize > EC_MAX_MSG_BYTES))
> +		return -EINVAL;
> +
>  	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
>  			GFP_KERNEL);
>  	if (!s_cmd)
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index 5c285f2b3a650..d20190c8f0c06 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
>  			ec_dev->max_response = EC_PROTO2_MAX_PARAM_SIZE;
>  			ec_dev->max_passthru = 0;
>  			ec_dev->pkt_xfer = NULL;
> -			ec_dev->din_size = EC_MSG_BYTES;
> -			ec_dev->dout_size = EC_MSG_BYTES;
> +			ec_dev->din_size = EC_PROTO2_MSG_BYTES;
> +			ec_dev->dout_size = EC_PROTO2_MSG_BYTES;
>  		} else {
>  			/*
>  			 * It's possible for a test to occur too early when
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 3ab3cede28eac..93c14e9df6309 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -50,9 +50,11 @@ enum {
>  					EC_MSG_TX_TRAILER_BYTES,
>  	EC_MSG_RX_PROTO_BYTES	= 3,
>  
> -	/* Max length of messages */
> -	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
> +	/* Max length of messages for proto 2*/
> +	EC_PROTO2_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
>  					EC_MSG_TX_PROTO_BYTES,

Nit: Better to not tab the '=' so far and place it all on one line.

Checkpatch now only complains about lines exceeding 100 chars.

Once fixed, feel free to apply my:

  Acked-by: Lee Jones <lee.jones@linaro.org>

> +
> +	EC_MAX_MSG_BYTES		= 64 * 1024,
>  };
>  
>  /*

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
