Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA1260494
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgIGSaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 14:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbgIGS37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 14:29:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB07B20738;
        Mon,  7 Sep 2020 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599503399;
        bh=ndF9CsJ7h76XNxRG68TpeYUKV6gTmHk0XmZxKYy89Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDjdK4hzjFAXfi++vkZIaZZG2PdPiF1Xa3i9CuRht77iFsLx5L+Zb8c+0PCOE1W8z
         cym93d9YgkpySjNU53Pl4t56hC3AU+GhuvIotncE5T+VQFUhWSFKOgDQ0CUtdRcjZz
         sHFifEkO7YCrGZcve9nk5D9IvUJtCY2ai81KPmcI=
Date:   Mon, 7 Sep 2020 14:29:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Codrin.Ciubotariu@microchip.com, havasiefr@gmail.com,
        stable@vger.kernel.org
Subject: Re: duplicated patch in 5.4
Message-ID: <20200907182957.GO8670@sasha-vm>
References: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
 <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com>
 <20200907173154.GA1016021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200907173154.GA1016021@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 07, 2020 at 07:31:54PM +0200, Greg KH wrote:
>On Mon, Sep 07, 2020 at 05:15:49PM +0000, Codrin.Ciubotariu@microchip.com wrote:
>> On 07.09.2020 17:24, Kristof Havasi wrote:
>> > Dear Ciubatariu,
>> >
>> > as I am not familiar with the linux development workflow, I am
>> > contacting you directly as the author of the upstream patch:
>> > af199a1a9cb02ec0194804bd46c174b6db262075
>> >
>> > I noticed that your addition there was applied twice into 5.4 [1]
>> >
>> > d9b8206e5323ae3c9b5b4177478a1224108642f7    v5.4.51-45-gd9b8206e5323
>> > d55dad8b1d893fae0c4e778abf2ace048bcbad86     v5.4.52-13-gd55dad8b1d89
>> >
>> > resulting in a non-harmful, but unnecessary double setting of the variable.
>> >
>> > /* set the real number of ports */
>> > dev->ds->num_ports = dev->port_cnt;
>> >
>> > /* set the real number of ports */
>> > dev->ds->num_ports = dev->port_cnt;
>> >
>> > return 0;
>> >
>> > Could you notify the stable maintainers to apply your patch correctly?
>> >
>> > Best regards,
>> > Kristóf Havasi
>> >
>> >
>> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/net/dsa/microchip/ksz8795.c?h=v5.4.63#n1274
>> >
>>
>> Hello,
>>
>> Kristóf discovered that one patch of mine was applied twice. What is the
>> best way to address this?
>
>Send us a revert would be best.

I'll queue up a revert, nothing else is required on your end, thanks for
reporting!

-- 
Thanks,
Sasha
