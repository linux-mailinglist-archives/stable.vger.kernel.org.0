Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B52A1F13FE
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 09:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgFHHyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 03:54:50 -0400
Received: from sonic305-26.consmr.mail.ne1.yahoo.com ([66.163.185.152]:42587
        "EHLO sonic305-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgFHHyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 03:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1591602889; bh=AEu8nK9QzTA2tbqo2l5BVwPShMs+2VsmLoZOZv6b3Lc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jnZxuy4fuIrURRDC9TA5AIoFpeWNf0zoK0IwhMBUAtxHI0UdUs60pEhO0VKU0LFGLbzyeNe/7n/R2TCPztYRyks3P0mJ5BzfIamGaer2SzrJUF2/POzsnstzwprZ3A4FTJerQhzvJGiF2gjb+q0b9ovGpkSO5Qu/cLTm4lBB/xQ2u/LDW+VmrTX6NFk/gJ6EyG1CCMhQWYcFMbnKmm6PXtsB8hrAPbTsfORHt0oNr93Zr6PI1Tv8JJw1rkITBTlyrWRbJkRji6OlUhcJJ7ffFOEz8kCMhZcJ9Ew+mrPhwn00GTI9wtk0SCGfNv3YBWNuG/dGxuABmmxRHWg3dnSmLw==
X-YMail-OSG: yZvsLHIVM1kFbjjMbeKseNqsiT5cycJ5gdZznDc9psILDSGTcxR7_X2Id2.SPDF
 UedFZ6tx7T6h5v9CM2w0LM0TdJPNCXHceqV.FCwuSXJz9rLHMYVt.Gy29u95y6.kP.f8XT22Uo4P
 PU.xBi2cYVpysDDnoyvQBmdbBOJVOLQtn_RnRUUfIgfHpwfw7ToF3xsMi8R6zpEZ0N8nMRBAzR_F
 .7I.Lzfoslhukmv7NUUEP8zKmxbAdzfKx3497G2BAHiE.9TXXA9nwk7hS12VfKEfkImRUmbsFpl2
 Dkxgg36dpU7hqWi2SRpYG3As8LS7Ec1pIAAptyziOtV60QrqkF6kLPU_0j7iyRC6F3kZpMUwQFL_
 1grAs0Etvcbz1CBcDdFuDXSYOloBz4Catqdow9NJzhhiEswoSmxKQhp.9NoF4Kz6sd8FW4LX62qb
 Q5xzr3_BJt8V0ZV7e39Su25WhcO45n8z12gMYRBADNuTvSVgVGg7qFe2sucfBb_iqkQhPAbd1koC
 WIMPPDOnvM2MFnYT6sjE8PCYDrpFoYFyy2w2ArbV2EJV4_5mn3H3SnC5d2jjjdqXXTDz8oG._z97
 kEMe2TBIZVlHxzFebGqkBXZAyNh0DINnTe8tXE1BSwOvdHgvJg_YTSZimBME4v3sE3f284ZemhwS
 Wkdjf.tcoQvQF.dGHNiK8I3VCT1fzCp6k.NrqG0nmJ5_EnkpnTJ6wATjXELhYINqRerzL6b8PeNM
 RKzkM_nGdXs3TCSCz.sEI76C4SO3_hjFQYiC11bFLcAOqXwc9KNgK0E6PLhxiNIrtxzPgojIhbKw
 7qjSsDAKKcM3rBmHdn23_R08xA_STZpnSkDY4.rWGxx8OIRnAKFpGxJxmk0ylzWp_L_o9qTy0WD3
 DYvo1GK5krW69N55puSgtGuDdthJdV4Ptq.45b1uMAU94r2NqNOGViMNacN6qPiGNd0etaj5oakP
 oR7SHhTQc41MVjHYTZ0kuQNLndhXugmOsm2Ot1tYD.mT6Mh.uraNpe_2p8uuKCSeGdLzNPGRCsGD
 6i25aWnVZuCj6BXh20SBMJaZp6jeIr.3Ji2ROWMKn5aU_7kbpr4tD5ez5b0cgM02ZQK9cPMXx2QI
 LKxQZ1iWFfL.iCCcPiQbdlTfevlQv6rMF0ziuWYxl6ZoAgvriSkhl0WO2I__kOtBWw8Xrd27WF.K
 WsMMN_HeLhY8hjwdzLlbLc8B3wevoBQmRZ3h0sX3qCtFR3DGvZje9f1BokqYvvXHCkDunPFvFS1L
 MHxWyR85OaobfXlvSoXYRs2_kOqy5jwVd8hOQoxz8y4aGkGJFyFUwefmCmqD9Slk-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Mon, 8 Jun 2020 07:54:49 +0000
Date:   Mon, 8 Jun 2020 07:54:45 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau49@bitz4.in>
Reply-To: maurhinck8@gmail.com
Message-ID: <376151082.792072.1591602885771@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <376151082.792072.1591602885771.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16072 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck8@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
