Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA8736B8F6
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhDZSdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbhDZSdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:33:37 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89D9C061756;
        Mon, 26 Apr 2021 11:32:53 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id x54-20020a05683040b6b02902a527443e2fso1922839ott.1;
        Mon, 26 Apr 2021 11:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LBJ13CXgrIDSN0zPYCuxuooG6slCMerC/V2MccSdEfA=;
        b=TIaFj6jxUpbbIppypOb4o7c27iVivaShkAF0ZYJ9tNyXc3CsBmzfwNvlhKESi3f+K3
         +osKzSvvlVs6jX5Prpq8QWvbGK+z0XiZBL+l67IRPZZMpZoBJHwn03xZV//Kn+rgE3wk
         Ok1kOzM8KByPNr4EDJh6LwtSfYkAvxlTc5ZP7pjeOEBZiqywddn+M6GYTKmSGhroLYIG
         eNiSBaHGuewMC8Rp0bTykX1ct3LkSSUiSGKQP56FepI4M/HCUSrDp7lADsQxH5jSQ/wB
         94/Zt8i1Fis2Ocnto899QcFKpsYQ/zavwQcjv1xSezk0lpk2m+snKD//V1+tUuPAzBAO
         Ognw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LBJ13CXgrIDSN0zPYCuxuooG6slCMerC/V2MccSdEfA=;
        b=kTNTNIh9mTD/L4QhQgYzyKAP8PPgrvq/yKQbfttTOlJ6HM1XQwv408qFNKCfaSdQpR
         BajApTpEBcpCNJDQ6cgsHjJJ8/V2HU3nR9XsWxB67aj23caNyOQ2Y97ijFR+SrF7ZXwX
         wbt3IMHMNdsKgahZAg+nVihcaqAwxq2OBHGz51dLhD9a4v3zP+z7Pf5VttnwoL5b0QFu
         zjmG5GcVR/fC9nDuol0a04oQSfbZdNr91TbixsUZlW+zSI0fKnGsfUw5as+70KABkKfn
         BV030MocTQ+QDwEVslKjfELDR/uSbVrVLaoKN3zXLXPxpOE20CNMq6BNVUp78MrKlNwn
         h2Qw==
X-Gm-Message-State: AOAM530hqA2B70wKq1HS7y6qFs0d9dFmB6ZIdvOms7JPN1qiBthG6AN/
        ppUhSodHWJEYCG5vTS8M/GA=
X-Google-Smtp-Source: ABdhPJwKwMAUriGwtOScGZKNNh7AOIs0AdZNGvbE88NQ9W52lXQqUmvM8yVMAa0v0YDnIS6QnS663A==
X-Received: by 2002:a9d:3ed:: with SMTP id f100mr16881416otf.45.1619461973433;
        Mon, 26 Apr 2021 11:32:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g3sm756757otq.50.2021.04.26.11.32.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:32:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:32:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/37] 4.9.268-rc1 review
Message-ID: <20210426183251.GB204131@roeck-us.net>
References: <20210426072817.245304364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.268 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
