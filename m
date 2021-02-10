Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A031677C
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhBJNHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:07:52 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:38986 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhBJNHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 08:07:23 -0500
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 247689F713;
        Wed, 10 Feb 2021 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1612962389; bh=ctMZOfE2foIeYMgl3gwz+hOPsCWvGsb4JYLBNnv55LY=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=sN1Z7NsXN7dHvnKud5DbJaFXbz2OD2K/dQNtM/aPgcWJA1KQ+a5Pq9uKda9Zc+eNh
         CnqCPSrsSCcXZjpvvwzy4QoJ3F36uuxHTmV70vHOar6YSgUwLh6BKh/VQ273PwUV/g
         02rMfF6wVczEh9jUVeemo744R9s0HNpcCcUK4nyg=
Subject: Re: [4.14] Failing selftest timer/adjtick
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
Date:   Wed, 10 Feb 2021 14:07:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCPZA7nkGGDru3xw@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2/10/2021 2:00 PM, Greg KH wrote:
> Have you tried applying it to that tree to see if it solves your problem
> and works properly?  If so, please feel free to provide a working
> backported copy, with your signed-off-by and we can consider it.
It can be applied without any changes and fixes the problem, but since I 
have not a lot of knowledge about this subsystem, I don't know if this 
breaks anything or if it requires other patches to be applied first, to 
not break anything..
Maybe the authors of the patch can check this easily or maybe know it. 
That's why I added them to the initial mail.
> But, why not just use 4.19 or newer on that system?
Why does an LTS version of 4.14 exist? Because the customer demands it :)
If the failing test was not one of the kernel selftest, I wouldn't 
bother you with this...

Joerg
