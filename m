Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A454F10770F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKVSNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:13:40 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43157 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVSNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:13:40 -0500
Received: by mail-oi1-f196.google.com with SMTP id l20so7281980oie.10;
        Fri, 22 Nov 2019 10:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HWSTYNzlkfy1NirQ9eTd5paYFBQwR5NNRGN8Mv4zqh0=;
        b=fCxdEI/y1U5H993S8qPP8GKEjbQv99Z0GnwdVd6TnAguaqBZ6kfHp13n7Pa46fPZbA
         kaKPqt0Sxhm9nWX09zgGSTGZp2P0ynr2EWGussUZA9lkg01YLAjcBDkmU44KRb7ll1pZ
         2nwFbKRwjzSt2lFY1OLdVeNg4/KeLtf+u2zVVhLN8N0VGHSIrFw4cJ/8RTPt6N8oKG9G
         IG2uP6IZK5kQBN5DcGyCEakAelmGmudhnYJYnIjuQhM3vy1aAARSnEExlsp5CiCq9i2m
         pxqHAd79qY96EAF7BV+RRgiXNFn6NdE0jto7iYxHAOeO75TzSayGp1MDpMrExwlW970y
         qwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HWSTYNzlkfy1NirQ9eTd5paYFBQwR5NNRGN8Mv4zqh0=;
        b=kdbebt9CZs62DcFp2jB+bP5UFzKHwGpnVtO4lqtrkgEhLwydq6rEa2Sf+pgxxweAyB
         ft5b9FjCdSZCBxBU0DsHaGq6qSEYnhqkc1z9L2JuvaAeqwDmA9gphEs+aypOf88hYOff
         5Wx3i7xHBN7wd8ksTJkunV4yJLmsU7+2LXquT3cvteTOY3+8pKraPxgsPFGNvLwxIuVp
         MrDm+KlgfMS+EZdR0KeiO80efwS6ygMpkb6d2+XhMQfr5CnoYgnUhIvWrSB2HodprrMq
         5XnFLpXjTyBhViXAFU2TYy7mdZbkatWuu1aKa5wYe18aWPIs/F2ayQRe7sjhBtFbEC9t
         Q5Rg==
X-Gm-Message-State: APjAAAXvnq1CZqVZuCl6k6HU09yxCBTJG0GzCLjpQmz2ut5cyANd80CK
        o76t1wNDSnO02N+D/CgrFbs=
X-Google-Smtp-Source: APXvYqyfJQQqBax+9bnfj+470MXeZoqlxTrix7Mu5n+3Is0+VYL0rUW6+An2aBQ2/fuFHCmi8yukRA==
X-Received: by 2002:a05:6808:81:: with SMTP id s1mr13715833oic.65.1574446419747;
        Fri, 22 Nov 2019 10:13:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k66sm2257160oia.40.2019.11.22.10.13.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Nov 2019 10:13:39 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:13:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
Message-ID: <20191122181337.GD13514@roeck-us.net>
References: <20191122100912.732983531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 11:26:05AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.86 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

As already reported, there is a new suspicious RCU usage warning
in idr_get_next().

Guenter
