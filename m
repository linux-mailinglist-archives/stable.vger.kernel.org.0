Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1AE149231
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAXX4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:56:51 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35650 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729236AbgAXX4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:56:50 -0500
Received: by mail-yw1-f68.google.com with SMTP id i190so1747996ywc.2;
        Fri, 24 Jan 2020 15:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IB0HN3PfBnrcaxk7RY4s5+dLxXoRwdVL3Tn514tmq/o=;
        b=SxAPXatX30pinmp4Yjs3/VzySYac6FTvlErsLzZ7mrmzIB2vFTCr+gVLfYXjrCoVyk
         7PrnajFD815jR0H/u9IiZ1dJ9OJEoJlQ5XmzWsV9IJ1IY9jKr7segSFoTlOrJwDM/FL4
         ZjsaUt5Ai3ZJnByxkLkK9VRD588WDismrqBkIuBgsV322US4b6qnv5TFPMx5Q0dQ6jGJ
         KQxnyJroftbW38PceJKNZlTVbS4V9pAuGL8xmsIldGty/A1JlUivlJTsrUvwyztFEZIN
         twEcQqxC6oxmC6rHaaGLT0F48O+1c4Alju75kM2h9nFK6wW5ltixF8xkYke5gxHfLg6P
         QzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IB0HN3PfBnrcaxk7RY4s5+dLxXoRwdVL3Tn514tmq/o=;
        b=V7Pjjm9pUS2goiTsuK2ZniwHObBud6exTDfO8/D5okvlstju2rmH9b4t3IZbTkpu+W
         JLrLzHNFfF1/o7uq9OopEWkgSI1ibiu8gOlX7XJHX1g6AdA4AajRpV/WTf7hDOUx01tX
         XaiW+gUgR+xS3XS3Q0NEOvy7439P1DcCgXo0yGu6E2iqUxQp8kD/HpZcqzL05Lx3+BNS
         M5W5lBolFCMuXN7EPPNw+UlI29CJSBjeqbNlktac+sp+pv6wx7MBc47V3PafFpdRlAVC
         pF1s9VmO7Szbpk3Sa0TvhyMMRO3Vjk8j1bt++5biugwY3si/N1gykpsDQ/GUQjv9oX7x
         5LQA==
X-Gm-Message-State: APjAAAU4R/NTJMdzuSGZtGkknSiMgXjLMddbbyu7G+JKt1M68Yp42iDs
        ocT7E7KJVk0C7Wwm44B6cC8=
X-Google-Smtp-Source: APXvYqweeMo5SOCaLu3QKLrjEQ0y0/qkiano5QiBhjDbmSNJSlYRS1N4raGAwBRzrDydBg2VPu0IHA==
X-Received: by 2002:a81:4846:: with SMTP id v67mr3954715ywa.459.1579910210044;
        Fri, 24 Jan 2020 15:56:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w5sm3275188yww.106.2020.01.24.15.56.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jan 2020 15:56:49 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:56:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/102] 5.4.15-stable review
Message-ID: <20200124235648.GC3467@roeck-us.net>
References: <20200124092806.004582306@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 10:30:01AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.15 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
> 

For v5.4.14-102-g5b29268443c0:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 389 pass: 389 fail: 0

Guenter
