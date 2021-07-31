Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820DB3DC365
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 06:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhGaEoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 00:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhGaEoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 00:44:10 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE31CC06175F;
        Fri, 30 Jul 2021 21:44:03 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id c2-20020a0568303482b029048bcf4c6bd9so11774173otu.8;
        Fri, 30 Jul 2021 21:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gof5uAFDYaK8JMjJaZeVTbKBZfqFb/cl6SCVEVhjqvg=;
        b=iwTPHE+vJTdw7S5eegFMuAtFncJu+aZxoq8RGLtLPtC3vdKNNIa5NVK+dohUE6gjU6
         zDMmQUkBBLHVKt7cPNsng6G3iyzdRb1ctX6EKJ7DPaJYQ0rU+Uf17YHbJ2M/c3a5BpP/
         44zpo3DIJd2W6PIMFKOT1ucfbiHVyOgiseRvf5RztZ7x4b6nK6BAMKhRpH2KX0NAL93w
         w225ot0+zElaNTUe7BDS59bMBDAtEWicfiuU4gs2MtE+kD5ck0VohrBYFLUCQVKsRnY2
         mBEN4kbwzNK1oyD9f5WBmzopRBH5SQGfUKbhUlkfPGKtOc2+sNGQk9MYAEg0/mkPdzoK
         2e1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Gof5uAFDYaK8JMjJaZeVTbKBZfqFb/cl6SCVEVhjqvg=;
        b=rEDyFMk7WZSPjAjzLTGtBolIHsXLjNcnxYVEBynVRRTyPKp2+LHUAFfuJBm6JXBwPE
         AMnkr2qNi6+/AR4GIMwN0K/UvRJw6Xg4QxRSbxD4+NwD9XZxRwAcg0ntjjoyYqTZjxki
         P1OP47POv68OFiqqXUfGjZ0dWyjDyPy5nUctqiPnb97lj8fDItk+08Pnu1ZQFDqA5+8O
         RgHe2xDE/XkgplfJjjpITntiOCBtqKjA/2PWi+dtEK+UDwEWhn2xABrXExPAY6AbTfcg
         LKWGn737BIGI3KRZDmZvDXLyoQVZfrmCYbrqKuPQ707JTdoMw3JnSEp5lqWlMYLlmi67
         sJYg==
X-Gm-Message-State: AOAM530aaGd9Gd4TvryrutzW34r8tiBnrIs/VRnMtWTZtBUOXXV5fYPD
        7G/0Isg7QC7FOw2Uy472ogg=
X-Google-Smtp-Source: ABdhPJyQGs2wEdHnPmd6T77eVk1eIMCgXRpbmS/2+gC2yeC60minYLDrb44SoPoDK8sJ70jJv3L2LA==
X-Received: by 2002:a05:6830:4104:: with SMTP id w4mr4620163ott.59.1627706643346;
        Fri, 30 Jul 2021 21:44:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f2sm640580oij.45.2021.07.30.21.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 21:44:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Jul 2021 21:44:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/22] 5.13.7-rc1 review
Message-ID: <20210731044401.GD3455442@roeck-us.net>
References: <20210729135137.336097792@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 03:54:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 470 pass: 470 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
