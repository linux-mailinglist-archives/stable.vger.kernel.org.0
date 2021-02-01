Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1730A3E7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhBAI7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 03:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhBAI7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 03:59:54 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC864C061756;
        Mon,  1 Feb 2021 00:59:13 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id g10so15667455wrx.1;
        Mon, 01 Feb 2021 00:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t6zzPkViDAZXtGNaHi4SN0UuGW+D82KkvB10PcytzLM=;
        b=K5ajE1azXG9rL/tbsndszJWiNLqbCyzpPvOm1T33/TDe6uQGh9QJLbx4qINN/UFmhb
         FTZymP+5Yo+IpIfx8bRbr6e+R/2xjjOuqgVHO3TOMbCneH80sKxgXHAD2u/And7HA31y
         1q7428dsyP/bPu7IR2J+hE/SbvRwmIwtAx0iPuqZVXFUb1Gy/bmgljaJRS4q9ptW88Wg
         0PlrT0hsfltDPvpfmYJtjp6dgnKeQbcNghWe+bYwbOOfe1RpU2HL7A2m1kSPR9OmO1nE
         0+86waB5NejmlbvV0kCx7byP5dbsF/jQ5KwobdIyorxxJGQwoFqXP4roaQLrJjmtU82l
         zxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t6zzPkViDAZXtGNaHi4SN0UuGW+D82KkvB10PcytzLM=;
        b=SBLP5e/fq8NSIbBZq1d3Bh7DirGIDDTgpLpV6Ej8w4ycbMVbfHYOFk6araRTuH6aMC
         4B2bq25kIt69iDZOKKbBu3Ypzr65Vl9a81+4Jx0nDhoRL3z6IUlldF34jLDe9Z1YHwDF
         s13c8E1wjXtdinOuYI68O1VKzH51PlDE7780XN7cPw1lGdmWR9c0cwNiB/qyTO22hbBV
         wZ86XCx8Tjz2O/pGQqrLk5tl5g8a/vEGI9rvkoWMYb3vHsliASYct8mw1nHNhlKGfN+J
         KkcSjgKDLDE4ybfe1ckOB6pI0Ez/jBP3ouAbbVOSJp1mmnRlCCzh+gvEpWawr2IQRqJ8
         wygQ==
X-Gm-Message-State: AOAM532/jAb2YGBp70TiRkWNyjFvIJXWSmx5ztmibVG5BRIk/F+Uexe5
        B4cx2XtwJHj2TrdP+b9JPJY=
X-Google-Smtp-Source: ABdhPJya50e/HGmsX3+yZ/gKTPzQPvV5G6wva2LODTQUjH6JkEDusLTtKjS756uYT/PBBegntjP3lw==
X-Received: by 2002:adf:f687:: with SMTP id v7mr16746501wrp.182.1612169952748;
        Mon, 01 Feb 2021 00:59:12 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id 62sm20685441wmd.34.2021.02.01.00.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 00:59:11 -0800 (PST)
Subject: Re: linux-5.10.11 build failure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, torvic9@mailbox.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
 <20210128160015.phaovyou2m2fgcpi@treble> <YBPfQXSrz+P3TOZf@kroah.com>
 <f9f8e2c9-3690-52f3-8d96-4f2b735dd6bd@googlemail.com>
 <YBPtAYK1Nj/WpiTo@kroah.com> <20210129151423.rsyubljbrzxicleq@treble>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <064cf941-e7cb-e939-2bd1-f0dc2850cda7@googlemail.com>
Date:   Mon, 1 Feb 2021 08:59:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129151423.rsyubljbrzxicleq@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 29/01/2021 15:14, Josh Poimboeuf wrote:
> On Fri, Jan 29, 2021 at 12:09:53PM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Jan 29, 2021 at 11:03:26AM +0000, Chris Clayton wrote:
>>>
>>>
>>> On 29/01/2021 10:11, Greg Kroah-Hartman wrote:
>>>> On Thu, Jan 28, 2021 at 10:00:15AM -0600, Josh Poimboeuf wrote:
...
>>>>
>>>> It is in Linus's tree now :)
>>>>
>>>> Now grabbed.
>>>>
>>>
>>> Are you sure, Greg? I don't see the patch in Linus' tree at
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git. Nor do is see it in your stable queue at
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/. For clarity, I've attached the patch which
>>> fixes problem I reported and is currently sat in https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git As I
>>> understand it, the patch is scheduled to be included in a pull request to Linus this weekend in time for -rc6.
>>>
>>> In fact, I did a pull from Linus' tree a few minutes ago and the build failed in the way I reported in this thread. I
>>> added the patch and the build now succeeds.
>>
>> Ok, sorry, no, I grabbed 1d489151e9f9 ("objtool: Don't fail on missing
>> symbol table") which is what Josh asked me to take.  I got that confused
>> here.
> 
> I'm probably responsible for that confusion, I got mixed up myself.
> It'll be a good idea to take both anyway.
> 

The patch is now in Linus' tree at 5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae

Thanks.

Chris
