Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94B25FFA9
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 05:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGEDNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 23:13:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35770 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfGEDNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 23:13:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so2465543pfn.2
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 20:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N2IO4pfRvp3fi/Bx06vT+ESFz9m9oS+vnVgitDhXnlk=;
        b=cvinMYul5caH68j0PDS1o1euY/qMSIt+eJQzgm97Fqa3GfDOq2oEsUvOQNXrVCwh48
         emTL3XAhJmoeXJkhWcNykVeXoXydlL1bSbR2Gf72J2XcSnSALaX/tRuyp+e9PbFFtm8o
         moR49LBYEp8iEDHV43t1iwy4GQJTIyuu9Imgn0OB6mNxMjcPa67SXzpag/SNO5FOnHgi
         iGRCbEtykbhpWgiZ1ou2DAIZAaY3BXz559PgIlxdvNevnIXUWSGjhlNaKo/D8C3hE5WW
         Pcx5u2fhD/KRr0T3mGOBGHtb72tSELxuy9O8+Y8EJViFdkfRMGp0hZsPJ+iiJ4lmIbFT
         3HYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N2IO4pfRvp3fi/Bx06vT+ESFz9m9oS+vnVgitDhXnlk=;
        b=Tm15e3zMnVsUyevWhBJIUBcSM2cU3wE1wblgUO2QfM2HnOaMRuYC99DB940b14t4oq
         qkFdXbxgxo4EnHFZMWP7mZOMQ3Rt2ckdlVM4Vrh2REQgOvK+QWLHtNAwFH+5MZl27Nye
         eM1RR08wBL9KAUI8wntPetoNNMfHm0ABW8/W3QEV/4xshytN/PGSI0n+jP3/LZMvFspQ
         MTqft4+76xq55dDfoo9GEYTFqQQPQc4NC72kceB+9GLjErzTy/t8ZvGNe8VkeM7eprxT
         8ZLePI/hVceUTXwmg+VNPnqJcNRdTniH+aJtPqtWPH69HQelC5114pHUGlSrjdAzZy7A
         19ew==
X-Gm-Message-State: APjAAAV30G0j2Ea5ZzHgxo183L76WMhrP6V5uxktYKMDE/boqkvdDbRG
        B5642uDY8WQ611LiGZgZOnWWoQ==
X-Google-Smtp-Source: APXvYqzqeRpd3KPGd5X2doKamT8zLl4p5im8dqSN/7y2ZSp4g4fAZ+OLBA5C1SDmUDXXCWg7N2SIug==
X-Received: by 2002:a17:90a:5288:: with SMTP id w8mr1705563pjh.61.1562296402187;
        Thu, 04 Jul 2019 20:13:22 -0700 (PDT)
Received: from localhost ([122.172.21.205])
        by smtp.gmail.com with ESMTPSA id s20sm7499185pfe.169.2019.07.04.20.13.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 20:13:20 -0700 (PDT)
Date:   Fri, 5 Jul 2019 08:43:18 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 10/45] mm/kasan: add API to check memory regions
Message-ID: <20190705031318.qnhrvfrzjqk24r3f@vireshk-i7>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
 <0cedfc51f5941ab2c2e9a09149d34c7451efda56.1560480942.git.viresh.kumar@linaro.org>
 <9c5374d4-1775-572d-ba79-b161a82190c6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c5374d4-1775-572d-ba79-b161a82190c6@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04-07-19, 15:15, Julien Thierry wrote:
> I know you have updated the code since then but the issue seems to be
> also present on your updated branch.
> 
> This patch breaks the build when enabling CONFIG_KASAN because in 4.4
> check_memory_region() only takes 3 arguments.

Fixed and pushed again. Thanks.

I have also tried enabling all the other ifdefs used in these patches
to make sure it doesn't work after enabling them. Looks good now.

-- 
viresh
