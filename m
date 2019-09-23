Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1334BB961
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388617AbfIWQQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 12:16:35 -0400
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:44845
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388253AbfIWQQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 12:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1569255394; bh=sgFa7Cs4ss6n8sA+brLiAjHMpjB11xRWsbVGUlCB1X4=; h=Date:From:Reply-To:Subject:From:Subject; b=C6Wo+hTMCClkje7AYRYBvouaohuNsROPq+TRqwCf2fOaYBTXLGlcQo1oo9rMfyCBaXawz/XhItFs6iCKKKG2qbfEU3Foqe8bKI3tb6Tb6axOZqCYksl3aK2sRqHisJt+//++YLMj6PrG+ga/J6Idkn5epdue+HXnwMwlqiPb2+VRPbADbASO5ezNz+ryFRbawktjywqQzLYkfChGdewa8l0LcMaO9AxEGBJkvdoeZU+ZVbvmqtZJbX9nPG/2PmxooO2l7kcdjV0ZpGqhpBb1SL9SiDtUsm01cBrtNB7bBTxR+4riqx9rTzp4+dZgbQ/6oqVxH29N50nre8JOykXzyw==
X-YMail-OSG: keui3C4VM1lPcnRhyALf.bcEFyS6bsIpokfP6IH.aV3dbNCF58YX1FPdAmD_h_e
 dIxqOeEPG96wsgTO75vShGKpjTuNh6RXV3bfVWQ0TXdEeXLXiHgtPUJHxuVot4gGqITfRyoMF6c5
 wraGEHHWl0gHUmI6sJ_p19zhrvFu.CrwrtiAvHeHVMt4FHoS.IVn_pxmbYjbvxYhL60usDbTTK.5
 Vi8t.qtIm_KT5.NdZoyyYMEM3fkIV9N8Ia5.2vxZiztYOTm76FrtdwqT3mt9FpRhj0beQ9PqHgNj
 SD9V9SWDl2FVAZoVHkpaxCY.IMlpmT4RKqUN1SBj4i0DkZfNgLH1mgb_b_EICYSE6qlE0oNkEreb
 hm3VrM9PnEql3QbN5eGQA292X5OzX3b9psVuO5yUFDzkvLVXBFLwkFIfQ2pXz6vx7QR0HCwWrGvx
 SPMeorlEYKXW6YAvKNoFUqee7GPkOz8gFAlzL03hHh2mhAKSnSe703xaPnnZC_tG5IZqtTwCJSCK
 VX5LhPkyXrYP6bhXN3LmSIB_iZkOEgV1SmarSMvxDD5LuP9pdz7VxkYZ7Aja9YOTzoJbTlpim00h
 5hFk11oM7pd32gY25Oxyzvz07l3H76Q93gFKrSx6d49dnHps.HuzDk8ukzKExvhZRbTDzqRUpoY7
 rn_Lg1pIK1cS7aMhnyDn_B4QjhXKC0UhkCWIkI.RbbxVNlonwNCq8xsxE5s4UVOmNEMJdJ4vJm_m
 9HhUvIltR.YhIc5xfxS2GZgqjXXfwA0RGpBsqJrrpunzETKA49AQcUJPriJozelogdMO6Hn9SSa3
 YtQakjEAlTA6t8BE93vq1moYlf_vFNHtKCeUg4p_mRoA_foAMhxhqglT_tr3YphG.EXthYMHMO4f
 vEReZKUPFqUIH_tee1uo6r4WhmYiC55HZCs6PIzWm9bliq_LGOF5WKLKOhT5WNrjlyflJ6arcKmG
 vkQFQlRa7JkrGzKcURaOEnoVYEEs2bc9cxJfVX3ATWuSLrTH.QXr5Usrf1AJHsmOHx_iP20vRXrC
 njjgn.wVBdRYgJkD9XqUywiPLToRSK5FQpC984AIm3WE81jFyPZxHKFoYQn8vH31RD_YjUYfZrxt
 NTq3yiODJ8XSmSCDhJxeFtlsBa8lIHr1rBuej3KFrEC8vAvKAVHX_ZDTrDg9UDG2dX_u6IS7woXF
 .Xv5uzveO44qtDIvUG6c5OpGiTyjxGhbvke9OT6ErdUJdRskvoF5DXt8iNN6Er650iH50r78VkYI
 4JCSwyYdlsk4.WIOlg6.bCRDpmtaStDDxMA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Mon, 23 Sep 2019 16:16:34 +0000
Date:   Mon, 23 Sep 2019 16:16:33 +0000 (UTC)
From:   "Dr.Youssef Bakary" <Mr.Sohalarfan.latif009@gmail.com>
Reply-To: dr.youssefbakary1960@gmail.com
Message-ID: <210912809.5402283.1569255393607@mail.yahoo.com>
Subject: Dear Friend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend

I am Dr. Youssef Bakary, I Have a Business Proposal of $5.3 million For You=
.
I am aware of the unsafe nature of the internet, and was compelled to use t=
his medium due to the nature of this project. I have access to very vital i=
nformation that can be used to transfer this huge amount of money, which ma=
y culminate into the investment of the said=20
funds into your company or any lucrative venture in your country.
If you will like to assist me as a partner then indicate your interest, aft=
er which we shall both discuss the modalities and the sharing percentage.Up=
on receipt of your reply on your expression of Interest
 I will give you full details, on how the business will be executed I am op=
en for negotiation.=20
Thanks for your anticipated cooperation.
Note you might receive this message in your inbox or spam or junk folder, d=
epends on your web host or server network.

Thanks=E2=80=99
Best Regards
Dr. Youssef Bakary,
