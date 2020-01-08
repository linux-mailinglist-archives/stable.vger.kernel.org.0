Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DDA13467F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgAHPnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 10:43:42 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34625 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgAHPnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 10:43:42 -0500
Received: by mail-pf1-f194.google.com with SMTP id i6so1830975pfc.1;
        Wed, 08 Jan 2020 07:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W7qeVqod83yxvrlZNG1/MPrpMYe26C58G5HTKvxquhw=;
        b=KC0CRv4TAOdaHy1PWbvbAvXavu3LX9X1xBOEmYAw1rvRBQw1Dhjvw+c/3IdNKbRCi3
         0zhz5Z48w8v9GfCPtwM5UN3QWUjDNJVFc/9zpzrJnxNihSqsbHl43GsRFWU5Gzbip5GJ
         a7Huk2pvm0GUnZKfLMIsM/eWuyri6yy8JA/zTqoNyNS2thcntsaAZOXay3dYQKAhUxLS
         CvbqqwlUhmo1k3cacTQTXFWrkK7PnszIa1LvSMloRTG0TfVwdoZRW1daaTwRNltqlOfI
         4tMfqkc7BnaAJj/EWzZkyxl/nQ1+E2CGBpxb8+rq2U2sB6gjJuQdUIWokoVzNounr9Wk
         Ekdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=W7qeVqod83yxvrlZNG1/MPrpMYe26C58G5HTKvxquhw=;
        b=KqyYgg74DyiEWYS8M2bMM209gZcDWEX0tnLp6fkYgB6H9PPdv0a78lhsEl9pY8iGF7
         QqV4qyjxVCT0wLFGKZaYG37KksCnM7/pMhCIM03jRMOSctnoOzgtjZNP9leyjLjDtfzw
         ouvA+TaI6O6iQtiw9TAcO5CVvsp8+3uZCeVGUBxEMeEF8BavZYXAXok6BmAc90KKUEZh
         4y0GZefanvh23YikfV+cIincQdbt6DXymF2/OTjG05B17ErECXvuuL8IrtaNz3wx6iGf
         DEoCn5Df2CYxrmRfhQ79cPLPfimna4V2F6PZs81HfVJC1LMk0xa2Rjy2L2bJIb43DCZm
         j2vQ==
X-Gm-Message-State: APjAAAVvuAjTCf+V7EtcQAlfZqNwACp0qaPq+mblASYaErog2vWnEpnb
        ZjQs/RSMQInAlxP0xmv8BZQ=
X-Google-Smtp-Source: APXvYqzLpFFkeMJ+MyAdZEaA4qzLQvWXWUIcidWk6gLqXroJDvLFYiRXjtfBLP/9Vb2BdTwQmEN3UQ==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr5900324pgw.429.1578498221692;
        Wed, 08 Jan 2020 07:43:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x22sm4309517pgc.2.2020.01.08.07.43.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 07:43:41 -0800 (PST)
Date:   Wed, 8 Jan 2020 07:43:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/115] 4.19.94-stable review
Message-ID: <20200108154340.GB28993@roeck-us.net>
References: <20200107205240.283674026@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:53:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.94 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 

For v4.19.93-114-g53089eea25ff:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 381 pass: 381 fail: 0

Guenter
