Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43946540E9
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiLVMUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLVMT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 07:19:58 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544231B3;
        Thu, 22 Dec 2022 04:19:57 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.22]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mum2d-1orce921Fj-00rsH0; Thu, 22 Dec 2022 13:19:54 +0100
Message-ID: <9f42f88f-26bc-1e82-03a0-659c85c40469@i2se.com>
Date:   Thu, 22 Dec 2022 13:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Content-Language: en-US
To:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:GqNMuyBQCZ0LHXhH96VILOKU4zFxWwFRmRhh4iYvQgG1kZZqqhL
 xm5blAxl+QrRkG6sabWPQxFUG1PKZMdmAUB84bFQRDJwL6H8BQlfbLGwx1e8ld/oVXffyXD
 L6wm40trIN7vJP4SOQavZAIYun67+aS3xbynQTX43mFzDldsam98zRMgn/OnKvvriRRvdQ/
 h4AYSEBLrE9Q6qz82JdjA==
UI-OutboundReport: notjunk:1;M01:P0:/0Ieui5bFNQ=;GW4uyW33rPm00y8BpfIZbU4GvL2
 3pOtyC0bjdE/fXItCvqq5GMnhxZLMAfpYDeg0FtAjo8/5SV+25/UJ+4By9KBFEx9hon0dzBYD
 NBL+H5bAmCxklr7U2QruKYHZPui+gyL4zfIVNxxsrm5VT2gHimfwyGgFZsXHFtxjupGRLlRr/
 dSe10U8SJEwajfX4W4Zt/A5dk2UCl5whDthB0RQa8Avtx508DA9k5c4EQeruQIxnt5a7DqB/2
 B9+u1cQcRm+t/Yk41TSMIvAPJZ9E/0GjzVRDn/boNXz6tTl63ANbl+x4gFprvr9FtJPk7N4Lm
 4RUUTigc01o340NoLo9SJ6c0yTWVCqB4kzA3hkLNqLKM2cTVr5wGag2MUWcPAK0rlX5jI4t/s
 BNa99EH4Ry//plWdbhYz5q8qEkr3Fd1ayp575jUYaoOx3XinFxSHTKGhhVpS45lnq6CNoFmsU
 eImYD/0j2TUajv7YdIqiVJ8LwgFRZCvgqAGihiyV9MiVuJfhwkESe9kr1mYBzuDtherFt/bdI
 NJIOwlCxtDZrtxWeR90+P6HtY6CDfxfDTIHZrqeBDlXELtX3mVSmf2966d+nxltAyMDb40rYE
 7xJ9S7FxDPYzAixCzzc0uFgzG3sitoizU82lHgtkohS1K0qZ81P7yx2t9r3RhsgV18MNw/y9a
 dSngartd9yFTNBPDi/wNSxe/LmCVRkGE0myEJsvEAg==
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 22.12.22 um 03:26 schrieb Matthias Kaehlcke:
> The primary task of the onboard_usb_hub driver is to control the
> power of an onboard USB hub. The driver gets the regulator from the
> device tree property "vdd-supply" of the hub's DT node. Some boards
> have device tree nodes for USB hubs supported by this driver, but
> don't specify a "vdd-supply". This is not an error per se, it just
> means that the onboard hub driver can't be used for these hubs, so
> don't create platform devices for such nodes.
>
> This change doesn't completely fix the reported regression. It
> should fix it for the RPi 3 B Plus and boards with similar hub
> configurations (compatible DT nodes without "vdd-supply"), boards
> that actually use the onboard hub driver could still be impacted
> by the race conditions discussed in that thread. Not creating the
> platform devices for nodes without "vdd-supply" is the right
> thing to do, independently from the race condition, which will
> be fixed in future patch.
>
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
