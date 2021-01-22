Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EB3300924
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 18:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbhAVQ7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 11:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbhAVQ6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 11:58:12 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B396AC06174A;
        Fri, 22 Jan 2021 08:55:49 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id d11so2938504qvo.11;
        Fri, 22 Jan 2021 08:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4C4c7hWhmjfrfZNOtXE6L3e5KVZSdKUbx3wD06pMIgQ=;
        b=Jb7M4YIKFihi4G+3Y9ZhsspJ6QHYBWTyX0+6wrxV7vOONHdmaJyT1mPpFAvRSBZFmj
         noJZUMkwM+u+dCQd/Qh44FwEC4gs9uAt/+VCzrxIl5jXLV+KjNo1pey1r5G2yp4Ykb6E
         02ZOpfGMKOb3Zv1kUk339mW98SR8Z//60IkGxnXG0XiwGImmq2iHd0YELB2EGeD8LU6f
         mf8srYF5IWiye7ON42/KQfk47oJV8biteGYfIPTBW0aS3ULdUSWFBRsjjzqVTZLkL/tE
         025P2OvqlwUtCkLkmo3E/i8fZ/Ebj75qxNiXU+z5hwbMKI+FaAkRXrSw7kFTUGa4uamZ
         qK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4C4c7hWhmjfrfZNOtXE6L3e5KVZSdKUbx3wD06pMIgQ=;
        b=N0SIL3eAktTPBKfOp5kr/ApdeooQ6hw4p0jyecT4CvfcEI9SBhn1iO9IXmlFqBsx13
         vpcyOhJtbmi5XDswZTHsFHouxbGYzh254b9Li3DnDmLfxysUW1MaXNVgN+ehwRNDV65a
         bQ6VP3R3bvH4/njVFrA60eC9xn9nDZegFGYGdaferaxiadrO20B9LYC2BRE09V8vaSV+
         T4jQSP0ivoR1EN1Zcw3l/wXnTnfSiXKpgQfufRS81CtWPrxhD4Hl4onk5RAMs3UDFU6e
         FFble/nfiuv8Gs3SoueDCOephUmBUMn+yqq8EVdZhbTpbyFdtebN2tdNAjYe85IFR5Cl
         ajqA==
X-Gm-Message-State: AOAM530HaOA3COCtXVZf32eHi/NrLMgz1xtrVjfjgbUIKsIdKwMWY4lm
        akubSxls13Nc+VNBo4fSi0g=
X-Google-Smtp-Source: ABdhPJxmTaxhoOPRjIi8owDSK/q0lqiswGfZN7LVcG4byFdcdM5bo7aWX0Dmda2HaRCuAZ2m6jN30A==
X-Received: by 2002:a0c:fc4e:: with SMTP id w14mr5125303qvp.23.1611334548897;
        Fri, 22 Jan 2021 08:55:48 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:4ecb:865e:1ab1:c1d6:3650])
        by smtp.gmail.com with ESMTPSA id e7sm5999382qto.46.2021.01.22.08.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 08:55:48 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id F1416C009A; Fri, 22 Jan 2021 13:55:45 -0300 (-03)
Date:   Fri, 22 Jan 2021 13:55:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 5.4 29/33] net, sctp, filter: remap copy_from_user
 failure error
Message-ID: <20210122165545.GJ3863@horizon.localdomain>
References: <20210122135733.565501039@linuxfoundation.org>
 <20210122135734.750091426@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122135734.750091426@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 03:12:45PM +0100, Greg Kroah-Hartman wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> [ no upstream commit ]
> 
> Fix a potential kernel address leakage for the prerequisite where there is
> a BPF program attached to the cgroup/setsockopt hook. The latter can only
> be attached under root, however, if the attached program returns 1 to then
> run the related kernel handler, an unprivileged program could probe for
> kernel addresses that way. The reason this is possible is that we're under
> set_fs(KERNEL_DS) when running the kernel setsockopt handler. Aside from
> old cBPF there is also SCTP's struct sctp_getaddrs_old which contains
> pointers in the uapi struct that further need copy_from_user() inside the
> handler. In the normal case this would just return -EFAULT, but under a
> temporary KERNEL_DS setting the memory would be copied and we'd end up at
> a different error code, that is, -EINVAL, for both cases given subsequent
> validations fail, which then allows the app to distinguish and make use of
> this fact for probing the address space. In case of later kernel versions
> this issue won't work anymore thanks to Christoph Hellwig's work that got
> rid of the various temporary set_fs() address space overrides altogether.
> One potential option for 5.4 as the only affected stable kernel with the
> least complexity would be to remap those affected -EFAULT copy_from_user()
> error codes with -EINVAL such that they cannot be probed anymore. Risk of
> breakage should be rather low for this particular error case.
> 
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Reported-by: Ryota Shiga (Flatt Security)
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For sctp bits,
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

...
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1319,7 +1319,7 @@ static int __sctp_setsockopt_connectx(st
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
>  	if (IS_ERR(kaddrs))
> -		return PTR_ERR(kaddrs);
> +		return PTR_ERR(kaddrs) == -EFAULT ? -EINVAL : PTR_ERR(kaddrs);
>  
>  	/* Allow security module to validate connectx addresses. */
>  	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_CONNECTX,
> 
> 
