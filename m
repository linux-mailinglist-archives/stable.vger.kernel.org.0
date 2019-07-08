Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81969628FB
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390639AbfGHTJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:09:48 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43234 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390491AbfGHTJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:09:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so17020197ljv.10
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dA2xhiNGZ0tuWmkiPtLUTjcqW1BzzQUxradpm/yDvWk=;
        b=H/Qz6Zl4qWwcws/K4ttAjHFj7ySNEcnvAfua+hF3xC61yiKJu8+PHKTL9/3Q79Ov0F
         04UJsxxgK8HOgQFcL+Y995nNvXIOkKe975rJKD3bDttCNpDbpKWx3P/LaqlIuugcGT8q
         2ZyIADyyETAdZHQUyluRBkVRjZTX98gebReZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dA2xhiNGZ0tuWmkiPtLUTjcqW1BzzQUxradpm/yDvWk=;
        b=LP9Dd9D9ivFbrrpBjB/hJVMI+qsYyHavW/kWGSzDjS5uLD1Ob3+WbUgx/aOqTWvEHp
         b7G4ASczTr8ED6CUyLt9e6hHyTfS+VUIlJ2d7Gnq/PKnivPojw2g0EjyeA6mSHly4Swt
         f8HsbwC2j+Eu6OxMDrfUkFZpTM2gNDH7GW2yvrW6INUaJjtjhKEA5SpFsv31g/nPbDij
         yAi6FH0WuXUWXkWz3tTe9lFpJbCEHqaATrZLDISt14qzOYMhNyQdK7PHEtOQu3edO6et
         Q466L4ktao1YdlK9X1NRTD2a5TphxAHibbxWjcgKdKs7MG5GQQ3v1xDRm4R0SqiBEgrS
         4g3w==
X-Gm-Message-State: APjAAAUWWBRrxX5Dm9fN2xNz8+tbWNwtzawL4dKtKn0z9UglWjMClafA
        r9kEB4qfqsXlQlyCwrx4fVb9Nq4WvZNpPxe2
X-Google-Smtp-Source: APXvYqwcb8orHaqFemykl0AZtk0WZ0DDmrGen5cKEPKeIzWzqPpyTZWQsDBi7rDXGKW6XAxiXf08jg==
X-Received: by 2002:a2e:858b:: with SMTP id b11mr11221294lji.159.1562612985927;
        Mon, 08 Jul 2019 12:09:45 -0700 (PDT)
Received: from luke-XPS-13 (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id k4sm3834016ljg.59.2019.07.08.12.09.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:09:45 -0700 (PDT)
Date:   Mon, 8 Jul 2019 12:09:42 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/56] 4.14.133-stable review
Message-ID: <20190708190942.GA4652@luke-XPS-13>
References: <20190708150514.376317156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.133 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.

Hi Greg, 

Compiled and booted on my x86_64 system. 

Thanks, 
- Luke
