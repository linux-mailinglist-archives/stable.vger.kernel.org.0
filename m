Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2DCC628
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJDW6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:58:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39279 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDW6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:58:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so3792958plp.6;
        Fri, 04 Oct 2019 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2/0xCPg47in+kKV+qR6CL700JBgNB0aTINwBCpkENdo=;
        b=rmte3oUjCD8YvTLrJTOJ5fmbvJ+Frk6P3G7PMayE/EPnKKV6oFX6Mf4oU7wrknVq87
         3rDpH7K0JixE9EVVkoLFCh6WfmfjZc1uNAUOfOsCXAno0MgJwxhaNw3qoujNiv8rzmgo
         yZGxnlHmqQbom18fHIsN115OVs20VjOuJ9DG3lMySjQtjPlArLQaE+Bd1Q6+Ow/IDfay
         eKKECqDWCvleVOUd71SxS7tbtFg1PF3dtVZhYbUiZm/D7FSzhjr8sexkYY8MNChjJsUl
         5IH+ycct+AgZGlPNH+PN0uoyERa6T9aFEb09BYCZeNoaQf89Jx5tm44jAFQN3nJ7zD2N
         T1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2/0xCPg47in+kKV+qR6CL700JBgNB0aTINwBCpkENdo=;
        b=VDLgOyamyv+aOLTgXVvIeJ53uI8swa45W+82FNkZ8vqj92KWGzwvhTr8UN2aEXpzYx
         TWl4pkKb5/l1YAa+wzl1sC1sL2vX8oJYuEGq81zum27FXTn+a49WHNLfHyuaKMkdidjG
         drWHWhEmn624AuvAlpEftLzD9A88BJ8wmmkcA6gbambuKpEruopB7qGHYQ/EUuQ4EtZw
         LumeS3XKTMZIguu6wrmnG2uOPJaQ2Ywe5cRTseKJlQ2RcLrzwkAd0nxsPWfwOBA/FYmG
         84JiE2OyOYXZRKBQoLx8MA7HNzNripuD+Q4JPrFS56YaMK6ZROA7EzPXBMWQAciOjdWc
         ZCyQ==
X-Gm-Message-State: APjAAAUQBGhTH5aLcY3LOv8dZ6N9GVf9z6Ptv8XHBVEN9YbpKzUU0098
        QewOl6ThH0WFkMS4rFNYjlM=
X-Google-Smtp-Source: APXvYqwu3VVg9YIYGydAbhjvvYM49BaaNzCgSIplNPErVEFrMPacueWxH9J9l6LDsEc3iDNJtS/Jcg==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr4430761ple.183.1570229891098;
        Fri, 04 Oct 2019 15:58:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a11sm6655954pfo.165.2019.10.04.15.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 15:58:10 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:58:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
Message-ID: <20191004225809.GD14687@roeck-us.net>
References: <20191003154447.010950442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:51:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.77 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
