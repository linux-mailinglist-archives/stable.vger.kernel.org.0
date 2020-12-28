Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4EB2E6BFF
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgL1Wzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729416AbgL1U0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:26:06 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E944C0613D6;
        Mon, 28 Dec 2020 12:25:26 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id b24so10196860otj.0;
        Mon, 28 Dec 2020 12:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZcKLzY4jaWamfJ9rUtvDjo8Gbz0cIlLJJK3B0+7jWhY=;
        b=ahlOYDq4rgKwzVElfwEveweKxwSM2T6CMHIEj4l889ThY6qJCxyh/GRjNF/kHSsGta
         fFpb0jN+7c49lMSfuVld3gpz+heIzzqJF9Ii7dt1U/TYOfrdal9oRVNXQzGrW6vWbyOD
         hVmvsBG6FmpGjfvsX81RLPUwPFMZouFe8HYYqdb4qhtQKGsi4f8r7dzQ4P0ZxvPcLJof
         ECLOTVTl8PogR4Qvd7hKMf0R2Rl7ovre/tkKbUyGazh37/BI85sFNrH3NEsDLxZzCkaG
         U7NLMGtEKR/V0/RIrv0are79+Ce64IBfY+Nr4+Rk2BSC0NNuvV/l17halaiM+cBxYH7y
         hI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZcKLzY4jaWamfJ9rUtvDjo8Gbz0cIlLJJK3B0+7jWhY=;
        b=oyo1DM8cHktjlTn8NGh7+bBfBSufYtT4O5ZaGtKI05PHoa/e/bhCsiOUgAvpvfQbFZ
         91/lzg/ua+lgY9LDkxvjKHxFtIykSJl5GJa0epjBOML39GoKAg5nOmPGmVW6Gzh1Sq5T
         qGNwPEby5nmv3c4JNxIwQBD7NodihQqihcx7oFU76U1V1M6MekwCTkf4UCSyrKtGoZRr
         OlaxSyFV17x/HNxP43WEzomRmiPhVceqIaPKLnZhbQnEOYpm0PutHaWPBhvxzZmZPw3E
         m2Vjr8TvmRrTiIr/DZGYexpCEgcoIO7TTI3gsKE7/0Hj6FCJ7f2f37Eupyp6dBeBIxG7
         Uujw==
X-Gm-Message-State: AOAM530bwdA/qyW+43+FSXucEB+mJDLlm3H9Z3H3dO4Xmm3GQ2xC8CNv
        5IpKDGdK5RBevLqkero9mw8xnnftR5Q=
X-Google-Smtp-Source: ABdhPJw7FNLSEQ3UMITwEaZfCvf5TNot4fEtO90aFvWodRw1qo6N8DLX9u8z05fGPqbzFCMRAPtXxQ==
X-Received: by 2002:a9d:c01:: with SMTP id 1mr19312068otr.107.1609187126126;
        Mon, 28 Dec 2020 12:25:26 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g200sm9106009oib.19.2020.12.28.12.25.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:25:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:25:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/242] 4.14.213-rc1 review
Message-ID: <20201228202524.GC9868@roeck-us.net>
References: <20201228124904.654293249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:46:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.213 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
