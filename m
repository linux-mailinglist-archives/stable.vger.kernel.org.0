Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C5AA968
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbfIEQy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:54:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43154 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfIEQy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:54:58 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so1560687pld.10;
        Thu, 05 Sep 2019 09:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WHLwbD16faZsxGqaj0X+34eXx8UAGa5vrR0WO0SL6m0=;
        b=jXyweOl+Qqx6fNj8Lmswxe5KitNyKZ3yLiyFt3P1NvD5wGz41tj6QIYynWtD3HT/cw
         w1GaR9izHxq3x5iKk4zg8imqXCusgwYVxUxV1F8JIvcAR7tvizKrPavZDdLrA7ZeCo3l
         uJMDx9YMsihXZNs9EMA//876orHHz5J7nDQ9kbAJWvWw49cDIyw17maJ+f/+xN1QYnqn
         zmCRyMQCTZWdw8X07u83ChLLLnIPllGbyyB8HnNe4wkf0KEH0YY+qwUkj42K2sGnkFe1
         dEBIULKIIX48RlXDwTmBptVJYdWNg0vykSFVlMmnHlbXKtsnr2ybOqhpsTwSy3jCk0UW
         0+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WHLwbD16faZsxGqaj0X+34eXx8UAGa5vrR0WO0SL6m0=;
        b=MeM/VwqHhgcl5iIUUzWNkr1w+JvDzAxdDh4Vimxktk/cGPdJaBXIIeMnD6ccSquIZp
         U1CvwbzzbAsWrKlqDAYlvOAmTas8LOFNGVIEI0xHpXRgeW0B0G4LbP8DzHGYuNAAV9tk
         4aP7WH5KlDg7jgD876H+h4AO/9sajRtrFW2mDzndInAg9uvIGVjvE2frcqtX2AzbjnDF
         SFC2FitLEFPtDVHwk3VURR60/11uBXhyz0oJHyKjWhjlYP/2PAvhQMupv0I1n1NZIn0S
         WjB3m880ah9wcwyceeMvX7HuV4JVJnwCLKxGLrdph/lJoycQVQCkdjY1biFLSrNkH1uX
         Y5dQ==
X-Gm-Message-State: APjAAAWxvYp6+x+1FEi9gn53Dx4fqpU4Bmc9kPkB5hqY36V6fhoadOTG
        n98BC5GqtQkoKf6Ek016XxE=
X-Google-Smtp-Source: APXvYqztdVGeit1+a7Uz0s4/93Ux89Ucui07+qP/bbkhVFwZ7uZqSsnbgocR4j4/4Sr0ExIhBTBuRw==
X-Received: by 2002:a17:902:9b86:: with SMTP id y6mr4516909plp.217.1567702498014;
        Thu, 05 Sep 2019 09:54:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v8sm3564319pje.6.2019.09.05.09.54.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:54:57 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:54:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/77] 4.4.191-stable review
Message-ID: <20190905165456.GB23158@roeck-us.net>
References: <20190904175303.317468926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.191 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
