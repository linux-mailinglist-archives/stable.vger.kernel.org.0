Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF71966E854
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 22:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAQVW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 16:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjAQVV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 16:21:27 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF8439CD0;
        Tue, 17 Jan 2023 11:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673984487; bh=g40rn34VJ/GTiCq7qnudEZfc73s1/o92ogHmG8ecxE4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=LR5SclvKtk9WKQWMdM9CY98p+KjnroX1qIjMxtPFmYVh5uMztkn1dNGWo6JmQ1O++
         e6w/dnU8vUm9L/vBmekkbJOahY8l7Dz5e49EhXuMJmoXuKQY20pbnvxZht7pErDeFv
         JnUoOxn4AC5UgRCVYeA3pUWFIiFtwvw4scI3cyztthuE2rELMz3RwrAULnQE10ZNVC
         hGe5VmVV38GcSUNyAWme/D+T6syhOGHaln+8DlBvvC6skzNiDViF+8luzBcq3o0T8g
         nlFtyyDsJF55TLNS5AdUIOh+QsXVdq2lx5qnYRWCldexUabbOfkQdJ8Qk6gqQb+201
         Ktik6DjmB2SxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.85]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MmULr-1orZQN40qf-00iQDT; Tue, 17
 Jan 2023 20:41:27 +0100
Message-ID: <bfe5ff9f-4f85-d4a2-c60a-9f0532847af5@gmx.de>
Date:   Tue, 17 Jan 2023 20:41:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lk0j7YYDvoFe3DHH4AeHLYbxiC7IkGp8XXpLxTPPcaxLnFdhyEq
 JjVdp2z63XLEueFE80dfhF+R8SBMvzaYjYoLZ5fvLGrrknnMRlQ0fVl1NiZmv6/F1kQxoyo
 xYx1TEl2/aEZ69TMEkVhJCMrKiYY54/1XFCJRsubsJ1JqILxc14peZ5eVoiydE41bPP/Q1d
 ZFyPU1RrNDkR/MBltQrPA==
UI-OutboundReport: notjunk:1;M01:P0:c3p95Dng61k=;wlfWvXcQOaCWy4Cfjc+HCgSzfT6
 KMVCRvuNs01cN9OATgmyjyYioRbjaLrCy8ZW9JnePgMuM4iT5eCaNf4JhdhAoGSCYZ2DahI1i
 2T7LonYGxkAGCOkoCFbdRPz7Z7kTj8J+IFqZCYHuzuQei9jn4BFomh7AHeyBeSwDeeigraTzD
 zM9XTyVa42Khqtp2F2evBJYOgg/mbwFM6M4i9/gpmQQ5VNSD9Fbu1Ra6MxPniIg0tDtKTlikF
 2TEh+V/hpUPb43Gso703OkEcomx9Yx8w7ojKEsCCaHhLlUH6LwVJgS5cdHkG+sCk1ElGZy4t/
 kRFeqGHvAplPWSopeSIdfOZRnJL5QekHFHDpObso2a8V+zbqhnx4aq+3smUtk0rbHiB2XD0gq
 tV+EzCWk3JvwEe0sDRTzRx8uJpEJXP8GHpCr+OgwmJWKyJV6yUClQQ1KzRMqQQ3h5W6yWedbp
 TOHvgBZ+OJklzTvWuyJBQ/nM17VuO4yevQDPXwSv4xzWWxYTNXlqfY43gc/JEbzcfasMb98mu
 SVZ2HkEjouwt22yXy2OfCDpypspdR7HCWBfH+BNm2K9WeUV53r2BmVI4YeZeW5dcw81sLaxVQ
 DssoOCS/zn9laNobEygQ+sysNPC8z6+CtAG3BX5FP9Anx8qctgYP359w4qxviDJESvZDAQRk9
 1fEl/DaP7OxZn62odwEEuUAOM9BTVTzcoNViFkWctLZoItSUDfojd/T+T1VSyRPI6VTE9+GV7
 uxs7OIOzzCEpOmJwd5E9jTCdl9UXwh5hJtISbz4KDmExnj9JF3JdCZeQ90iwDxnmK07y081yX
 hzm0zpK7o5AHR/e4XBAUxaObKIWqeQ236g1MkcIPQDGVt1MauWfO5DFBprvl+LoN9BF5umvlq
 rLilMu9eNhuUDO0bb50jTO0/Cxr0znr3ELizd3k8OOdQvGaYgbj7ZcC3p4y5jfXouOERNI8Pg
 cRIZH3fSpLGMFS4VLZBiDFYJzRw=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.7-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

