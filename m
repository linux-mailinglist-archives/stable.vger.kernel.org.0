Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61D623BFA7
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHDTXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHDTXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 15:23:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3348FC06174A;
        Tue,  4 Aug 2020 12:23:11 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q17so23772697pls.9;
        Tue, 04 Aug 2020 12:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MtM3ApfyNrJjXu/qEmYD0OW7ljc9Cz+zZCrUbTUZlhU=;
        b=k8fF1pbV7XBsXCm8lNQjhYtqaEyXCmRQ5FdL0m09cYJlJJRIW2hQZBEzovItC2RyOW
         XnAI8AZ3RSSpDseWaYsUxkNnNeAz/73LvaPto3LeSMRD6Z/YoVQw4yG281yGJT3ycRlk
         GCr0gilLKZ2b5ZrSJKulXNerMKVOVhGyrQraELczZckwiUQyYKt8r9sN6FhK1EXBcZWM
         4CJ+j0/xGI7ZbeyWtsAgQYz8L/OjitB7vwWvFlYP87z6O2+sg5z5tCdGEyx3J8guyTXk
         nR59Hg5YavJYc97CoHf1bbAdCyQyPgnMBTXLJqvcG/VES9PhZwoolmr0XehWU3vdWbr1
         C0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MtM3ApfyNrJjXu/qEmYD0OW7ljc9Cz+zZCrUbTUZlhU=;
        b=d/tZDm4KK45E4dDAK1Y7nGs3A6DicfzzP4bBchDVROA5sJC0HY+fgyhN0g9G3rd9aI
         c3JTd+59QNHGj2dJtGPsFootxmB9Yp188fIseR/BpgaOas95HyoysUdYQHu/gWlzGwhE
         IDDycR4Ay32te3MtL6CusxSAwIS9HaettBobWyYg0YYah+h6DN/lHxkVda4k+HAQIV51
         gIMieCR8NB8eP8pNwSUWStNEaYHI0c7XHfCFTftRVt4ApEoYc2coOgTs3Fi/1c+Ddgx5
         0J5+tY4HwAjiV0WoynN1bTqnhbSnJjpUrk4t+kUb0FWbbwYsiEc3XUxY5oj2mpKd5q3O
         7Wog==
X-Gm-Message-State: AOAM530Z9nR8IsuKFCKZmTl4D9bq7+dc2sz+voQNzeLTmkoOBwUDKzQd
        cpls4EWFgmwgjj1spRwZ3DGuZhJ4
X-Google-Smtp-Source: ABdhPJz42mKnVMjsnjZvU8Klck7AMDarFEqqfRVs6OsR3SUCKCyLV+EfuIX9ZdhkbkpwIdJKSDzKng==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr20472262plz.8.1596568990774;
        Tue, 04 Aug 2020 12:23:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l17sm1448734pff.126.2020.08.04.12.23.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Aug 2020 12:23:09 -0700 (PDT)
Date:   Tue, 4 Aug 2020 12:23:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/47] 4.14.192-rc3 review
Message-ID: <20200804192308.GA186129@roeck-us.net>
References: <20200804085215.362760089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804085215.362760089@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:53:16AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.192 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
