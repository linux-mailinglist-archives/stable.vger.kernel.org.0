Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A136F661069
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjAGRXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 12:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGRXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 12:23:32 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A9D4BD7A;
        Sat,  7 Jan 2023 09:23:31 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M5wgF-1p7tG73pxT-007SSJ; Sat, 07 Jan 2023 18:23:12 +0100
Message-ID: <d606398d-8569-5695-5fd7-038977c83eb4@i2se.com>
Date:   Sat, 7 Jan 2023 18:23:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] usb: misc: onboard_hub: Move 'attach' work to the
 driver
Content-Language: en-US
To:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
 <20230105230119.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20230105230119.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9k4z94OJ4aeGNpmmKJukA+X6dACJBSUpe+xiHwmIKPnn1vDwQHX
 avkaV4ZKVuz+yIEEJo2oaWjZHowER5VkWlC+DgRpwsDDeoP2ojQu6/M2+2SnEyjk41eF6st
 BBmCVOjJMKsSQP2aATyiS5Gu369T55ZmYkaJSoJlLjluW7qM3BW5ZjFeriQvl28qxwKQdqa
 2/uuiwWY3wU7JG5FDGZow==
UI-OutboundReport: notjunk:1;M01:P0:QAVfzearRYM=;rrdYSFGcF+8+bs+DKW7lbU4La9b
 sK+cISQBxyLljpR1ss4EPuvRrr0/iLRCh0YADBjG7N0LSXCKN2YBUG905A9pbVtTydBK6GpQb
 IWFYzJRajt9tOA70B36qKhVSdpzr08SjSGB6zrUqPWgXkIZmgP0EXwSSVnDggptTXDwrIOwCD
 ZD5c97tNOeRMtnzq9QXxE0q71Y/exUfQRz80zoGlECnwoPdyUxlB2sl6CI12Whu2bOYNNCs9A
 nM7igJay8hkyI5Q3InFEEKHeBmqqa9bL9mKum+v7pl5eMtLNQ9L3Ek1dLK6f8orf8ZQER95GQ
 xhF5Xgy2izDsmi1JAhhAiCAbittvb0zjPmUACJy2aCZqf+Je43XFwl8YLOgycEvYYz7QjYEht
 8kNqemj0uSRwfY8rhdKUWdrv0WrlcG9zbfyySfser51jfhnqUrfWJ4AE9u9yDpX8rp4AGdcVw
 JT783eNXROFZYyfHvU9dSN2i1ZVfTVy/snoWqkH13su9qjKj1sOLVPrh7JpcBt0yhgKsTEbEq
 wsdN16n0JxqKSYJSsrnjLUhY3wh7KNRNLjilwWWOP8WUR2enoPmcwkGAc1IvdjgnHh4boG6oU
 asdAsDEBXpJm36N0nOeTMHXcxkGyePHkijve79mUSdATYp1epVzyMfDaNh2UvLMzFeA4VI9vu
 rsE/hevrFHsyyCtWvI3UW2mPQko/mY6k80KJGxFzpg==
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthias,

Am 06.01.23 um 00:03 schrieb Matthias Kaehlcke:
> Currently each onboard_hub platform device owns an 'attach' work,
> which is scheduled when the device probes. With this deadlocks
> have been reported on a Raspberry Pi 3 B+ [1], which has nested
> onboard hubs.
>
> The flow of the deadlock is something like this (with the onboard_hub
> driver built as a module) [2]:
>
> - USB root hub is instantiated
> - core hub driver calls onboard_hub_create_pdevs(), which creates the
>    'raw' platform device for the 1st level hub
> - 1st level hub is probed by the core hub driver
> - core hub driver calls onboard_hub_create_pdevs(), which creates
>    the 'raw' platform device for the 2nd level hub
>
> - onboard_hub platform driver is registered
> - platform device for 1st level hub is probed
>    - schedules 'attach' work
> - platform device for 2nd level hub is probed
>    - schedules 'attach' work
>
> - onboard_hub USB driver is registered
> - device (and parent) lock of hub is held while the device is
>    re-probed with the onboard_hub driver
>
> - 'attach' work (running in another thread) calls driver_attach(), which
>     blocks on one of the hub device locks
>
> - onboard_hub_destroy_pdevs() is called by the core hub driver when one
>    of the hubs is detached
> - destroying the pdevs invokes onboard_hub_remove(), which waits for the
>    'attach' work to complete
>    - waits forever, since the 'attach' work can't acquire the device lock
>
> Use a single work struct for the driver instead of having a work struct
> per onboard hub platform driver instance. With that it isn't necessary
> to cancel the work in onboard_hub_remove(), which fixes the deadlock.
> The work is only cancelled when the driver is unloaded.

i applied both patches for this series on top of v6.1 
(multi_v7_defconfig), but usb is still broken on Raspberry Pi 3 B+

Best regards

>
> [1] https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> [2] https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
>
> Cc: stable@vger.kernel.org
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> Link: https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
>   drivers/usb/misc/onboard_usb_hub.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
> index db0844b30bbd..8bc4deb465f0 100644
> --- a/drivers/usb/misc/onboard_usb_hub.c
> +++ b/drivers/usb/misc/onboard_usb_hub.c
> @@ -27,7 +27,10 @@
>   
>   #include "onboard_usb_hub.h"
>   
> +static void onboard_hub_attach_usb_driver(struct work_struct *work);
> +
>   static struct usb_device_driver onboard_hub_usbdev_driver;
> +static DECLARE_WORK(attach_usb_driver_work, onboard_hub_attach_usb_driver);
>   
>   /************************** Platform driver **************************/
>   
> @@ -45,7 +48,6 @@ struct onboard_hub {
>   	bool is_powered_on;
>   	bool going_away;
>   	struct list_head udev_list;
> -	struct work_struct attach_usb_driver_work;
>   	struct mutex lock;
>   };
>   
> @@ -270,9 +272,15 @@ static int onboard_hub_probe(struct platform_device *pdev)
>   	 *
>   	 * This needs to be done deferred to avoid self-deadlocks on systems
>   	 * with nested onboard hubs.
> +	 *
> +	 * If the work is already running wait for it to complete, then
> +	 * schedule it again to ensure that the USB devices of this onboard
> +	 * hub instance are bound to the USB driver.
>   	 */
> -	INIT_WORK(&hub->attach_usb_driver_work, onboard_hub_attach_usb_driver);
> -	schedule_work(&hub->attach_usb_driver_work);
> +	while (work_busy(&attach_usb_driver_work) & WORK_BUSY_RUNNING)
> +		msleep(10);
> +
> +	schedule_work(&attach_usb_driver_work);
>   
>   	return 0;
>   }
> @@ -285,9 +293,6 @@ static int onboard_hub_remove(struct platform_device *pdev)
>   
>   	hub->going_away = true;
>   
> -	if (&hub->attach_usb_driver_work != current_work())
> -		cancel_work_sync(&hub->attach_usb_driver_work);
> -
>   	mutex_lock(&hub->lock);
>   
>   	/* unbind the USB devices to avoid dangling references to this device */
> @@ -449,6 +454,8 @@ static void __exit onboard_hub_exit(void)
>   {
>   	usb_deregister_device_driver(&onboard_hub_usbdev_driver);
>   	platform_driver_unregister(&onboard_hub_driver);
> +
> +	cancel_work_sync(&attach_usb_driver_work);
>   }
>   module_exit(onboard_hub_exit);
>   
