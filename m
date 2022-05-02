Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB5516E3A
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350217AbiEBKoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 06:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384658AbiEBKoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 06:44:06 -0400
Received: from mout.web.de (mout.web.de [212.227.17.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3370912A8B
        for <stable@vger.kernel.org>; Mon,  2 May 2022 03:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1651488014;
        bh=Zb2iOMURRc/ylar1aALSKgigYn8efxcPcIP33RgOR2A=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=K1yPliI6h2rSmsZrBlOCKY2Lyly5KzFbA/G0rmpbiSzg2B1HXS3C8aUtAJTshkbNt
         1+qBshBCvYQnOLG80aHqzXib+jTVvS6PQeaUkPyEidG1qlvxf9J9anbDDSQcR0N38H
         LUq8ZKHinFCB0vGydq+mmIx8Lv9mW5JJTqd9os5U=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([79.245.218.86]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N8Elm-1nyYQQ2Wxs-014Gfb; Mon, 02
 May 2022 12:40:14 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1nlTTS-0006De-5d;
        Mon, 02 May 2022 12:40:14 +0200
Message-ID: <55b4e020-4b8d-382d-e45c-64ab00c082a1@web.de>
Date:   Mon, 2 May 2022 12:40:14 +0200
MIME-Version: 1.0
Subject: Re: Linux 5.17.5
Content-Language: en-US
To:     JoergRoedel <joro@8bytes.org>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de> <Ym+oOjFrkdju5H6X@8bytes.org>
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <Ym+oOjFrkdju5H6X@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H9ga63yXfSz2xMD4L+pnLVwfsQPe9OVmJvVQ2F0uLVHBtjnfR2i
 45M9PWVC+jR4oHOKJZ49DEfSGYZ2+ZWGwbx26+w12qrwodKR688F1AOjkiteelij7X8lsmx
 QIXITdFo3k49cjVBzx/HdclROqhsUTgd4wxH1tfdWDKtmLy3Rjgpw/gzHMtHVG3KLhbnGHf
 H+Kxf/TrpXjr8RMzt9HqA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qF0T2E+aqmk=:uvOfuznN/kpRFFpefrewLz
 QJDX7CDCR1VWYqq+JfYF2xabHl2SUc2WPGztRswtaL3CM54llo0kd78pwF5kI3YRh//+KqFn/
 ojbK3pMPRPG/Rveq/Uhziu5ioOdNNvJRMTqGKRDdZR3aONRLg6HnIaj462pgx38orHUYud9F1
 XYfTOLcVDsJuRK5gm6aOu8Ug81omVnoj3MvapXCI+AVgLy2nqhCqDVyDOFdZ2vVWd4DXgcWQl
 ZTkfqxUD179SJVXRDjp7xzCDF4Rbicb/Gv14Ldd7y00ICXJK9jMwVPFNq+XoR86+krjkwl0tn
 1fyYG2XzYrotB9Ay9+116xYnFCYy52VdOd08EehXh/dSPnyN+fm3p2/GvE+SfgdelJox+1sC8
 eF7+V/hF1RIL13zmm+AzU469uZJau7hn4B7hm1xZ5nCreHlcPUxoWnJnTrl/CyHB6fEl//5mo
 AKRs3xgrl9svPt2tPI8baKcSSKV+1nVaTZQfZkOUOiEXr61wfzpgKcS5RRIMf+QCOWEtkMpb1
 ssCD9+pN0Bs2a7bIgT3VPzssZ1r0NfVQDhrcMCvTN5WcPAGEptS+WWpVso4vz4aDgSnsaoUAg
 QojbPLG2NkG3MSRnd4RU27ukXO5bbIKr+bGUgVFshvAgr3x51E3zpQrB3LMWsGlWKSCnLW1Ol
 vGuOg/VaJ2mudylB6nLrL0CHXLN0Knal5I2QQihAnU0xu5sw7bWu6m0BvgcRZEsHEoee+0nTD
 r1yNC2vpWVBluVX8jEWhLcdGjeGvmdkL+4dpvl+qPABJ7x5Yx3GhZ8HD8BbVNbPQ/9Xnqo5ic
 3iIu89egGYAc8pmwwhOuA3rhoOY4XpQq0meVUWF969XmzsG+iHFm20QAYVD8yEvFri7opX8KO
 9Dq+AkrP+j2XqhH2xxxnz0H6Fk3cVHHkVeT1DtGtKUM5r6eHIsub5zbmwmnIbkiE1FK3jCI9v
 PutPWNVSoZ0QMrDmYhhmEjvjm1ErUKoR3IXOA7ulV21bLiw8dTxLX/odEhkbWa4RzGqr4YeLK
 9cORcjQJL0elIk1ZD9jgXvJkW7wU1YInMTgbJB6poH8YoP1qav1ZCoE0TZl5m22aFOzbpSalP
 nxGN1ywOa8peGU=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

JoergRoedel wrote on 02/05/2022 11:45:
> [now with Vasants correct email address]
>
> Hi J=C3=B6rg,
>
> can you please try the attached patch? It should get rid of the WARNING
> on your system.
>
> Suravee, Vasant, can you please test review the patch and report whether
> the GA log functionality is still working?
>
> Thanks,
>
> 	Joerg
>
Thanks for the patch.
Will test it today.

Regards,
J=C3=B6rg.

>  From 4fee768d5c23715eae31fed3b41cdf045e099aef Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <jroedel@suse.de>
> Date: Mon, 2 May 2022 11:37:43 +0200
> Subject: [PATCH] iommu/amd: Do not poll GA_LOG_RUNNING mask at boot
>
> On some hardware it takes more than a second for the hardware to get
> the GA log into running state. This is too long to poll for in the AMD
> IOMMU driver code.
>
> Instead, check whehter initialization was successful before polling
> the log for the first time.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>   drivers/iommu/amd/amd_iommu_types.h |  3 +++
>   drivers/iommu/amd/init.c            | 13 ++-----------
>   drivers/iommu/amd/iommu.c           | 25 ++++++++++++++++++++++++-
>   3 files changed, 29 insertions(+), 12 deletions(-)
<snip>
