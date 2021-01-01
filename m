Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E34C2E8588
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbhAAU2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbhAAU2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:28:31 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F03C061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:27:51 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qw4so28854691ejb.12
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dna0BjHGb1xRd1e96hqCTDimSUF/8BPWZRaZai9NbVk=;
        b=eDL/dyXzENmKwmLcJzlomMBOx4+97kMIsAuwa6PMLe3588inzapzHA7WNvfmIAO0ri
         xgcNU9ml/F8itbO+29xsd8v/YAj8ag2yf/PpKJqOHI6b/GMEJJ5hHwzr4QzpAPfNCieH
         svxhfs9UFl/VoDD3bGqmfRWfej4jJZAwALzgw0eP1sOim+kRNskcOduN93ZOmo0klgZn
         X3MHHh4blb7P7J+GgRwJ/A2TwZma8vBvpA3udGQvCvUfCm4uVQKnipo72CW1ZXgnbBsD
         wN5KpyfkpaibpjN+X8vMUqqn7wRcCZLkaKKqTKfme0YbOnI2DlFdRnXwE8+kCjGiTLhc
         JFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Dna0BjHGb1xRd1e96hqCTDimSUF/8BPWZRaZai9NbVk=;
        b=m6jL2vM24z3sGn7g3e8lnVr+2WxlQgluuL2HEotCSyYe2TExeikuU+NCbOXI1Q+ZhV
         MpX5t9uhFjqoLwx6SsvRBkI9oG8lhag16FDaBKZ3cW6FgWAQ0LoiTrrRacR8Hd8sS2MU
         WiTCZRV5DIYtIByOBVAlIGmkiwzRYldXI8zsNXGgaXgIWm982X0ORqGZMRGndgcF4Vuj
         imevwjwgYEKGwesfh8BcUQ4xvKt/KYFrpCMOpAhn1INdmPHzaBYsBwklgrU4nfuhKm1p
         25nVSJ9uux2wKiKzmzobDdXEwKqCgHbrgO1Z/zzvCoFVUZeKACZY4zrU2VOFnrzkJ3m5
         Z2Ig==
X-Gm-Message-State: AOAM530QcE3+NFGzzR+B/IXKJISLAoaplomL5/fRQlkgG8fve/u3QL9+
        M+ETFY4hKDGK5Q/kPwc3izoEpMpTve5q9A==
X-Google-Smtp-Source: ABdhPJyPGAGWdRvvj4NJdYL5h/LGWxkP0luXVCldubG9AI9BjNsr0ZWo6RWf0YdbUhECsvoBZXENuw==
X-Received: by 2002:a17:906:cc8c:: with SMTP id oq12mr59826799ejb.419.1609532869985;
        Fri, 01 Jan 2021 12:27:49 -0800 (PST)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id d18sm40946335edz.14.2021.01.01.12.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:27:49 -0800 (PST)
Date:   Fri, 1 Jan 2021 21:27:47 +0100
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tools headers UAPI: Sync linux/const.h with the
 kernel headers
Message-ID: <X++Fw3tSmvOOA1V2@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210101202245.27409-1-petr.vorel@gmail.com>
 <20210101202245.27409-2-petr.vorel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210101202245.27409-2-petr.vorel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Arnaldo Carvalho de Melo <acme@redhat.com>

> commit 7ddcdea5b54492f54700f427f58690cf1e187e5e upstream.

> To pick up the changes in:

>   a85cbe6159ffc973 ("uapi: move constants from <linux/kernel.h> to <linux/const.h>")

> That causes no changes in tooling, just addresses this perf build
> warning:

>   Warning: Kernel ABI header at 'tools/include/uapi/linux/const.h' differs from latest version at 'include/uapi/linux/const.h'
>   diff -u tools/include/uapi/linux/const.h include/uapi/linux/const.h

> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Petr Vorel <petr.vorel@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> ---
> Fix for previous commit.
For stable/linux-5.4.y.

Kind regards,
Petr

> Kind regards,
> Petr

>  tools/include/uapi/linux/const.h | 5 +++++
>  1 file changed, 5 insertions(+)

> diff --git a/tools/include/uapi/linux/const.h b/tools/include/uapi/linux/const.h
> index 5ed721ad5b19..af2a44c08683 100644
> --- a/tools/include/uapi/linux/const.h
> +++ b/tools/include/uapi/linux/const.h
> @@ -28,4 +28,9 @@
>  #define _BITUL(x)	(_UL(1) << (x))
>  #define _BITULL(x)	(_ULL(1) << (x))

> +#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> +#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> +
> +#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> +
>  #endif /* _UAPI_LINUX_CONST_H */
