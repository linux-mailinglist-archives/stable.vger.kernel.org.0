Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B82A6C34
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgKDRu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDRu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:50:59 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D99FC0613D3;
        Wed,  4 Nov 2020 09:50:59 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 32so20123609otm.3;
        Wed, 04 Nov 2020 09:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iL7SD9rKNtxAOkDqBDUHKbdHnnaaeFBiMXWzs5c9w8M=;
        b=ZS6aAlMCIUaaXc6cEcoK4mfFMgExWfRaTxjFCpXfyDJlOXBYO72SIoHxIjeSs4tRJe
         Rm9Mi645QsZugSRMOAejkpE1SCAG0TJm0jrBtT1D46eDfW0sw9pGsTHA7Hlo2jPY5jf8
         tsaqoeTYIvB2cEt8Iakm/y9/PNqinWqLLgqu46xdu1wVpG9CXP2DCZtEMy2lb6EC24RN
         Juls/r2K1Me0HlM0ig8it0lRb+v9UK9wIykOcHd1BGa/NP1xrzOySSiMPWvZ63dmt+fV
         9Rsg6f+yeI7XersGwZ2160AY5pUqaDw0i27F9FbbKzp3qf9wRhWm2KMQpLPK3UPGQKPE
         B7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iL7SD9rKNtxAOkDqBDUHKbdHnnaaeFBiMXWzs5c9w8M=;
        b=OgpLWEUzNDbQLJSwsrhoh8oOR20hhkz74FOpy0QUCCPeI1AwgN+Nyp6Inl5oU5ZfiN
         XRLc2G/HYQSTB4ggiZMGJM8JL4sV2iwN5E/WmBVEYVUkgPndKFWuBd8tx13KoHNqlTL/
         3iQwdStrT3bFn3UPrEJQbpAnnIwLlvvGEQPHbV5XYlPovJTt8TJqBfUnaHXKi+vvMUOu
         BgXZQLwgNdArmky6xJVPOLt8MMqPfy4qr5GVsVimbXGhF9Ljy60nF9No29mfwWWgPSEn
         6lP7MdcM+gniBGnyIfY6hRKdJM6D5rCbAaJLYvCwFsz+vKddUvPnpLnACPwE9yb0vJRW
         5qhg==
X-Gm-Message-State: AOAM532zD39ReSLt96Zi7vErSzcxSqQ0/7h3DRFuj2A93prp733QWSpR
        B6ql7o6EfCZp3ss+IvHdTic=
X-Google-Smtp-Source: ABdhPJzUe9Sn3zPEuguutdaWdAoWDyjnqzjZCZ2tpgLw6qLDoE8mRBmNmPYUsSSZaRbiemPigcgdmg==
X-Received: by 2002:a9d:7d12:: with SMTP id v18mr19173659otn.271.1604512258669;
        Wed, 04 Nov 2020 09:50:58 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m11sm674119oop.6.2020.11.04.09.50.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 09:50:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 09:50:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/214] 5.4.75-rc1 review
Message-ID: <20201104175057.GC225910@roeck-us.net>
References: <20201103203249.448706377@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:34:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.75 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 150 fail: 7
Failed builds:
	<all sparc>
Qemu test results:
	total: 426 pass: 394 fail: 32
Failed tests:
	<all sparc>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
