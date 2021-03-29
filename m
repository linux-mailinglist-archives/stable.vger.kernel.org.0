Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3172934D991
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhC2VdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbhC2Vcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:32:41 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAADC061574;
        Mon, 29 Mar 2021 14:32:41 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id c16so14476258oib.3;
        Mon, 29 Mar 2021 14:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8f1H+3JhDIPVV978WzQpX+MApqv4IOLmxk4nw5dLpvg=;
        b=ouEiVUB5kxLFeXtv4+mNPtESJE0r3IQBNWdPFdRggldy82qEl7MIiTzlJPMS8c/QL2
         E+zbmb6sTaMqFUVDf7/DUjRmqVLC2LXIx1h36kBAgzdNxO/nfxW7PbXD7uxYd+P1VjEO
         N2RDI3lZbGpAf6+JOCkeQCl8A3taJuRPB8U8O5U3E2lLUhGfC5sNBTMNXSfWY7q59b5o
         KhX/USva0E2WquvY4D6TSLjGIIIbYRrF8RbkaJNicmAS1miIWzWmwmQddErS05MG3yrc
         afg/ydErTO308ty7y8U5hIXbYB6EaQSZ2OXRveR060nZAnTzn8Ao7gDfaoXbz9BnvlFh
         YDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8f1H+3JhDIPVV978WzQpX+MApqv4IOLmxk4nw5dLpvg=;
        b=c7e3T+q1/c2ihMiqzaoBCVpowfP6jINOPckE7odKCdjzNa8dy2TkUZQv0pE1yo9V/q
         42y7IHx4jiRTLWR2OVePAoo9PGDQBOWOxAmgxgHNqkcyyCIMsSOndCdDZrPUeQeKE841
         1GV2dXLb/89sHKAeZrKX8XBK1G0dQJViZ+e2hf7ivb2mzRlWfgLVHDTSurQLL++Jc4Df
         5G6zTOnUC8zZkyuxlcp6SwH0pQTKwqPvbz+M0UO31rnksLFP0XkvWh25sH4IwlTvrm95
         7gxYCG5jdHDJ21z5BbcTuNMZJX6GBahPCuTEp9wEseFoQyXzKjQx/5pTlEX4IvIUFQDH
         5Itw==
X-Gm-Message-State: AOAM531VyyX3im3OOb8jDJCOUBJWfHoUAS1GKanUFdbjTLz2wz6c2iUQ
        R/wT1sG3RwdUhCFtgKlLqLk=
X-Google-Smtp-Source: ABdhPJxeLcdpvZ1BjxiXIdbUrOiAdrw2WX+z5kbukyzZEQQun+8KXbNIq8K93X9ZrJfynwJf5tmbjA==
X-Received: by 2002:a05:6808:aa3:: with SMTP id r3mr812584oij.38.1617053560863;
        Mon, 29 Mar 2021 14:32:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x23sm3988207ood.28.2021.03.29.14.32.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:32:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:32:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/53] 4.9.264-rc1 review
Message-ID: <20210329213238.GB220164@roeck-us.net>
References: <20210329075607.561619583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:57:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.264 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 381 pass: 381 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
