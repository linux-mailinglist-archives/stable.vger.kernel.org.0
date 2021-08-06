Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF63E2F8B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhHFS6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhHFS6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:58:09 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000FDC0613CF;
        Fri,  6 Aug 2021 11:57:52 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id kk23so4776066qvb.6;
        Fri, 06 Aug 2021 11:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C6uvASxATo/8FszVinlHObWrBJ3cY2dBa71kPo+56Nw=;
        b=jUbUNnn5UeUsioUDPC3W2NWkyvDyKRgEyG4iqyYTbx5JGNNeZ1ep9qTS6tzkkOf8gE
         DAx2PxdT5lIhQ/Oln1xLyQCQhWuS1aaZk2RHJmQ2Duv5/vFXN+tj6OKMi2X1ceQJYbgO
         WOT4gRS522sKEQPwkJz1KozfBEV1zC/+zD02Ab0y/TTMLVSE9/gsaPc+xILDfTocinm5
         EBA7nO8seDzFLxb4+++SpATuSMh0hm9f1eFFSjc4T4CW14SDIJfBvf1beCw/QkNZt9KL
         KWf2Rlpik6RtBYznTojP+iKeFQ619xJtqlIQPAHTu/k4Mm/UPkUIc5yZ55RhtCHpfECt
         WOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=C6uvASxATo/8FszVinlHObWrBJ3cY2dBa71kPo+56Nw=;
        b=SzY/TI9ZX0pLZ9kAAlMYmlTutrORzP5gnTF8uufos8WoHNRpEwusIk+OHvF3XUDjV9
         kkweNY41nAErgXGmo+Erm9oa9sB3K92MtKa3MTNnkRgl/i3Eysr9Cju683OgXzRMBsmr
         sFjQo3Vm9QdbTZhATKStk+c8QuBS1KIfyivehkMwIQk5K3CwHxImdMp7UJ6e7mZWBQHT
         usy/UmzozfAJfyz4H8U/F3/v1jHdtPFva1e0J8e0sy5SIVgWHXOUsvXowq7Yv1Z2agDj
         A23Nnj538/7RpNOML7nDfpa2pnn/HV0OjzwGKgNPYKMnODY6O+AfiMubbqW7OR81zNHA
         S3fw==
X-Gm-Message-State: AOAM532nfqFiPRAObEySGqnUs23HfjgwdJiJoCsMP9XwAbleshGdYaZX
        WhXe+PGgsXxBPBrFjsUgcVk=
X-Google-Smtp-Source: ABdhPJzp+ooUKmmZWd3uE+3W4EUcsurMfNRB7b8OO/KimJRqIZHCin2vgfgHdgX03Ztnv8Y3qBnaUA==
X-Received: by 2002:a0c:b29b:: with SMTP id r27mr1371873qve.35.1628276272247;
        Fri, 06 Aug 2021 11:57:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c13sm751587qkk.75.2021.08.06.11.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:57:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:57:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/7] 4.9.279-rc1 review
Message-ID: <20210806185750.GB2680592@roeck-us.net>
References: <20210806081109.324409899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081109.324409899@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:14:39AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.279 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
