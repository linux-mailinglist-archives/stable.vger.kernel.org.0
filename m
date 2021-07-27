Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B83D7B95
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhG0RGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 13:06:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.183]:3640 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhG0RGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 13:06:45 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.179])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 63E14A0073;
        Tue, 27 Jul 2021 17:06:44 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 219EFAC0082;
        Tue, 27 Jul 2021 17:06:44 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id E74EA13C2B1;
        Tue, 27 Jul 2021 10:06:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E74EA13C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1627405598;
        bh=d9I0mXd0R1t5IefPUqW52TxJvXRFT80ifKTzFx1IAhQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GHHCFDVbgf0b2h/IMyn7freCTIg4eWMHluIINkze2qpyt3by/L4TrRiD2kKJFsApL
         sUcltjmikPvT72Hrhj0oopvqEXTvoPI+Sp4opeEigOOXcab7CTq150Gz5BHNHr/4HI
         Xt4kvmKL3tsosggwFMX23aSR1gxwD6I3Wy9tMeBU=
Subject: Re: very long boot times in 5.13 stable.
To:     pgndev <pgnet.dev@gmail.com>
Cc:     stable@vger.kernel.org
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
 <CAHv26DhDYNYGmQa7Dt4NoAz74J89pi8+4yuEprFO0bjuN9G7gg@mail.gmail.com>
 <f8be86d0-28ac-3e5b-1969-9115e5e0472c@candelatech.com>
 <CAHv26DjBqX__YYdqJEfMVZKFomuW8+mid5grAvUfMNmXMtC8pA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <f3593f21-11e5-c568-c8e7-45b3f6657a02@candelatech.com>
Date:   Tue, 27 Jul 2021 10:06:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHv26DjBqX__YYdqJEfMVZKFomuW8+mid5grAvUfMNmXMtC8pA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1627405604-pzoBfyQGJtyT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/21 9:50 AM, pgndev wrote:
>         embedded. checking...
> 
> 
>         iiuc, it's got an i2c.  possible a uart is on Irq4 thru the i2c?
> 
> 
>         if so, might wanna take a look here:
> 
> 
>         https://bugzilla.kernel.org/show_bug.cgi?id=213031
>         <https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D213031&d=DwMFaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=HYKqseB9xg-u2kz3egvegqfgyXnEBhQotXfR3iCfdgM&m=gCRilkIAaKYuJwLWOT7O5ttfWG5rta0-6eYjPBdnTz4&s=VSfJDrJPSqVtQuCoCZGazYrmnWTe6xldTkWT_Bq7vwo&e=>
> 
> 
> 
>         maybe related?  at least shares symptoms...
> 
> 
>         ACPI subsystem lead sez in offlist thread re: that
> 
> 
>         "It looks like commit 96b15a0b45182f1c3da5a861196da27000da2e3c needs to
> 
>         be reverted." 

I don't see that commit in linus tree nor my stable tree, can you check that hash and also
show me the commit message and other info so I can track it down?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

