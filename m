Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7AE3E4A51
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhHIQwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:52:23 -0400
Received: from sonic316-54.consmr.mail.gq1.yahoo.com ([98.137.69.30]:42742
        "EHLO sonic316-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234225AbhHIQwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 12:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1628527917; bh=9GvQm8NErsAV8WhOEeuwEmGDdXBWxN1SDggFjdQ6EyY=; h=Date:From:Subject:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=ozF/hMU274qK+ey/11X3d0I+qnmUigMPpofU2DPi2OTlliSpr/bzz50iuRMrXlvnVaMJOcLVIqi6e/CBJWXMlg2F+s0OGIL7fKxzU4Hy95uQL6O6mVlIrmLlD28iq38mOrCrgtSjZVVtufPGmq59mxdbzjoKvXJyU8AXoZ7yHoXg70EVI63coNupAHP3QlomayyIHk9MBc8NHDvEPRDiQReHzH2hRXIW0A9uTdLsa5lYpTm/zpqrsxKmQRXDegPHmDDFOLdfvNS/vYZ5lAH4vcYo9897gR0R8ozRdcbInm5tQHkpI4S5HZm1G/s8Ul1lwe5lyonNfYrYGs6Eiuc3/w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628527917; bh=/RXwAMXwBj6sZVSEcwTrQSh6t+XcwUuiVgjuRCiiaV+=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=HwifzzTA6/cwZvvnwnwr5TBQZfKZD8DKsf1Wj1aI59a7v/u+i+i8T8GwRu77yEN4/3p6x2ldz3Wgw+KnrGRX80eGiGWIVijjmnqCFvhLiXsn/JuVB9Se2f0cwMux/ll2lsDSlV5c7DxP9O6Q8uPXjRkzyBWybzshBJ8IqAIO/VjnjzTCgPxHfikNMLGwRogls+11GfTRz4L5vXZuMFF7mz1Us8h+bsXAbomLNtn467dLSvuBjfe/xqB+jC+0WpDVDrfuf6ug/oFdGMl5dXyvUo2JGRubS218sh4yxKtyXgK06RcH8c4QZpoEcH8Lf0xIn4W1DeCKVxPu+l/LRlyWog==
X-YMail-OSG: nphgHwEVM1msXlJ.Rx1ZbjPx.YgDalbRQVNSMbQm.sAIkoZJfOWNbVYiLRKAR3T
 Tzhrs86rNCt9JxvHXLsiVPitfaPzOjALp1LhoWngFWOfBichDmp1GySFxUFLkBJwFMU7smlvK0fx
 zDwGGQnwoC4hGElrvVJXVraCVvm1kbEuYKPn._BWqXst1D1iFa33HnXrkV0tIQU6KXrab9ijRnmC
 yy6pqa6NwCpTA9DK5DuL2JAl.q7llIihtdrY.vUCSQiLG6B7eqFTqfjtiyngZcSkQVK9llvAzIid
 izhdxiwUCaFB9drWTQJTDxKOT8sDl3qz3HZiRb_ATzBmPHOpcfIKypgfUJmOgDh3MCHzq7qSROfy
 Iss8c8YNzygDE9YRqVdUSF3WWHRLLB9mWv3t9tWtTe2fGVgH.AnKVrEq.vrc5umQfyCWlM1stoLW
 swOpLuvt02tvwD80TrYqkdWHpaxwYVTF1SqP4Ls_Enx_gbtwSG_uvoB5ENAGjlLiLhqwYNGorwn4
 iJ_4wiL8HPMpQaQlM5iBBHZxv36UkYlja3CWZVJlEeAU1kfwBtpie3ihXsLNr.NJNBimBVYc3CoP
 WF3hxd3E__SHYC7Q3AWblZT5FMkS9wTSizqvRkL9tktKnL6cVVqXbfarEspIHSM_PwucXmd.NVP6
 Etgm2HUz2t3L7vBIzMqHxu3vTUTWOELQA5dtmPzaheWAAvl1Q0BACmqe7FX0u5B0X9oV1oUZfI7z
 dHhJE7oQctHu6CuEVgOj.qZSfJRFshO4u3FD77FC8n.k_i7110yUx9KUwjozrDoSomP6Hm_HhylQ
 yfDTT8YSmUacFueVV2TrlK10PFeDVjG8Z5kGD6q6W0MwpIOGcUXzulQ8ibHqMwuCiJxJfEfHydKC
 _XnN6gwkGOklcmCDlb.0dg0U4JVKvEgUV5zd3sDtslCeeplLhJW5iTPsG8KA6GsJQtKJufOg_95g
 _oZj1gnukS70x2N78CZsWfxjJ6SWQowJY04XHY8cXJn80heuNsN51nfKBJHrT5xZeM_Hc7DYGult
 hKv3Rj.rvFRI4KVIBIshyfkVpJQzEfdIwZuojeXrimrCdmVCQIKFkXDYCQTljOP2W_BdDHgscsi0
 U26dEGSmkglquTKzSoDh_Q8qZn6SfuJOpk4cqZa8OA3H_N_m0S63sGi9Pd1goBc2CDIb6vtOJtZI
 oiFPc6CSBATkihuSThATK904nE7pPmCXt67rhPU7HnUmiT.2i3SKC0HHe9gRcOrnuu36YlvLLvCB
 XKH5SFjIH_R2Tt7mWWRK4PC.ttOsuebdHD1nfz5Vd.u3dgZvn_1nWsNyp4ldgXtIyHTPly.G67_p
 49_GUqUE7MvjCZRW.Z4eLnsON1QY92Bj..Ko_kpJ_.nYvbXFNFVvH2FrDmwN70miGOjc4nP9CiQc
 s_MZ2fzsg5n2QPDIAbmrYuy8miapvZaveEkG6LNhpZ2WAYKrgZ9lmOhNbc5KBcgKz.c1qyIElM8X
 RZ.q_83o3kpYPDdHtXrNsWkABNlnm1Y4DTv8Q7hbGS73NQPaTrlu5WNnygdKnJxURKsDtOUuY7L1
 Vloq1BvCwFuR8pT__ZRHJ.RDLHcQpYC40YvlvYDP1vlY4cTn_GDE.NDrvtkBluQuNznyJlhPBy5n
 F9TRYn5Gpv8mt5pEA_cTCrf0pO7UfNurq9vB30Xe3DDqQIOWPEvxqJ4Ini73fu0Fs23_kFkKEJYn
 m0KVr_KeGuf19Fil9dPKCGoCX7QGesRVgLQkgN3OOiuRyQ9mL9y5O2kwTBUaP__qNIIEiUonLHo9
 xakTWFcSWsUzT16SlAolKoMi6BrdcJXyhCeeLhGv3IAU5Zz7CXfOuADLFy9lRFdelhm9KQ18.juH
 XAjLxB.RXyxF0_W3Akd8zKcgNKr3h1p11xGV9VBrK9IYRt8P61ijNNWXx4xWr3lf0Y89IdeXAuEy
 SqxUhaRHhCB2RaxWO0guzdBPxX7JuLcpvYJYR9i5PCjf7vGmWT824TINpCsaRL3QcTY9xBWkEN3V
 Q4FMYiSux7bmRFcaDibKaWqqxZ312eDNG_ojaDmoV.2DMoehNZVpeAX1zXT9kW71tmKfd754zVwj
 pl3o4QU22.n5zZYVqMZFbKsM6eKla26jdVkfa8.Tl1jB02ESE3npRcx1aZdyRt2oE0G98jYpzTQ9
 Sr0mZlKrYPUarKQbsJhPtgTJvJs.DURE9yd53k2PGk1PoKe2AKIhQl9vvXGpPBKM5BQso_5x08Vn
 121mEOFLs08TEQ2ce.TdYUNRv19SG.bT4POEjE4bKZUVP2RpnceJf_LCEPOusVS2eK9oLoTwI1cr
 4Xdf.0FyoLmcuoDQNvUO0J1_SJmhfeLiiNCLvrLXZt_CmTD_dJ5PXjB6KmAO7.9l6JrP4.0d4pyh
 _WHV_YkPRnFHhtWfuN.1gqmkGPDPipvVBD.6m9ZAOMKauUxGV0I8B7bdF9FOkXBAhiFl3HqtG1Jp
 AjYBT23DhKKTStZIH93Sk_3snoFg5gmvxaY0PfQfUIe1cG8fHeRTDwlrogl9BlaiMYOwqeDXPCXB
 P95.JWUsgdD6ve5Z9Ps1ISn672b3j6TXeB2UusbvvZa4SFZVG0YdsDNZf_t_6mw1MW3xchOKp.q6
 SYXLhXQntCPNiAS5.B8aAH_rUdwXs5tOY8prSAyhpxtJmYKFvrKqGEVA8QXSoJ7XSxH4wMaW_Kg7
 .qnfgJzz1U4H.Plx9PTw4xuRbkFQ4w0i3ABhNw1A-
X-Sonic-MF: <alex_y_xu@yahoo.ca>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Mon, 9 Aug 2021 16:51:57 +0000
Received: by kubenode545.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 107921d25eb4207a66c39d07ac0cf5bf;
          Mon, 09 Aug 2021 16:51:52 +0000 (UTC)
Date:   Mon, 09 Aug 2021 12:51:48 -0400
From:   "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Cc:     stable <stable@vger.kernel.org>
References: <162850274511123@kroah.com>
        <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
        <YRFXe06Eih48qlD7@kroah.com>
In-Reply-To: <YRFXe06Eih48qlD7@kroah.com>
MIME-Version: 1.0
Message-Id: <1628527244.3ckns4zvnz.none@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.18796 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Greg Kroah-Hartman's message of August 9, 2021 12:27 pm:
> On Mon, Aug 09, 2021 at 09:23:00AM -0700, Linus Torvalds wrote:
>> On Mon, Aug 9, 2021 at 2:52 AM <gregkh@linuxfoundation.org> wrote:
>> >
>> > The patch below does not apply to the 4.4-stable tree.
>>=20
>> It shouldn't.
>>=20
>> The pipe buffer accounting and soft limits that introduced the whole
>> "limp along with limited pipe buffers" behavior that this fixes was
>> introduced by
>>=20
>> > Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated=
 in pipes")
>>=20
>> ..which made it into 4.5.
>>=20
>> So 4.4 is unaffected and doesn't want this patch.
>=20
> But that commit showed up in 4.4.13 as fa6d0ba12a8e ("pipe: limit the
> per-user amount of pages allocated in pipes") which is why I asked about
> this.  The code didn't look similar at all, so I couldn't easily figure
> out the backport myself :(
>=20
> Willy, any ideas?
>=20
> thanks,
>=20
> greg k-h
>=20

alloc_pipe_info was heavily modified in 09b4d19900 ("pipe: simplify=20
logic in alloc_pipe_info()") and a005ca0e68 ("pipe: fix limit checking=20
in alloc_pipe_info()"), which I think landed in 4.9 and weren't=20
backported. The backported patch should look similar to this:

@@ -621,7 +621,7 @@

                if (!too_many_pipe_buffers_hard(user)) {
                        if (too_many_pipe_buffers_soft(user))
-                               pipe_bufs =3D 1;
+                               pipe_bufs =3D 2;
                        pipe->bufs =3D kzalloc(sizeof(struct pipe_buffer) *=
 pipe_bufs, GFP_KERNEL);
                }

I can send a rebased patch, but I think we can also leave it the way it=20
is. It's a bit of an edge case; if nobody's hit it so far on 4.4, maybe=20
it can just stay this way until February. There's SLTS, but I don't=20
think they're interested in this kind of patch. Thoughts?

Cheers,
Alex.
