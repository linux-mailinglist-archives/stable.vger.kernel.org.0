Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6C33F7D24
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242682AbhHYU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242635AbhHYU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:26:59 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF02C061757;
        Wed, 25 Aug 2021 13:26:13 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id y128so1118550oie.4;
        Wed, 25 Aug 2021 13:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LEYuiYq7FwZJafN+yJuSPERkMaTbp9M++92EzpySvds=;
        b=R6aO/ivnjk/RrIfHs4iEwInYkmRU3v5Q/41hgCZAHkyLx4XLpd+GNV/UAO9/ydJ3VE
         Js0+FgktLjnCYnArbpfLMwTHBw6UsWVIrCYTOoh1AKDCrkKozK3AIvFoKjDU0pgEFf/r
         EWVS+/BwdNyg5YY3wmha8GF0a8U2kZEorGzoj2meD+lROoX4FFQ9kpUgv0PN3Jvlz7Sc
         TK49fKU679Q/dqhvW1DrOppLRe9lpbfFWiQYSNJ6knE7E5HBNeWHCe7WyRZMfhQo28lU
         feywRusUeJhFU/UAPhVJz76kpAVdh7is9PaLfY81X/Fmz/Kxt0bPkbtRRH1QG5lCOckr
         3c8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LEYuiYq7FwZJafN+yJuSPERkMaTbp9M++92EzpySvds=;
        b=jJP/dh9ZffIQ/uoMxGGPsCmLa0zaLa8LZOr9/PFuQYKT4wMryvoP05c0hYTA6rG6Un
         wVVyU1l8KqQD+ac/jiVTlIbpdrSEkY0OZ4ZHdqsv27E0beyzoxSp5IW5N6tR3S1MfL+v
         1SfjPluiYpfBrDedcRV0mD3aKoOvSbnWY/W+kVdFI511DMhrOAWSXLWX3urHIqX+eOPv
         Z+bGUTy6vX7G+qSRsxsqli4CNPrrqDCPzlAEGiHr3aGT271FT8UxLeZmrTifqq4b9jbT
         F4kdTXMQ/66ldajxnekwXCFIONrdCLnqkBvFzhwZf4ARPtctjTCLJfDxkRI3hjEZyv13
         Eb7Q==
X-Gm-Message-State: AOAM530Y/OmARHxG1Qp2iSuirhmYangfT+5I8wkMSVbMPQruy48f1T/h
        ApaYXcJuWnfDFPFr0b2mrw0=
X-Google-Smtp-Source: ABdhPJzqbFkW1oqqKAv2Kqa+Eo8cPazESHa4g7K9NVdCUxieIOqqATIzi1iQ6rerTIt6EoAwmGkMjA==
X-Received: by 2002:a05:6808:14c9:: with SMTP id f9mr8050442oiw.163.1629923173250;
        Wed, 25 Aug 2021 13:26:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j2sm200384oia.21.2021.08.25.13.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:26:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:26:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.14 00/64] 4.14.245-rc1 review
Message-ID: <20210825202611.GE432917@roeck-us.net>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:03:53PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.14.245 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:04:55 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
