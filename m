Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3886DB6CB3
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 21:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfIRThv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 15:37:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33418 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfIRThv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 15:37:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so460775pgn.0;
        Wed, 18 Sep 2019 12:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DR+J5C79lLzRKGlKuT2X9cpCjeYLt6AyFeSZmrtSIys=;
        b=KY9CRwjk5uXww8C2OvO/Cwbf2mT5w7l3OCtIbTM0kTG5Kbi880mpchPLV6kKUqI/P+
         pCkMV2SnxVfyV5qOOIaEdIpgKU35yDGEJ46mCuHssgpuBMK7dCKJZ9ip3BNQ2l3np7F3
         7e/6Unih8OfmrFVvDfZJBQps/jba7jEqBp4JlOf8BekTBwDACmQk3wuvmghDEo+j3yqa
         lqF/I8LscY/6aZjch+XNp7JW9Kk/sKP51PXFFzjfNn1itUFjRe910eu+G8FcZI0+/kxd
         wP3PKSVQlqlQ0AiuJtSm1spR5U1vbmrK7WpWX0YqaM5LGJeBuF40GSWwOB7kl6YKMIus
         ipAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DR+J5C79lLzRKGlKuT2X9cpCjeYLt6AyFeSZmrtSIys=;
        b=UgiXV01UpMNo4TqZK5cS5iDOpVD1ThZL/OZZ96XzhdCGObNnHwLV6ySwHJOiQ+OJ/1
         wtagT5dVomhHSijD0o1YgLckaARs1dALw4kbIe7Yu3UsbFudTARNHpJtjY1w6L/Q2XKC
         97ioHBVG6QQE/BoOaLWkKeLf7pzZsJgSC7rdQaLdDv9zJ2A5JK6/kAsXLLCzo0+cXILu
         M40vTpyV2zda4xuU9/oFAzFsLgYAuDxpDKQtaetlBtvCF546EX8ZpQIZ/qxM6IVC87ll
         XzvBIuPAZ9kA0vufdNLt8SgBFhge1sW9NfDBNRXbvx5NROw4+BxK8Xdn5BuoaFkJ3x15
         qILg==
X-Gm-Message-State: APjAAAVLQMxq7e/Z7B9BtFCNL3oJWJzJIiSbcdeTdhUyPVuKemLOTaAQ
        sK+is0ptFYT1LT/Fk6lvMW8r8PE2
X-Google-Smtp-Source: APXvYqzcxu4tGyAZZuLc3tFbpNtrS0UhtGLWCi6w4HEk9Sy7P9JuL+jImzfvpp5uSocqkPND5UZ2cA==
X-Received: by 2002:a65:64ce:: with SMTP id t14mr5455011pgv.137.1568835470414;
        Wed, 18 Sep 2019 12:37:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 193sm8979708pfc.59.2019.09.18.12.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 12:37:49 -0700 (PDT)
Date:   Wed, 18 Sep 2019 12:37:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/50] 4.19.74-stable review
Message-ID: <20190918193749.GB30544@roeck-us.net>
References: <20190918061223.116178343@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 08:18:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.74 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 

For v4.19.73-51-g7290521ed4bd:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
