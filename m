Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0812966618C
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 18:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjAKRQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 12:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjAKRQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 12:16:31 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040B0F4B;
        Wed, 11 Jan 2023 09:15:55 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mv2gw-1oxqlZ0vaa-00qz8j; Wed, 11 Jan 2023 18:15:41 +0100
Message-ID: <9c242f84-367e-d857-24a6-8336d652257c@i2se.com>
Date:   Wed, 11 Jan 2023 18:15:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_hub: Invert driver registration
 order
To:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Icenowy Zheng <uwu@icenowy.me>, stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20230110172954.v2.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20230110172954.v2.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:mlSvIIHDHoTWUrYZbV13DXLwgb5LmiMbUGrfSyk6xy9dIvfjHs4
 SBkT6X1/UoAV0k2FJ+W1qxmXvyuMggPTpiWfIPLzMw2BPC4RX84zrIlxzz/WgUpwrSJi1+1
 xC12eF77e4cU2xbmro9AGAoHMCxPs/7xyfLfy3FJfkt76kSwfWifwmnLkylg/nEFTrpbP5D
 sccMSLqGhUlBxEeZ3ESow==
UI-OutboundReport: notjunk:1;M01:P0:uBJw4yKVRVA=;ULD0lhkJDedWrQ4W1B5hTSUxABw
 T18a30pAbHMyMZR7XqwxqUJ4SNOYnmYtyEaO/2FrJAw2TKOpcRvROQz8Rg8JjwrTjwCilt6Ta
 iTf4fbv6LVCn5VDBmvc0Fc2e3oJDQo8ugWsOX9HTCDqKCoFDWM3J+jdXkrP5XXIIJvfMR0MrK
 8QSx/OfBqFPIK1vasnzFVZTWlzn4anGWVYH9V18A79JJPOVh+lh2M2VAwo7ztspF7VttBXUGx
 4+VL11D0lpiAf6/gCsNJLbvB1wja17F0aYAkRqe2veRASRQAccK8tam8D/0TeWqlig7u5Sxuz
 fzpCvWVlngCRmgFXotWyLvyUpdxqmbEhJpKm/xwoEVB6OBSC48ZRkSsUvZORo3kkYxl4gk5D+
 jbygHUWhE+uOJsgBAAebwFClZy7eTBf8ynTNaLrH2a8vlhnFfhCIis+pagOviNPfTMc6yK33j
 OxhjVcAacKI0wSiTFhuRVZHBCOFA/PEPu3taiLRzye3a4wjeEkaDuE+d1TU82nbo/yyeSTerX
 xN3vP1kLIgOy+4HRf28BuUlSHZngksudk2+4EhGT+He2byk+A7RigpbGqVXjF2eDDRKrXNfMh
 ZAap2AHn0NoeIOWnw4Qs0/aYgJW99hUChPM7ntuFg+DrW0uAN55zYqFiuwDBPahSEVslU9wyi
 DluFk5GmaaGXN9UwqNYa/S4UeIM1DTwiTDvUbcUngw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthias,

Am 10.01.23 um 18:32 schrieb Matthias Kaehlcke:
> The onboard_hub 'driver' consists of two drivers, a platform
> driver and a USB driver. Currently when the onboard hub driver
> is initialized it first registers the platform driver, then the
> USB driver. This results in a race condition when the 'attach'
> work is executed, which is scheduled when the platform device
> is probed. The purpose of fhe 'attach' work is to bind elegible
> USB hub devices to the onboard_hub USB driver. This fails if
> the work runs before the USB driver has been registered.
>
> Register the USB driver first, then the platform driver. This
> increases the chances that the onboard_hub USB devices are probed
> before their corresponding platform device, which the USB driver
> tries to locate in _probe(). The driver already handles this
> situation and defers probing if the onboard hub platform device
> doesn't exist yet.
>
> Cc: stable@vger.kernel.org
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/lkml/Y6W00vQm3jfLflUJ@hovoldconsulting.com/T/#m0d64295f017942fd988f7c53425db302d61952b4
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

the whole series is:

Tested-by: Stefan Wahren <stefan.wahren@i2se.com>

Thanks \o/

