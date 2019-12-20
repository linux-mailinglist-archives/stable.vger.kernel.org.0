Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4812825B
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 19:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLTSr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 13:47:56 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33094 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTSr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 13:47:56 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so5379026pgk.0;
        Fri, 20 Dec 2019 10:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EaoCsuGKZiT2vLZ4ETpd3zrvFVz+n7708yQnJ1IMlaE=;
        b=LPzdGRN9HRoHbtKLTu0jnfcZ+vjsgxywBBV9ZeLgVSCTr/lsuIcpq7J1xnW5P3CpDO
         4XIlFlW7n2XbU0jbQA85Kl2oX83aw2a6GIzXLein/npnUpDXSu1E9PGhvlTWg3nm0vT3
         COpoXWUPj3DhspiLE70lWVgL8MrIAPP7W+0UerCSizAnFogT+1c54YwdKjFNx/5EKsvV
         8KqE3Ll4piwLoyQstEVOl2TGMhTjNPUozQ6mbZzfie5Ze/0k3i4Sug6hNDLvxwLkzrnM
         q4kcU573P4rvNWCudMkmTPsurFfPeH5siWdjmzFKahEv9KCPvnHRcDPT0VmT3540Zfoc
         LFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=EaoCsuGKZiT2vLZ4ETpd3zrvFVz+n7708yQnJ1IMlaE=;
        b=TP0bMAYA0sdVMBGAkjQvlM1OgW6Znypc7MjfJTsulJnYOdJ6r0y5hHRgLlBt6dusTO
         0GoOk3NvXNRYjLbDhTwNJwymL+v8hBdJOE1oD1Krgaes8PqWUeSOfLwh1b+PuwX5ZjCn
         3I5G+KcJORjp8CLkzprApClQhpVqs0DwDHULfP1fWbepn88prAplBeJvMP463cq2FEAx
         YLp8GZ/8HvOSlzKWRW2sqdq/Ytaqo+4+CX90+RKghS+N1Xhy0J2aZe3qtfu76LCIxHZf
         cxaDIfCqhJR63BPGMuCjg1OgtRx1kHHgR1tQaULS5ORZD8EyYZ0glWe/31n9DFIjlf7B
         mI9Q==
X-Gm-Message-State: APjAAAVbK/3ZVmpO1ASN9GK0DrPLF7S60xS8PhDHl2HqdQYMalNilIdI
        K7knuF1FQXTdAbEL4oL+ifo=
X-Google-Smtp-Source: APXvYqxxZxACA4X5rvUoWRrpEX8wGtZMqY/dHgftQDMhGhbXgS7jYZmTTcw+ciVZgAYIrtVZS4cCeg==
X-Received: by 2002:aa7:9729:: with SMTP id k9mr17914926pfg.72.1576867675540;
        Fri, 20 Dec 2019 10:47:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10sm9788301pfn.5.2019.12.20.10.47.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Dec 2019 10:47:55 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:47:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/199] 4.9.207-stable review
Message-ID: <20191220184754.GB26293@roeck-us.net>
References: <20191219183214.629503389@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 07:31:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.207 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 359 pass: 359 fail: 0

Guenter
