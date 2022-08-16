Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D218595286
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiHPG3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiHPG3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:29:01 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7582635E765;
        Mon, 15 Aug 2022 17:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660610581;
        bh=qtWTAgDws3/A2ECwdJu8VQ1RYUmPGuwFTdeUQDBCQ4o=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=eA5r6LBYcnE9vXbJR3xVIeuYpPjO06S6KxQ9yer4sbAzWVjglSbjxcKeXTI7ttKM1
         46wQUIAl925/n0siDMPxJmKACK58U5RtXtu93HFXRgaFJXz0S+gpBdJSh8zXMMlMXj
         AximEJvWx9faOdRJ97YXihoFwCfWU71y7JI4y3YI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.47]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MacOW-1nlf270pqc-00cDkm; Tue, 16
 Aug 2022 02:43:01 +0200
Message-ID: <a2c029db-a689-08e3-e34c-d02819858084@gmx.de>
Date:   Tue, 16 Aug 2022 02:43:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:LhZqGFrKTHhEMIjOgweyyu9zw2iOL8yYivL9rHbEUBCZRURL8Kn
 ZYPiKH59z9dj7Rfa+PlEXYzHJxwtbycJcDyCyF3KVRV0rH1keDLOQXFbtoAbI4gYpmOIK9Q
 DNf5lgChrU9JJNZiKRVS/4AbG0wuXmhWFyq/k7wakzi9BBju1Rkayo4K6ubfml8qrSq7TXU
 3mjZfBgUrb6ouy2KuRm8w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wy6m6B0cjX4=:nr5HCHMOXg6dspu3pkdhKl
 TiJ4Q8CUeRS6Ahwznyc9RPMp2oBZ7o7W0xwH8T0DXVAKk4aRhBZfadP2MkR7M51LhAAk8mKjJ
 QnKdkdPVZHeGqBc0Lcf7hFNEtMSRbgG1NVXga5HYbwwGWqV1I/2Ua4OOKJRW2moF7oXbjd+02
 VHNBKq5avjUOmUQ94F6+lTLp6zovy+V2foyA3YGwfp6XBDhDiKog5fIsajsyUljha19unYIok
 BZSuSc+rFhQproyOrxw1Erat+TJ6NT8aa/Ix6WmTy++RAP4vCzebESu3u90hSQj8XdaK2+sq6
 UL5QJ0+ydtVB3fmQZVDVvagBc7sk7jy3M8GOiA2UfczXyXD89dnhrt8s7swEFerR+SynAWq7f
 T45W5+NpAJntt7OmA/T8SDr2AoIc5BIXxw26dDkiIOoR/QgQmZjCxXfyJSZbR0+H+r1F3r2AL
 qTbkJB9BHyuPmX/G6IaEOyzGXcqLtp+KK+ZfAms2Y/K7yXbY2UJR20KcAQ9ZdE+wCsoo6CWCu
 AbwAaQNFm1UEvrfGBHY9LGRFTqhRQYc9aMLU5EzCN8X0Z5w6lCFYj+TmbI4AEcJpPhWnRn4Kp
 HD4KQTWUMzuilzv06/0HLuo3NSGXwNWqjanmEHsEEemCP4jC0KnapnhTHFNshPKetsAhLBz+Q
 80l1HV2DdVbBLfK4ehLby/GYMgEiVhTUZ994pPGL79nwsxSEot1rZ98xjYposVXlu/Ow7masz
 I1qb+UaBpMNf1eAcz1jLZ25pTcQA0blxY0ighwdCC8bzvWMCSyVpfGbs98BthHaguIC3XkmoN
 iy7q5eQX4HHxGVorGU0z5s/ay3FYk8iMnRtg+DPv28ajt9XOBFj2OPa/chuiCw44gZMxbCwEF
 KdTZdahmbv8eNvcgKfTeKAz31bVM+/zyZ9ZZedqdVFo6XMcRWyi3WicGENRy5KyxqiRmTdKNv
 NL7/4F5tbbFuS9I6Bw5CgwUcF1LZexWpPCm2JLxsM/RGEJmiVQVBraak4PCrpyNPUfWhfIchD
 6lVQUTUHCfMt9dkidyLfbKDC/gVyjCuDwbDOvkL60PFexXf+0jK4nDf8lvZRfB9bhL28+Mjxm
 yYuXKdbbwUhVdOZNs0Nme/hBEFDIMw2usRw
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.2-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

