Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD82749F6
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVURj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVURj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:17:39 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05654C061755;
        Tue, 22 Sep 2020 13:17:39 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h17so16859806otr.1;
        Tue, 22 Sep 2020 13:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mNj7G7Ic3mv2j6tH0eZ5Bv0KO9rpEhresnZN5IzGje0=;
        b=le1TpTZ3iVqQIaVRg+9apcr1VxkMUeSXczqZWz9RWt3sEC1c6EeOHkQRME4RuEZX2J
         IQt+lULl1M1Z84UzyN2xGGZ4EPVVJh3jwwkEX5nCYELUcXXa5r2qFBlVyaGx9v3rMoR0
         wrECeEmy1FZC8iTe0dHStr4AgDE5HmWvM/LrJKQJ6w/oL3W3hv19csKoeYFRD7qxC6gJ
         2WL0F/ffGJW9SSEqABlRfLJdjaCpN2rApgkUE4tnhElJuSW6N8lCu1AuDf4FT7NhgGD2
         D4HBPA/cT28QHqAc7IuZwekKxrOg+nkHZdTODWPE6xFJm/A10044atw49+5nusoj9PJQ
         Dy6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mNj7G7Ic3mv2j6tH0eZ5Bv0KO9rpEhresnZN5IzGje0=;
        b=mVFL3zyXLyacEfgJZUv9Pdy72Jz9lab2F1aBAPo+itf5MhO7GBsuXAp4iu/xwei2cU
         gkENNpRCuXpVqYQGYzXM5ACbuMEi5FmGYsyzh01AnpCybZHnF4tFmh/Y6rTIqioO9URn
         g7y5p6NLoxdmHfll8edaBFdHSFhzSiauSIt2f174dOVX8M3SBZGK+9zhm5ojWK9YLCUi
         Ii1jk/0juOMCECIoQrBz3e9SQlG6lT6NskL6/7H312XmwlBgCmaYCMA4Q3SB/doGvViZ
         sbqqrCCJIRjGq8+MIESg2tyTgs9aRqP1sY0XYIghy5LtqU437uJhzbZD1VEf6+6Y2Y68
         LfYQ==
X-Gm-Message-State: AOAM531JSylbyxKd6yHMBlgzIOd5lF7CHK+VBVKK7tbZAywrKxagDWpn
        PpMYNQ1f6kBn0EhWeKtxki0=
X-Google-Smtp-Source: ABdhPJwW3xEz7UrSNDXbxs/e7q2knnsFJWc1PmaeedeL/qPNLMG6Pnl0CpVQv31igYA7AO+TzZA/lA==
X-Received: by 2002:a05:6830:1e90:: with SMTP id n16mr4009162otr.304.1600805858313;
        Tue, 22 Sep 2020 13:17:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q64sm7749000oib.2.2020.09.22.13.17.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:17:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:17:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/46] 4.4.237-rc1 review
Message-ID: <20200922201736.GA127538@roeck-us.net>
References: <20200921162033.346434578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:27:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.237 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
total: 169 pass: 169 fail: 0
Qemu test results:
total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
