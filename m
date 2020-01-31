Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA03714E79B
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 04:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgAaDdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 22:33:39 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55405 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgAaDdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 22:33:39 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so2220731pjz.5
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 19:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sCkfQKuAvr2OwnqtodV9K1xSpHrcxn/rSTQuhtrvKOU=;
        b=pxNHn2M9cXBrfcqStDTNXinFnaFZgwzgE2vm+n4vJm654u2TQVB0U8AcdZbLnH/0g+
         b0xIAlR2PKnZ/wbMGuTlnRPoKi/bDdKQIn7FBhUDH0StxMMBjs5LZCOTa6xFzF/o39jW
         2sIWq+xNvlahrcdmuSTJWgrfyH/Zsh6ThmqCUqaO37MfNgjDQuZ4KRRZsEOHeJCYk1re
         nLnBjR3j1RSm0i9ce8hQE3kSbH1g8lQOHH97vWhkoRd1w5lNmidpiHPZdAzCWDUaWc5D
         sGJKbgZ3G9taQCKp2p3pvTL9d6xPWdONNF8wrFoaasOXiPrXixz3O+D/TIIUlAd6JBvU
         9CxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sCkfQKuAvr2OwnqtodV9K1xSpHrcxn/rSTQuhtrvKOU=;
        b=Y7KeVdN11gJLdoul2PPExPccq/i7UP/qU6OWfGs4j1yAdMlrPKH/vd6KtuFWWE9JHw
         e8Azg/Ay1PiOvXHuhLz6JOW0PvQXtzgtwhiZGxyC//trvaEPoAaK+6IkvSuA6DEIWpc8
         s5NbT1XFI+HINmOPugvJl9zIJrL2QLLSpl66iFxFaDkVapf5dtafEPgAs6NTkfeUVnJ1
         74WghldFZi/6NsgSakaJokC1oQiahF0ulIyhV48kyYUG0ivqOO9WjT2K/oaj5oD0xXJA
         QoqVSseMdpRrFAAQCYmI/YQaAAqPki4pI38PEmqP+ta0sibdzNdTlc51eK4ciUAcACeT
         kMUA==
X-Gm-Message-State: APjAAAXkgyzHpAPlitYiFLrEkmrWHme10XE0TwW4AyLeDieyKH1jSjKf
        rUztsoCZvNUETrz/VGr0wSXQDZlY
X-Google-Smtp-Source: APXvYqySsR2sWrcTsnIM80y8gVrz4GNW8m+Aulayv+uKMP9cPNMzycm2QjRc8e+Hd+umVZ/W1qW23w==
X-Received: by 2002:a17:902:7b86:: with SMTP id w6mr7789279pll.317.1580441618553;
        Thu, 30 Jan 2020 19:33:38 -0800 (PST)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g21sm8738494pfb.126.2020.01.30.19.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 19:33:36 -0800 (PST)
Subject: Re: Request to backport "Documentation: Document arm64 kpti control"
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, stable@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
References: <520fee3a-4d14-9a78-e542-cce98acae9f6@gmail.com>
 <20200126135233.GB11467@sasha-vm> <20200127155106.GA668073@kroah.com>
 <20200129191630.GB2896@sasha-vm>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <5457028c-6eaf-86e3-ed87-cebe30a39d1e@gmail.com>
Date:   Thu, 30 Jan 2020 19:33:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200129191630.GB2896@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/29/2020 11:16 AM, Sasha Levin wrote:
> On Mon, Jan 27, 2020 at 04:51:06PM +0100, Greg Kroah-Hartman wrote:
>> On Sun, Jan 26, 2020 at 08:52:33AM -0500, Sasha Levin wrote:
>>> On Sat, Jan 25, 2020 at 08:03:25PM -0800, Florian Fainelli wrote:
>>> > Hi Greg, Sasha,
>>> >
>>> > Could you backport upstream commit
>>> > de19055564c8f8f9d366f8db3395836da0b2176c ("Documentation: Document
>>> arm64
>>> > kpti control") to the stable 4.9, 4.14 and 4.19 kernels since they all
>>> > support the command line parameter.
>>>
>>> Hey Florian,
>>>
>>> We don't normally take documentation patches into stable trees.
>>
>> Normally we do not, but this is simple enough I've queued it up for 4.19
>> and 4.14.  Are you sure it is ok for 4.9?  If so, Florian, can you
>> provide a backported version of it?
> 
> My objection to taking documentation patches is either that we take all
> of them, or we take none. If we take only select documentation fixes it
> makes a frankenstein Documentation/ directory that might cause more harm
> than benefit.
> 
> Let's say I'm looking for netfilter documentation on 4.19, can I trust
> linux-4.19.y or do I look upstream? Right now I know I have to look
> upstream, but if we tell people it's okay to trust the linux-4.19.y docs
> then we might be causing harm to our users when some fixes were
> backported but corresponding documentation fixes weren't.

For a high profile feature/parameter such as kpti it seems to me that
making sure that the documentation reflects what the code supports is a
good way to limit the amount of support requests. For other options, I
would agree with you that back porting them probably makes little sense.
-- 
Florian
