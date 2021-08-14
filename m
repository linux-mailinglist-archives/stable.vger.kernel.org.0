Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56D03EC460
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhHNSQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbhHNSP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:15:56 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E77C061764;
        Sat, 14 Aug 2021 11:15:28 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id r16-20020a0568304190b02904f26cead745so16006290otu.10;
        Sat, 14 Aug 2021 11:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1d7rmqpIUNgurq6O5SPLkM/mna/Tp4Xbxnx/+7lA4RY=;
        b=mVbnB2fpTwEAs0pravy2d+Q8LFkGnzkQjFHjIuStRtGoPU24JO/fO9T+xNWB8uR+CD
         7FcJ9pWqJGAvUZW8NlXLg6iXhoH+CRSie96B7FXvnXoedEjOsaIy/25XvZciQI9+utuU
         KXIQFkaXMGBcDWZQCJJFsAe+GKh5dRzIYUnB4VdtyJ6/6FgQt37moe2oGZ6T/li1AMXT
         YZEzJMYzvkptMYWyGoTGHfCDYnnKgKTNoOT4OfawKGKVbwdLNVZSFJJ9lDP3yqUdbiu7
         GKcZnzGAwbL3Gci5IG5tlBME3Kfp+PS3gnqZ/AkAf3jInlF+SvKMeHebpVDVd8fH9LxR
         dGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1d7rmqpIUNgurq6O5SPLkM/mna/Tp4Xbxnx/+7lA4RY=;
        b=kfDjnrmhpWtiPWSdlC4qi12FdKDl5nDAo8sijE6oebP0Kivq52Ii3VoJo+IcK655j4
         gbE2vFMmDhRuZk7VliugG3YbtP6KPDqQcN8Rrlw5pT2cN3in3gHZA0gyIYftFz5ZrCik
         sbpWHhFYu4nl6CC5aWNARuvTtlE8rzIW+Kx8+z3/3VMy/iIBKfGcYQ29+bi9NUaAsoZF
         KqPWZRjostkXWGk+c2axHi+LC8StwlAgzcxHL5YW0EmjiED2TsZlqqsCZStG0nSZOXOv
         vhRra8hjgzToSyVMctawVTkiMe6n6qHC5uzca20cY2aYZFAAuYvUgEw5znP32VQZr/Sa
         QsCQ==
X-Gm-Message-State: AOAM53311Sh4ieN+h6S3MZFLm5DA1LEn1nYvdiLsLWGhZVpoEMiOECDn
        FI8o/aMh2It49GjwYlkjEto=
X-Google-Smtp-Source: ABdhPJzaM1n6NUnC9PNrvl9+2kgaGc2UKR8g0eIBM+N/vw1aElOs3M1VWY+IIdcBTTTSZ80BJeUG3g==
X-Received: by 2002:a05:6830:164a:: with SMTP id h10mr6580645otr.1.1628964927709;
        Sat, 14 Aug 2021 11:15:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q187sm1115324oif.2.2021.08.14.11.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:15:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:15:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/11] 4.19.204-rc1 review
Message-ID: <20210814181526.GC2785521@roeck-us.net>
References: <20210813150520.072304554@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:07:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.204 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

guenter
