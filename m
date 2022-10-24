Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2684560C022
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 02:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJYAvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 20:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiJYAvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 20:51:15 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E542A18E723;
        Mon, 24 Oct 2022 16:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666654260;
        bh=sbM3L7q2j0MNanFbpvlk4CSjJOidE5xvJJaI4BLiy+Q=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Q32yPIeNsxZAbRf2+2Y2ggTxewbnqwxIr4zMBwuFTiJu+iqddxNFdyv00M6InbyHS
         c7/6pjXHU4In8aJ9ZXpYi7PVXv0p18xDKzN2wBXyNOsINLbJgzBXSyA1aqScplZLo3
         WNSq2nHp6IS5zwxfieSW8UpQvjc6dQb2e2TebkTg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.170]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MG9kM-1osbbk3LjQ-00GczX; Tue, 25
 Oct 2022 01:31:00 +0200
Message-ID: <d44dad3d-33ad-7e4c-28d5-42d9d1372c73@gmx.de>
Date:   Tue, 25 Oct 2022 01:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:R8vYBbUooOSi7MshoH5Y5qxCav3WBy1NlUQ0z1lVhrrXwGRaHQO
 0pR8+RXiZ8CMIiX6PihSopgc8kfPH/NWS/hzPiRXnszO+/tMX5h8afBD58vJyMnbHTqxpti
 UyYrMIvpsZKxxCuQjjxhHKuqLsj4/xnzJwt7HbNB8VRGgNV571c9ardTJCAq0Z7lfhJO9nI
 N3wy7UVFTHjgl13j5TOtQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/5xtx47EcM8=:2HXPT76FgnSzFLXhC+ca+B
 CcWDh0Xwl97uQp8njSaa5IuGOcMiFw8izG8nA0BFO4Qe2iIBlyWEnWMA/OgYw+0rf6kmH/1eb
 e4IvNkBzvgs3uXNErxJfvOZxjTpv4+WYsFHPXAu5MpgqGXGhyOCg/balI9HGj5ayYIGKrSkAn
 CJdbFOOROkGK+6K6po6pbHlIrdZnxAQbvSTeenkJ657ZkzgGE1vskg1CHrnQ/PmB6XZJDE1Hy
 x7G4AnM60Z/dnsbtIPePVNxqY/8RLJ0x0DMUmLBnUx8UqUjfxYnpysNuUkz3dhv00ElXS+1+w
 zTwOXxudtJhn55RHai76ze/SoUXLKXl2lrZF2UPts+D8+LfAUo3DZg48Fgjz3w3mUUMhEn5om
 7z3FxSKC2IgriD3xBFuiI2NT6LUU020jWQD5uim1VIr1zU8+rCqPOLMRlT8ouUNSO+KJlrLq1
 rs8fdGMFfJLPMinXdMZR72J7cyeWnXvcXhZW9o+A2LKK0KX7S3bam2KqKvfFpfq2F/vXuuMzt
 fVeZINmwdg+yQAMFCWtgmXvkLIu1j3mHJgYcKHtLMtkqn5BQIYss/T/9UJ8/Z4Hz3yjW0PXMv
 OLuAMle2i6Z1ovwPq4AYPZbD6La2mhclu0WQfceMX79LvE7wF1r2RFEAs4WpllPf7A9GLOB1+
 1OhFZepk/XKKUa1tAWWMvwei+ByO8huAuDPXMffO0drdQjlTK2vmWmKXosPV52c5wv4MaYiZi
 zfcJmghnQjD0sA+594XhdPUzzvbXhtG5qtSCRF3Xwq7t5lmzatJ2NGvviRirjwsIeyaD4a/1W
 +JXhvq0m9YCU05dvTLqA7OaTzwRRooQk6zUA2h4pS4wZKo3g7xybSdES+NaB9RsBic3vvnrOh
 0QyaorrOOQ70VO0f0aoCVW+835cE0JK9ewxfN8K5TEFZtiu0xl/Nq3OMAwp6VcLmdCMOy8Bau
 huj94f4gFdt/g9dU/kNdm44xlyutsQUZPYZ23wj4tWimgOu+lZPpUJqq+h9sDiEPZ7Y/CgajG
 LGG2LirbfN53kFH+oztCLbzHGd44nmMRhyzpwWwxVOfc49o0poDul/OCzlcTsZkaUwAMHkOoN
 efHPL6NJiodOmrhW4+BU3Wf0maNuPxGKWq+czudJ+rRVKvuJ57Hc3UI99DB8blrnFnevq7pAD
 L++eSgVxiRRHMZ66KiqlbRcUNe/Cgc1gmfkK5zW4M/Gz5v0KOkHwqGqLavIzQJrNOefz1YNGO
 9dRkg7UWBLPBKn7GZAnlO/7kd2SCvSMy3j+h1tPF+ewbzLmRolYgKSTWq5lMfWdR3S2PIlgH4
 JpYDYMR4bW5nf7iEjimcOQMd18ETSrcw98Zoa73eeKaJF6znJDtCLSifM7JtD1jQAnbXWZ15R
 xyM7ISg5j9R8VteJxJBzjngop4B3UVdKm8XxiV+JyMy8L4wf1v8jxKP9x+xAQuzr22ZEejN06
 IGSaSZBnozCiM84pAA1H+GqA44n5eEUyKOJqEwUpiluJ5zcXYfsD9RODSEU0ACsZcdnnpKpdU
 4JEzCzm2n/9CBKUu/xNpRt5cqozSFcnpabsZRzdB7wzvA
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

