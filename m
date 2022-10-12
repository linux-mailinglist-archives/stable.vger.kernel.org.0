Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F985FCEC2
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJLXMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 19:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJLXM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 19:12:29 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38AA125733;
        Wed, 12 Oct 2022 16:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665616336;
        bh=sifrAf5cUTittzOP73JKNs4SgXwLTDYTy7aQJdjlO7k=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=U2R2jE0Wu1sPBYYjAiuxnaBR8cRA6HDpbjB5QJo/yLZTVQA+guSBa1xVJyf5AqosT
         BQp9vzTe5y7yRcTet/GW6Iv1jP1O9MNN+hfG2IR5AWwl3oRe2CYytVzx9kSS+Ia4xa
         u1LJrHasV7pz4cLjPcF8JWku2e6wTGaxDsmLiP00=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MiJZO-1pKrbV3Lt8-00fQxe; Thu, 13
 Oct 2022 01:12:16 +0200
Message-ID: <7cf55e21-4d68-8371-a4a5-08cd8278bcf9@gmx.com>
Date:   Thu, 13 Oct 2022 07:12:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH AUTOSEL 6.0 38/46] btrfs: introduce
 BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
To:     dsterba@suse.cz, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-38-sashal@kernel.org>
 <20221012125648.GX13389@suse.cz>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20221012125648.GX13389@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5qNb5fYWOeTTU35hLmoqcrQ2Sw3VOKKVjWIRnHrVadcZIXSUkK3
 r2bEvBknAw+V4+I5RgHyQ8BTOLO+RMsKIAMxTCWn0fpne5yHh6/swT3N0qcq+/82Kt5S0oh
 m2vl9xpxBBuINPM1Xj8W0L+2Wlkrw/llmTNuhTsRacQcUP1JyQNMNT8hp2SWYAoeSLN6VXI
 aArHA8W7NRUuMorUzDt6Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LS6b9Jc9Ycs=:hBWAE98ja1CB+TynM9T6WG
 J1oDhG02pwQvEJFaOfv/rfe5bJBGpBTwEetFO4au/FYm0i1gl0ZayBX58rYwMeWWa58eYP494
 yBLgSLHstGNEFdoE0bwLOd7ISkD54BTcCXZkK8+QDNBFwr5DUV7uP6LW1XyrtfDwJdfvTfDPd
 Yho28fPwIi0KC7kWdxHEpBLOSzkHkkzyEpB2E+8lJE0sx+nBapR9JLvxrM44905YGmKlmG57e
 FCQrexFioRh9cdGPME4G/GiolKpwmp58VdgmShmwwytLqAdmvLDaxVYgSD7Ht1//2G5jDtO8r
 8tib+VycZUVDNsFKsb6g4mCHNAk+dHOP53fIWEc3RpETyyyQ4iIXpqhc4GetTjbF5FrGnKmHR
 mn+oZZ1RiSMHz+HsJBDV0vO1Iyh4gYOxfqqu3WCTgquVjA6XCsC6YlZ3V9sSORguWtY0MAMvm
 VmIBdyz6f/VGAbQAavxbppZOHqRZyWN2ExRVlJxhPgpAKOMOt7JttURh4onB5JL16+mkdn2QA
 L/LgDWbwmOZdMNXx/xzI6R2lDpRmjnejCkr3knoRTIpIGCTseXy0jolKjtobk6iDN89kWLblv
 mW/Vg6j+BX+WC5e59Q8Sr8jAFxtgHprU5cnlseGdE94hzoNVVen2gW6WyKAyRaAn9xppycvvo
 F6IAyp3XWTNNzVIj+cXbcHmrGK+v0ZFApUAAlzT9rBKbzN0liz8on/h2ud21A7SL58N3nM55d
 h4CGVBttGiEGqRzcYHpxWBwbgd4ugmNyyXTLeEL+nFD7My6dXrw1RRSZE11vta2PiPNLFgJ5W
 LSaCvOmTMXG4/eItZXK6Lmn3I5q0400V0U5K/0OxRC8oXOBJIs9FJ2+taa3Q6CIKTLMnIhHbD
 v14Biy9SreRFisOepq9aRojGkapM6LGV/hPyR2+xXqlMd2GPWC3biD+6VzZdTKjKSBzsx7zy2
 oahNpNTEEvjtudt4T+qR3mr5YtOnqZLuB2lQ0ihWSHyz8tKUgx8j4IIHVfyvGtRgOQ34udStv
 cv6jjPuL3D2pWIbyyAjgsatlb/lrzceLwEDuzCc3KP6QgQlrujxwPQfSO6GcOKr9oYTce9iNq
 ke6oz4gN5zV3Yf8qGDks2TMKPSBaF2cE2I57PWq5T1S8W/+maVmWENJMycS7WiUcwExrAsBke
 qigUoYoREJpwj1hD49HUAlXg4VzGuzJkx0AxP8aGKiubAjGQUY/FEQJjuG84MQoigvC0qiNs5
 7MFWpcpxDy8S6xNvuuu9Krq1aC6ct28NXZRMozkfKpabbYxCVXQZpNG1NKUKmHxZGFaOK0Jy5
 3uUSfQJVywKLNfG5vPpFJ5X0Ca9xMpgWxDXRFAyVTZucOP8UKYrC8bk6cQ5HBjpJASK8e/q/Z
 TfVy8qywsglOYxhCr2kIKBl/Wb1UUZHHtwhvQBNdlRRvL9rkinfO6nNUdWHqMUMw6CA+/olJ8
 vsZ1IMOTLMKGxNfnwF06s8OBPMAAIPxvexPx2R6icVE+/jv2H8OXZm6SxEXqRP78LW8IyOzi4
 3aGWI63TjO6rf/I2NKoS8E8Uvk+XLpvpY76MlxSUTOWTU
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/10/12 20:56, David Sterba wrote:
> On Tue, Oct 11, 2022 at 10:50:06AM -0400, Sasha Levin wrote:
>> From: Qu Wenruo <wqu@suse.com>
>>
>> [ Upstream commit e562a8bdf652b010ce2525bcf15d145c9d3932bf ]
>>
>> Introduce a new runtime flag, BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN,
>> which will inform qgroup rescan to cancel its work asynchronously.
>>
>> This is to address the window when an operation makes qgroup numbers
>> inconsistent (like qgroup inheriting) while a qgroup rescan is running.
>>
>> In that case, qgroup inconsistent flag will be cleared when qgroup
>> rescan finishes.
>> But we changed the ownership of some extents, which means the rescan is
>> already meaningless, and the qgroup inconsistent flag should not be
>> cleared.
>>
>> With the new flag, each time we set INCONSISTENT flag, we also set this
>> new flag to inform any running qgroup rescan to exit immediately, and
>> leaving the INCONSISTENT flag there.
>>
>> The new runtime flag can only be cleared when a new rescan is started.
>
> Qu, does this patch make sense for stable on itself? It was part of a
> series adding some new flags and the sysfs knob.  As I read it there's a
> case where it can affect how the rescan is done and that it can be
> cancelled but still am not sure if it's worth the backport.

Considering the qgroup still lacks a way to handle large subvolume drop,
and a lot of things can mark qgroup inconsistent halfway, I think
backporting this patch itself is not that bad.

The problem is, why only backporting this one?

To me, it would make more sense to backport either all or none.

Sure, if we can cancel rescan it's an improvement, but rescan itself is
already relatively cheap compared to other qgroup operations.
Thus I prefer to backport all the qgroup patches.

Thanks,
Qu

