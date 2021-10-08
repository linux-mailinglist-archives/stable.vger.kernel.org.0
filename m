Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599464272CB
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJHVGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243358AbhJHVGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:06:20 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8559C061755;
        Fri,  8 Oct 2021 14:04:24 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id o4so15308563oia.10;
        Fri, 08 Oct 2021 14:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I3T2zMHtxiLaCgChu7eDZh44oI8W+1DTNoQX2vujqes=;
        b=anaIrksijk4Af2yEXw799L+ZiJMoalPGvDYxpfM9gjzPQ4cgnryneO0tZLUMh8eWZe
         10u7jUxrUV4w++VspV2hMF6jXvw7pN/dLRbzJII0NsogbwjOKLgFqxMBmHtGq3shS+AC
         11WTbJ1q6fHz+wrzpI7oNXFfz0DY7Rkuoj82rFbFL6WeBOzA16idF3H9lgDqtVJ7WpER
         rIPi+E+FHcjc1GfuMYTet5B0GJ+0Q0wpVQJUIFyc2S6mFaagEYG0FfWKVLexTQ58wrCq
         Ig4lkL/cSmus83gTyENKRF3zOR3/G/isKN2cUBsKpi0+nX/v9LIin8Rmf5PgfzGfbwiI
         sCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I3T2zMHtxiLaCgChu7eDZh44oI8W+1DTNoQX2vujqes=;
        b=omU4Pyx4pTI1PaYYDK1xdNpQtukCz0OSrnVvMA0ZlEu4NtGk9s4VAX8Z/r2JfzfQ79
         ORPHcC9SrjDe3t0k5RE6QKn62aOEOBmhbAq0TABbkyfUFlSzI/K0uTCvH4DK7zCrj9df
         kMjJRBY/9808HrgriIdoHT9tGxK6SFB0fisXk27pTsuCai9AF3jfu3zbx35T2aYfckF4
         eltij3uAt9oKutShOdmyihVCSPTx9XYCM8WJQRl3ACpxcMbxF2T92stVju8F71GcYwwj
         blAO2ViJPC24qy0TSO/qNfbK1DrcmCtFEQN8E3wP/vz8eLI4R5d+i8YUfDQLb09Ehf/c
         gUNA==
X-Gm-Message-State: AOAM533f5a8eDvHE8VbuqGsZ4WKts8K8rfxZfQppmRedYbMPxc2nHIGQ
        Dm1JTuyIsyCcuOD4f9ttOA8=
X-Google-Smtp-Source: ABdhPJzDshC2F06RlOgfvyYo1D1QDIcfs0vFtuUUx3y7R4U3v5dmAfoS+OuylPac9YvdQbKHxvfZ+w==
X-Received: by 2002:a05:6808:c4:: with SMTP id t4mr17566198oic.22.1633727064277;
        Fri, 08 Oct 2021 14:04:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s29sm95100otg.60.2021.10.08.14.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:04:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:04:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
Message-ID: <20211008210422.GE3473085@roeck-us.net>
References: <20211008112715.444305067@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
