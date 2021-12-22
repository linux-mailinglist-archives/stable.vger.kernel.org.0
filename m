Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C847C982
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhLUXLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhLUXLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:11:24 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346ECC061574;
        Tue, 21 Dec 2021 15:11:24 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bf8so1091818oib.6;
        Tue, 21 Dec 2021 15:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lCW8wP5Q/Uo2r64/gAhXuYC5jQimI7pQwjylId5pwr8=;
        b=O0juyOZ3N3HKaUoigUt8SWBf7LfhWVWAizSzXTTaznzLuiVCDG/+N/ouZJTFjEy1D7
         FtxeAFudReBbb6My8De6svaF6fPew5PZYxIUIlTlqqsii8z30oeErBoahYS8pzXo5R6X
         TKhjyWRk1JzbuuuQKsZc11qT+AtyEZvvfQQgW4+YSqQlEPB8rQqwqa5UZ6nLezzgoO+p
         YyKR+Wx46qqM1bME1LFgWGjvtMLo6H2Af2tcVVqyr7Y3EocYueknm8GPAbxC5nq5oaIs
         x/nDd2PPQrEowM4lk3h5eK6RZifoVmd0LvRF1/G7pbmKNuf5ZH+flXAcv4RChvg/FRYx
         9+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lCW8wP5Q/Uo2r64/gAhXuYC5jQimI7pQwjylId5pwr8=;
        b=AV+Hi9E1nHtx7TZfM70iNyz1NLbTv5DdHEolfycWEPqMb3qQJHJp7FfhNpd+z0GxIR
         /Fe2AcUJhluCOZpRLSdUCZdzk5OqDXYwM2dZFDihZGfeFjhrur8J5995sqcY1FwH80gH
         NtI/wiiaivjUgqUUIX3l4IL5xATSUHJ561rdEBgMoSZHNrHEp8A5HHpVVD40pPRS9LjK
         EtQGuMIonHdQfIbh939ALvTWtofmazrUCjLL6aOHMwIM0iNofdz2yOtMdKFKqGNBxw5i
         lZik1wZ5uC2UkUNV9m5CqBvtSjUbop9UdbG5BWqyg8lOJmpDWH50fPj4InWeXFznDJBs
         U7oA==
X-Gm-Message-State: AOAM531Qo87ucofR7OcAa8Bn06B65GP5iBJT183LBlpbPFaywBW5fUxq
        wqp3aNvJCdieT21sBPvVYCg=
X-Google-Smtp-Source: ABdhPJzvphHN3DuvcsoP/yJtY6T0/MlklRgKtx4/fhJVHcvvD9uBlUIRjjqohWR8ikiGQ4va7IL1Zw==
X-Received: by 2002:aca:a9d6:: with SMTP id s205mr312238oie.101.1640128283463;
        Tue, 21 Dec 2021 15:11:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j13sm64708oil.42.2021.12.21.15.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:11:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:11:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/23] 4.4.296-rc1 review
Message-ID: <20211221231121.GA2536230@roeck-us.net>
References: <20211220143017.842390782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:34:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.296 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
