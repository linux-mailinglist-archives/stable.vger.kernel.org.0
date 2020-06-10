Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC441F5BD6
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgFJTLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbgFJTLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:11:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B7C03E96B;
        Wed, 10 Jun 2020 12:11:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t7so1393603pgt.3;
        Wed, 10 Jun 2020 12:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VjN6PtM9eQcwFat45q7B/D/HGaIIKGoFFHYjqauxi5M=;
        b=ZG3FMJb/s7lorhLzOiw+9VtxYoaNbteAdtUVi8jp0vu8doytYRyRWeuhiNqkZmycPo
         FNTf1wDNuJSgQIU1uMhE7OiSDuadU2N00GKZf9KrecCaiq2Q5RjLr3BVzW5HdmE08nYD
         H1LWYcVA4+gQ1KbPHM6w3m//SNBN35Etg1DigQBSxC/3FjZDVTG5Pmyo9X7s+4Z/6yuq
         nobb9BpgK/I0jnFHmcDiUVbAJ30JCHEDWDcI7nJY3OvYFRcO9J0qt7d9ntwanWLnUkCE
         CW+Y11tP4hEaatZNM5d+xRTLeK7OPOZEIjoLelduf5A8YT9aYtixH2yLBNkIrXCUXNZw
         sEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VjN6PtM9eQcwFat45q7B/D/HGaIIKGoFFHYjqauxi5M=;
        b=PPss7E48HX08bpvyFIoGyLQ2ff/r3obVW0yfLVHd1GBnnSzQWH9afGhb9G13sC4/4W
         XdNtRgMFCkKUxElDL+pqTzQYrMpwaOpu2bITa3GOkxrz3PRXRaOQbzGPlEl0HH9KoMvz
         q7eGm8gyOCWslWrHE/jzu/yiWjQVOR3E/w49y6Y15UThWnDFR6kqoHE4lt17WYrY9s5f
         yUQVGUYhsT1auo0OXSQLsN06pK21xIoiU3tdJLI+/9TEZVYZGsLWQdClutTCOzawLo44
         KV1p+8ScPI8/0s3imSzX/dEHfkXr+Gu6htl+/io1IrVTvKFhLhrKZwdf6WbyWyq894RA
         ZFCA==
X-Gm-Message-State: AOAM530Nk0JkTp+a/pGIR//BksIa/1hObAwXjv1haxtyNOus/SlzNv0z
        PRw4c6Y+oR/5qhz/DlAB2sU=
X-Google-Smtp-Source: ABdhPJzWzvq+ruJBppZkgAr3qNOWvAdy8YVaJb3I3CCpg30BFY59+gNBpu0TdPma3eVaREpUBfj9GQ==
X-Received: by 2002:a63:591e:: with SMTP id n30mr3934505pgb.429.1591816294770;
        Wed, 10 Jun 2020 12:11:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3sm673149pfr.2.2020.06.10.12.11.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:11:34 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:11:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 00/24] 5.7.2-rc1 review
Message-ID: <20200610191133.GH232340@roeck-us.net>
References: <20200609174149.255223112@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 07:45:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.2 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:41:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
