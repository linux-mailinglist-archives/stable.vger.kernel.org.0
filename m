Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDAB65B17B
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjABLtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjABLts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:49:48 -0500
X-Greylist: delayed 306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 Jan 2023 03:49:46 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FC010AA;
        Mon,  2 Jan 2023 03:49:45 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N9dg5-1oijbD07Bl-015aNV; Mon, 02 Jan 2023 12:44:34 +0100
Message-ID: <fdfe4b3c-1e7c-b9d5-6173-ce2c0e8dd52b@i2se.com>
Date:   Mon, 2 Jan 2023 12:44:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
To:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
 <aa9fdfc04c3b6a3bba688bac244a157242faab82.camel@icenowy.me>
 <3724284.kQq0lBPeGt@steina-w>
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <3724284.kQq0lBPeGt@steina-w>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8H+d7hWesExJl4kSwA6nWmwGDR2OGL48FFwKuGrTC9dYxMS7eA+
 0MIf8ChqjS40OU28w9dpUwHTjN4MaX04QHiCLC1uv41EdlZs/90KEb9XdfwMN9PQONT92tc
 dnZXthXgVruaA9EYuQlVCatMkCI+MdSz2uleZAIXSiRoEXl2rxiBv9oSQkXC3aTMW/0vUHn
 /OrxlEYUzYrYd2ajBsqNA==
UI-OutboundReport: notjunk:1;M01:P0:tYGoUjyvkw0=;f2l2XlgSgtAduqMOWaKN9HvdtXM
 AhQt8sS4YPTFpa5YCkp//cMSKWHQb11Xw073mmPeOTwDsElXMVssdoWeyXq9GG64GMEn7Eyyt
 St13qc/kWToWP4sHpOpaA0m/pb3emfkbv6pVfze/acHmPxYsmBDiLDl/jcyXZHhSOjYNpq2Tk
 Qdj1QtQas4gYML9TtGp3OmT4VKpDBs/cklrRAHW5ekpXUER6GUniB0iNZ2zjEOw4mk/KyE4P0
 M+UIwvSuuqjo4JBz+CVgYlCa2w+B7dZtIKtYkZOS5Ah8V+snoJMVVLuXNEuX6QNe2BaQjSpwj
 vVfybHq/YP2kc2OWj28r8kmsN8hKF1RaLIvC76ZUNijt2HEVO5h0GWo1gJZxY07jcyLZo+8Hh
 wtqyW2tGNBSTRA2t6teLhOvSIgjGMwCBt7xZASWPQJw48+/MJxElyNG9lvXkwHEb9iUWNYXf5
 IRbaEX+zP9N/+TqDCwIj9jpBIYcvZcSHbVkDsw7C0aR3Mvnc++1A4Ur+JJzdfGV96tziWuW3P
 rJoSj+V45HkbhYLpi29VzGj23Vyn5HSJfAWaLg8Trdjzp6GostEzARnv/Ar1Wx+M7M9iDAeIl
 pqR19xEH5/XXJyzk/ReUiOLs0Sv5Tbb08otxF3L0nVKbldtoIoIs4jMtHhkuz7CmsxDqcEOlv
 toeJsTOowifGGZCXj2eWbF0FYG787OVv6QIEBn8EiA==
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Alexander,

Am 02.01.23 um 10:20 schrieb Alexander Stein:
> Hi everybody,
>
> Am Freitag, 23. Dezember 2022, 08:46:45 CET schrieb Icenowy Zheng:
>> 在 2022-12-22星期四的 11:26 -0800，Doug Anderson写道：
>>
>>> Hi,
>>>
>>> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
>>>
>>> wrote:
>>>> The primary task of the onboard_usb_hub driver is to control the
>>>> power of an onboard USB hub. The driver gets the regulator from the
>>>> device tree property "vdd-supply" of the hub's DT node. Some boards
>>>> have device tree nodes for USB hubs supported by this driver, but
>>>> don't specify a "vdd-supply". This is not an error per se, it just
>>>> means that the onboard hub driver can't be used for these hubs, so
>>>> don't create platform devices for such nodes.
>>>>
>>>> This change doesn't completely fix the reported regression. It
>>>> should fix it for the RPi 3 B Plus and boards with similar hub
>>>> configurations (compatible DT nodes without "vdd-supply"), boards
>>>> that actually use the onboard hub driver could still be impacted
>>>> by the race conditions discussed in that thread. Not creating the
>>>> platform devices for nodes without "vdd-supply" is the right
>>>> thing to do, independently from the race condition, which will
>>>> be fixed in future patch.
>>>>
>>>> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
>>>> Link:
>>>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
>>>> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>>> ---
>>>>
>>>> Changes in v2:
>>>> - don't create platform devices when "vdd-supply" is missing,
>>>>    rather than returning an error from _find_onboard_hub()
>>>> - check for "vdd-supply" not "vdd" (Johan)
>>>> - updated subject and commit message
>>>> - added 'Link' tag (regzbot)
>>>>
>>>>   drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
>>>>   1 file changed, 13 insertions(+)
>>> I'm a tad bit skeptical.
>>>
>>> It somehow feels a bit too much like "inside knowledge" to add this
>>> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
>>> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
>>> keep the absolute minimum amount of stuff in it and all of the
>>> details
>>> be in the other file.
>>>
>>> If this was the only issue though, I'd be tempted to let it slide. As
>>> it is, I'm kinda worried that your patch will break Alexander Stein,
>>> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
>>> CCed now). I believe those folks are using the USB hub driver
>>> primarily to drive a reset GPIO. Looking at the example in the
>>> bindings for one of them (genesys,gl850g.yaml), I even see that the
>>> reset-gpio is specified but not a vdd-supply. I think you'll break
>>> that?
>> Well technically in my final DT a regulator is included (to have the
>> Vbus enabled when enabling the hub), however I am still against this
>> patch, because the driver should work w/o vdd-supply (or w/o reset-
>> gpios), and changing this behavior is a DT binding stability breakage.
> I second that. The bindings don't require neither vdd-supply nor reset-gpios.
>
> But I have to admit I lack to understand the purpose of this series in the
> first place. What is the benefit or fix?

did you followed the provided link from the patch?

Best regards

>
> Best regards,
> Alexader
>
>> In addition the kernel never fails because of a lacking regulator
>> unless explicitly forbid dummy regulators.
>>
>> BTW USB is a discoverable bus, and if a hub do not need special
>> handlement, it just does not need to appear in the DT, thus no onboard
>> hub DT node.
>>
>>> In general, it feels like it should actually be fine to create the
>>> USB
>>> hub driver even if vdd isn't supplied. Sure, it won't do a lot, but
>>> it
>>> shouldn't actively hurt anything. You'll just be turning off and on
>>> bogus regulators and burning a few CPU cycles. I guess the problem is
>>> some race condition that you talk about in the commit message. I'd
>>> rather see that fixed... That being said, if we want to be more
>>> efficient and not burn CPU cycles and memory in Stefan Wahren's case,
>>> maybe the USB hub driver itself could return a canonical error value
>>> from its probe when it detects that it has no useful job and then
>>> "onboard_usb_hub_pdevs" could just silently bail out?
>> I agree.
>
>
>
