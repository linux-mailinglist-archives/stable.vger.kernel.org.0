Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE410B7E
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 18:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEAQnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 12:43:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35960 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfEAQnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 12:43:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id 85so8534073pgc.3;
        Wed, 01 May 2019 09:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hCSVytESz3Q+D4Rhyjxyxt2cp+x2VgroJNnJusXnblY=;
        b=Bvrw7tAXHLL2ASfME96js8WKxak0Rnee0TveON6p4bNle7a/tVRL4PVj8icZN1jcfh
         Gt9qWHdrYFaykYq2RXIkmulxRH/oCFlXFHsqJRYkRZTW5YfM6/kB+z8kJfpV9S1oTr49
         nudAnKm6yoDaFZ1dJWiOZmqrw3XfXriiZX85pgw3IBQSH7fUBrkWX1V2ZSRfOoBEaqrO
         ZeGwaFKyly80mZEfzuN1xovlxDvRnfY7Ln3NTje1IciAjRkL8YGO8uvhyzq0mTukfhug
         CVByzYshsRDVaoHGnTVpCy/gqZfznrj/KXuoY4nrkk2g0m8kAnDaSlbLjlb9b+wbw1OQ
         SJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hCSVytESz3Q+D4Rhyjxyxt2cp+x2VgroJNnJusXnblY=;
        b=tWZnzXdd418ZyvX89Gw2oVAYIupbrAdYC1W+6TioK4APZb8XxI6r4CKRtvnsgi3Xc9
         nKAA6t2+/fyTM1UhhGYs4uRi0jSDzDjD+VvVwRrGdilZ4YKK3BPbMzOhcG+FNa2Cm+3b
         cbx8FZZXNIEOxMgVAD2/+6B1gaADaxR+qO4QEE28no0Uu7GwNom+kpgK0UlUJmM0qiAH
         CXusLcX+xCPStQcCSg/t/kakOqkzVDnxe62G2LK8R1nK/UsUJIYgSX0Z7y++o0qePrX3
         isWOoRRwA4wFQFrO7qAqBLoIS0hS7gan5KWLELtEs8lSNvyPoH8no8SCQAuhX/IpznED
         sHAQ==
X-Gm-Message-State: APjAAAVW7Hamp03HaWBS41/4txmvEhcXjpe8BIvqOu4nIKPoYGk/xCro
        2140EfElhBzWnAR4oC9rcmM=
X-Google-Smtp-Source: APXvYqw9HVqjfxFo+D/1M1OGoWppewKKdbwh5N/pyeUxzz5GqAMgqXItwO4iNwDknosGOuFsoOZrWA==
X-Received: by 2002:a65:64c9:: with SMTP id t9mr73975884pgv.221.1556729026592;
        Wed, 01 May 2019 09:43:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b14sm49875493pfi.92.2019.05.01.09.43.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 09:43:45 -0700 (PDT)
Date:   Wed, 1 May 2019 09:43:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/41] 4.9.172-stable review
Message-ID: <20190501164344.GA16175@roeck-us.net>
References: <20190430113524.451237916@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:38:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.172 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:41 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
