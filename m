Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE245E9BE
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 09:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344107AbhKZJCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 04:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbhKZJAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 04:00:30 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E65FC0613E0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 00:56:31 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u1so17013800wru.13
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 00:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dPlVAyhM7mWjQgSm+rkqlA38aq0g0RUSzLsuhSHe1c0=;
        b=M2qkUwX9kDrUlv9oKv+7vhdqedOLBEuoLyRLqQWe+3rcLclJf43nfTm65nYeIcg/yj
         kG7AhgGAfe5wwokn0yiIeC2JmSeiO7lbtNehWZ8hjJnTzIA2USWt1F7zj7VfoP2oHKVp
         /OoYcLRwiqd1T1V4cmZFT1DgBrHvNNU5eYkhyHfm8zehzmjVg6iNnbdG6pATwuDuMg3w
         FSVlgEpcbdKD1c+4LmjLUEKQeZ33onBpMzyzc5e48j0R0Gz7dDbOl/xulXhk+n5GMOTt
         pwlkyMztvPflpizFy7zNQ7o8DFEldTwIHB8Ql1t4V3/JnxzPbVyH7CPRHnBNy7KwOpQ9
         hoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dPlVAyhM7mWjQgSm+rkqlA38aq0g0RUSzLsuhSHe1c0=;
        b=3qCk4MQQgRG6i+epOnYrmKZCxxhJn2BLNcm80mMz003BG9SmR+tV4Xab71dfIY3qaJ
         On66fUdcGmJwYz80K4ttqSPaEVAm7cVP2fUasJpeI31+b8PI7+ZBaU0hEdBiok5bReL2
         Z3mglSnCm+iJgVJQhooLuqKc01aR6MrRlScOSyPxzrMqnTdvapAdK/OlMyyFA2EejIEh
         dP2+3zqfM9o/RcJp5kmRKux5ZGPUtnaFYjE1fXK78Mih401HIhq5CTsFtWrxCdcq2d+V
         VDm250SgE00mE6CK0XCWXDbh1kxtCaRLwGxlWF/LAIeILnuEt0qaavz/F9NSalxqOM7P
         eT8Q==
X-Gm-Message-State: AOAM532DHDHZyvKuzJ4SZhOxz5M3igju9fBIjUAVDiyPLn03EGl9o/t8
        oIy4ZdaEkXMHCjtEMogoZCCOKg==
X-Google-Smtp-Source: ABdhPJyYmrMo4WedZNLK4ZSZEF5jQmcupPD8SVApxovJ/ngdNZxp27pbwryBXlfh69MPDudqggeDrw==
X-Received: by 2002:adf:ed52:: with SMTP id u18mr12461534wro.609.1637916990020;
        Fri, 26 Nov 2021 00:56:30 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id d7sm4776440wrw.87.2021.11.26.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 00:56:29 -0800 (PST)
Date:   Fri, 26 Nov 2021 08:56:27 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, riandrews@android.com,
        stable@vger.kernel.org, arve@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YaChOzfm2/3gY4o3@google.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
 <20211126071641.GO6514@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211126071641.GO6514@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Nov 2021, Dan Carpenter wrote:

> On Thu, Nov 25, 2021 at 06:18:22PM +0300, Dan Carpenter wrote:
> > I had thought that ->kmap_cnt was a regular int and not an unsigned
> > int, but I would have to pull a stable tree to see where I misread the
> > code.
> 
> I was looking at (struct ion_buffer)->kmap_cnt but this is
> (struct ion_handle)->kmap_cnt.  I'm not sure how those are related but
> it makes me nervous that one can go higher than the other.  Also both
> probably need overflow protection.
> 
> So I guess I would just do something like:
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 806e9b30b9dc8..e8846279b33b5 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -489,6 +489,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
>  	void *vaddr;
>  
>  	if (buffer->kmap_cnt) {
> +		if (buffer->kmap_cnt == INT_MAX)
> +			return ERR_PTR(-EOVERFLOW);
>  		buffer->kmap_cnt++;
>  		return buffer->vaddr;
>  	}
> @@ -509,6 +511,8 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
>  	void *vaddr;
>  
>  	if (handle->kmap_cnt) {
> +		if (handle->kmap_cnt == INT_MAX)
> +			return ERR_PTR(-EOVERFLOW);
>  		handle->kmap_cnt++;
>  		return buffer->vaddr;
>  	}

Which is all well and good until somebody changes the type.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
