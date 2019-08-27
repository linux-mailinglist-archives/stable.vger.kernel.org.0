Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643A79F18A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfH0RZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:25:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38862 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0RZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:25:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id o70so14547171pfg.5;
        Tue, 27 Aug 2019 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rRezVoilg+nffqvxCs3DF4XZQiwLzh4SLwalFGZk9Lc=;
        b=sKC20rPMQqaiHQ3bNsYNAWMqZ5IrG43weYvUiEhEWsTHdBk4xdkWAJMtRZaqK3UEl+
         ptieMi6oL/wqiubyeq8kttdzdb1cQoH3FL+kope2oK3QugrAQmZW0Vy2IQbiDz2dYEf3
         c6um2LXwHarXdGQLm0SoAaTURxKNuekXzNC1py3Nt9FAIqcUgZCJu5adG8HRjNWtKUO/
         M+ddp3CVSZ56tb6c6gyrf5qFApGUy1HRZrB24b9LcXxFdKC0bIdjk0seOwWuiOcRyBhF
         x/e3PD/ndOjWbdM1L2bOHLcce1UvGLMJGMX6l1YwmqEdsRfsBxYqTf7YnaatnFDH2ZWE
         Rcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rRezVoilg+nffqvxCs3DF4XZQiwLzh4SLwalFGZk9Lc=;
        b=CeEsYTLFck6TGNdHyux7njFXFh/jFpjKj27VtGpDBN6DI21sTirhjhB7VE16xCaaLb
         bXGLvjksE/rqfTkwKoKrcVwTcSq5BPUzMDv+eBBcdyHLwMlXYjhcCTwcm9dHvqhhiViN
         CAkynu5TzjgXIx+qrr97Vln99mUb5bJRNvOfUqoY3HDID3ahpvbqSig57td1UXQQSMIm
         ajO34k3qEc+KfISv2PZ8q9MDU+1TzKynIRa0GmtduyUTu/cQ/4rOG+moA+yMfC8qj5Uh
         6ccCv5VdctRDu3HeSFKqs7EQtsAugpAkBknkIYjPaLnuo2c17+DPxKUWrvzs4xJIxRQR
         /8fg==
X-Gm-Message-State: APjAAAU0ah79smf6ViiVeN7sSNW19Kd8hC2rliEZwH7A3EiFQUE3LLym
        wnFLr/p7AfvHGB1B8vCKJoU=
X-Google-Smtp-Source: APXvYqwS0sReW3QvGrI4E+kBPMQshS/Ndxj8vSrAZ2znKnPE0khWjfl8xlm0mJfMsBQ+vyLyX9w5ag==
X-Received: by 2002:aa7:8219:: with SMTP id k25mr13470528pfi.72.1566926751686;
        Tue, 27 Aug 2019 10:25:51 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id g36sm15844256pgb.78.2019.08.27.10.25.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:25:51 -0700 (PDT)
Date:   Tue, 27 Aug 2019 10:25:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190827172550.GD31588@roeck-us.net>
References: <20190827072738.093683223@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 09:48:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.11 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
