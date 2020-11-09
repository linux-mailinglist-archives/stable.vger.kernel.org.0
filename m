Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F242AC907
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbgKIXFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgKIXFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:05:34 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1529C0613CF;
        Mon,  9 Nov 2020 15:05:32 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id y22so10679268oti.10;
        Mon, 09 Nov 2020 15:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yosY1X/lp2WurLN3A+ckwBqf1ukozPcLkaky5QXLRcs=;
        b=uAE2S942wAYm6MMpian4UYYFn9a5hmXIVQJ0sZvHkEp9yPhe9CIpeBBQswmlonmVN2
         /K7ESkjNDL0Y6PdPOudWNnkAKJYXyND8yH/+/lK89h+HjSDBu9Q2ZO5+u297GRL+n/1v
         iENpEV2goW6DIbjHKFQlYbuJH1VWNmaWNXKoOchL5BD7Bnc4grrEzgzPMPF5/7bhwKbB
         n1fMcwyPn6fFkjgPB/a3BLFW6ezeMN9WCTqBI8yG+Q6VKJxjQCbQbYKSLm8PPBFx2UVt
         gujx8W2gfi5/+qCGcGVPSTLI65bEDwVtGOGttV2ABOB/XlpMiQwSIN9f1hOExBa2scee
         JgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=yosY1X/lp2WurLN3A+ckwBqf1ukozPcLkaky5QXLRcs=;
        b=aRL9k33kGJLK+7iQbVX1+R+v0Gx/Fhx66rYTG4hcEqS919w2I4m8UEhlMPmjkUQVrl
         3uefbs1n82OWfrnG2JIqp0/wzi3eVogMZ7aTyzhn2JakVxPytENChYx9JBWZ2nS3Hm3D
         HqQNdnBqD524r3Q7WE3Fz6XV4Yn2rZSU/qBwQY0fZ6z5cFS68b+IXabzBMg2Gzbvm30U
         7LX4EYdHDItjZX9XwC7ieQ3B56WsxeOcojTDLWnrIvKDbwIlJA6FhTpmjJ2X1eulD+DL
         6GmJ5buKHM0HMEHOjpyFsWdpmoYig9UoMbuSi0fX0PwPgJcnWmW/g7BwfQYIyZlnOH/e
         12+w==
X-Gm-Message-State: AOAM531IylCLGxgc2eOe8aFjEtsZwYMi/CNg/G5QbX6BzgYVUGzbfdXK
        t8oOOkUr8w9KxdGJK4ryed0=
X-Google-Smtp-Source: ABdhPJwxxPWYQrepLb6uCPENXijphHkLL9KyAa+MGNInnGaiOvnAF6uNPYtjowNwc4PHxaK4KOoQ0A==
X-Received: by 2002:a05:6830:8f:: with SMTP id a15mr11500464oto.362.1604963132264;
        Mon, 09 Nov 2020 15:05:32 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u19sm1419582ooq.36.2020.11.09.15.05.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:05:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:05:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/85] 5.4.76-rc1 review
Message-ID: <20201109230530.GD92773@roeck-us.net>
References: <20201109125022.614792961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:54:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.76 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
