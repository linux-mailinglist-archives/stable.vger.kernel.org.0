Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE7937075E
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 15:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhEANP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 09:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhEANP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 09:15:26 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D59C06174A;
        Sat,  1 May 2021 06:14:36 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id u16so933319oiu.7;
        Sat, 01 May 2021 06:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n9SoJ4D2tkyOR08YemCe83AAwDPORPsn+2J4m0ujUmY=;
        b=vFuh8FeRaZD1RzyxX5vaFp7ruqXQTa6BWF5TxiicVhUudNnXdBYeNiUrHgMCxmIWAn
         DNVXWJvsRZmj0MEfF1k+81kpQALpovKniSwwRhE1zO6QTiMOAM4rlq48mqc7UtU7zmsX
         cXvH04FtP3MzUqw9DGUTcVOO5olYv4cLf60IPI0fDgYJny2P1f0E5Q2Z4xXmAUKUTTEY
         csuaO1NRdWsIFv2E1aFdW3I7zVk/q7ZeG5GCAeCokhbBgPzecX4PH7eO5C6bztYIWsEn
         Jrf9zOAczbAaUcS041u4EUnRKQc+BHsRIdUfSP9q09kHeU+7L6puzBqcRGLMe2G3BTgI
         fwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=n9SoJ4D2tkyOR08YemCe83AAwDPORPsn+2J4m0ujUmY=;
        b=Z9+BoZyWIADXRGf6Dl9xeH4Ho7uhmQsEzeYYGH0/HEUf2u3K6G5H1nNUoKi03HTjAO
         PFVesOkVJ1jDlghC61Lq7/sP9y5a6UpwvPcDqSuUhh6PYAr7/EEWHsQw6vAPNyFfmZos
         cXUppOeg70nluJGasIoP+Kz5SooD/ccC6LTpfsAgZ8dOmlqzA8BZ7BKaTcM86J+iDHns
         Zvk6PGmV+J6yH9/DAoMHFfQBKU6VJNgjkw50y6MC74WsEk1S+w5PDsM8fBBpCuG2q861
         aGGxmr3EL4OgrUNYECxJPTkzKcWlSXssPhi74Q0/MG8WX7lybQeusXfh3rIEu7Adilm6
         nGQg==
X-Gm-Message-State: AOAM532ltnoUN5lOvDDam0qg7jgt0tn4wBYja9Qf/qhGxDbDqobkLkcr
        wpgpQDr0rkL1HI9LR6Ewk5k=
X-Google-Smtp-Source: ABdhPJyFHtEdxEqrfNvu2pdNrqXGfzisk5y4508xYKqJHdlDMCjSg0aGlnWOl1v8sT22amj3lFClqQ==
X-Received: by 2002:a05:6808:2d0:: with SMTP id a16mr7598380oid.116.1619874875522;
        Sat, 01 May 2021 06:14:35 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x3sm1604126otj.8.2021.05.01.06.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 06:14:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 1 May 2021 06:14:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 0/5] 5.12.1-rc1 review
Message-ID: <20210501131433.GD1774517@roeck-us.net>
References: <20210430141910.899518186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 04:20:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
