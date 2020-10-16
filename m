Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB181290C04
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409157AbgJPTBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409151AbgJPTBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:01:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001CEC061755;
        Fri, 16 Oct 2020 12:01:53 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w204so3612612oiw.1;
        Fri, 16 Oct 2020 12:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oSo+H82zrkk/LEjt/UMvMsv1mUB4/HhkSeiBGnVeQpw=;
        b=F50KHa/Z4kdsFscKU3ZE0f/Fhypx7p9hFbwShhOxC+IBt9AwqQLLoU+FYZUBy1GYkJ
         k6eh6uj3XN0s6fWxBIvAb+Ra0rCKKh+eh1kiXCKBugKEr0yQ8QQdmbNt27uQKfvQ6Njz
         tqqsP7Ncw1HbRx6a0YT9Ie0VTmv8JVetp68sjKD8U472nCGGPBvRihqxw5DWhTA4MwqF
         839OwE0eBbQFh3kPVwXzJN4ZTJyTrpghghCQTBVBd2adtDRrjfluxVKd2Q44BSieNbjb
         OFasgvF8YvCH36W2l9R4hkskyc6Kj0fP8aSOqGxfYerNFa3jSoXBFgs3SmoEFw/Qt8PF
         ikdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oSo+H82zrkk/LEjt/UMvMsv1mUB4/HhkSeiBGnVeQpw=;
        b=IAVONgV7p1WRSJHAHc4tr7Q1G+valGodTNrbxwwb9KCb5Ll47U1+Ny8iE7wc7Z9t+A
         bRm9kpKJ+75zJXHJ2cuRMXZDuAjC5q6vX7k5A1nsndMtl5XzmNlriRwPuk7mcVFhiz10
         idB2LR2FVvBLex6XFx49LPXvv7Ct0RWVQ+RBStuJ5doJzQA8guGmbaevl4YpKeJtVBxn
         CyZDd2bnPm0bGAr0slO7xuKwmJambJn5JPO24tQpt+77chbfqWQuNHLkr6njhgXhvvB8
         EVnsJ0IlhJTBLPJEGbeetIf37kFoaUbD0vr+L5nSp7iAfoHZaj/tylSFj+DgoEJAhZIL
         wqEw==
X-Gm-Message-State: AOAM531pFvaoQN910gV1MVhWhBOppB2Z3HLIBypAsrQylNF9kXIOfy0k
        AwoOCJkJ9AJebL4OBjnRQKs=
X-Google-Smtp-Source: ABdhPJx8cJ7e4olg28JOPBXephn6rK0B9W7IN47BZtDxHppFmPgHglGRcv6WeKxWXESLztvJ/cyStA==
X-Received: by 2002:aca:d64f:: with SMTP id n76mr3667693oig.174.1602874913477;
        Fri, 16 Oct 2020 12:01:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 65sm1195875otj.75.2020.10.16.12.01.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:01:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:01:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
Message-ID: <20201016190151.GD32893@roeck-us.net>
References: <20201016090437.301376476@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:07:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.152 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
