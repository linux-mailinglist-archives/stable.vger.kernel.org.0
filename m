Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6905AB40D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiIBOta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiIBOtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:49:03 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25B5BD12D;
        Fri,  2 Sep 2022 07:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1662127821;
        bh=m7Q0zcOItCT94vu8JeFVa1fFU59kIyLleT8Zywu1zB0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=BBd+FUSuXtrbDztDgNub/Gr+r2YBWRg2JpbvUoLsjclpP0Kgm19+aFv2kzXmEWEds
         d35xBO4ywqx2d5pxiVMf/4rWzBaDEDp2VuYm7YntVf5pjgL6X2KmrV39UcZU3v0Udr
         tPi7QjPvyxquBfsLqGwhjs+fHCFCKY6b69V3pyrk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.106]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MQvD5-1oiDqk1AXv-00Nw5I; Fri, 02
 Sep 2022 16:10:21 +0200
Message-ID: <ebc00135-ddad-53a8-6952-59d436fdbcde@gmx.de>
Date:   Fri, 2 Sep 2022 16:10:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ijNeQBw1EWtDrbcxnCLPaAzSoiVmqT1o3nhWk6QPfJn2OHmwguC
 1/1KiyP9Uq616gThdHilWb+pnRyOhB1ZpPC5qQ6RwwlzM+qAXZpKIcHyXlae768J5hHQL9F
 yci8148WdKcaTc0xd1LJAJ9KnlLH4aEyYOhM/nW0cCg5NNpJEUxxlaDP/J4hpCySFO8/44Z
 sSX9DjvT1KPoOF37fgtxQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yXtkfLrVieg=:UFEiqoOBogHK68TpANNhXQ
 lZ2KU4bH96tu1m8gpELYiFCLUi56vXtnrCaav3SzBrB6iuGYR82CRy0SECfl8622QUcVDEZNU
 iSFvdXwsTh42Mscg7N6znzTeweyXVXjT2VR+O+U5viQuZXExjkJo8qm1A4M2jl/+M7mtku8Mp
 Cj6dce/ELOvZitf4q/hlrFVZ4M8lxi0TV+3/x7J2DWi+PueL3uAZyrpWwsIVYjNlVhlVAg7pH
 azaYp4LW6ik8EdU1cPSVXcPCei9z8HblVpsjZfM0UoX+XZDnfqp/jwG2rftLllQ1pR0EWG24a
 E5JgqnB2tWMC9HMYh9sqdu2u09Ug7xPpNeGigiZTvnE4RCS+U9aM/hrCuJQ0tv5mqwoWiV6FJ
 iR4VufFAszwf5d2wwM9GHVp8nCvzdtE/qCANqqhFDlNrcx0dSezb3Op01HZo1xnQzDmqRVB0t
 TcZS8p9jKL02lfljRERTxEp6ttvzKEeDcNH7qauOtFiNQ9+H4qT2evnV/Rj/MRTexkgahys5z
 UFWhYXKjQDgSynuH3bgzCROpxT+Z8kowQcW8KR80vXmoZy5pq3+D5WlTPNtOH4TW+ihBKzoHU
 12rJI/Me2ApjtgJCyUZJn4+dolTu/fi3xWwRhR9rqYWpeTnyfoDQEyDlO8KMyyGM6OV+OpBfJ
 kHneX8sM1sj63xItZrBw2FMMH/suNlk524X93MCifmcYoD5PX65ivMOIZjuTdyD7+OWpJC25G
 FjkMYJh2a5aMBoIXemFdlkSvmyBss/yr5ePKsMIhlXP9Nfj9NXiNTAYgA1LnE0xjvM4BTvv3Q
 6t01MpTtcx2r78QMZee8mPVbH2ITgQprb9GqZ/oM9AS+MRDFOu66fK6RzhR26HTgqiz4N239m
 qFdpFqEyVGb4m/NOql/6MNTMsl1OtD3r4to85wNKCRzPiji8u1VyObbXYB93ROXioIrRzaMBx
 AZzfXGPnOhr9sU8BxVYc8F0R4XclgDESyZd2n6ScOZyKvWYJZdWTBZUI5rCLRfWjbUe6kzHs7
 9MpPGi7tLkZvFN0XlsHRiSxGGtfMTxd70CxygDXiOlYa6ESBAJAq8i6uVdM7lJvBItIJ5HkjF
 k49Bvi0Phe1zHcHMbHrNRywTItONfTE/0TGnYI+9ebSZROEcUaIj6gigOsvlegWwdkSkjthvZ
 KyWVw=
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

5.19.7-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

