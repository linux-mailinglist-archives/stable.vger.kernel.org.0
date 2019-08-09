Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B4D87E26
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436696AbfHIPhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 11:37:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45985 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436647AbfHIPhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 11:37:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so46024277pgp.12;
        Fri, 09 Aug 2019 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o7RytPPyh5GMtiv3pgHlkz0FSdx66hUEJr7Catf0czE=;
        b=htHffqRITwD8S+XEBDCTNlO034cZBA7VemDBWVNeeMtr9wNXklrAtrXraAcfKbyfSV
         nBZi53N1wW0c1ZHJs+JYdWRyhj9rUa3NHJD/pNNKs599m8c40Hq9YKTb4OWJpRHnkC41
         WQES2IfDTBUzywogngC7LUMhA4uBqg3evuhB1kYzY9tfLWyjoEGX98QtDezRRf67y8XX
         RJthC0JFa6NtEaUYbvn5EtNfWL/OnW1bW2VLBV1e6+3gupvN3rEaFHFhqIcgPzo3eV5x
         83Gwml6zZg//39wbqdoSK1q5PAyjBjkZkak6ZcWteCU8y9ftPrZRRgi6CH/xJ+s6i9X2
         eqOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=o7RytPPyh5GMtiv3pgHlkz0FSdx66hUEJr7Catf0czE=;
        b=RjBFPxl2IQzHD7DrQZrV/Ukk5AGphHFxzLdIYt4Vl8n+ga/c50iwhdF2WLhRZDIdsx
         2oPx3sY+ZxCeIvHKfRKeYAH620mOR3GgLi5g+IhN5RMazkptuutCe79CpVMSDEn8hNyg
         EVpUPoAXoGlXjxR7QuAVisHNjOd0tWBL7DSzJy5HxoxJyu+ZlCfYfTACj9tiAOuwa1OX
         FITnT3CDl5uOl/2C3b9xTElIYMQ5sIs2OnSXlnczaZz3pbtFeT8mjgmpiB5+6lydQT0d
         bZlaq0UHTWJoPkNTNdRVwHJXGNOuzi5t9Tl5NxgRm2guB/vNvXARY8HujApnRujQ4MM8
         qH3w==
X-Gm-Message-State: APjAAAWplyEUD8wGePx3d02DaABXibVQ5ks7jFyBvk2cul8tgK9ERgqM
        Cdp6wVQUkK31D+2ah33FjXo=
X-Google-Smtp-Source: APXvYqyCiU5Ufxq4D8P/1yToS10aCw7PMHs44cNMu8yyJA09yoTiPNMiE96j61yPp+bf4bQtNLirMg==
X-Received: by 2002:aa7:91cc:: with SMTP id z12mr22131354pfa.76.1565365027498;
        Fri, 09 Aug 2019 08:37:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z63sm72576598pfb.98.2019.08.09.08.37.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 08:37:07 -0700 (PDT)
Date:   Fri, 9 Aug 2019 08:37:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/45] 4.19.66-stable review
Message-ID: <20190809153706.GB3823@roeck-us.net>
References: <20190808190453.827571908@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 09:04:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.66 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
