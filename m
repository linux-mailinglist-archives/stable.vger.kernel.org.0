Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C626D55A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391607AbfGRTrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:47:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37234 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391394AbfGRTrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:47:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so14402552plr.4;
        Thu, 18 Jul 2019 12:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCeZhvjMPxe0X8TT7PbsY5EmMpx/Napv2I1k7N1YFk0=;
        b=ENXS4jDhS0Qd5mbCjrCUqlBRrj0bVDgtLElaqlY/Fmr9jV0p7OJ4FVqCfCfNpqiVNN
         7YmvmHfU4IyHNnApQfjbk1uvGZT05dcS4CAA1TfLI3Xs2zMswZv/3i70Z1/cyn5f5hEi
         J7VfM0w9bB6KjFf/ZvSBXLLSq0llXTr7Ex31pJ6gkFJ7KZqcXrLzFpu0ef0SGcao0wYS
         NH8xwdYQ5GH2NgoG6+XuVyIl9HSXSPuX6zXRnEzDrLH7/D+6e+ZadeHbdb8csFcQ/6cN
         wHQtiWgQ+6UgTnugrHWmt3WEaOl19qKMq5VsCwMYn9gFB0MAPLV3KLnnghXe/ai5jX0y
         +ATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCeZhvjMPxe0X8TT7PbsY5EmMpx/Napv2I1k7N1YFk0=;
        b=FN6CD+ozaIAuOMpeJoZtbwtmDBM3EC1S6HHUsdTV4jVkAb3D5sB58BzrnUGQkLmQpK
         q21xyzTjFmyNRaC8u98BjQ2Zpm5XbgYHGcAb4QIoSNXtU2uMV7Qz1zeWXlMaQ7JVW73o
         pWk9FvfkAUbnboni/CCg+Sb+oesm2a0+8NrOac5hHxD8FqSE+2T27Q57ldcsaR6yfezb
         XjHuIx/wY1H9PDVnUWVLWyGkmkKL59SycJLcSrKDHTYcyEkB0LUn3Tz7IjFtHVlorhMT
         RZUbixiNx0YyULGf2txCrclMdyhq3LqRs6+KY85W5K/gLivs69uZLS0Dh4quq/EqA5NB
         93Hg==
X-Gm-Message-State: APjAAAVV5BFTLqjIGe7JpzZo6PwPuA+R2pJVEIM7nTpeQRSbmxssrIbQ
        KoqePdi99xakkbrj1KRuJhU=
X-Google-Smtp-Source: APXvYqwVPN15asyLKMZcr03KoOgq+EUL2ozfRLgFh6Tj6c95U9/BPUTnSfC1trgces5Rvv09nbuYMQ==
X-Received: by 2002:a17:902:23:: with SMTP id 32mr52029908pla.34.1563479236003;
        Thu, 18 Jul 2019 12:47:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 131sm33900891pfx.57.2019.07.18.12.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:47:15 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:47:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/40] 4.4.186-stable review
Message-ID: <20190718194714.GA24320@roeck-us.net>
References: <20190718030039.676518610@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:56PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.186 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 307 pass: 307 fail: 0

Guenter
