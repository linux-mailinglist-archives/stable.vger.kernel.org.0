Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D3512DA02
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLaQD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:03:28 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36359 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaQD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 11:03:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so19695764pgc.3;
        Tue, 31 Dec 2019 08:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gYY8tRl4k68rJ9RJ3qf1OX97DTcbAI9maOR8pJnYvvg=;
        b=g5nurgnsyzOUL7BulOK8UfCi2moz/WyyYNhSJJHyvI5T4FhzRa1uIaiJSdw5QDqKp3
         tz53QVnDwMpB8GJKKOUIdqX10CIsbVYhJaA5fxSbNGa6xngZ9wXx8VQ83IZXCQlYJZnp
         DwVYE/tYnKhy7MgGsM423c6d0bCqPQDmqBcQHwRVrtaUm2puyVKe6E4OvF/6HhJbwf1z
         xgeozCYn1u6KY18E2RtQ/2SS7W+7ogMPNJiRCmcnYhhD6oVlk8wT3T/Tgo2ICF9LuSTT
         vo++KD612NTQJbBt1P6UswXE+EFPukFQqaP01sLSuzQoGwzUgtvKGCALUptYAHj3bDbO
         aQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gYY8tRl4k68rJ9RJ3qf1OX97DTcbAI9maOR8pJnYvvg=;
        b=JQwzqu7EDy/V9TxF/40llzZUqMZIHeYQPh6Z56v7S8p5r+YiQMbn6MPnGLxdqv2feO
         TJgHDhB8oosL5t5VtFOc4XMvtlvH6qMudxqUaBnrg1UYR9EMAbYnj4sAcMHeTEAuMYRi
         v4SquwFMOmdF60J+FHHVYHC0TJBzp+crjpl92eig38i1w1ocI5weDJ3+3pfaL9d5T8hx
         vAMMSsfKEepSspEQendPT6jYpiVD/a497xO2Z3yZhkTBIViSaNy8lTz10IFmr3CBL8eS
         AzWH9uigCUniOJO3rLGUr1ul/wVHuxDfwfnxQwfGJVSmQpubrljS5f6Li2SAYrti6fHw
         10Rw==
X-Gm-Message-State: APjAAAUn9b4ItJmqkthI8xHSdwSNwyoddBsjK+1Ck2Jk9H0skprs1Trk
        TxwsymmQRwZ6dOlwLyU/Gbc05tXV
X-Google-Smtp-Source: APXvYqw2jwGACF5ql25fmRNUB2jWSBqemAwmyZB4ApIcNaapuW8X5HQt2+AsQvUI/AXJEKi3CjCZPg==
X-Received: by 2002:aa7:8687:: with SMTP id d7mr77722817pfo.164.1577808207289;
        Tue, 31 Dec 2019 08:03:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8sm4100041pjy.24.2019.12.31.08.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Dec 2019 08:03:26 -0800 (PST)
Date:   Tue, 31 Dec 2019 08:03:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
Message-ID: <20191231160325.GA11542@roeck-us.net>
References: <20191229162355.500086350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:17:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.161 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 

For -rc2:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 373 pass: 373 fail: 0

Guenter
