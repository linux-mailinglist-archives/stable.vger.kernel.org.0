Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94DB7B90A
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 07:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfGaFaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 01:30:14 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35284 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfGaFaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 01:30:14 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so133617625ioo.2;
        Tue, 30 Jul 2019 22:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J3z4rR7tscJSQLhjs9fqHEn2dwJY0f3wtUsYUqVYKos=;
        b=RTewgHKVfeigtmGppEW+PVCRAj8GhWkhPpDOwOU+4KoRkS+WjUMmyV9ex00SjdOwNq
         icWCcfGV1dauTqx8kg++JdZHQqAo7T/BtHlF6FbddacoXBl1cyQ8WRiedeRTFmCXZLW9
         T4vsnYJ/TKPLuHXVGZ9Sg828FhXma467uLyIwD7izij5Sl0FbulWq+kunmRKSu0OfLXL
         vMRXpjZbo1fvTTpNETCfhVd+ucM1zdz0x5AUl3wkzKQZHCRD+AUok2dwYJGk3zQ8ehMm
         vRBAfSjS1KQBmfiz3aW4+ElhSInrRVZ1BQjur6Ck8fPP2hWl7lheOO/CLlziZCNXrGOT
         aP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J3z4rR7tscJSQLhjs9fqHEn2dwJY0f3wtUsYUqVYKos=;
        b=EhLPk/WzmswQqbWS4BvZVUTP1FeiPGm4zNQCVUsoDfIgr2+OYH3pIzmDuWYziLT5DM
         mN8j8SGMYDSC9tAEX4MvshNLMk9Yr6pldETGGKxIDeKYDbVB5zQqF5jFWRvYwMlIj7EX
         XZHSB/16qYOWr+6B85miV1+xV5NSAtZ87Wh26b17bLcs+vhPq12CpV6+djjnWSF1S6BS
         oVMOjy/VrkmU8zhSK5zDMjyTSr0mnxOSBtpu8yl2RRvBsHchMl5Zreq4rnhpYBxNMvPm
         4hWCntLfLexfX4scfhfbebxCSmafzgIHvrvVAADXFKoDvOFOy3HZlLBqSNqwpeN9rV9I
         iUCQ==
X-Gm-Message-State: APjAAAWOm5TVlxhvBkdT5DedwEY7sKuvL9/jsL6YZqrX0GBGmZVm1dpg
        LQLcHmR4ulSlzn5Pr8kX+A+4spFUKpTqUQ==
X-Google-Smtp-Source: APXvYqxk/i+Tgv2KR1MclqaguNC8kXGE6spLrmlKfC4XKS0vO83D6LGbVEj4pa9L5Q5ZojenTurInQ==
X-Received: by 2002:a5e:d80d:: with SMTP id l13mr69520136iok.292.1564551013238;
        Tue, 30 Jul 2019 22:30:13 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id b8sm55593860ioj.16.2019.07.30.22.30.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 22:30:12 -0700 (PDT)
Date:   Tue, 30 Jul 2019 23:30:10 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/215] 5.2.5-stable review
Message-ID: <20190731053010.GA4326@JATN>
References: <20190729190739.971253303@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 09:19:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.5 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey
