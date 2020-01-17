Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C92140E7B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 17:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAQQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 11:01:05 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35014 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAQQBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 11:01:05 -0500
Received: by mail-yw1-f65.google.com with SMTP id i190so14566601ywc.2;
        Fri, 17 Jan 2020 08:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m4jigix8/IeV/cj6HaZtnJfIt6EeVwmS3BmF8Y/P+vc=;
        b=Vm7QkpzQa9Oa13aaQjl7fLKholx6yEO+TIKnJ3O+MPnw569ggHh8oerFH7ZcxYK02U
         MhM9UPKuYwN/b31easw9GrE3a55rzqvv+AIQDjQ/l3IwLUAt6fFYubVqTeAdlYB3wqfc
         7O/9B8LYU7F1Q85KRAsAWrgZPNIy2ztHuYU6Z1GmMKEaOfazRIOJ+/RbAPQE/x9HXDoQ
         nVNCdsGCjl6TzpOFpk+ojewOa2nqLuu51xWUk5Bk670xu7QBhV/cl/AjvGGuiq33lxzf
         kJNCTB8bMCNSaHo+J8eukMJ6PnfJlirdoc32ZimTOrgCTSmUz7cYzO/P1RvDdBujPwHB
         J5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=m4jigix8/IeV/cj6HaZtnJfIt6EeVwmS3BmF8Y/P+vc=;
        b=p+UrMeT1VeoHUSAalfWdICBsnIbuTD7pvwjwArBGx2b9j5aGjNcXEu1nDhwRdpNmRM
         Tx9mE3VtEX8088UYIs1QJypc/AgVu+7y6bNKCLe/wUoPrXyyhrRX7eCzbSkN7DAc7bOV
         cfhUmB02RUqQgCj+wS8bhOWby2GoU6EnvnxNPENBLtLGTa8xZgCCuQYvQsbTY6PKgAtI
         NFN8X0rmhBixGBtdgJj9ehs8knbjWfXCPHV7+2WK6fni0tewqN0HwfKnjPLMHIWZ2WqW
         3hBKnJ0E3YvqoA3TPA+UePNyqk73byYf7oPT+nsV1E8P4eXF7JoTFxktgv1zkrKODwy+
         XEOg==
X-Gm-Message-State: APjAAAVTP+m5gzE3rRp2UTmBbtOqb52xoFWxVlY0TsTWEwt+lR6htZaa
        0N9121zeUC8WmJpJUOFuPdQ=
X-Google-Smtp-Source: APXvYqyWrPuG0SMuINqVFoTHwLYp97WmjLWg5zszAwgwR/RYtMVzUlWxxrLJpHu9/hk9RZXkORy3Cg==
X-Received: by 2002:a0d:e195:: with SMTP id k143mr32034017ywe.211.1579276863954;
        Fri, 17 Jan 2020 08:01:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l22sm11784819ywl.54.2020.01.17.08.01.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Jan 2020 08:01:03 -0800 (PST)
Date:   Fri, 17 Jan 2020 08:01:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/84] 4.19.97-stable review
Message-ID: <20200117160102.GB25706@roeck-us.net>
References: <20200116231713.087649517@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:17:34AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.97 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
