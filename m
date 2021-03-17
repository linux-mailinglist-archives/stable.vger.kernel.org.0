Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DE533E747
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhCQC60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCQC54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 22:57:56 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616D5C06174A;
        Tue, 16 Mar 2021 19:57:56 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c17so129121ilj.7;
        Tue, 16 Mar 2021 19:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ogRJm9kxdsheL6fGYzsvzfyxMIsZO8zplKaSSV2V4bM=;
        b=bhU/2ydrm31TuVH9dd62TY9ABePIgeC7r0SG0SO+Gd/oq8SPE5Eqqrp6jOHolqv3fJ
         7tki3mOyrx/VFV6ji6cQ0BeNIX4MPsyZfRCXNrbgSyQ1TMAqZpfRaYP9DA4heqY6Tp6W
         /pHzDOcq3OGRhVjXhMfBy3ZDD4LQEIQi70W9DypMkRgT6/sWExgrs2Csj5kx3gE/yg8h
         OmHdlV2vsjUKddhn2i6S4lR9pik68YcdUdmzFDoPwontu4UWxl/7wOkV6vfgL5RHhgFV
         9M2XF590Kjp0NlF7g47OBvRkMQ3jib2ZtyQ6Ml2WjKOLdBvMiC9tHEqteqTGyeoxeUxQ
         +pGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ogRJm9kxdsheL6fGYzsvzfyxMIsZO8zplKaSSV2V4bM=;
        b=XIPQJ6B1BRmEkLNa0WOSgBhAa9ZuDgmKCA7gcBDkariJb+V82Fy8p38ZdABZvO/TmP
         fu1N4fjUID59FHGlFqi4roO4AmbCi6UMDc4kbnrTW5fGepkR95SxZ5MVuidi7sWj2bQy
         0AlbIzUmFV2HzHhgb9qRKON8W0lW5SKEyBZAAV6yBndJjxqMnOsPqAJBgmx1YfScn00Z
         /icODP0r2R7ITYCux+QdU4TjaVUNCOCSosfPb9V/Pdk6SIS8KEFvnm6WSb2DdI+64e8G
         hZJQnFQ8Nf+BnnSZVMj9hpHzOSqfnsa09cD7RPmja+9aXZFoO/aEpOTukt5Kpj4545q3
         pRjA==
X-Gm-Message-State: AOAM531jgLYOuu/xj9t/UNA3yZsymxsFSdR8LnWCwwvZh76LKV3upQxL
        qTL5v5J2qtWQ2SftYiC6B57/ccWFTrZtQA==
X-Google-Smtp-Source: ABdhPJwdebIAiPziAUriYBxL35GdPOOm03EhfnQymz5MQ1Ja2R7DOznDBLqMIgpHx/VbppBksvq+Lg==
X-Received: by 2002:a92:ce4e:: with SMTP id a14mr6184021ilr.219.1615949875832;
        Tue, 16 Mar 2021 19:57:55 -0700 (PDT)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id h128sm9605414ioa.32.2021.03.16.19.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:57:55 -0700 (PDT)
Date:   Tue, 16 Mar 2021 21:57:53 -0500
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
Message-ID: <20210317025753.GA6466@book>
References: <20210315135720.002213995@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:55:51PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
