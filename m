Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA866540EE
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiLVMVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiLVMVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 07:21:21 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94D0F019;
        Thu, 22 Dec 2022 04:21:19 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.22]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M3DBd-1p9hTs0g1d-003fA7; Thu, 22 Dec 2022 13:21:17 +0100
Message-ID: <97138f56-3915-b7d6-73f6-e8eceaa0ca63@i2se.com>
Date:   Thu, 22 Dec 2022 13:21:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 2/2] usb: misc: onboard_hub: Fail silently when there
 is no platform device
Content-Language: en-US
To:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <20221222022605.v2.2.I0c5ce35d591fa1f405f213c444522585be5601f0@changeid>
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20221222022605.v2.2.I0c5ce35d591fa1f405f213c444522585be5601f0@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:HlE8p13iAhP0Vhk6L3o0fro9+sYEBtmoiRX5ecuA4PT0NVCHQbu
 u8Q2ovmUZpKklSNwiWfE8JN4VKGzTgbQ0VkO/4gbRDIpqIoJDZRCckeBI8Y78Aaj9k+Ef/y
 XUuexUmInUaj+YTthaiM3Xd4kJuDxIg2rrcbfYq2zVDUiftGJ57+zSxVnIx4qny6h0XphfI
 oWJW2FxLUgbAcQuJLWDYg==
UI-OutboundReport: notjunk:1;M01:P0:dETeS9UmyNs=;dBNkXmBiuAy1A8vVOBu8CuESKcm
 iF5wqqkRAHKvS78FdbNx497SiQefjCqKLa5q30L3mHCYBL6WOwpcZfqN+lwF/6IG+BnBfL0Td
 RuJDRTgxhuVshxe7RM6kDJapGjHaEtPoBD2rQ3yQpzML+sVxqmH9TfJTYbr4Jt2lBPDnAN9xJ
 2GRsn6ZshlQTLlLRmj00DV5OIp6GqydQcW2ldp+HRpcroZRIoJrPq1MqFSjoic6GXQQsaZEDM
 l/jY4gMkzvKqyEgKt7C995AclUMMyvfjXcTqhF87t3FcKWKWVfYMsGCn1sPL1rDFrHKEz4vjB
 m9YwEal/soWMiaaWJY21a9Knmn3V8yBUA3gLEp0bBEb9gD0jhCjFsG8yGpjzhik1LmGeZksBR
 hTEH6DPc5nbxzUPFjsOM8pHDJ2Fzwvu8E1vhwmP9Sg84606xkzJNofo5F3DLxque/KEKJuzro
 sOAl0e6u59rY2S/UxKYUnZ8KNUICHJ+miDOjcbssyACYOxjwYq03nzuuJFYUWorccJezln6sO
 kXylwqxTomNPxXDCwUHMYdWrit4mSsnc9HdNciHCFwvq+tA88poV8Pra2vpJLkErKujnn9dkt
 0de7qAiSErL+41dt4h1RQq69nW9L/ZT9qAXjADXGGIO+sOrL+xAW6MPtHexvvVR7UD8NZPV0i
 1z470JyV5+FglKbZHPBtwyuZDQkpiSdSpOBV6fEhvA==
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 22.12.22 um 03:26 schrieb Matthias Kaehlcke:
> Some boards with an onboard USB hub supported by the onboard_hub
> driver have a device tree node for the hub, but the node doesn't
> specify all properties needed by the driver (which is not a DT
> error per se). For such a hub no onboard_hub platform device is
> created. However the USB portion of the onboard hub driver still
> probes and uses _find_onboard_hub() to find the platform device
> that corresponds to the hub. If the DT node of the hub doesn't
> have an associated platform device the function looks for a
> "peer-hub" node (to get the platform device from there), if
> that doesn't exist either it logs an error and returns -EINVAL.
>
> The absence of a platform device is expected in some
> configurations, so drop the error log and fail silently with
> -ENODEV.
>
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>

