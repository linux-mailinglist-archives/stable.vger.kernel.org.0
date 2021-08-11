Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52173E994F
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhHKUAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 16:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhHKUAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 16:00:49 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41277C061765;
        Wed, 11 Aug 2021 13:00:25 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id t3so3730391qkg.11;
        Wed, 11 Aug 2021 13:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p6HpFKC8JQesvj7FItqZXGFyWA2QpZWIAOEr2VRwgm8=;
        b=gR5PVSrbjTn8AGPSgRDLyd2uFNFRK2xmz3xv1UGspR/NF7OofaGYyN+YPwVsF69mHa
         ZNTOGOkqsZAd+lNOguyV8IXZ0fm+5+2UhQpNWuoOwCIyT+u2TWDYamsyaRz5y717ieCT
         DT+x7c1LckY/W+1NkKuTq8x9Ffv/V0EpoIeNB5MGwmdmi4YDqi7t3zDLRy/hd/e4blMz
         QsbUK1Vst6m0+6IPNl7+GMffzlJbsVjreAtb6MlAB8j7jMET3sfcNxU23p2QYk4DCY9X
         g7X4Zj0vxcwUvTI+dauA5hxss3z7bkdQt/ry+X/kFQ1TqR5VzQDKV8eNAXaP627U/0oQ
         6sYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=p6HpFKC8JQesvj7FItqZXGFyWA2QpZWIAOEr2VRwgm8=;
        b=IJRO/aJGAXqh1SDV0gyaCFtn2S5SzoSE6Hzt53fYVjgtoDzokDWtnDPyzP4VHXVSL1
         n5engg7bdlyL/1uEEhXPJGt4VPRBHmpj73G/EsExjYevXvQNdfmrrZGSRFaAlI55hedd
         t23hEVvE5uxukLlk5EljUMUxfLEpjt05/VsOxMhoaqDHRCxJoIQR/f9PjHX9nJgxOvHx
         DdAAJRCnLRg4CBV7bi8j8YI6g9W3eRvs8S6zewJ+Pt1he6QaeZDe2cbIy+ZfULdmLxpG
         sDlobfop2Y4if/c988MLoAgOOODLhf+94SgLs8NlMDkIZIa1iBFWTZ/OfQyyAJVzdDe4
         msjQ==
X-Gm-Message-State: AOAM531/T2Lue+OBHbRRIC52s+j3M6mCgMmMa56E5tmabFTAQ4q0fZjf
        mKTwWU/PYBDoQFOjKfdC4AY=
X-Google-Smtp-Source: ABdhPJyv7GBzEiekYNH+IiuZ21M0xiIxkcACzlgUphWJ8wBhkw0pK7SffETtbWvkNV0f5nHb7iaQpA==
X-Received: by 2002:a37:a9c7:: with SMTP id s190mr768137qke.29.1628712024479;
        Wed, 11 Aug 2021 13:00:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f184sm116242qke.7.2021.08.11.13.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:00:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 13:00:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
Message-ID: <20210811200022.GB966765@roeck-us.net>
References: <20210810172955.660225700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 07:28:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
