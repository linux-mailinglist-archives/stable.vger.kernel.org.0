Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971DEC28E5
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 23:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfI3Vg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 17:36:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44423 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3Vg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 17:36:28 -0400
Received: by mail-io1-f65.google.com with SMTP id w12so14211806iol.11;
        Mon, 30 Sep 2019 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+3MdKnUABv25IAdSiEwkkMJWrh9wQQENbXR7LVZp6NM=;
        b=rwTk7DUuEf/bOD3IPt3jYtXeL1pQVj2ohRY0XQ3AP0tOsJ2BWC4TpFnBHSZxJlkjCl
         c5Ok3/FsUTSTbvM9nvy4HDAgMyLpyXgvo573qakp28AvJJ+IsWa8U74mtP47qXa6u61P
         QfR/8D/Qn3GweP1WeG0/ssbQK4o/paBjxJ+K+Er238HR+5b9Oh/fz3ygumwP01VRrjvV
         DRfy/m6IsXHBoAggbnaA/ThYlpLFrU8tzqsEHlgZAsG046cnwUFUd2WHCC3x0xRo9gO5
         KiIvBknb0aY767m5Qkr1Dui4ZgM/vV0x0quzcKzLuv/ewYKhnqOWH0UsIQYIayerMHHF
         CktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+3MdKnUABv25IAdSiEwkkMJWrh9wQQENbXR7LVZp6NM=;
        b=ezeQCQT7MrelrOr35wldBfZMfmtzxktrJzCbRadf45uDEFejWif2IokZ53Dan+Xnfy
         8fyGRmeHjn8hN7bwyvBctH/PZs4gFFmIhqQo6QAtqAo1jdeQ8xprLZUFKFKas4nO9/p3
         tYa/UHy22kOu6/pixzp85ABrzcWW5X7ZTB3ck6UsBTOyuCaTWzibDqlH16eIhIiOCr74
         UIhjmu2qgLe1d0RI/Qlz8ZFtrj5qA8scZnGwMHGGYFkm98EkfeO6AeZGgJmXSYYpU5Zu
         SXiyPV/spkMLPT1fNAboY7FIY8pm4h5tST821qBo/KVtqxb+tifSIN5+JoymYeHr2EwP
         xwxg==
X-Gm-Message-State: APjAAAXQaZZm7KSfCeTSI5G6Geb7fUNCuuAeJ58Q7T3C7N/4pIiplJie
        d0Xz2M2Rn7EA8/GlJH+XWTOyNMkW
X-Google-Smtp-Source: APXvYqz0E4xOhwB939Y2K1wFzwpGWnKp5rCshUvniErBXZsosyGQiMGXlEU8rwrkx/i8InQ1QJKhbw==
X-Received: by 2002:a63:e812:: with SMTP id s18mr24809098pgh.291.1569868216516;
        Mon, 30 Sep 2019 11:30:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z25sm12300003pfn.7.2019.09.30.11.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Sep 2019 11:30:15 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:30:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
Message-ID: <20190930183015.GB22096@roeck-us.net>
References: <20190929135006.127269625@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:56:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
