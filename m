Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB652E6BF9
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgL1Wzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbgL1U1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:27:40 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB3AC0613D6;
        Mon, 28 Dec 2020 12:27:00 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id a109so10187899otc.1;
        Mon, 28 Dec 2020 12:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BdOEXk+rRvQklnLTMZvml+dqs9iD66LsEUiGTeRAC+M=;
        b=Xu7nSQS27Ma1mYJ9KGNH5ht+mxx8xO28uNw211QiVdeH8Z9lLTO+Tii8t13+z0KIC9
         nSS8Qq23KWEHzhAk0mKwosvAw2JuhQNKDmSb6GR5a4yuyZttvac+B2dvhsvUGHoDRhkv
         izHt6U/TpHenhsGoWw3ynV/5QRp/rKsoVdJV3/O0hu5HoSRvFMoGGaDfvJUw3xa1jSN2
         c2xc0Fjsx0cg91FXK1X7Um1dSET33JBvQApH0xWItvorrpHYbZg3lgW2yR5u8D/4ZfME
         LFTeMf6rE4Fdy4IA1WkOHTarC2WgSm31qIwC1R6csCi4gYFIRYGlinC7crQnamgu6NZa
         2BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BdOEXk+rRvQklnLTMZvml+dqs9iD66LsEUiGTeRAC+M=;
        b=lSs2AAi3bhXJ3035dhuo4tpJ7tO/oq/+JoCvOfOwX094qwJo1ME11jwh9qnZcyeSO2
         lIAYNKyJuuFJAUX6/AK7iJscuzobEKrY6Wm2resuhRLxcq6Pr63QFZAHZFwFgUKZ8znL
         KScAbK9zH3L8dadYsm95tsfmKmdKPM8wBV6VKZ1wbuniQELpUJDn7WjXAvIWRtG2fmTJ
         oLbnHwIa3ni5Aek7ToI0Yzrr9XkyXHaTmwcg13O6haBIDp9WbxFAkFnnlDV2VZDeHNeI
         gN7Qg/fwyOr9EivxivzqJtXwYMNeMbNL8uOrydpEJ9Go7K8E59X4tTI9E5NRpD/ePWVf
         VjtQ==
X-Gm-Message-State: AOAM530/n451nSeXICGnCkaSsvMKIDbH1fvDZ69Rcti28MROHKvNnl44
        uKsAUQHv4xZeyZi7HlWLAc4=
X-Google-Smtp-Source: ABdhPJw0eacDFOxg4C7lla7JnWTiIAgTx2BnRDS/haAD6HBG+bjMZ2Ct+5tLw+oR5Iv8UERblBxQ0w==
X-Received: by 2002:a05:6830:2402:: with SMTP id j2mr34480630ots.319.1609187219358;
        Mon, 28 Dec 2020 12:26:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r8sm7147799oth.20.2020.12.28.12.26.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:26:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:26:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/453] 5.4.86-rc1 review
Message-ID: <20201228202657.GE9868@roeck-us.net>
References: <20201228124937.240114599@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:43:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.86 release.
> There are 453 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 154 fail: 3
Failed builds:
	arm:multi_v5_defconfig
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 427 pass: 427 fail: 0

Failures as reported.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
