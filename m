Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FCA180B29
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 23:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJWGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 18:06:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42961 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 18:06:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id h8so33402pgs.9;
        Tue, 10 Mar 2020 15:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vw7q3wO5xHFp8C4lHbH3aXHNFZTBELzWX+v0PT+gCmY=;
        b=eEBd8fQ32tavv+Tw03Q/4eyjuZtF3iAyeXxulJzHCxO5RbxFaF32VQ3MQUPvPQX6sP
         GMqL5xgtddEmFGlBzgHSKVhqvaaxyTru8CmbHzMh61TR3XhD+R1Sz4K+QrGmTLDUt1hS
         FIzpM8YOQd5JOwju0/VuB2XcuQtBkJnhu5E3awJLox0Wgn5Tp7JgLH4EhMjd1ADloK2o
         Ul7EjCbiBi64xO4Qy71r6+a8rcWbZn4hC5/zbY4+xnDrzKdK5/iZRFZ4vqhwflY4uUCX
         DNYIPyhxniADqMiaJgYYoYlUB6ZUBfbVeFhX9SJYqo0TgWLkI9aLM5tcy7jZ5rmnlr5q
         /rJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vw7q3wO5xHFp8C4lHbH3aXHNFZTBELzWX+v0PT+gCmY=;
        b=qxD9bj5hz/bXXZZNRpQmwvdGuEc7RX03oRs03JZhSOXs6IFVk0XpXQ/ULJotiGg60N
         jgOd36+1+4yj5QFKcBUv3eTTUKin1R4ffzNRh1kIMEofQ+8L25y77Lnd4DcTW1vIAO8g
         chb6RlN/GST8bnPyD3WVMVB7PEi1MyzB0adhGnpI744nKvxiZI5OkaD+OEEzeCKdp0yp
         faGRmQbu5ZDp1f97DovY43GNU0O7eovzTbce0E+dqZ1YMA9BjMQvYSkLB1lEHYbARAKy
         kb5VUuFo6iWJ+w1X/NdNrgTWx1861WTNTDxpW9uz2UDUi5DjFbzpLVqozhymg1kl5AfR
         pMXQ==
X-Gm-Message-State: ANhLgQ2BQ6PQ0gLZ/u1qlBjWeE7W12ej4lLbC8T/a2TtBNOJJtGnCmZH
        fqKCwXXFKouJamnyavi1X2B+vR0S
X-Google-Smtp-Source: ADFU+vvNfyTEAFpNwA4gmC130f6QOgd+jQjAZ9Ojmo6Gen6c+Fo+J/nD+zh9qLIvPLLHVBoGznYW1w==
X-Received: by 2002:a63:f752:: with SMTP id f18mr22782784pgk.196.1583877960847;
        Tue, 10 Mar 2020 15:06:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n14sm3358908pjt.36.2020.03.10.15.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:06:00 -0700 (PDT)
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200310123639.608886314@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <a98e88fd-8e52-4f27-5e06-878241d65d4e@roeck-us.net>
Date:   Tue, 10 Mar 2020 15:05:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.9 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
> 

For v5.5.8-190-g11e07aec0780:


Build results:
	total: 157 pass: 152 fail: 5
Failed builds:
	csky:defconfig
	csky:allnoconfig
	csky:tinyconfig
	m68k:defconfig
	m68k:sun3_defconfig
Qemu test results:
	total: 423 pass: 418 fail: 5
Failed tests:
	arm:sx1:sx1_defconfig:initrd
	arm:sx1:sx1_defconfig:sd:rootfs
	arm:sx1:sx1_defconfig:flash32,26,3:rootfs
	q800:m68040:mac_defconfig:initrd
	q800:m68040:mac_defconfig:rootfs

csky:

kernel/fork.c:2588:2: error: #error clone3 requires copy_thread_tls support in arch
 2588 | #error clone3 requires copy_thread_tls support in arch

m68k, arm:

block/bfq-wf2q.c: In function 'bfq_get_entity':
include/linux/kernel.h:987:51: error: 'struct bfq_group' has no member named 'entity'

Guenter
