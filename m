Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334DD6C3BB5
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 21:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCUUYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 16:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjCUUYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 16:24:05 -0400
Received: from mout.web.de (mout.web.de [217.72.192.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A564742F;
        Tue, 21 Mar 2023 13:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
        t=1679430144; i=dahms.tobias@web.de;
        bh=3vrnUaZQjktarTyyAWmtSbWvpA3xyzQS8LOv5gymyyM=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=eso4Q+iXBnUEfC1ghMuLfphO4olJjHoKZZTdX4bjwKgcvbSCKaMdzCaYMrrpvCZzP
         jP5EA0CqrbSL7mj5zW0cMs1MYrl7VXByXSgaGySefRhsi3ZzzpJ3bliEkSr5isHETp
         d4xiJ7mwmNHNQBaOGT/WF21lB+82FKNchTbWRZktWKdaZxMuRZ8Q4UvHtmlqV6BRu2
         +eN9RFFcy7mEapj5WmQOYkpl3kmLn1Qfcz9Etl0Qs0px75lC8DRU8Kiie83o1wKW3v
         e0AZIJcaVp0zb+aP1WLQs3SUVxa8gq8SPOdaxn/4ma5oHnEDBSjMV8vJ5swjJ6Eqaz
         xX4kOS7buGzPA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.2.2] ([92.206.138.58]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgibW-1q8Y4y23J6-00h2bQ; Tue, 21
 Mar 2023 21:22:24 +0100
Message-ID: <f8f7d7ae-7e4b-e0fb-6a21-1d4fdcc22035@web.de>
Date:   Tue, 21 Mar 2023 21:22:23 +0100
MIME-Version: 1.0
Subject: Re: kernel error at led trigger "phy0tpt"
Content-Language: de-DE
To:     "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Cc:     linux-wireless@vger.kernel.org, linux-leds@vger.kernel.org
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
 <be785bbb-d77d-9930-56d0-dcef26f07bb2@leemhuis.info>
From:   Tobias Dahms <dahms.tobias@web.de>
In-Reply-To: <be785bbb-d77d-9930-56d0-dcef26f07bb2@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uHQnkX0fYIYlHoABAFNTANHLkC3kvk98ARgpoB0OZ0avajHCvlG
 BJird9BaItFEqkVoLuUpMAKtu1xKLR8ie5pN/iECs7wAIQpK0Eu13GWGgqtMNpCn46At2EQ
 Nr30f1wbNf41laurSwZmIo+CxRtlovme6KLNHUwxdT9LRoSS8Lve1+RpeM9Ouki0TiVPx/x
 g4kEqKBOe1vO8lZt8Y4vA==
UI-OutboundReport: notjunk:1;M01:P0:ztJnEZGelIg=;3q/vPhXE6vuP4fqPiimMQf3PhBU
 tfrInOcvw5b2yuNyHUoNWC3+t9mdSfYrQheu3IYnu5eu++8HNeAvA6aVJpR+iHY45qUEtkhyW
 0ZBF95DHnFBEYH2mUj8CF+8nhCs55pZ1xBK8tWEkL9YaMxlWrSpBptO/1lqB8NT4foHBA01rS
 MIYH0iKRS0B6g+nU1vZKW823dxbFlqJB12+0yPD0F3HMllhqHV6KkUm286FhdRDJG0Js3c9UF
 icnPtg6IiDhMnUNH1Tbckp2XF9jS8vE8uiZNn3ScEOLOyEKn0jwN4LMG2ht4Aal2N9rldem9/
 q0Zay1FtAkNkI85u60MzoihFJDFllCjEDbFtbMW4/TKrhvcbiNogph2iz7wkidwG8Fure+K+z
 HoaqtLao9IkMKJF+4kSI76R60yNBxCKwKwA3E5+FPrscKHznI4l9mRxBzPX1j4MtWLBMG6Jl4
 LzFp7mx0hRCdJ70CkiEoKMb3SpQUuyZ3tP1M0/0kNDqV61u32wbQQBJG8siOMd0N9nfeWoZ/P
 gfnyMWES5hUK+8xBDveXy3qOT2hhxz+rbruk8Zvx8cW8NL08uSJ4l47OcoI5Yd6MeQxn54fnf
 coYxAQdo4oZDCdhDyTdzN1LXfzTzEuosJv9NzgzWMcYii1ZVH4B8Icc8VEw11V7T108SY4Oxu
 1pnMcq0Afe/Rs63DHEWiXOND/HcjRu8IBIUD4KKoQEZ4NZrMirIKyjx6MEH7zvWMsXtrpdygk
 jwxlFj9r8+ZbYX5db+KLNH/Sv39GCnOJcxN3OJJV7opVyQ3RmTA+y0JuU/2/YcaX6oIqVVEXU
 BTJEBGeGFpiddRDLFkQvYrMOa5W22kzqjbkgdV9FIdW5MrD2wawoiQcHy7/b1Fk8z8AvGK+eI
 FxRKmzGGOKJ+9nYejwsLVVv+07VJ4ym+2Ud2BB7CmB5RStxGlGuufWyBZnwvhFCt0zvwYPuSM
 e5Zw4xtn23j7Aumk+U4V6IlNWD8=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

all mentioned kernels are vanilla kernels. The "-bpi-r2" is only a
suffix from CONFIG_LOCALVERSION=3D"-bpi-r2"

I will bisect on weekend and come back to you.

regards
Tobias

Am 21.03.23 um 15:40 schrieb Linux regression tracking (Thorsten Leemhuis)=
:
> On 20.03.23 20:44, Tobias Dahms wrote:
>> Hello,
>>
>> since some kernel versions I get a kernel errror while setting led
>> trigger to phy0tpt.
>>
>> command to reproduce:
>> echo phy0tpt > /sys/class/leds/bpi-r2\:isink\:blue/trigger
>>
>> same trigger, other led location =3D> no error:
>> echo phy0tpt > /sys/class/leds/bpi-r2\:pio\:blue/trigger
>>
>> other trigger, same led location =3D> no error:
>> echo phy0tx > /sys/class/leds/bpi-r2\:isink\:blue/trigger
>>
>> last good kernel:
>> bpi-r2 5.19.17-bpi-r2
>>
>> error at kernel versions:
>> bpi-r2 6.0.19-bpi-r2
>> up to
>> bpi-r2 6.3.0-rc1-bpi-r2+
>
> Thx for the report.
>
> "5.19.17-bpi-r2" sounds like a vendor kernel. Is that one that is
> vanilla or at least close to vanilla? If not, you'll have to report this
> to your kernel vendor. If not: could you try to bisect this?
>
>> wireless lan card:
>> 01:00.0 Network controller: MEDIATEK Corp. MT7612E 802.11acbgn PCI
>> Express Wireless Network Adapter
>>
>> distribution:
>> Arch-Linux-ARM (with vanilla kernel instead of original distribution
>> kernel)
>>
>> board:
>> BananaPi-R2
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
