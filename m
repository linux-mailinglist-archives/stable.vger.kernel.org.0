Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5F3241C49
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgHKOX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgHKOX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:23:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C57C06174A;
        Tue, 11 Aug 2020 07:23:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so6802574pgf.0;
        Tue, 11 Aug 2020 07:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ggOSz8ht1ri74CY5rqN/s8FPDAvFj7a4Vq62xIB7QpQ=;
        b=HanSVvpfouVXy+eHmdIio7dWRMJCSyzC15OktXRRJHn6/x1FW1gYihErlRy7B96y1i
         IYU8tNY6s1ilB5m3bheC9wP2n6RFT6kkVgl6rfimTTW6xgSZTdz4pFUkELmKN6Fy9Eu2
         baQ2DtQjYctIibOdw43wc67NrxkcySFWlG9QdqNwK7C2Zx22xSrnKUugToETebYxcZ1D
         sfZWyJNuBw7L36eASNYn6TT/QYP1YcFCzsq3DvLjQHOwBG4OBjJKLQxr8RguGlEF/SuD
         zeXbEKdf2gkj2gKCOBbGOx8hEfmv3Z6t7r7MEChFzXEAU8EW5Zr9armoV3gz/8SgPgpA
         gTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ggOSz8ht1ri74CY5rqN/s8FPDAvFj7a4Vq62xIB7QpQ=;
        b=UYyGZbkIdrg5fKAY9jtkVuWtsPxX4H2luhiLKp8UnmP6cS7a8amDqXbW1J4Fryh7bH
         B4qbtzqMtHlwg/hW5uCLmxrdSwkoZavegqUWQzikstZYh89A+RYBLV32Liw1o8Wo23eW
         Rkt27qLNnzQKNc7z6WbpeHZbYCBquIukdUACPToGKOjcRzsGL7BHP18ZH4PGL4HECUAJ
         +tZw1lDcc/XqRrh4xarN9C+ejicndmO5iWuVCw5Xz5F0WE7GKaco76Jgfx4SCNpbTzU+
         Eogo+jN7Dxlsa8cuVAVWOrB9A9SGeYtuUG7bkpVqay1L7jrmpHjeZHgFIfLmLf+WOb+j
         BINQ==
X-Gm-Message-State: AOAM532rqu4tyYFAnng0RlIb7uROWUS3rgYfvUP3VhGvPiq5BK0fREzA
        x8PZDLaoF7aJ1lSDrCSDZmjXoxc1
X-Google-Smtp-Source: ABdhPJxypLN9SUuq6qY8ZnV8sLXfZZKgFg3SISj4H9DDBqtffiu/FS6GraQ7yzt/vhGxq8HcFO8fTw==
X-Received: by 2002:a65:64c7:: with SMTP id t7mr979592pgv.89.1597155805910;
        Tue, 11 Aug 2020 07:23:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22sm3081834pja.36.2020.08.11.07.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Aug 2020 07:23:25 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:23:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/67] 5.4.58-rc1 review
Message-ID: <20200811142324.GB195702@roeck-us.net>
References: <20200810151809.438685785@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:20:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.58 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
