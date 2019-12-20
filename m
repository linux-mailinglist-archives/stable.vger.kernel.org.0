Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC206128259
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 19:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfLTSrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 13:47:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46565 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTSrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 13:47:04 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so4454903pll.13;
        Fri, 20 Dec 2019 10:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WUFFdmrlLLOcZoODl24Mz9x5e4SBbfgw0WqBc+hkjRw=;
        b=Zn/G+njrDF2WV1P+SPyANEG7P6SV/9L+l0w6UHSCX3+hvSciiJzE7yELDIKsz/K0T7
         w6evSjvopfbchMqB9MJaLl9Bkrg9qb6cQYs8UCTTaMEPWVO5dKcivREzBQR+1fWS7Ril
         5OH28j2J8CnZ8YAC/kD7tYO7Z9GNT6OTNrwCuacvGQRwSfriT+QT8ARexKjjaeJ+XK2N
         c8Uh78SghhVspsDKGIMeHr3aVGtB7vNUfFAB9ZHlCRpfw179Y6y6tZYpXmMMGR6yHGop
         vS6/yqD9NPTG7asg0MWQkx4yqpbW2ulbkpOaNA+DTc0x8WEotzmkuYAoe+N3IJ+/N0gz
         /GxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WUFFdmrlLLOcZoODl24Mz9x5e4SBbfgw0WqBc+hkjRw=;
        b=aLfX7y++rlKNpxEBCB0XmipTPpkOel0PYPPnVgCBbe7EPrvp5/el9fLec4KqW/pSVp
         i5TpOlgZUZK8CumXxGEYvAY0u2dYspnmBZZ+S5F5DiiVLUmZzRdI/H4C7xN6afShMMzH
         D5TF0uSaaoDiyeaXz2JebHxSs1DlspNp5dhKJ8Ti6HuWeU97ktYaT0mCp/s0W5Sa/5s4
         h28sZMnxoSL6KZaM7r0u5AsXghg3f/ZLIOl9gzVVceoj/SuRkaO2PMkzJSZWlvdzAZds
         00gj2D6fhqnKGl0MNfZo41T7gPDDuVImB4KcYjr1OxpC1HmXX27L70Z3lDSvlK71Lte4
         X9Kw==
X-Gm-Message-State: APjAAAX5s5sO8MVtY1eWqYqkEE6LVVkTYYOS+Xf6GIzDh5o7zKATUIWe
        cNm/KGpbg43xMMzWSwTwTpw=
X-Google-Smtp-Source: APXvYqxB8/zw26funWFuWvGzeZh11f08sIS8/UbzKqUeyTZIAzQRUyNCQBpUtuO27NEFaSHPrLBlpg==
X-Received: by 2002:a17:90a:ab86:: with SMTP id n6mr18006586pjq.53.1576867622873;
        Fri, 20 Dec 2019 10:47:02 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j14sm12390317pgs.57.2019.12.20.10.47.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Dec 2019 10:47:01 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:47:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/162] 4.4.207-stable review
Message-ID: <20191220184700.GA26293@roeck-us.net>
References: <20191219183150.477687052@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 07:31:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.207 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 327 pass: 327 fail: 0

Guenter
