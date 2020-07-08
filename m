Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC525218F38
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGHRvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGHRvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:51:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C411C061A0B;
        Wed,  8 Jul 2020 10:51:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d10so6452915pll.3;
        Wed, 08 Jul 2020 10:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qq536U2eN0nQuXaJKASC+YhCFrssFqjbmgb/+L6lDXw=;
        b=Pa6Qc2HkPY4Y9Dhv50AxCmeZAo6sFfNCPqgOZCTT6Fgg5GEbThkkxi+eJ7XqQmyyAO
         oPLTePItnAgnn+OtMvyAKeqKSUc0WHFaRynIzaasObHgXh0ovVmZJmJz0Ox1BPkvAyhr
         7yW+IM6PCkWK0DhWYuK5zJzAf3Qg3w6nILyCcojmipuIUKooBKqJ2GNW5bCqZQaNNDE+
         DewNn4MTnR6aPKW+ZEWO63gxeCQTJBexD7U+f4OQ2v2cUAA7fyoXPs0X+Oi4ATSs5+fI
         bjihfOn4xCOoXD8QnTxijmjP4TVTLXUHRPZSZP1T9gqCJ9gcMvMECiRjn5AY4ur4y+7X
         HmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qq536U2eN0nQuXaJKASC+YhCFrssFqjbmgb/+L6lDXw=;
        b=d97m35Cz2SD6/2D6VLl85S6FDm8bUpMUvqR/508H8sp9LM8ybREk7TS0L4Oa4Nsiqk
         YUEbHMpQ75T10FX3lAp3ryItmBgjqal5+nhSvrDdbdRoNWwKN6s11nxH2qb/fdoCT7jD
         8LenFfhQPtQJDCfaDxWkh90OUnohYlM8s4KZME1mF4VfzEE/4tthtghCdxtbb5MJzLFV
         N3cRBQ2pnTby9KDib9t+jlcZ1wmlmzE92Ct5Ix7XgTvLvkZ8n8JqHLbv2w5kLODikd4V
         fudGwUqpd2pf5LSif3M5dXUn4ji+M+Lx0wVEOMay9uZ3aFkxOS9cCm8A3tbk5aozVvOH
         KSmg==
X-Gm-Message-State: AOAM531suMHKKuYGj3g829mEYcEuq3Ns6jwoi8eIPggM2IISii6dMXSU
        CDp7BxFmACkb+bLkNJpZ3J8=
X-Google-Smtp-Source: ABdhPJwBJZ6Yvty0GbHJ9D+mv+PdPg99jfNEj+beiZp6yV0T7t5FHWKpiUpX+De8QbRdJ9HD0sVvTQ==
X-Received: by 2002:a17:90b:1907:: with SMTP id mp7mr2208920pjb.220.1594230703734;
        Wed, 08 Jul 2020 10:51:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10sm476324pgn.6.2020.07.08.10.51.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:51:42 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:51:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/19] 4.4.230-rc1 review
Message-ID: <20200708175140.GA224053@roeck-us.net>
References: <20200707145747.493710555@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:10:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.230 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Guenter
