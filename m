Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92A49D502
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiAZWKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiAZWKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:10:30 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D9EC06161C;
        Wed, 26 Jan 2022 14:10:30 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id c3-20020a9d6c83000000b00590b9c8819aso688327otr.6;
        Wed, 26 Jan 2022 14:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptknAGUuI5zkjBqmLrJ4g8JL3W4I032+2o4ivQryEhY=;
        b=kADrc2tvB0NEIW8jrGt11Iv5PxummJUKXYqD7S9Y3qHCSOFQMQEF97cLHU/EcKpHol
         hii7FvWUd91w57Pfh7kB1hXPVIwO0m4/rnsNsszzX54zVNVcdVkZYhYI9aZGy1c5Rzcw
         eR6h4sEYlY7B9SWpb/ULbj8Zw1qtXtGB11zagKyI2zinrAn7drRaOGMeB8PKWh4CkxnF
         1zCfSOHr7gjHRosl7fIURTRq0XICuslVHHXkbQFCdWfp21ZTvsS/4vbIZcgJ/VGhvwhv
         k9+pe3Yfea+jXcOGSrWKb4PbSaip1Tv7oemts/B/s2U3ZJFC09Kjn2XJ0eqvPc2m632t
         k8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ptknAGUuI5zkjBqmLrJ4g8JL3W4I032+2o4ivQryEhY=;
        b=MkK6qZ5GERBMP7gtXxSpljI9zvV32Pimu8nU+OrhB14b5Oc0ibBUYlEEjuaBo4WObC
         yoZZqO0ITymOrrqOI5lfJtt+SPLm4PBjpv/gAGKppUC6cptKTLcKtfYLeAc89CAle6f6
         9pBij2AZyc6SPWhon2aHCk1yFVCkql9UEHoKLdsvpx7KYeGTqiQvsgBrNOnWLNd+Ghp8
         xxJIaZUAve60H3XJKqiXHnxbcS9D4HKWqpfejr/0VxyqLd097oLJ8EF4l29KvGZ+KWjy
         MufUAEzSO9ru5AfhwjeSoO5CbNy3gVgzPUziTWop8IsRz4494hZ0eaGtxqZ0Y6Pv1lY6
         QaDQ==
X-Gm-Message-State: AOAM530rgWFgFYsN4KYygCmSGIgU3nIFwoP4BkYwB7HLkLs4Yg5F8GRU
        d8EeDqXf+NZNVJI2s0KUuAM=
X-Google-Smtp-Source: ABdhPJwcrstHAxmVFObAu6ScZqiq0KNBdT5GLFG8OMoFDFrE9mak5P0y39abr3sNTJO9rTY+diwkmQ==
X-Received: by 2002:a05:6830:4197:: with SMTP id r23mr525215otu.129.1643235029172;
        Wed, 26 Jan 2022 14:10:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l18sm10038583otv.49.2022.01.26.14.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:10:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:10:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/184] 4.14.263-rc2 review
Message-ID: <20220126221027.GA3650606@roeck-us.net>
References: <20220125155257.311556629@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155257.311556629@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:31:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.263 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
