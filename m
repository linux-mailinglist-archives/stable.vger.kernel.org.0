Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF3365E648
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAEHze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjAEHzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:55:32 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9DD37272;
        Wed,  4 Jan 2023 23:55:30 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N9M5y-1ohQa61a1k-015HyC; Thu, 05 Jan 2023 08:50:18 +0100
Message-ID: <15ba4d43-89a2-2a3e-645e-f5f26c9b77f0@i2se.com>
Date:   Thu, 5 Jan 2023 08:50:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
To:     Matthias Kaehlcke <mka@chromium.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
 <Y7Rh+EkKKN5Gu8sz@google.com> <10807929.5MRjnR8RnV@steina-w>
 <Y7XVgfjLEDtWhMDB@google.com>
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <Y7XVgfjLEDtWhMDB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:BCGKh4j6MGeg3RhokWIDy9xiyUo//X9YveLbbQcC2HQm7xwtQY7
 hZq554g2hjpAZLLk2MCVUn3YKlE9DFSKiGC7tcqWrksZTyrB0bvGK9QXn4OP5bfP8ilbNVL
 LA3OD6ZefzlxI52EhVB5FY6oZ8SoHc1mvdX59BP2IrEL6xwkqZ9cfOdAB5QV/OFD0UV648s
 NIsa9GlzhlokurnK+XEYA==
UI-OutboundReport: notjunk:1;M01:P0:N1+v9LpllM0=;b5Xfp7QmUkzWbsUtEi/9UPXBqEX
 LgH8nbuyE4Ly8Te0+dXUsl+AjiawMD/NMnSbc3NTYSN8riZxWRJb7Yzbn2AUs4gY1et0ll7hk
 YMS12/mGQQP3uOUW/g9OzY8L2ZRxSfyOsQVWmWGTebyS3Z1wlYPuy4khlURBw94epfmX9FjWs
 TJZdPp4v9DAhvjW+dVLIBUQRX8MK2LjxKsBX9vgLIUZ8ZgzaUFCP9kAyTt6Qmnohtg4qgIZo6
 /JG3Z+7pwye6CFSuI+Zo9AGI7+X8wepXcDLQ8CyVuL7oNRr4qLvXkrwRH+wHm62dJXtCX924m
 WrJpd5yrEdEhTVweOJOk6RJwA4iRim3Xgpot5caAto7iay7YsfUx+QpvVT8SLD5lPAejAt0yQ
 LBJIz/71Ru1qjMFjqTJ1F9CQ4Dbb+rNQV8ClhkdiJ7FH/yTFCyUXtYHzWqgav6cDqIRJTiw6z
 d6gV6MOVLhK1yL2W3GsZsskLL3RQQIDV4GEK8nTFHUSXXEdNYuP9XI9wrnmdqtk7O3ohEWZAX
 XVXfiuB5qnDSZuq6wVTvKDMjI70trhckf0DrGp21HxSYzd3Xkfn0dbS0aRaoGjwI25OAjxT8X
 SIaUZldneYVfeKBDmoNI2T9VC8BWi9KeaD8nh0QsNMtNIGGMt+dwmL9b8NQ3GEGv0nf2R41j7
 6nj3+8VFfJWlNdQ2/gKOmcTa6VAkEWw4meTLz6DWeQ==
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthias,

Am 04.01.23 um 20:37 schrieb Matthias Kaehlcke:
> On Wed, Jan 04, 2023 at 10:00:43AM +0100, Alexander Stein wrote:
>> Hi Matthias,
>>
>> Am Dienstag, 3. Januar 2023, 18:12:24 CET schrieb Matthias Kaehlcke:
>>> On Thu, Dec 22, 2022 at 11:26:26AM -0800, Doug Anderson wrote:
>>>> Hi,
>>>>
>>>> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
>> wrote:
>>>>> The primary task of the onboard_usb_hub driver is to control the
>>>>> power of an onboard USB hub. The driver gets the regulator from the
>>>>> device tree property "vdd-supply" of the hub's DT node. Some boards
>>>>> have device tree nodes for USB hubs supported by this driver, but
>>>>> don't specify a "vdd-supply". This is not an error per se, it just
>>>>> means that the onboard hub driver can't be used for these hubs, so
>>>>> don't create platform devices for such nodes.
>>>>>
>>>>> This change doesn't completely fix the reported regression. It
>>>>> should fix it for the RPi 3 B Plus and boards with similar hub
>>>>> configurations (compatible DT nodes without "vdd-supply"), boards
>>>>> that actually use the onboard hub driver could still be impacted
>>>>> by the race conditions discussed in that thread. Not creating the
>>>>> platform devices for nodes without "vdd-supply" is the right
>>>>> thing to do, independently from the race condition, which will
>>>>> be fixed in future patch.
>>>>>
>>>>> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
>>>>> Link:
>>>>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com
>>>>> / Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
>>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>>>> ---
>>>>>
>>>>> Changes in v2:
>>>>> - don't create platform devices when "vdd-supply" is missing,
>>>>>
>>>>>    rather than returning an error from _find_onboard_hub()
>>>>>
>>>>> - check for "vdd-supply" not "vdd" (Johan)
>>>>> - updated subject and commit message
>>>>> - added 'Link' tag (regzbot)
>>>>>
>>>>>   drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
>>>>>   1 file changed, 13 insertions(+)
>>>> I'm a tad bit skeptical.
>>>>
>>>> It somehow feels a bit too much like "inside knowledge" to add this
>>>> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
>>>> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
>>>> keep the absolute minimum amount of stuff in it and all of the details
>>>> be in the other file.
>>>>
>>>> If this was the only issue though, I'd be tempted to let it slide. As
>>>> it is, I'm kinda worried that your patch will break Alexander Stein,
>>>> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
>>>> CCed now). I believe those folks are using the USB hub driver
>>>> primarily to drive a reset GPIO. Looking at the example in the
>>>> bindings for one of them (genesys,gl850g.yaml), I even see that the
>>>> reset-gpio is specified but not a vdd-supply. I think you'll break
>>>> that?
>>> Thanks for pointing that out. My assumption was that the regulator is
>>> needed for the driver to do anything useful, but you are right, the
>>> reset GPIO alone could be used in combination with an always-on regulator
>>> to 'switch the hub on and off'.
>>>
>>>> In general, it feels like it should actually be fine to create the USB
>>>> hub driver even if vdd isn't supplied. Sure, it won't do a lot, but it
>>>> shouldn't actively hurt anything. You'll just be turning off and on
>>>> bogus regulators and burning a few CPU cycles. I guess the problem is
>>>> some race condition that you talk about in the commit message. I'd
>>>> rather see that fixed...
>>> Yes, the race conditions needs to be fixed as well, I didn't have enough
>>> time to write and test a patch before taking a longer break for the
>>> holidays, so I only sent out this (supposed) partial mitigation.
>>>
>>>> That being said, if we want to be more efficient and not burn CPU cycles
>>>> and memory in Stefan Wahren's case, maybe the USB hub driver itself could
>>>> return a canonical error value from its probe when it detects that it has
>>>> no useful job and then "onboard_usb_hub_pdevs" could just silently bail
>>>> out?
>>> _probe() could return an error, however onboard_hub_create_pdevs() can't
>>> rely on that, since the actual onboard_hub driver might not have been
>>> loaded yet when the function is called.
>>>
>>> It would be nice not to instantiate the pdev and onboard_hub USB instances
>>> if the DT node has neither a 'vdd-supply' nor 'reset-gpios'. If we aren't
>>> ok with doing that in onboard_hub_create_pdevs() then at least the 'raw'
>>> platform device would be created. onboard_hub_probe() could still
>>> bail if both properties are absent, _find_onboard_hub() would have to
>>> check it again to avoid the deferred probing 'loop' for the USB instances.
>> I'm not really fond of checking for optional features like 'vdd-supply' and
>> 'reset-gpios'. This issue will pop up again if some new optional feature is
>> added again, e.g. power-domains.
> It's not just any optional feature, it needs to be involved in controlling
> power. I'm not super-exited about it either, but if we prefer not to
> instantiate the drivers for certain DT nodes (TBD if that's a preference), we
> need some sort of sentinel since the compatible string alone doesn't provide
> enough information.
>
>>> Alternatively we could 'just' fix the race condition involving the 'attach
>>> work' and the onboard_hub driver is fully instantiated even on (certain)
>>> boards where it does nothing. It's relatively rare that USB hub nodes are
>>> specified in the DT (unless the intention is to use this driver) and
>>> CONFIG_USB_ONBOARD_HUB needs to be set for the instances to be created,
>>> so maybe creating the useless instances is not such a big deal.
>> IMHO creating a pdev shouldn't harm in any case. It's similar to having a DT
>> node without a corresponding driver enabled or even existing.
> If we only want a 'raw' pdev (no instantiation of the onboard hub platform and
> USB drivers) then a similar logic will be needed in the onboard hub driver(s).
>
> So if we don't want any logic checking that at least one power related property
> is defined then we have to accept that the onboard hub driver will be fully
> instantiated even when it effectively does nothing.
>
> If we add logic to the driver it needs to be checked in both the platform and
> the USB driver (in the latter to avoid a deferred probe loop). It would be
> simpler to just skip the creation of the 'raw' platform device in the first
> place.
>
>> Also adding USB devices to DT is something which is to be expected.
>> usb-device.yaml exists since 2020 and the txt version since 2016.
> Yes it it perfectly legal, so we need to handle this case somehow, and we
> are currently discussing how to best do that :)
>
> I still don't expect the combo of supported hub in the DT +
> CONFIG_USB_ONBOARD_HUB=y/m to become super-popular, which could be an
> argument for the option "just instantiate the drivers even if they do
> nothing". Not my favorite option, but probably not that bad either.

i disagree in this point. The driver becomes more and more popular [1] 
and this breaks arm64 for RPi 3B+ too. So it's only a question of time 
until distributions run into this problem.

I willing to help in debugging the real issue, but i need a little bit 
guidance here.

[1] - 
https://lore.kernel.org/linux-arm-kernel/2188024.ZfL8zNpBrT@steina-w/T/

>
>> Unfortunately I'm not able to reproduce this issue on a different platform
>> where the same HUB but no reset-gpios is required. I also noticed that
>> onboard-usb-hub raises the error
>>> Failed to attach USB driver: -22
>> for each hub it is supposed to support.
> Interesting
>
> I also see the error with v6.2-rc1 but not a downstream v5.15 kernel which
> runs most of the time on my boards. It turns out that with v6.2-rc1 the 'bus'
> field of 'onboard_hub_usbdev_driver.drvwrap.driver' (passed to driver_attach())
> is NULL, which causes driver_attach() / bus_for_each_dev() to return -EINVAL.
>
> I did some testing (unbind/bind, unloading/reloading the driver) around the
> 'attach work' independently from your report. I couldn't repro a situation
> where the onboard_hub USB devices aren't probed by the driver, which is what
> the 'attach work' is supposed to solve. At some point I observed issues with
> that in the past, which is why driver_attach() is called. The driver_attach()
> call was added to the onboard_hub series in early 2021, by that time I was
> probably testing with a v5.4 kernel, it's not unconceivable that the issue I
> saw back then is fixed in newer kernels.
>
> With that I was already considering to remove the 'attach work', the error you
> reported reinforces that, since the driver_attach() call from the onboard_hub
> driver does nothing in more recent kernels due to 'bus' being NULL.
>
> Thanks
>
> Matthias
