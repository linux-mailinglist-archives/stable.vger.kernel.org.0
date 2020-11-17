Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CCB2B706C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 21:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgKQUn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 15:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbgKQUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 15:43:57 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB38C0613CF
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 12:43:57 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y197so22099710qkb.7
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 12:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=63xsiwtULQ4G6VpX+0Ay1KZ0sy50QK7nr5FZ4J13748=;
        b=JjLWGKprFQ4G64Sh5h0Y6ikJxJ8EGI9AwX9t6km2PcYmnzT6TMJmvOQV2nrpx2Ydez
         HDvUu2pHHzdeN/nP70vNJzeGfccegsLOaXeUzHbA7hZAN/PY4oleAUVkLYp9jkheBv+b
         GPLbHLr2kP9qsfQR77A1UL5ENac/HQJzEv59AXvtDnFmE/Frd3ef1SgtOp2IQjskWpSB
         V9Ha6Yq5wSzCwUX0cCbffciVWjZVB8lKoMx/ZUmT9M3VOBPdfEZmfwAl5kxqlxNpWmg0
         bRKMuiU+xvEbFV8Ee1tk+uS6qiehKUH8/WTPjjIoW3Qu98KVgnZ9X5hAt42CGrcKck96
         VOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=63xsiwtULQ4G6VpX+0Ay1KZ0sy50QK7nr5FZ4J13748=;
        b=j/aKIC57zsZ2bXmKmo+sNSKUAcz9s9iCumghtgPSt0rqs3FBkTqygGbkgZYOSBqHFM
         M3UJgHwikOEK7uEZI4sK2KASAi1FAdxQGSz/g9xP0sIoYmtqlrL2lpp0mnAvw01dlHXx
         SSAsvwXIlRZjkE0E3d/6VN1ZWxrr1VxBRwid8uivGFMOCpu3kNSKp2z1xI6YN2OZpoCf
         IAArIjgLY+9aOxZcykSDv3W8xsnq3Xc1YY6gbfxkumYrO2YTB5N7LEO6fQBSJAwHfla5
         z8CLxxzX42BFwc4f0oFFqaWY57AKeuSnEf3FCGYOfFy3RzbFjqDauJb7h4kHLR5G3+vI
         WioQ==
X-Gm-Message-State: AOAM5300w2HMXTIByjkRzMOBd59OIjixdOrHCb/tI735ELVRTfpQXPjT
        1YwmbMjFdk+C/DUxRHij2CCVg3ZshO7sp341FOc=
X-Google-Smtp-Source: ABdhPJy/EndM+mBIUvM7AyTlpBNrGaKDS97DwKtzNcLCRhKx7n6UGQjv3Gpf9hIR6cmsoceCv3k934GrZlPUch+iYRA=
X-Received: by 2002:ae9:edc1:: with SMTP id c184mr1493338qkg.188.1605645836845;
 Tue, 17 Nov 2020 12:43:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac8:3502:0:0:0:0:0 with HTTP; Tue, 17 Nov 2020 12:43:56
 -0800 (PST)
Reply-To: rhajihaid8888888@gmail.com
In-Reply-To: <CANC2eqGOqaE25_gSaxJ0mAT=+FJtRx+cJ9XEmPicgd5OeO1eCA@mail.gmail.com>
References: <CANC2eqHbN1Cwm9BSDAEv+jkHn8ugWd=R8SK0dqXSNa+_EhPSvQ@mail.gmail.com>
 <CANC2eqEf373Sd98GjKjdF54=vrPVQTpmJ4BM1cVHHZ665_5AaA@mail.gmail.com>
 <CANC2eqF6K0zM02v4-1-1_tskS+UKVsC3SMt1ywhK8k6DrNYzvw@mail.gmail.com>
 <CANC2eqEeXs04VR9AWDX_K+ThTgnYse0jiNtKdKiy+5OANjz0tg@mail.gmail.com>
 <CANC2eqFNmyOpBvbqq9jsCCuMC2v-LQdRNB4WM9hkjqHLsj4XXw@mail.gmail.com>
 <CANC2eqH4+9VSv9e1DcLuo6O7OWeB7dpxPEBw79YsN1vYQ8EaKg@mail.gmail.com>
 <CANC2eqHeYOqyjbj-F5KM-YHCffA5dyLGjgp6A9qrCTz_rf7dBQ@mail.gmail.com>
 <CANC2eqGY-9Wmhgx+sOgS-cuoCQ09dSD6uVtWi4WOXNUu98BZrw@mail.gmail.com>
 <CANC2eqFGRiqgGzoDugaj=9eF8ODmMW1Vt5ayGmZuQXF3uK+PDA@mail.gmail.com>
 <CANC2eqGi06BWBpEjvzrPZEL==jquNZQbrSQi79=ZCdBYi8HrOQ@mail.gmail.com>
 <CANC2eqGFt1FsQ-_mfMwXGL4KnxVOz3pi9E+EySgq_8_Y1oyGBg@mail.gmail.com>
 <CANC2eqHD09o3S6wU4_pa5p+idad2mhUM61b7neRw9pQ=5ivumw@mail.gmail.com>
 <CANC2eqGR=Vgaz_rS_HUfnD1JsVw5cjsiyx_=1W-s-i-naog=Yw@mail.gmail.com>
 <CANC2eqEC=-yVov7kpLE+tr2AuqVpMn86wm9k+jMq184FBUPOsA@mail.gmail.com>
 <CANC2eqFhMYFnFVCnOf_4yEjkAR35cfHEd_Ag43HsK+BPw-uJ6g@mail.gmail.com>
 <CANC2eqEqQo0zOyw=-A3gDMZFXqmWGw9tgi9_Dfm9e2MVupcDuw@mail.gmail.com>
 <CANC2eqEUkHEJ7a04pdBSFN322y5Qrf4V5HLK8ar3SEw6tLZtyQ@mail.gmail.com>
 <CANC2eqGoLwtx0JOp5yhSm4j_vb4osDtx0007jq0_9eS7oDCRaA@mail.gmail.com>
 <CANC2eqHjTpb5QnAEJLEm7=Con-qh9_Z_GCV0ZA6of+tD1BM-Jw@mail.gmail.com>
 <CANC2eqGb7w4zu3=n4+PJ_8QA1enmHjkaY_dSuG3vht_Lz4h8yw@mail.gmail.com>
 <CANC2eqFhP9_Q3rXcVVuj_0NE_s_Aap3B2sFf932HZ_8S3=JsRw@mail.gmail.com>
 <CANC2eqEh_Db_0=S1h=R_wH3s5LL7jvrAWbYDA9uG5amRWkV5+w@mail.gmail.com>
 <CANC2eqFQX6CBvW40VR7T-SUKK5j9=55WXYQRb0Rp13jooDuMfw@mail.gmail.com>
 <CANC2eqExJEiCdYVrZoWJVTNaa2iNNRcyF8K31pHdPn00BeKb+g@mail.gmail.com>
 <CANC2eqF0z144HwvD0wG8dFpcy1+ABb2YJ7_8dygAa55jexXz7g@mail.gmail.com>
 <CANC2eqHHEtQqfGxwi5sZ7oUV5zaDEubV2UKZPNBQ31ahWjj=Cw@mail.gmail.com>
 <CANC2eqF_7Z4mrWeihopqB1Fh51XHKYhMdP_+6e1EMXkc7KeSpw@mail.gmail.com>
 <CANC2eqFm1ja_VXrWT+X4xy72Y==qtocKawgdoU_3aqRcYVi+mA@mail.gmail.com>
 <CANC2eqE73EQwC9xLHOSRXJdOFNhu41LBu8KmBSPb4H5mnqKB+A@mail.gmail.com>
 <CANC2eqHsWLDgusthDcRsSQ_yW_OwOzZ3SL_U7z0X3bhQAEBLNg@mail.gmail.com>
 <CANC2eqGu4JyKRk7qskXPZLJVY4QX61zYkqfwZn60VSZ_fBtnbw@mail.gmail.com>
 <CANC2eqGaCZn9XyGXU4RGw8SrbRN9DwM0NMq3E9YeMxF7SjiS7Q@mail.gmail.com>
 <CANC2eqHA6FD6Hy6C5PpJbnBUO2WhJHeES1zLaWxpyNyFMY563w@mail.gmail.com>
 <CANC2eqGtEDOn_yzv5444fotnTT9N8HN7x21P0PuyinXzXTfXfQ@mail.gmail.com>
 <CANC2eqGskykKPj1nWrLPPL59R15vYL1q9tmW6k6Gudgd0y_8-w@mail.gmail.com>
 <CANC2eqF6AvuMW9fXOuuxs2JBRMmYHVaHpcFiZsOVdMXyjXeB9A@mail.gmail.com>
 <CANC2eqFMZk3MdL6gdLfCFqEVeyoCVGONs=N66KD0JcnnQ+NnKQ@mail.gmail.com>
 <CANC2eqGEe9e_rubyNSaYo3g7=iU=_CHHkGGAzTiLuKxr5m6zkQ@mail.gmail.com>
 <CANC2eqHr2rueY+gHronF63WXy2+SGZFo_CB-rRKBfmiHi4Ad0w@mail.gmail.com>
 <CANC2eqF_==cTSvrVpW2tnxS-q-hXFS06-mAAmiPGLJiqxMXOOg@mail.gmail.com>
 <CANC2eqFEK4CAZM5p=z4qsXGWpD4EQEKafxTQsQ0ofEPscZ9jUQ@mail.gmail.com>
 <CANC2eqFoYSF8bW8=YKekJfprAtdmZhW21eC5LpQu_c5DrfQJ2A@mail.gmail.com>
 <CANC2eqEzXOBkuB5ANorFL3kZsjaVobuHNGqR8PSd57625uyytA@mail.gmail.com>
 <CANC2eqFa59rzS0ehhXioz0H2V3=6oTjrRh045t=8Rx9AVjDnyA@mail.gmail.com>
 <CANC2eqH=bQYuDusTvi9ysQUAzo1hgsBzhqXkQ2Yah7z079SCfw@mail.gmail.com>
 <CANC2eqEo8UTA7e1edG4pEESfV3hYv+KaQBZPc38kk_EVh6+Ohw@mail.gmail.com>
 <CANC2eqFUvq3QXn-2zkRJVNoFVLGXbf_8gZAbeDi9veF3SSQw+g@mail.gmail.com>
 <CANC2eqGfc2m238tx8a4sawWsfbBy3LoDBXt_BWpvy++XnfFtmw@mail.gmail.com>
 <CANC2eqHLqSzz0N-=NXsTLT1SZapetnCfc-cFXXCaWkeu46N0NA@mail.gmail.com>
 <CANC2eqEqOS7dr_WYRriBOe5bkGR4Y_=mw4CBhDsWO7Cfyxr0fw@mail.gmail.com>
 <CANC2eqEUZJAwoqMyh=_1uadr_Xj90uCQFKZFCTNT_mF0C8ETcA@mail.gmail.com>
 <CANC2eqGtOgHnJGW04XE7BYKB-+Wm3zGCeveWZh1EKaUxTwaXUA@mail.gmail.com>
 <CANC2eqE31DEhwHXYG6UBWEw5+pAPpnF35qp7EDfiBzO7iNyoqQ@mail.gmail.com>
 <CANC2eqHiTgo9y4o916ASuVSt-a2S7f-_zByRqt5JSmB=2XBZVg@mail.gmail.com>
 <CANC2eqH2LQj7aYgZrb3t8=OXeGEPm2o0U8n3uY41GwmQB6CLvA@mail.gmail.com>
 <CANC2eqFzQXwEw94N7dHoS8Tt=fs11Piqw36x1JfNvcgp1fLhxQ@mail.gmail.com>
 <CANC2eqGm1AOKy9FJ9sa9TiL44dHS1qMb6hHhijOh9G+2t+040A@mail.gmail.com>
 <CANC2eqFqXv9-t741xRosT4my-SKKOjLFmraUVgCpBb9hB6_qhQ@mail.gmail.com>
 <CANC2eqH5T8Xsq=z8bS0P1Byk3SKkxi7h8LFB6FzKG9+=HDWu+w@mail.gmail.com>
 <CANC2eqHcenAVwMFzaBrbEyt0_8fy_niEhd8czREuo0DSPTq2eg@mail.gmail.com>
 <CANC2eqGXRa7ACWND6Z6oXZMTODMiYNYQhij_FFid-HK3D9-L2A@mail.gmail.com>
 <CANC2eqHTAT5viEGfXOywmwvi5_2_3vMAfCk3LiO38z0LuVWLmg@mail.gmail.com>
 <CANC2eqHsLD2SJPr3k1HSXzh5borS-d8DDip2-Lvvgyr2mmFqFw@mail.gmail.com>
 <CANC2eqEnuPFh09KC-Ux29bpc877ELbMaBH4-AoSth+Gou-f2zg@mail.gmail.com>
 <CANC2eqHHtwcmhZQLDJoG4BdjG3xw9FujW-bYWdQzj1OkKqzQsA@mail.gmail.com>
 <CANC2eqFNBVDz81jz-e-yBak5-o2A=jkBb+zy4LN5ZRyybbYtfA@mail.gmail.com>
 <CANC2eqE-H3M7hgpaaD3ZY8kS8Z2dU0xGHaE4YzMhYR_WNAosmQ@mail.gmail.com>
 <CANC2eqEh3uYQM=cPRCn-3o1f0COd4AH66=LPxmX9hvQzim1JyQ@mail.gmail.com>
 <CANC2eqHvC++TXsFS3Ft0rPg+_vu40+MUporyGrChb0bw88Unaw@mail.gmail.com>
 <CANC2eqGm04TSX2nMkL3xhPUV=3ocy15w91+CUKPBCgmDhuogaQ@mail.gmail.com>
 <CANC2eqHnSh+4YrDLGd8_=4+J=dKAKNyxuPL4wX=HkL1KdVB-pw@mail.gmail.com>
 <CANC2eqFBx9J5NjW72dwe5fob6jyYuieE+6e=BmNcN=Wse5uErQ@mail.gmail.com>
 <CANC2eqGpEgPbASHMRf-VgU1fi-N=moOhwvzwXxj6nMbkWz1FPQ@mail.gmail.com> <CANC2eqGOqaE25_gSaxJ0mAT=+FJtRx+cJ9XEmPicgd5OeO1eCA@mail.gmail.com>
From:   Mr Rhaji Haid <johnmoor1002@gmail.com>
Date:   Tue, 17 Nov 2020 22:43:56 +0200
Message-ID: <CANC2eqEpfsJxZRzwTiBir7Wzj7i1ihnmG7Z4fooR69x_NEzxdQ@mail.gmail.com>
Subject: URGENT ASSISTANT NEEDED
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend

you may be surprise to receive this mail since you don=E2=80=99t know me
personally, but with due respect, trust and humility, I write to you
this proposal. I am Mr. Rhaji Haid the son of Mr Tariq Haid of Darfur
Sudan. It is indeed my pleasure to contact you for assistance of a
business venture which I intend to establish in a country with a
stable economy.

 I got your contact while I was doing a private research on the
Internet for a reliable and capable foreign partner that will assist
me and my family to transfer a fund to a personal or private account
for investment purpose.  Though I have not met with you before, but
considering the recent political instabilities in my country, I
believe one has to risk confiding in success sometimes in life.

There is this huge amount of money (US$18 Million.) EIGHTEEN MILLION
UNITED STATES DOLLARS ) which my late Father deposited here in South
Africa awaiting claim before he was assassinated by unknown persons
during this war in Darfur Sudan.

Now I have decided to invest this money in a stable economy country or
anywhere safe for security and political reasons. I want you to help
me retrieve this money for onward transfer to any designated bank
account of your choice for investment purposes on these areas below:

1) Transport Industry

2) Mechanized agriculture.

3} Estate investment

I will then furnish you with more details and I have mutually agreed
to compensate you with 30% which is your share for assisting me, and
5% for any expenses that might be incurred by both parties in the
course of the transaction. Then the remaining 65% will be for me and
my family, which you will help us to invest in your country.

Please, you can contact me through this Email rhajihaid8888888@gmail.com
all require is your honest & kind co-operation. I will give you
further details as soon as you show interest in helping me. I wait for
your kind consideration to my proposal.

Best Regards,
Mr.Rhaji Haid
