Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5D480BD0
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhL1RHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhL1RHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:07:04 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB5CC061574;
        Tue, 28 Dec 2021 09:07:03 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id t204so24972990oie.7;
        Tue, 28 Dec 2021 09:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZXUAl6NsZSuLztswntyenpbF44oUUqSFH/Q0u7ERfPU=;
        b=gmfgAZaJcCSx7hs8wwXubhCsrJnIxrTYh+Ckddxz398BfDzSAxWXxnqX8vsBXMxns3
         luwVW8rckBvGcR9n0hszO4paIlUTv1O56pf5WWAMFw6Gv5EbmbXKTweEyk0VFRW0nTm5
         +aka4J7A+tjHARjgvWn/86JMqu0IxtXEcQ7CzP6XQDfZq55ym+ArFY7nh3/z67lNXJm4
         5HQsvZJQfRddnvor23+m1b8lJc3zuy9XJUecJFpVHqfhdpJmR7jA3TQUMD9vAB/cXRko
         DcBQQ0a9v1uDOXMZx2CCkEg0Wau4G0Is+l9H6JMwXZiCbq1LAdrro/sQ1cg/ttAAiN4m
         ne/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZXUAl6NsZSuLztswntyenpbF44oUUqSFH/Q0u7ERfPU=;
        b=RPe2gpjtKLjRsdUm8SexeIsNLrpNvFO1ISLbInkLraagVdvCekzOszWyDYuyGeAUuv
         i3g05yLTPAQVqwn+G+w/xAKUV0rxJtVCNKLp1x87UWJu+6wXfAlEIw/Hys8vKiav8Rsr
         RozSXPrFN/jpE4YB1f4G4IkJwB0ka2HYclex9V1UPFqbmUlh/BUCHbu8iwFGGfbp5iJX
         0qfEHKLzP7wd/KdjonRYZd7+Q6PVFST7XYBHPRpLoYUC7Xw9OCvyNIe/QWsTDMbOkW3I
         ImTie4YHZSj4qztIfV8RX7CAxAFwF/Qe1RgRWpgeDAL2e6o+a1tvDdkXRFnq79HMkTji
         XS2Q==
X-Gm-Message-State: AOAM53094uQuuhBTLClj4d5cyXPA+z4ssS1KZBsOxqw8NH79JumzDQEy
        vlWPTaaMsJ8FTX+4LziFy4o=
X-Google-Smtp-Source: ABdhPJxCg7fMFzTl/UPG5nrudssH2fX7vpl0KH15R117RFGdBaNoIehwNWqcbMsYq8w5gePrq8WY8Q==
X-Received: by 2002:a05:6808:1305:: with SMTP id y5mr16926098oiv.83.1640711223228;
        Tue, 28 Dec 2021 09:07:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n18sm3222876ooj.30.2021.12.28.09.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:07:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:07:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/47] 5.4.169-rc1 review
Message-ID: <20211228170701.GE1225572@roeck-us.net>
References: <20211227151320.801714429@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:30:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.169 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
