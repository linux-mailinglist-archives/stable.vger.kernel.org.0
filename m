Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB169CB81
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfHZI3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:29:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38956 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbfHZI3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:29:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so10147306pgi.6;
        Mon, 26 Aug 2019 01:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7nQNofdNPA0V1tQFGi6EuiXnb+AcRnunYAP+c0aUwnQ=;
        b=O46FQAxCgM01hf0RK+D1QTP9Z4bpcm6iSXU1AsuYjaI/HhYvWQRyFUg346Jtdm9P5k
         W5PhHPKdBWom2AvvVFmtv0bwhhL89KazYQZNGmiKHuulCoiyy7MFvDxrgkST2167y61B
         oZm9xvGGiBDSIKgXktfgB/4kkfgBhezmIC7U9Jb9dOKqo3tnU4IHOzW71zG2OoVjFTt3
         IOTXDjyArz+FItOU9xNGbKQmK4qdbhs9d0cGoDhzJ/hX4RthM0Zp3gyoC6gB0672oaa/
         /iiGXlb6ylbcn1+RRt3q3GW/xdTWhKTlD/Iu4SoYQsrZVexId487SHY9VPrNB7347aOy
         rRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7nQNofdNPA0V1tQFGi6EuiXnb+AcRnunYAP+c0aUwnQ=;
        b=AoRrDtRlqZJPrWoibkjU5o0+1g9SVNKNTEgjER/n4avEvCozmtjNp9lR3JoVT68+s7
         ZJQygLrrnlT7QVQ0N95Rebzktu78asJeM78RBnfvypqeE6tqJJNBP5ql0Z+Kzu9rch1J
         sMBSOeB9BQYvdpvF446uCcrcdOQVN1onCbtlPlWBjtvbXe/ZwjTE4vp/fz3Rfw4K0PnU
         d3NtGUEGunP64SoBl1Y9OnZ6AeVT7Hf+00Cq3e42h8Au1fHG3WR9dm/JQTLVw4PbAH7J
         YPHWZIWLDghIJf8843EWKzGQTXpsUicKdn2HU3iPQbzt3TneFVLwdsHaUk3ivXvJoNQk
         BC8w==
X-Gm-Message-State: APjAAAVOwJXBnbzRniKyb0ImkC8Ji3L1LISTa7rUgwvEyeM0Xmp2MyM8
        t/CiMIkzwLBS/pbk4F9gkRs=
X-Google-Smtp-Source: APXvYqzEFo/9132jFUKd5RLlKtIRUdOHvpdHS4+SIU3SVhuKafxKsOPWgnDw/5AcMmq/nHXsoUe8Cw==
X-Received: by 2002:a65:500a:: with SMTP id f10mr15350698pgo.105.1566808153696;
        Mon, 26 Aug 2019 01:29:13 -0700 (PDT)
Received: from Gentoo ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id ce20sm14409379pjb.16.2019.08.26.01.29.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:29:12 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:58:59 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: Linux 5.2.10
Message-ID: <20190826082857.GE31983@Gentoo>
References: <20190825144703.6518-1-sashal@kernel.org>
 <20190826063834.GD31983@Gentoo>
 <20190826080107.GB30396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190826080107.GB30396@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10:01 Mon 26 Aug 2019, Greg KH wrote:
>On Mon, Aug 26, 2019 at 12:08:38PM +0530, Bhaskar Chowdhury wrote:
>
><snip>
>
>Due, learn to properly trim emails...
>
>> For some unknown reason kernel.org still showing me 5.2.9 ..Please refer
>> to the attached screenshot.
>
>What mirror are you hitting here?  There is a way somehow to see that on
>your end, I thought it was at the bottom of the page.
>
>You are not seeing any of the releases that happened yesterday, which is
>really odd, it's not just a 5.2.10 issue.
>
>thanks,
>
>greg k-h


>Due, learn to properly trim emails...
 
 Agreed.

>
>What mirror are you hitting here?  There is a way somehow to see that
>on
>your end,

I can see it very well at lkml.org  web page ..top right corner box ...all
the release happen yesterday.

>You are not seeing any of the releases that happened yesterday, which
>is
>really odd, it's not just a 5.2.10 issue.

Hmmm ...that indeed odd. I have tried that in "private browser
window,firefox) and in cosole mode with w3m ...same result..

I can see that straight right here :

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y

..wondering!

Thanks,
Bhaskar
