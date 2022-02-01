Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32184A55E1
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 05:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiBAEYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 23:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBAEYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 23:24:35 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A786DC061714;
        Mon, 31 Jan 2022 20:24:34 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id q14-20020a05683022ce00b005a6162a1620so2300957otc.0;
        Mon, 31 Jan 2022 20:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J2FSCvL9AByrl09RrrZCC1Y0RN5Yn3jPxKlhgmQAMoo=;
        b=Iiz36oWh/dj5IAWq/9JscPY84toob59o9C0uM5zvrIH5FaMbcsg264C20ZaHW1WQGq
         sa3SCRTwtHC5CvwISTGfALkHUQgiHwyI/KOKeaid6IWaDGaQjfa4JI24AIfVW1BainiV
         kbiYXURs8AxdSRiE5OrtpAf6mian57EdfW7a68Y5Z9qmfbjXFFeOZqeUNd+LaXSKdSeP
         sUzHUoJXH4tt++qhXUfafA1MIwdw5zguNEfaKVwX9M6k9S8+aTVNHApWxZE1cE19o2mg
         J7ozNdw/0KbaiqBxBh9LSoLfQf/Heb2UKWZ0P3fcL2Tvc/eLLoITqNfM7TriJlr0Kf0N
         st0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=J2FSCvL9AByrl09RrrZCC1Y0RN5Yn3jPxKlhgmQAMoo=;
        b=7cNEky8Ub08GachFmjQv2sJp1OgRwGwb8uZxa980FArfkuJGZnKyEIKPpJOa1TepKv
         wawUPIHCjALpcSmLg36uN+zLUI5Fe2wxSCg+bSR7Yv1tWIW+7dO91gMoSW6zVFZvhMdy
         J//FH1fxMoG1hGL402+9LQR3T0f3qIVanXYznLFrCDFMym9C74fMIW9IyDzim7pDqBkn
         utJNM7XBdpcpNBH+oQP4F9LYGVGirN5RTIGHHw2hEhDlm0uBRHPlQVWIXEnrXQOYYUMf
         0tGUSyoG2gER8EoGXlOxq/GVmrQxJuU/T9dG2N7736EcNLMaCSvZVdVVzSMfhLEYq5dQ
         zdhA==
X-Gm-Message-State: AOAM532YilKsyb45uEqP9K4yISipkePXqdfKL3GRLlBGMVQfNCAgFF2F
        fFbRVpEqf8HfiNIF2VxuQ9o=
X-Google-Smtp-Source: ABdhPJxxZauLqmstap04wwcoIvgoaUOm5NfpIMM82zP9/q0o0lX4IqG0Q6j2MYdTjxU4TXG/TWeY/w==
X-Received: by 2002:a05:6830:34a3:: with SMTP id c35mr11821982otu.113.1643689473925;
        Mon, 31 Jan 2022 20:24:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a19sm12993551otf.27.2022.01.31.20.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:24:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 31 Jan 2022 20:24:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.4 00/64] 5.4.176-rc1 review
Message-ID: <20220201042431.GA2556037@roeck-us.net>
References: <20220131105215.644174521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:55:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.176 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
