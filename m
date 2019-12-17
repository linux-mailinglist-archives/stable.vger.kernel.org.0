Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D3123499
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLQSTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:19:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36009 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQSTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:19:20 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so226885pjb.1;
        Tue, 17 Dec 2019 10:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y8THL/YW2uX5PxcO7i2llMd+Vqlo/H2mlplje0N8sXU=;
        b=ZySSx+plgUC2ZbCG8XuJXI0WmRx/rY+wdg4YYLyBWitJ02wmx13Go2xwUpDAnPnwEA
         ANbqQkLVSNRP01LvdDL+QMLjkyhscWy5sCZI6Qf4RPhbSlJ+10wUYLEWhVcOnobek6cA
         EyFo3B0drnFfoaTeKfNjs4gtB2ouccYHlcdKM4zkw/HgxeWDvp4b4gcHijwsTUsydDx5
         FIv6XyfpWv5gEcV6LYcjtGvXBpqiBBjP3d4lO4zFV8ucoJ/2opTCNY4n9mUlN/tJRHy2
         Aeb2+IbwbP7Z4Ld4c/COELvVer6/8ovAPNvNhmM10ZWu3tT4xXjfguGgUK5Eameklnhu
         tfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y8THL/YW2uX5PxcO7i2llMd+Vqlo/H2mlplje0N8sXU=;
        b=O/uqITCMzPrd3E78J4WR7DaHO+wDsHQFaLtEjtuJ0rOCG4w3w21ncx7mWkx0ROBahC
         t1oXArfCtpM9oRoJ7/RoZk7MMlfZakB/FUtEWTcISvdy1XHzcnir0d6roFn0J8Os2rg4
         zHobebF6lu5qGF7wkwUiCBtLslBTu7/1EzJi+ik2vvVWKyCoBHsaSy7QuergBBKmjzeu
         E4IOeBwDpxxLZVfiF0rLf920/HZcX5aESMbOHdW+XP9BXulQ1DZkl8aTelcZ0fbrZS/T
         m1IOTnxICQC6XIDMiklMt+37pcXJhwBmPnkwAvWdMwweDone8wS2YXP7D1gXIRERkdGk
         0rsA==
X-Gm-Message-State: APjAAAX/otZXG53teb7oVG6UDxtOd7OtNw5fEQ/KlbLiYCS7Z9UPDvbc
        DbS1ASxmX41yKHnJWJohC+8=
X-Google-Smtp-Source: APXvYqxwxgZNYKFKcxRhEJTCO0wliITlivYXlSuWvCEDPIKuDrdNMC7N4W190kWw79tFGi7wKgAQ0g==
X-Received: by 2002:a17:902:b48d:: with SMTP id y13mr25109228plr.215.1576606759372;
        Tue, 17 Dec 2019 10:19:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l21sm4112536pjq.23.2019.12.17.10.19.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:19:18 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:19:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/180] 5.3.17-stable review
Message-ID: <20191217181917.GC6047@roeck-us.net>
References: <20191216174806.018988360@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:47:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.17 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Guenter
