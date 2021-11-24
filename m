Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87E145C8E4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243941AbhKXPna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243677AbhKXPna (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:43:30 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D296C061574;
        Wed, 24 Nov 2021 07:40:20 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id n66so6092837oia.9;
        Wed, 24 Nov 2021 07:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lrXM5Ku32vVurxgMfpqQlfiGWI22GAVou6uwZfe+JbA=;
        b=aj796oMT+64jNfB+zSkMj/KLoGhIRCI0INPC+u+1t/dDSdOpTBgiHV8XCTa+JtWYls
         owrrDI7ouLZrGkAShTLiC8znCG9Q352i62L9hoBhpfAxmnQacCJDcVjLYAwA2rP4iA15
         4HacMnktA7R036LVc4mEgD/az5G9Xh0A3RtLgbFvpFPeV/HxgrglixYXprtceiYWOYNj
         x6q1bODDPanb2FI32E6sBeFQxorpx2IyM2M2LRI/JtHV3j0hZXb+oNNk0VKk95Dp+2rs
         3DLoMWsu8ghPaQarMcpDM5LcpucLzf9nUB5tC9dp4eoowsnFWhRebcd1jSFkT3vV3FT1
         wiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lrXM5Ku32vVurxgMfpqQlfiGWI22GAVou6uwZfe+JbA=;
        b=vbF/Kn07+XEx1KcxBwz5Fr8n7qwzos+vGQqnKfW5YtaMUb2E/yd2X4+INe5O4i1TEW
         VnVLendCE55XAkalXUKt4RKXdarXvY1Y0ZfwLAVRZ+1MZm7j+Eak2i0g7+lyKtT4WmSX
         y9ej4xH6a0QPcK0d6hLpvXhpOZVpd1FaUYXs6BpT77easXIZZ6kzM7va+5SYIi/+e6YW
         96srPh+a6djToNjl9dajF1lotSyNptzfqz9eglh1TjJKKO68Ksy5xCjWUg8eG9Ky4Iqm
         /MWHLSLm697TDQnaW5UUkzYSDEnOVZ9igFtRLFiZs/lJHl57bsPKDNAx6+UESSJg4TMT
         PTAw==
X-Gm-Message-State: AOAM530OXrPjETkcG30gw86dwrrhjYO6IcdMeyALSH+knsRjpb7D8q1z
        VZ7Gz8+uEh720EVO08/t9XA=
X-Google-Smtp-Source: ABdhPJxpVwhQdN2ywVu3PVTUK3D08m3TRrU6FBxYcFI28GfyhMaQSnssesYAi3V/euY5HYRiAG4jOw==
X-Received: by 2002:a05:6808:1408:: with SMTP id w8mr7077745oiv.54.1637768420011;
        Wed, 24 Nov 2021 07:40:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w5sm15325otk.70.2021.11.24.07.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 07:40:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 07:40:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
Message-ID: <20211124154017.GA1854532@roeck-us.net>
References: <20211124115654.849735859@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:57:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
ERROR: Input tree has errors, aborting (use -f to force output)

Guenter
