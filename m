Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C63E3C65D3
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 00:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhGLWCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 18:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLWCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 18:02:48 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00409C0613DD;
        Mon, 12 Jul 2021 14:59:59 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v32-20020a0568300920b02904b90fde9029so5827592ott.7;
        Mon, 12 Jul 2021 14:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CzhL40t+P8D+tzzrpYHGw1WDeuBpumGKvYMIwr5aqhM=;
        b=F3c5HI5ZtQZz273GOOtCcbcU2aHAy7RQNpGPhn0iWCiv+DAffbFe+4PmJzi5YgNM6f
         f1gVS5kaYm35eCl49rRYOHWo1birVFhF9MtShH3PCWLCH8nvf+XHmuKp6S4mSKfPqdYK
         gWvmmb4YE87b5nbaxvmJew578EwkkO4nxc7fXIBDA0sUkZkz+shwqmf9j+yIXtdjrrQm
         R2GoQaYJMt9nBMvzn3IQR2kIlcANx7eh571i4VUcfrPt4EAkQU2Bd7cNgy7kY32Q8Za2
         vsHO9P3y6AU770BePVK2BAOHnddFNbHXbsMitiszLylecJMQiPauLvsMpKFH/KEz5DWR
         No8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CzhL40t+P8D+tzzrpYHGw1WDeuBpumGKvYMIwr5aqhM=;
        b=q06ytQ8gzjouglqshL4RaAMoHsHOyCqMk33SCm3iMlk9aXI+3/lwOyMpaIwnJ7QU4y
         M3c/oKTzsT/10o1FqNWgX2vlsJtaTJQiSGHxFaffsM3rVZzCgvy8NrhZ1gNOzWH0sC4G
         mbA/mNHXQtrrTnAvo3VTJIdKiCcC6heFeNxPsNxFWJ8jSs/UEVnTkOqf9w25TryHjaVh
         ko/EN8b2f+HbygTvEJazD6oaBJHHGkFhP9toEroQmL/G5vigH2b2FrU+iIS1oLEiM5SQ
         AIz2xvdll6kD5YRgHWOnm90Ib4ccOOKFAwx3OsvKaM/i306FYCGWThmzXOqDzORvbcUS
         2NeQ==
X-Gm-Message-State: AOAM531RFNgp/wvCHvQ9UCDKJtRNAPJ9Dxlf5iBK9tUyho1HF7Qv1J4E
        HynHMQVOFNhjPJcJ2iK4MQE=
X-Google-Smtp-Source: ABdhPJxAdW1pleng3ou5Bt8uk9UM9dFwBU83aH0c8bMQ1BgWPJlQ/8IThWvJWA1q7mnRLls0952CVw==
X-Received: by 2002:a9d:72d3:: with SMTP id d19mr877715otk.7.1626127199408;
        Mon, 12 Jul 2021 14:59:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 2sm3293436ota.58.2021.07.12.14.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 14:59:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Jul 2021 14:59:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
Message-ID: <20210712215957.GA2210980@roeck-us.net>
References: <20210712184735.997723427@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 08:49:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
