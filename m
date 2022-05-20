Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF6C52EA57
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 12:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347555AbiETKxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiETKxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 06:53:44 -0400
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 03:53:43 PDT
Received: from mout.web.de (mout.web.de [212.227.15.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FB595A0F
        for <stable@vger.kernel.org>; Fri, 20 May 2022 03:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1653044021;
        bh=zTsDrlvZm1vrf8ldxec3slzcofwI7Q1rJfgI/nB/X7M=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=mIDp7+DgFNMBCONMFAPF29tPt3Dz3ojL0zU2JNx7wMeafFc02xpuohK2wFIHye7Ke
         OLl+o9kgoOanbNv5BUUNRxN4lTPRh0LVFLBMs+ItWys5FZvq7RwqZ26ukmVAURisUC
         ltEJ54Gi/95itzMNZ26cBPTzrbngSJkrdv9walxI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([91.6.57.238]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MnG2C-1nQbuK2tO8-00jV53; Fri, 20
 May 2022 12:48:28 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1ns0BI-0008Tn-7q;
        Fri, 20 May 2022 12:48:28 +0200
Message-ID: <22b19b34-5cf8-e026-97f8-c66011ee535b@web.de>
Date:   Fri, 20 May 2022 12:48:28 +0200
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
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <YodtvQJXInHDI3lD@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jOVb+aoLeDp/ywUNpu4Zp7/4J9oiqVg17z1P2TWxL2CddVTXVL9
 tfnhuSHGvuvLb9pR1MMlPk0RsjuwK73KkAWzFUhtXwDdEOZ9C3bTA+FgHkMkwbRQzrDZ8qu
 IbanLse+vwp/YlHN14ojcqouuVm/41tQ1tx1SSgnfU5EuZUemq4wyro8Ll5LumMFg3xhH07
 hTPwaKQ0FMvEaFD8Pjk3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:w1uql2bttxM=:cVp3R3Aj4M94xv8YjGHlvr
 +0tbu4QRP6l8w1Yqy4hf1Ey5NrkZzcD8sCTMWQoCrAJUat+zhkGJC1wqoyDVmyyq3C4CVY6HD
 R+H8+J0DRZbQRPQWEPMWfU8T5nRA7cBgfb1q/90wLliRnvpemmIwLGJ8cMP52NPkVr/Iclgca
 tE07KRklgUPqOgKOKA1dw6DcElLJKdr4tFCPS6uGocmAGGYtUgXWWbtZVYqMYZQg7IUDYfw8z
 3dN4CL9fkwpdox1yDon03rGCFZGk4t16DZLgLNRfhVg7Q6jQSSobjHWJLKliauc8nIXzGU/Qt
 Gu9u+cIl+LUTeHim0V8WJDoyOTtxx09PU+qlBJhDwl6901ryL1+DhnybRfpRbC+SjKouXM3p9
 r65yUp64joDTB9mj+WxnW6p9eqQgcqNzlkP624QCrXMHGZWDaZG3brgmixtInBbCdvie5ppyx
 JpGgDggBCb2rP7XFqGCGOAm3ZEreFo3drlAVzhjgAKX0FRcIkXPN+JQeZrTeEG/90IK9hPzeo
 J07ZlvfZzwoGhny2175v3CKVwXXpdIOq4KaKi8iFauK0nuaEagwFCeoLyp6YIjwQ49lSAm1V/
 tUJppTdcklqnRxiIcf3OISNC8tS02l7JthEcHucs6EVeCP1k1nkh8LI9L6tYBhcd9EEc66xzC
 Y69qZADci/uUDW0DhOqbOV6+ux+rZlOJvcaYjUeyhL3Y0DhIZXzSEqYqCqoH0raHAqVmjgeKX
 TaXZ+wLGjA1mwztgSZHayNFEfx1R+hcg4geptk8xYs6HWLDSOtNw9djElqw8gilR/Sb6+IPYC
 h1zCdeiQtSYpVLM3cwkVRBa2fNpql0196yzlQLaq6c9DWOZzlSWhtr0eW5QvdlxAR0wyJK7JG
 FxpmHfajNsPmPmpPBOt16jboAsVixiPh0fqthdRg8ieY/ih2NM3gR0BK8jgAci/nlqC5ubw2g
 RGafhltHt12KGJVBdSUzMjEQPCT+6Ro8rUQXO8uatw1LbBVzgQC85mql9lQGTEBLh9YyJQQMa
 iBb8BE3KOWUInaGMqxITlblfhXuQmrtP6u8TfAEsE0PdbE2+jdBrJgRPiU7F9IL+M43NxcLtJ
 lJ+DUDtr1z2b1+NMR/NJJqOzn2tisbIZiWM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yes, I will test it on top of 5.17.9, o.k.?
Would you also be interested to get a timing from my computer?

Thank you and regards,
J=C3=B6rg.


Joerg Roedel wrote on 20/05/2022 12:30:
> Hi J=C3=B6rg,
>
> On Wed, May 04, 2022 at 03:21:45PM +0200, J=C3=B6rg-Volker Peetz wrote:
>> now with the really patched kernel 5.17.5 the warning doesn't show up a=
nymore. I
>> did two cold starts and one reboot.
>>
>> There are only two warnings regarding the CPU:
>>
>> [    2.659141] amdgpu 0000:30:00.0: amdgpu: PSP runtime database doesn'=
t exist
>> [    3.538925] amdgpu: SRAT table not found
>>
>> Sorry for the confusion and many thanks for your help.
>
> I just sent out a fix increasing the loop timeout, can you please test
> it and report whether it also make the message disappear on your
> machine?
>
> Thanks,
>
> 	J=C3=B6rg

