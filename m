Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3841732215A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhBVV2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhBVV2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:28:01 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C5FC06174A;
        Mon, 22 Feb 2021 13:27:21 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id s3so10314283otg.5;
        Mon, 22 Feb 2021 13:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L3oJgiJ+zDn3xGPz7jamAycsadqJrwICZWkbJnPDtkI=;
        b=mXkWC+z18KcNtwx9/FU8AFx8LZF8uOMxpuOmBb7Qh/7Z3aOGjzI60TQ0/ZP/pkokw2
         kyPX0L/bWbpgOol8SK8eGuWjF5U0MpED9Z0X+ofi6LB/y35LvW5R4+wBDvMjtvV0xvW0
         AtZsgTqMLCk8QfWAUc3f4VqhovbVDlc+vUhdFUS7GApzKhgyxHgDXSgW0O796CJ9RJCw
         zOtwb1LgvNJS4Fpw+iBVLXGSz5VhQO1UDKmRK7k8WUwdjLIYBbTSeEKoyyzPm05Ghtxf
         SwBGJhb5EWJN6SoL1JikPfkSIF96d3ZdDfaFyA4o19KwMdhSZwBF/6/OtR5W/NwdAzqK
         6eWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=L3oJgiJ+zDn3xGPz7jamAycsadqJrwICZWkbJnPDtkI=;
        b=CO4UFa84p/zuX52eFcVmKDDZVgfGrjZAAnkd+de5advBbLq9c4CWf9Zo5KGJvIgKFU
         Mo7F5O3jm2dd+aUEGE0VAMs/mppJgFVXyAsgh6+7hAoTD3TEYbU4JPMQv9cxgJb/coSm
         SLhJTt3sQqJAs4PIWXWQpaMfg6reRlpJWlc3LkA//taVafaVDLjM/xu3zIQPD2Hw9VBf
         Vpn3Y2BZ75X7vmbnsHDWZRu9QHkWnDwc0c37lH68Ff+uYftZQc42SaELGaCC7zmL76El
         bcdqy2T3jAY4AqI/a7LjPFLDlsDKle8FsTKOMkSzAuCLRX1OL+aQcbn3bWdXKHHidklE
         tvHQ==
X-Gm-Message-State: AOAM530WKq5aewn0/YNvnxReebiS8/VMD3VcrxlWqREl+3JMh8PCeF8Q
        45JwYCrXtgdE7badGNSjmlA=
X-Google-Smtp-Source: ABdhPJxf/ZZz6NDHSfu7elNg5uT0i89wTN6bQhd3Ww5HRSax5OgRwSCVdK8n7nsjT56Jjm+Ihu0cLQ==
X-Received: by 2002:a9d:d34:: with SMTP id 49mr762813oti.205.1614029240417;
        Mon, 22 Feb 2021 13:27:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q132sm2426531oif.32.2021.02.22.13.27.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:27:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:27:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/49] 4.9.258-rc1 review
Message-ID: <20210222212718.GB98612@roeck-us.net>
References: <20210222121022.546148341@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:35:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.258 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
