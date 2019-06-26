Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C0F56FAB
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfFZRgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 13:36:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35986 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfFZRgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 13:36:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so1725727pfl.3;
        Wed, 26 Jun 2019 10:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X321/IDP/t2tBpgQipnU54rMZLTeSk+Sj8cGzkHPfpE=;
        b=TUZqc5/E4M0gtB5pR9iNHep6wX+2rOU3fXqKT1LQAdl63/Tfj3eqGbEGmGW50zdMiq
         kYpkfHbLg8UcL5fzZ6sOGOtzQA5Dh4XERuL3F5mhTaKFLijwlfFb/ak9UylZD2yPRJ/O
         1gP498EFjiN70EKvNLlEqP7mohM+c5IzaJh52HET8mBdUQcA81xUbG8YT4aYFGc9NoVv
         mp9jMt0RsQQFBitUo835acHisfmCF8e1GL3pL8ZUu4CjMFt2LRNPK9OH/kUZDe6Ddfdi
         jgj8Zt9QrngWRb85vfeW5Y0JZ4EXveXRcesEAQPZmFxKBKZ/WEuKxa9ZkbB58a/wRNEg
         02lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=X321/IDP/t2tBpgQipnU54rMZLTeSk+Sj8cGzkHPfpE=;
        b=nM53p4wBwE0bLQZIJUOoFtTQ+YM1eAMHRBei477lPB80ATEU1x75rTI/XvoyhU6+WG
         Zxis7sHW8Wck1HLE/gX5lHNyIge+ldUmwJGwelnKlpJ/5k/aixch3Br35MH3e62P93d1
         bC8RvZhgMcGwuA3Juym4VimDJbeWHePGIjVFPKYHRQtwquZNuN059zdXouq2BcpN2uXy
         5nMtRkriIOPKy5ozrbfnc5AXnvNTFtFGgZOuiYdw9cuafoTB0yl9rX/pTpannk+5hhZZ
         qv2C06DPccfo4CtBAH7psoyfYSD3Zrx5BCVsLBwmIWDC/PTe6UmkZ9a4Wxyf5TwCb7yf
         A7yg==
X-Gm-Message-State: APjAAAWOrD7RVvdd3RH2ZOIgxXdH78L3h2mRJAl/hknrxjEA0Mk6hIH1
        mg0DT5lKtefyMy0QH5IxqLvKYm6x
X-Google-Smtp-Source: APXvYqxNlLUbRHLcrdpse8TlvXdR6DmIZxoofU6OpZ2Ow/xy5cUSuBHFV/U8K23BexWPQlpKnmGdFA==
X-Received: by 2002:a17:90a:a008:: with SMTP id q8mr267573pjp.114.1561570574715;
        Wed, 26 Jun 2019 10:36:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c83sm2430022pfb.111.2019.06.26.10.36.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 10:36:14 -0700 (PDT)
Date:   Wed, 26 Jun 2019 10:36:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
Message-ID: <20190626173613.GB2530@roeck-us.net>
References: <20190626083606.248422423@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626083606.248422423@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 04:45:20PM +0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.131 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
