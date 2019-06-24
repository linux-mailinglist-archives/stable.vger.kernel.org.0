Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1676051A37
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 20:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfFXSDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 14:03:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41534 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbfFXSDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 14:03:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so7964603pff.8;
        Mon, 24 Jun 2019 11:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PCvtDCUCpjMSyIAhRAhBLf7oJ+KbK1Zh4keTiDChtXE=;
        b=bcssdMmPd3qsUP6KIeFC5k3jx6e2AWsynKvKDQr7wAWk4AKa3suQ5BvdAloRnnFADZ
         2TimM36y5qX3czkYLaXAU4eRLuSZZbtYVS5Pu3cPXvlrcZomRUE493HKc3Wm+EyMXoW/
         hozxVmzkFEVa+SM6SX2vqAvZGcNd4XTvKLuPQNQISxWz8yN7vDeOa6RzLj3jN8bgXuo8
         6AmYvaZXcQT+ArzlPV/iZKXASZlVlvtWsyy4yKTMcWeaqq3smp6KVl0KU/NjyZLxkNdG
         NRPFvCkPOA2QglyheZ8PtkCclerC+nY7QPMSUCGUmLQyosgJA1f/m/HnUHip7WWE9eeh
         O2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PCvtDCUCpjMSyIAhRAhBLf7oJ+KbK1Zh4keTiDChtXE=;
        b=Ypxp2EfA6yTad7eg4WZ1Z2ULA2gGpHj5V/ux1eU5JuSbE3JCU3vHoADLcYyFWPjP/v
         D/+vrgp+1cv1mVL4oPsmupsO5LgnKLwI2okzezwwoQ5m8wcZCZFJ+mWHATo/7byUZq+1
         4fVjAmq+K2GJskmTV45yb+AUE+8qNoaGYSQPC/zMjvpwmKX50tfYt0qb+XywHezCBbOi
         isYsJHoBaZyZprX9A8SWAhzgCG/2MkTHj8PTbeDiAD6Ym//0VyHsGpJqHqoXSjCDvsLE
         R1Yok+lYWq4JaIql02ICZ4lPYB5XaKRbi88rnM02YFDUgi/FCRRh+wRhD96J7tzpZU7k
         i/ow==
X-Gm-Message-State: APjAAAWrCzcgcoFq6GN1P4EFk5oAHodQq4GjzVipyIh+5AsiExj+g7kL
        R6De0CxNDTkZeVdGdfoFwvluP6xL
X-Google-Smtp-Source: APXvYqyO6sHXsoHaPxH2UTvfIo1D2EDl9g1i7YEAKvP+VrFCdlUrpApbEzT1MHvRG+YlDslscdctVQ==
X-Received: by 2002:a17:90a:5806:: with SMTP id h6mr23232455pji.126.1561399418766;
        Mon, 24 Jun 2019 11:03:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j11sm12840651pfa.2.2019.06.24.11.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 11:03:38 -0700 (PDT)
Date:   Mon, 24 Jun 2019 11:03:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/51] 4.14.130-stable review
Message-ID: <20190624180337.GA27897@roeck-us.net>
References: <20190624092305.919204959@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 05:56:18PM +0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.130 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
