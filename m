Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57F52F077
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiETQVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 12:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiETQVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 12:21:49 -0400
Received: from mout.web.de (mout.web.de [212.227.15.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2B57B02
        for <stable@vger.kernel.org>; Fri, 20 May 2022 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1653063699;
        bh=XNZa2MJDg3Ejw9oc/fw9bCPjeN/8oiws33/BgA+Ct+M=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=E1DxWPlAzsP3PaCp/CSS07LapaDliLMANVQq7kDugF85Td+iQ9JtAYGS3iHSNtE3u
         5uKmgUL1OO74tPDFjV9Oal+oiwnOitKDSLP6gooBF3CdC2WSTrne92HgSNJ8RMWh+g
         BeyJAsMUpws6P/r1IO241GKuTCfI5Kcf5t5WJgg4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([91.6.57.238]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M5j5y-1nyABd230U-007dCS; Fri, 20
 May 2022 18:21:39 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1ns5Nj-0001RR-3v;
        Fri, 20 May 2022 18:21:39 +0200
Message-ID: <78eaf506-5a23-3071-3d4a-362c4f0851dc@web.de>
Date:   Fri, 20 May 2022 18:21:39 +0200
MIME-Version: 1.0
Subject: Re: Linux 5.17.5
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de> <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de> <YnI2QYZ1GqmORC10@8bytes.org>
 <f731aff4-a20a-26b3-473f-723b65e760ce@web.de> <YodtvQJXInHDI3lD@8bytes.org>
 <22b19b34-5cf8-e026-97f8-c66011ee535b@web.de> <Yod4E9K8ZFOxso3Z@8bytes.org>
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <Yod4E9K8ZFOxso3Z@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YIHZzzV00pAShyv0HSDYNC3MNvfCpnkti/EXR8LZUugzIpx29jA
 lTbLdUKxKpoMOOHtxZwUl8qm1RY5CIA6kJwhUTUU5CCR82mQo+L8YG1uVx8mqtcL7+bDvla
 6vwBilINATVLGhVRtsBut9nsSAFVnSBLFYjVH8xV85tOfc/2/pD9JTGEzgjXSvgbZj5fhn4
 HjfhPY71EZ6uL8DwnZIDA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yzBLPY97dX8=:6v73Koo5Vr1EnjG03HRQTY
 /atIq4Dwpes5wuVDumhdQs94myJrNKGNt9Vy0KleIBVOhagTHuuiMq5UwVDw6w4oIGSElLP94
 mvgJH9x00AtK48iOZZdgLsWqqFbogdVybuezthe5oVXORrrQezB60VKfc0nUn+z4fFAtH722e
 ZEjBlyPwLIoE3DE7T/XNJPAc+fbwyD154TMZ28Bk8halTbDfB/4ksQflMjrmxVJi/SzFXDzvX
 kXrsqV2yweX0BIFLlQ+gnxrPGl0HUD9EKWT6DzmprxZlkedVfqvhykMlgC049lVImUafLxNtw
 6jYzXbDcTbODRnPf23hWQrrLIF3Lholq0fnBMy9fZbjPugYp8BVTL13fEGNotfSrQjZttqJls
 Ee6ybK7dN27ZezH/dalClnb3ah2rnenCtbeHeIKlxcA/+REAtUosM1/Mb/POkuwpwBqD4cy26
 IrJ/0NKCDfk/awUBP5iJpsAzyLa91y3WcpON7EOvz6IHmYSK2rnrwp6gxv8IzsFmp2KMh9AHU
 ikfAW0dNvD8uIrMfmqpkwRf/96G8rpAhrFSlkH5LqEILIZwQIqKcUhGo/7MMjx6+pygUANQIh
 AYCPkpyKXY5yUAhuCYBHeRpquWXbZ20C5xN9w19W29QNWRpnlx9aHYW7/j3ucd1x2Mzj1jTil
 xmAfKkf0xa5G1YrX7h7ayXEZP8jG6Aklk5xe2Ev+j26cHPnsA/FroEEOHl01zKNtVQ2BtDxHk
 560ZK5PXoMSiAtDwdo6l4t+XsIog5p7YRW05Dh2IO5x+CjgVRsRE4cJ6Qpn4HpCF6AG8HTlVg
 qnW6pYoIGd1YPSineQZnAoWT7sHBCPFJR2gbYBNQA+yBNdLEPLEPgMfv3B5bNdg7kE2SR1SHb
 dY7N/dmHE/9KmqWeWvscHdG/xx24UPTPU/xcB5fln+dtMX9nzLa3S1O4lOFPkkqX0JhtHozB3
 D1vySo1Ifqvk8AMYqPoDbYYPGY9hoYcDDFfWDLWRROlis4dqzoMNyGs7YYXjxrASgkw6qh58c
 Ey5121tCoZK3dOMeVuZ7jiHJUVlocIVx2SSMn1H9adS/0JJXwvk5UtICM27E4DchlfBMc1iS7
 6dqzWEREaygiuDkLtWxXQoNxg/W54j4c2CvJ1ZfkPV+L8uDSMlmgxDJNw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joerg Roedel wrote on 20/05/2022 13:14:
> On Fri, May 20, 2022 at 12:48:28PM +0200, J=C3=B6rg-Volker Peetz wrote:
>> Yes, I will test it on top of 5.17.9, o.k.?
>
> That would be great, thanks!
>
>> Would you also be interested to get a timing from my computer?
>
> Only if the patch does not fix it for you.
>
> Regards,
>
> 	Joerg

Applying your patch on top of 5.17.9 seems to fix it for my Ryzen 7 5700G =
on MSI
B550M Mortar (MS-7C94), BIOS 1.B0 main board. During five boot ups I haven=
't
seen the warning.

Many thanks and regards,
J=C3=B6rg.


