Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318AB11D558
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 19:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbfLLSYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 13:24:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38446 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbfLLSYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 13:24:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id a17so953323pls.5;
        Thu, 12 Dec 2019 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+yXUnT7p17Ie0K+wMnq//C2QNUFuiX6CATyd3WqyTQY=;
        b=Z9/eaQKxArfp/r0C9iMfIBVx7VDXiNMOsHq4T5u9QhTytVEsYA01P5NW6u4cgZ8nUo
         8lhZKkd2HeAHNdR0/o6zIyr7NOK17CZABLKstv0X+HtR90ZtfBJKuPHxfveMBtGpEKm+
         g9JOtBlM+1JwVV5vQa5dzrk8zYtYAB1Td2V5PYsVHHsuK6bcfUDCt+CCEhQRz47s+B8A
         vsctpViBYGbqrzODYzbMOPwamdS3CWcyw1nFdrA4Uwsvnzmmm00jbGn5tLVEl3gpNErj
         2n2C0kNL3m4YX/f7Ap/ydMxjGwUtR0CbGRP9esNJ9oHqRcJRYmY67iC/jJJ6Ro1t1Kri
         TxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+yXUnT7p17Ie0K+wMnq//C2QNUFuiX6CATyd3WqyTQY=;
        b=dMg+sIV0i3wHCTER89BveY+qHQZAS0SXdQlQasFNZM3q/Po5cjnozGFuO1HZD7J0p3
         iJ6tKireluCg0TKxCwL9kd3ziWWyAUvfu4nE37LubVvT+Wx7xRHHmuiVOy/5ebBEAjWp
         JiAaKQZ3w+51xI+umIkTViYR4Di9pVhC2jRKsZawxbHL7i/0tjtAwgrAjeA2vdPqS1Zk
         gEwAKCNa7l5nfpkc9u01d5t5M5HqIphHXhpDo+VKmsPFGHPRfPxhmVh5FMNRB2yF72Do
         tDxnOVUAuOelWJY34lSxM+LWUDr/XY0qj2A14kV0UZzOV4xzBIVZXpKV+UCpA3AU24Ul
         bAiw==
X-Gm-Message-State: APjAAAWeLY+dE6sqBev88bqMJiQprCUNO7tL0Olwpu+xNtYI25qY5bKb
        5v54HzlrjB1q95vW3Ta+sf8=
X-Google-Smtp-Source: APXvYqwEsunvsFHpXGOUpqwbXvlzeDyE/MDghAFSJYV9eLT+2v8BegkezBbGkbmqxqa1wWGI3hy65Q==
X-Received: by 2002:a17:902:9302:: with SMTP id bc2mr11199629plb.148.1576175082872;
        Thu, 12 Dec 2019 10:24:42 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c68sm8030267pfc.156.2019.12.12.10.24.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Dec 2019 10:24:42 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:24:41 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191212182441.GB26863@roeck-us.net>
References: <20191211150221.153659747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.16 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 

For v5.3.15-116-g9f27b7f4a193:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Guenter
