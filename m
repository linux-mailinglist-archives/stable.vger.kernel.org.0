Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8DF6C39A2
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 19:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCUS7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 14:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCUS7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 14:59:47 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1657B50FB4;
        Tue, 21 Mar 2023 11:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1679425183; i=rwarsow@gmx.de;
        bh=GSCpxG5OCHgvMzb3RwBoT7hLXDDM/WP1XsNJuPopjaU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=uZyGabHhpoC8BsWlVC6cFJlpgpVH7wNVB/9s6mh0UDzJ3tud0z+ovXIRnh/F/NHZA
         o0kasOF1eQEFs8lVt0OCawLBD6JjrTpINx7d3zrClv5Qa+WBMk2c76GqDNFFxXpCBQ
         7kfc4I75DwLKMUTSH21O+1tNUpnUtZPYwaWNJ7hOtoLGysjj1meszx2Oy0Xrch4GOj
         xyjjyZH8TzW2G/iV5ziRDxQKQxqEu04rdDgYEWJO1LKRMLzU2hMZipvH0bhNa/DYtJ
         zAWDKzGgwiD+dP2buW/PqJQJQtitxFm9efQrWaT3U304GkT0Nqyj4NaZ0wWsa1Ok8z
         sOuW3EZzQqIsw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([94.134.26.109]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mw9UE-1qWNit137E-00s9me; Tue, 21
 Mar 2023 19:59:43 +0100
Message-ID: <6a2f32c4-8bb2-3f26-4731-9575aad8fdc2@gmx.de>
Date:   Tue, 21 Mar 2023 19:59:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:GvPwEls1Lbzno+BYv2/yhiB4y+IxToie8vTOjvwq3ehetpvQi+r
 dql2IcPhoE5QqUoCb87yT8ru6P1FxsR3YM3hLomdhwbTtpTMQMc1WcTabyPBA8sk5KkuG5k
 rSf3nR132RC7cwoECPCQfK9Nh832TMcTUfHfbNrx9Nx08QBYahvBziwRPvGZYjZyYJrwCCz
 /oIHROgYEzvnWirnULAog==
UI-OutboundReport: notjunk:1;M01:P0:I8aV4dh/Wrk=;f9AcUeamFJKXhD/D0osbGVriKIP
 ltlblEy5JXKr9Mejb/Tk8h/j/VGPsiEsH7Bxwdj64eAXqEUtQwsj0ZSZQEpsal71rM799ywcz
 bIDEpfNL8vr1sWp/TZByfBLGtMBo6s9WnimVzvJ8iCuI0FmX24muwfJt7rGa245PlhMkVg+vo
 CQGZRoiYsLYlFx/tFXHe67ipCRMO/OpqObbhcHyvFGQ0024bLb84ObjAoTTPS9BH9SumIUQUj
 QkXvKotPnwy2Msm6yn7Y40sTcdXFpJCjxmS+YMgSqZYaVgj8EbCJ8T9/PaaTqG8Bqw2MZ2LnY
 0r9koHGuG28AOG/CIACyodbkwBHIvPeXblshVfEtGPeL6dQTfcVspUJxw+51206CyhkGSveTN
 AlMCNUCxn8GhojBf+lkL0t4SD6+eUeWI6QMpEdBskV3rpxsEFu8hq2mq/6nd9Nf+gculqMfg3
 i2xS6l2G9mqut1ad/zyREuE6jceVkkMbIZSn5xMZauO2uch9uUK5Ad85QImZFBd/aLGOEA/Uw
 Y3kWsEcD6ZNcxh6+l1RCLPdANDjEsUXvBNEfdNYIEJlgiqiDLnhOznLfgT2/gi3Q6ElrD86h9
 PTwgjdnFKIlh/biRu7Uv1fDDXd9rqI2f+S4GXmI7yCUqKoqlpKNRVOewGncMpgqpA5cYvi9+I
 iONX/ovXxxC3Cf+P/6DXNQVkoxDLZs04HuFCh6rLtEJ7fx48RMxrmdy9Egc+RquLnCZZPWQrG
 y7TRyNfNJ2Hh9hgCAYv23tDbQb+gSnh6sCcTiEwBfz3yPOm3m5aod6I4+KGbDjcI4KLgtKYsA
 1PnULlzJa7ADlvt3XoneAhi99SLfjG9i1PXpj12M+F61ODhgDGIzPxrPZ37pk8TELKROB0rll
 s4hnv6Gg43t9fUp28v7jjxLVpiDZg2EPBeabk+rte4totRGO4UvAYWwVnkpPimG26wqiJ6v67
 f5c+Kg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.8-rc3

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 38 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

