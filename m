Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F018F50
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEIRiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:38:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33533 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfEIRiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:38:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so1577289pgv.0;
        Thu, 09 May 2019 10:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f4d+zUvWSp076co/UEghpzeuE5XMvDzMZv9OPdz0Fho=;
        b=QtGxLGHCCuQdIzSY0pMaYXLV3vvrla34kJG+0exw7HANJF5fNMTfR7c2tr0Pd+Dyns
         4M/h6TGxRyze6lnUWkYzRtH+5MhyVJyPy9qhrDYbIOQQdiQqo8LrYzHqy5hOVBY/e9jy
         km7kntmd3VcGjzMGCRLaKWZ25p1T5Wq6mqGZc3edVky021c8rRTojDC4oWEtYpigP1lr
         xQ0bE2IBUgnwgOLhbjGOQQyRI/g8hwnUFqewabqStZqHv+IWbJNGGHT6sI3Q1cd2hhIu
         HY06CyJ+mrzLjNiJIGhgEI/4vSIky9YIbtPmLerr9viJt+lYRsCcgjxfABrDthTBeDXl
         nifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=f4d+zUvWSp076co/UEghpzeuE5XMvDzMZv9OPdz0Fho=;
        b=XPng5GOIRvanK8osBKBEXorvBs0eGDLX3HanGKYnGC+uE0tPMhyBh+FW5G0fCYD+71
         HuFaArweaJEIFELR5Wj/2KW5w/KbLWBjAxPeDeq8K3HNEb91veBBus6PwAZ0zADEZhzd
         /5EpZ0abYl8fwfxAp0GXmNY34mjEclOPd5QxZPVWl1fywrEJNEP8cInb5LTmds0RzxR6
         R35PtkKb1T01HOjuXteucCqlu/Y0KF0kUnHFPa9ew/4J7ey1+dXkFJtaEa+F4sLr8RyA
         5MVdlDI/nq9T59SePZycvhI2Hg+PRIripZ0cL7ZwD44m0KoDiFlQ4beINL/nIaP4rgHl
         l7Zw==
X-Gm-Message-State: APjAAAUREJi2l3qiU4jLzvVlq45mJm+8PKX3r1ebM8Ge/6iKjY4EXIkZ
        Fwa48P3tom4JjRyG3BMRKeayucUJ
X-Google-Smtp-Source: APXvYqzyyS1q4NMHTanVzs6FfP0UL8mgF06W2JAoYOItAnnfh5+BodP+1E9ckk8girs+SvXD7oPq7w==
X-Received: by 2002:a63:445d:: with SMTP id t29mr7225134pgk.303.1557423492126;
        Thu, 09 May 2019 10:38:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i22sm3612911pfa.127.2019.05.09.10.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 10:38:11 -0700 (PDT)
Date:   Thu, 9 May 2019 10:38:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/10] 3.16.67-rc1 review
Message-ID: <20190509173809.GA28365@roeck-us.net>
References: <lsq.1557410896.171359878@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 03:08:16PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.67 release.
> There are 10 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat May 11 14:08:16 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 137 pass: 136 fail: 1
Failed builds: 
	i386:tools/perf 
Qemu test results:
	total: 226 pass: 226 fail: 0

Thanks,
Guenter
