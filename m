Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35160CC62A
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfJDW7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:59:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46724 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDW7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:59:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so4733244pfg.13;
        Fri, 04 Oct 2019 15:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CIZxQaWWP0rp1yfI7bD7fjQ9Sju1hVaibmotupE53h0=;
        b=p1k7ys5vzM97auvucoYKRmaqUUMpHPI3HaUz3+ZRpFDH05S38gT7+SWuZBM7mB8h/c
         hzXr41C1vQfV6HcvlZZ25uGTLMAuVEA3WoE55uU1wtWEiw/AgS8F72ug1OpWeunGUvdm
         uRprlfx7Iih8gSUegOv+qeYGjcCD1ikHWK5wC8zDLSKzCnc3Fpe7+sazE7O+4h3BVsY7
         tMQ9S/8m/I0RTdiH9JPcJGXBJhzjpZZmLipOud3iF3mI27iejowXkM5r/7yfTTtzsvHN
         R5He3jqiF884EnrVFYEMlsAL+/3brGpLEp8Png0sV2bU5ZmcbjfAAqk/iNS4h/RGTVkz
         bqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CIZxQaWWP0rp1yfI7bD7fjQ9Sju1hVaibmotupE53h0=;
        b=a6ZpdnW/OHL1yGiObHycyfNNI80+yRgzETXv3jG6M3SFicxa/TDYgwlXlOhxuMfIPm
         C8owo1QM11XipLnrsq7XxosDsxQBL/IMsEQW9uXoDPqOHQnKOcwHxdY9ktU5j+bgOBEt
         xwT3U6G1SiIOIW2MLyZsTdSt9ib8B0vx7Uaq6JLZZPPmVMlMWapsnhSYgl6bfxJhCQVQ
         rSpNfB4a7Ay6d9SOYAcFOu89QX2G62ZNBT0wIO30R5dBiGiy4Y0u/xs6S8hH6PczI7OS
         bQFIU46MsMJ0NmYLIAbpPsqPv4XPVrXRFd4sOaWKwmJUReHj7zuoriV+mkcCK7teIi+p
         AJGg==
X-Gm-Message-State: APjAAAVPyGG42o/3FgKziGhof5uBkXXk2xSDvnwKUvm6SqiMY/Z9fVYV
        BXFQQFSX1JyCjtv/vHIzEC4=
X-Google-Smtp-Source: APXvYqxDByI2Tl2T7mfNjw/+nXAqU++MT+19bL4hjcb85bRISc75Al55GBN04UueD9ShQDANA/r4OA==
X-Received: by 2002:a63:790:: with SMTP id 138mr18481075pgh.220.1570229940341;
        Fri, 04 Oct 2019 15:59:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 14sm8594327pfn.21.2019.10.04.15.58.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 15:58:59 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:58:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/313] 5.2.19-stable review
Message-ID: <20191004225858.GE14687@roeck-us.net>
References: <20191003154533.590915454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:49:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.19 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
