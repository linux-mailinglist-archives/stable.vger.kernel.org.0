Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F3423BFAA
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHDTXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHDTXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 15:23:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04113C06174A;
        Tue,  4 Aug 2020 12:23:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so3033893pjb.4;
        Tue, 04 Aug 2020 12:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m5AnQm8mvflO1GdQncr56awDp+2fPiP79OACWfvg8sY=;
        b=etcLjGuOQD/HTJtXhCM2b9U50BIkdzOXf73otDz86eusfzLPBcirF3i8aSmRoz08mR
         PczAWPhh5QTbhlMaBgtt9G67KMWHiFRbP1dR64AyEvwfyPdJ/L+hiWXajKVOGBpWqktq
         h5ewsZvRmPL3QonRZfbI/xxU0xmQ/fpd/zG0LW+9KvaxZX4SpLce6T6gpiD30uq2hMhS
         eO8mok9sGbjbZHlBIvInXQqbXu+eBIy85pIviBTGBUtUqS09Epr+S0c4K9Lx/k0M0YTP
         M2nljj9pJ2HnAAme6KoLi6h079KYkK36Q9I+lr7IF1yqGU9bXyRWBNd010PzzGLVr7nZ
         ++IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=m5AnQm8mvflO1GdQncr56awDp+2fPiP79OACWfvg8sY=;
        b=WnbOnuq84O5w8i2h5VCIkro4kqCIZlrsZLqmBkeZ29ubdd0mkGtpvn78HCiDFbE84m
         wZFWaDP2/wjZbQZeqoGcWFGWf+6k0M22J0aWK0n0bEc3bX9AEChNM+89YWWKKgfscPLS
         DAqSfWlY8en6sjMT/txIDlmE5U2YSu0ngs2G+nIHpUWV7h2dS3ipX73ZYzhC/oCksKuV
         uo5KoSndx/OO7gJfjXDGoXcof0Id3LodzxZgrnVxA9jJ9iY535jKelOiwaMoRQ6P0nUE
         KXI+TaPhwIZzQOMrhsF8YgeBUHO01k1GuLmWWZa06PtRktZs7CjAuOoSvMsRid+5e8i6
         ieDw==
X-Gm-Message-State: AOAM531M+MkHDFzJQiMnkxgLk/kz1nR/vuVTfLIm/pBWhIfzqRJ6dWV+
        5DkPdgemOTMsKD4r8shmtng=
X-Google-Smtp-Source: ABdhPJyYNsOs0QLJYi0wnZ4YqNheHHAPNje7UERKQPvdaVjnvnX/g0fKbK3gRAh2yElZIfQoqPU7eQ==
X-Received: by 2002:a17:902:eb14:: with SMTP id l20mr15022279plb.6.1596569014618;
        Tue, 04 Aug 2020 12:23:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l186sm23934449pfl.2.2020.08.04.12.23.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Aug 2020 12:23:34 -0700 (PDT)
Date:   Tue, 4 Aug 2020 12:23:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/52] 4.19.137-rc3 review
Message-ID: <20200804192333.GB186129@roeck-us.net>
References: <20200804085216.109206737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804085216.109206737@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:53:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.137 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
