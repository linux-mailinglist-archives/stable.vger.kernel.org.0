Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96228D26A
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgJMQlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgJMQlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:41:04 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC114C0613D0;
        Tue, 13 Oct 2020 09:41:02 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id w204so77544oiw.1;
        Tue, 13 Oct 2020 09:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IM6YvhhMcS0VXUgWOd+IejIqAH3xdFSgZS85DoAPgfE=;
        b=U4Aux0FUxkHwSAIBpmj51+aeO6g4lsWa24rdDRti6LVD8Sdmfkzsr8yz5/YhXKZsgh
         +1IH/weCvI2fzYlvylrDDBHlVxNOJincc4sWiNM58eA7bk6wmCj6ATMDbP/4sT5aU95+
         qWSJCG+ePysYr8toHn2f9yMz8ElMNofgOVDB/53SQ7zSFbP8ekL7zyRo39zBh8PLuwUE
         7jYDPLqfF0nwunaLqAeYJAmi4r8DTaNrMP5PhekuONrDeotxxvqzlBGd3pEXdEwKg8no
         Xyw3NQwRgGMo5QK0LJoD2GiFKzUZLWVNIKasItDjy9NnuQxsJshoA0sUBmXkUusMm0C8
         Bpcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IM6YvhhMcS0VXUgWOd+IejIqAH3xdFSgZS85DoAPgfE=;
        b=bfXupNF1lkxE7hDJb5xaAoq3dd4lcdZe0gHldUO5ApwjCPMNd/PE5K+727hDY5gF6Q
         chS7C0thH0aGgTmlAVTCmhK/IWtI0uxivSzpRY6VNuUP+LmYhisUenb27iW3VLGSEd+o
         Up2B4/GB+HgtWZqMF+LulsQdhFDiy6St17/gr9F+mT7+vChid1dFk3eJgeaJFlv7hZM/
         OoyI3owOqTl+nRJyEQEk4xQtjlIix1oWrfbzDhgwm/VXYKJbi4YPuV+HA1LapFKICKA3
         +FwFcBmDpYyaIC+oA8TzG2K9d9qfXpKHoByu/7oHGW+a4Vw2wiMvUGiD7TeRBlCnXY8q
         AfVw==
X-Gm-Message-State: AOAM53166IsLBI3fMcgsBq+aKDV+DH1lK8Bx+cY4Ziz1Laj7yCe0jYVY
        rPYrXb7HPll/tJqk7rt1lPs=
X-Google-Smtp-Source: ABdhPJxwQI2fpJhAvPOdPPrXufTQ1KnPT1sIDSh+v2RH6a8aKDYX9J75JoS41MXwGVPE+vS6Y1ABfw==
X-Received: by 2002:aca:6209:: with SMTP id w9mr379782oib.68.1602607262204;
        Tue, 13 Oct 2020 09:41:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l62sm93428oif.18.2020.10.13.09.41.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:41:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:41:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/85] 5.4.71-rc1 review
Message-ID: <20201013164100.GE251780@roeck-us.net>
References: <20201012132632.846779148@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:26:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.71 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
