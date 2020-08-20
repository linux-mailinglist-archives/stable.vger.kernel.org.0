Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605624C691
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgHTUGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgHTUGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:06:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3E3C061385;
        Thu, 20 Aug 2020 13:06:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so1652496pgi.9;
        Thu, 20 Aug 2020 13:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ws7KLthtlvcaN+hNq/7gXjEUWx+KzV71hjE8x1ZKWG0=;
        b=fujbvCMYqtNIXAjS+2zZeXwUtGU7tKud8bda4EIDGmIad/5uZh9+51R5hUxkGjFjlw
         P17mT1hj3X3VdR1U3JcA8TfEfoAV0vK+F5DsgrYFv9rWUb2rZCKcAP4OuGzQYbwIiKLm
         mp/D4khz0/OO2i+k76nWdAnqE9Hcy7i0uPfqAByjzOL9OYH7mdWYJZpUPhiZDmG+RyW4
         q0MbpENFaT/x6Hz5HhWTkWiYHyTPVeE3ZJksbCe9rt7EOxyhB7V2WmSsAcINJDI8vhLt
         B8w0Q+45NvyMcMmrNAtaud43sBvi8ZJ4mfL7BfKTkg6/aMjAZCiekSgS1jIPAF4XPKZ7
         3ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ws7KLthtlvcaN+hNq/7gXjEUWx+KzV71hjE8x1ZKWG0=;
        b=rNte+/49jmCJ1WQeJl5qpd6gDdLtaKC7ry4ClZRlhVBr7A7NjFBfvIUN6Py82bziC9
         ngWjD1wJC8CyFDVdH2ciLWx3JFUfNTdsyUqN3i6Ex/f3r1JVVff/MC8bcMQSnt2AlFs8
         Wz4KVcxR/aK4X18Es5dp+sPCcD9JjVbxs1wPq0XIkOGKIUAXWmOSKI1AWaY4kYIZWLPr
         JczZjS5q7RkbYOMr4cLmGEV3x11+KJrCezaFLrAjrGgIrgS4X0bbqeq0rLuJERcRQhZV
         CnyJlMVdLluTz0Gjy+KTRw1kJ6+thcrSCExyOKzwIwDzKG+UB7QswgN/jicLicZQUYFH
         cb/A==
X-Gm-Message-State: AOAM533RoRDYNlgfM0dYERO5UvHzbWsd8f+kDJ7B03nj7h/ZQ09gA+gW
        y3H4KA3C9UV5HBmrmXk/Bdk=
X-Google-Smtp-Source: ABdhPJy6N1gtGNITx2fvb4Y+W2AKYVPDMmkN9GSg55hn96fjF1AvDoj/d1LIpydvWtQ9URfwe/I7Jg==
X-Received: by 2002:a63:36c6:: with SMTP id d189mr296325pga.392.1597953992937;
        Thu, 20 Aug 2020 13:06:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s185sm3591584pgc.18.2020.08.20.13.06.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:06:32 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:06:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
Message-ID: <20200820200631.GJ84616@roeck-us.net>
References: <20200820091612.692383444@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:17:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.3 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
