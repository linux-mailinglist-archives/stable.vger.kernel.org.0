Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CD53DF537
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbhHCTP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238734AbhHCTP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:15:28 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F7AC061757;
        Tue,  3 Aug 2021 12:15:16 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x15-20020a05683000cfb02904d1f8b9db81so10131825oto.12;
        Tue, 03 Aug 2021 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i2JS5oZYaTwTQFPiqZLSvkf/A/V6SetHGv4i1KeUD2I=;
        b=O9zQJSI/fOb94yT0zgc5TKCYqgyMfvQEPwoaSp7xRqpOAMaEbzWURc1biG/l7rywyc
         jcYaRtdWNYazXUF1R4TY6d13FNV0K8VgvZKE3Txkhye+f20xCg58/L5FE2uaYG3xvvOJ
         8czGnrxLFTkR430UCuba0TAjdIlB9XbH1GvUNiDSZjOVRAWtuq9sX3FLfL+8RMH9emSM
         nqNLPQWFGeGldx+zGJItwOR9RYiCTmDHe1CD1rsdhZXimgOsAmg1DlNUgR0HM6wMpwIV
         x9OpHSOh559Fk6ydyq4o+4TEIsDJblTwnxXGXaakVOaOUtNpWr8b7svQku8lgWDJs+5s
         HICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=i2JS5oZYaTwTQFPiqZLSvkf/A/V6SetHGv4i1KeUD2I=;
        b=knsgCvPs25bFVyDMcvQSjluvsrklRyBHd+tRgKva5uferU6biBxSTZVKAAZdmya1kD
         4DsMkiwB6TIyLfbeiQHrtnua5l20x//SH8IAfYPbnYCHP1XBrBkhKnvVYsQkuWySO4ji
         BfEhYyw/DZwvabkSz8Z0qQrQQm7t+nvv+KtvcNKUhOXEjairdignc/bnmKdzmuK6JdLQ
         TP0dR3PMnAKAoHueTpLm2WfFbTeQLveQRYbvrlafQ9IzLqxwwUE6kA35YeoYm0zh+/3M
         B5b3+ROq289O6DF1BxyB7vGopKvtr6N6kCF9FONzLjL62ivLEwCcwEVK75wE9XpVb9Wu
         gn3Q==
X-Gm-Message-State: AOAM530z2l0vvC3B4egQFQlMoU1nVzvbthsC5kzif05tcxnOtdWe32ca
        2P+RSDuRVXK6wYMWv/6hhBI=
X-Google-Smtp-Source: ABdhPJx4QM9/F/a1JL5iqA6f2gpzJp0AWanALuul6hLu6/noJKYfJsc+ZnUSzRHEzLUJxkoPKe4AnQ==
X-Received: by 2002:a05:6830:2144:: with SMTP id r4mr15876731otd.19.1628018116298;
        Tue, 03 Aug 2021 12:15:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 65sm2610653otb.8.2021.08.03.12.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:15:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:15:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/38] 4.14.242-rc1 review
Message-ID: <20210803191514.GC3053441@roeck-us.net>
References: <20210802134334.835358048@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.242 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
