Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C17C9EEB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfJCMyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:54:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36402 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730208AbfJCMyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 08:54:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23so1747785pgk.3;
        Thu, 03 Oct 2019 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3KwiyzQXnyUJv1x/MpX8d1dxJ0H+8l16xNQfdlBiu7Q=;
        b=Ki7WXgc3hN/m65nEvTuJa+uSDNFti0pDLKU0okGj1ewDEUaaeJHorGdPZtOksopZpl
         DKDH5I5rAEOnD894ytQVVWiAv0YTUDVgOpxXblBzaqDR6yJhS6dXUqWAmTPvHFE72rqT
         IMfui+z3v77jS1XjCRtzy8RhFKgUqQjsZKYHnZ4lX05WApaHrlAbkubZONZKchxO9QlL
         D4gwXaUb12kYGrh9WKWfRs9ef6sjT4ERyIk6C6lpIsBI+lgWlxgwZ6bbvlGQkHW84dzC
         lJZZYO22PQfFCoILqICadeFaikNHBMW3aNbBGHFNWdC1r+r/xI6kirTjjVhnQZp7TAC8
         tW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3KwiyzQXnyUJv1x/MpX8d1dxJ0H+8l16xNQfdlBiu7Q=;
        b=q/G6vE4mvtbVUoxA5VHp9rOUP+dIyTy9S0qFILANdNTwqcfu9SL1XWZU2Yfv7DrDlz
         DAXrQpVXI48og+nJE2LtDRseAlWYlaOy4+Ge8MUeyNPgVwkP/csHPHn6cHI4ioxmVUCa
         slCGJkPPyzNlClFI6Us6x7x1u0K2U9+MQ/Q9F02cQpDjtzDCZJPj5fETPYNkJ3FZyP7x
         1BtCNiIIN2VZqDPeaAqNVQq7VTojND9nAbLZVdFeVldW0xmVF//xVP5zFpGW1bU+l7dv
         26n4ECGJX9lZBgtMUQOhvdJvaXIu65OsPvoYcXgJGH+MCO8buLiPptjo7Ve8xCrWIxBI
         whFg==
X-Gm-Message-State: APjAAAXof1aysUbSrGiZ8zvC6Y6zctyWd0QqxP1cqtOMNkzdW9zQ/uc4
        adnsC671sPrzBb6ErIiB4lM=
X-Google-Smtp-Source: APXvYqyEIaDgDSzD8DdoQRFBDstfMRvl2zMjJnbtV8041AXWaa/1PccwYt4WDZQDa124/NUEXYAcpg==
X-Received: by 2002:a17:90a:356d:: with SMTP id q100mr10627772pjb.53.1570107283855;
        Thu, 03 Oct 2019 05:54:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c6sm5516569pgk.65.2019.10.03.05.54.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 05:54:42 -0700 (PDT)
Subject: Re: [PATCH 3.16 00/87] 3.16.75-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1570043210.379046399@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1a374d67-9908-6c7d-c428-219ee6d79ee4@roeck-us.net>
Date:   Thu, 3 Oct 2019 05:54:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/2/19 12:06 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.75 release.
> There are 87 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Oct 04 19:06:50 UTC 2019.
> Anything received after that time might be too late.
>
For v3.16.74-87-g815992c3a9a0:

Build results:
	total: 136 pass: 122 fail: 14
Failed builds:
	alpha:allmodconfig
	arm:allmodconfig
	arm64:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	m68k:allmodconfig
	mips:allmodconfig
	parisc:allmodconfig
	powerpc:allmodconfig
	s390:allmodconfig
	sparc64:allmodconfig
	x86_64:allyesconfig
	x86_64:allmodconfig
	xtensa:allmodconfig
Qemu test results:
	total: 229 pass: 229 fail: 0

The error is:

drivers/staging/iio/cdc/ad7150.c:9:10: fatal error: linux/bitfield.h: No such file or directory

which indeed does not exist in v3.16.y. Culprit is commit 6117323f0fbfb
("staging:iio:ad7150: fix threshold mode config bit".

Guenter
