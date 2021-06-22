Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230D73B0F74
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFVVg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVVg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:36:28 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB452C061574;
        Tue, 22 Jun 2021 14:34:10 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id s23so956146oiw.9;
        Tue, 22 Jun 2021 14:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qt6b+/DX4cVwyTlMy4xX9tvg0HxZ/viIDRi+Zx+CmRw=;
        b=tIjJje13CYjv6cn+pv0yLUyAPbOoPZFmmyHHeoi1Uz/GjV0ffyJQFiDX/wgFyF5dN6
         G/jIB2+YyUqCfnZbkJt4Hry49NvCi97LqAzbzCh97qfUJT63w7mspm0uPGTYsJpqRimi
         kAIr1WLNQtIVhUpTGSsz2R9D+9xAMefbM1ER8uNXdaZ+uVX0sjyvse0+BMye39xrsxMI
         CoXoFzhPFTUg7KZEloI3QK09fY29kkyTcFA1vhV+hLF92DDWdg4nU5aU+rgsc2LBCh0y
         RMxBS20ZxnFN0nDLhD+pMQuI3p3MhKxTnTkJl2YAgIZIyIidpTAiihIqOoviYPzKqkj4
         4lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qt6b+/DX4cVwyTlMy4xX9tvg0HxZ/viIDRi+Zx+CmRw=;
        b=ZmvyRPVyeui0VBbOStPbiQp1apnTNG2xTTb16V6j/70WUFxxxjIUsXdNv3ua+z/8WL
         3K7Nu23IbxApM5h/AcbEtlqdiIcomOh7EVScpQuwXCrVlD4ykCx9P0NVRhCCU2AHNEh6
         CbSuAzEhMhzzV1M5qeJIuZbZ1E+LKKsT1HP6ssoS5ujRZVRLxpIF/rLojIWXsaziyeT9
         NfMgQNVqNbNsvLewZY4HMT09OuU5Gei0+iKEvqbm1l/22vWZCBHhUCMOi8bfvy3JXpQK
         uvtIT3qPAN3RJ5KdGSqFDdKiuUUW1nejLzkRMSZwWtYUyRhQwgj5p3f6lsD/ybNAp/ED
         YRfQ==
X-Gm-Message-State: AOAM533GBiL6HInY40/lRZ3G8sZcWP4hlfD+ZeREms4Pg7lJWqBzM/8R
        fanAYN4Lm0rJsT8gGXqdIG8=
X-Google-Smtp-Source: ABdhPJx53X5OgJM8a17FFh/zNTaVTtyJZQRzqTh53GRg4FQo3mHiaxiSybbACzKDBVCDi/czefn27g==
X-Received: by 2002:aca:aad2:: with SMTP id t201mr604399oie.117.1624397650294;
        Tue, 22 Jun 2021 14:34:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f12sm801494ooh.38.2021.06.22.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:34:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Jun 2021 14:34:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
Message-ID: <20210622213407.GA1296965@roeck-us.net>
References: <20210621154904.159672728@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:14:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
