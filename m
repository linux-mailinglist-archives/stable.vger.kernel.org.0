Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C76A99B0
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 15:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCCOj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 09:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjCCOjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 09:39:49 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F37A199
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 06:39:47 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id r40so1981910oiw.0
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 06:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677854387;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vc/2NQRQk16ve/0Vl/Q/keTIxoyosmZ4FXbANNDHG5k=;
        b=VJjEZfXeZMeWNzfHRhxI7+FAU68j2H/ZjImxiinRRAAN2IUJIzuMckwzQlYzLUwuqT
         R/tQ8J9lXy3ZMG/HJRQuO4K3MJYI7JavGIRq9qtxAAVebzHwlKpQI0nTXlxjOkf4yDHl
         kRW2DriU54l0if1TTDDiIWKNUX18ua/ZvF2qYs1DFFj0C0s0fyppTSk9MvfxdcUfa1Wq
         dgsyx9LLEVLwu7FY+z5ls+PRO8aqVfP5LlbfkjYl+jt5vKgOiUHXl4pNS5WlXc89Ugbx
         x8AWbhucQV2fuKiGiqTU2Agu1fv63voP16qoN6aayRleYZD9Yp4Ojctw1Udb2iXm82uq
         r8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677854387;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vc/2NQRQk16ve/0Vl/Q/keTIxoyosmZ4FXbANNDHG5k=;
        b=4RJ06UuORPN53kP47+dy+3JLGzzBsxqyyt1yEKtOo2K3dhGNSRF7XFxVcOS19YbHvi
         EaiS+2G7S4O6ccJ60xyhElnLKYYkK+b613VxAkUirjNhZjMATCp3kwkVzSOWt8qS8nEQ
         DlsJhxvUjM85O5RT86+T5toZYgXFpQDq+usmWyPeNwQ21S2ijYlZBUdsemSBOkgQvtmH
         1VzxsGBJCRUh/ZveQwfPC/W5Re0g6b0RtZ1dUVSHYJttK9p5Wg8ZwtluhHbovO3t7/YU
         54oUFy/s2QLFlFFIDmRtKNHohhJ+rNCPG1P5bAKqhKNPPLaU7Xe9AZZkm4IZaYH17n/g
         OD6w==
X-Gm-Message-State: AO0yUKVIM+xMf+R/bOt/OjeB9sLJ7BBiNhiSh4SXJnV4u8SXZYsW9qhS
        M1I1vjFyqtJ1EL+WP93UOBh4nAkV7tTYr5/JUio=
X-Google-Smtp-Source: AK7set9p4EO3RfeM4r5oAzSZw4xrjyLgtEVpsAx0zYxxf4UM1NX2Ckbu+eUIPr4/kKp9YMZGsOqAGo6pOGBcui2UOhQ=
X-Received: by 2002:a05:6808:2343:b0:384:474c:c6a6 with SMTP id
 ef3-20020a056808234300b00384474cc6a6mr629723oib.2.1677854386751; Fri, 03 Mar
 2023 06:39:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:3b87:0:0:0:0:0 with HTTP; Fri, 3 Mar 2023 06:39:46 -0800 (PST)
Reply-To: MarkDossou@consultant.com
From:   "MR. MARK DOSSOU" <officelawman40@gmail.com>
Date:   Fri, 3 Mar 2023 15:39:46 +0100
Message-ID: <CAEKRo_wJ1GgMGbZo=MWCRn4YrvqMSXKYVzjFNAAQ7GPGti-Pmw@mail.gmail.com>
Subject: =?UTF-8?B?ccSrbifDoGkgZGUgUMOpbmd5x5J1LA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,MIXED_ES,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TUFSSyBET1NTT1UmIExBV0ZJUk0mIEFzc29jaWF0ZXMNCmrDuiAwMSBCUCA3NTk0DQprxJMgdHXF
jSBux5QgMDIyOSBiw6hpIG7DrW5nIGfDsm5naMOpZ3XDsw0KDQpxxKtuJ8OgaSBkZSBQw6luZ3nH
knUsDQoNCm3Em2lox45vIGRlIHnEq3RpxIFuLCBux5AgaMeObyBtYT8gV8eSIHjEq3fDoG5nIGjE
m24gaMeOby4gSMSbbiBiw6BvcWnDoG4gemjDoG55w7JuZw0KbsOtbiBkZSBzaMOtamnEgW4geceQ
asOtIHTEgSBrxJtuw6luZyBodcOsIHLDoG5nIG7DrW4gc2jFjXUgZMOgbyB3x5IgZGUgeGnEgW94
xKsgw6lyDQpnx45uZMOgbyBqxKtuZ3nDoCwgemjDqCBqdcOpZHXDrCBzaMOsIHfHkiBjaMO6bGUg
emjDqCB6aMeSbmcgZsSBbmdmx44gemjEqyB3w6BpIG3DqWl5x5J1DQpyw6huaMOpIHHDrXTEgSBm
xIFuZ2bHjiBrxJt5x5AgamnEm2p1w6kgZGUgd8OobnTDrSwgZMOgbiB3x5IgaHXDrCB3w6hpIG7D
rW4gdMOtZ8WNbmcgZ8OobmcNCmR1xY0gc3XHkiB4xasgZGUgeMOsbnjEqywgc3XHknnHknUgd8eS
IHjFq3nDoG8gZGUgc2jDrCBuw61uIHpow61kw6kgeMOsbmzDoGkgZGUgaMOpenXDsiwNCnnHkCBx
dcOoYseObyB3x5IgYseOb2jDuSB5x5AgZ8O5IGvDqGjDuSBkZSB6aMOgbmdow7kgamnDoHpow60u
DQoNClfHkiBzaMOsIHnHkCBnw7kgZ8WNbmdjaMOpbmdzaMSrIGRlIEhvbiBCYXJyaXN0ZXIgTWFy
ayBEb3Nzb3Ugc8SrcsOpbiBsx5xzaMSrLg0KQWxleCAwMDAwMCwod8eSIHnHkCBnw7kgZGUga8Oo
aMO5KSBzaMOsIHnEqyBtw61uZyBodcOgeHXDqSBnxY1uZ2Now6luZ3NoxKssIHTEgSB6w6BpDQoy
MDEzIG5pw6FuIHnHlCBqacSBcsOpbiB5xKtxx5Agc8eQIHnDuiBjaMSTaHXDsi4gVMSBIHrDoGkg
eMSrZsSTaSBjw7NuZ3Now6wgeceUIHl1w6FuecOzdQ0KeGnEgW5nZ3XEgW4gZGUgecOod8O5LCBk
w6BuIHpow7kgesOgaSB3x5IgZGUgZ3XDs2ppxIEsIHfHkiBjaMeUbMeQIHTEgSBkZSBzdceSeceS
dQ0KZseObMecIHnDqHfDuS4NCg0KWcOzdXnDuiBsacOhbmjDqSB5w61uaMOhbmcgZMeSbmdzaMOs
aHXDrCB6w6BpIHTEgSBxw7lzaMOsIGjDsnUgemjHkHNow6wgd8eSIHjDum56aMeObw0KdMSBbWVu
IHnHkCBnw7kga8OoaMO5IGRlIGTDoCBxxKtuc2jHlCwgdMSBIGppxIFuZyB6dcOyd8OpaSB0xIEg
emjDoG5naMO5IGppw6B6aMOtIDEwLjcNCk3Em2l5dcOhbiBkZSBzaMOydXnDrCByw6luLCB5xKtu
Y8eQIHfHkiBxx5BuZ3Fpw7ogbsOtbiBkZSBow6l6dcOyIHnHkCBzaMWNdWh1w60gdMSBIGRlDQp6
xKtqxKtuIGLHjmkgd8OgbiBtxJtpeXXDoW4uIFLDumd1x5Igd8eSIGLDuW7DqW5nIGrHkG5rdcOg
aSB6aMeQZMOsbmcgcsOobmjDqSBzaMOydXnDrA0KcsOpbiwgZ8SBaSB6aMOgbmdow7kgamnEgW5n
IGLDqGkgbcOyc2jFjXUgd8OpaSB3w7ogcsOpbiByw6hubMeQbmcgZGUgesSrasSrbiwgecSrbnfD
qGkNCnTEgSB5x5BqxKtuZyB4acWrbWnDoW5sZSBqacSBbmdqw6xuIDEwIG5pw6FuLiBZxKtuY8eQ
LCB3x5IgeMSrd8OgbmcgbsOtbiBkZSBow6l6dcOyDQp0xY1uZ2d1w7IgaMOpZseOIHpox5Bkw6xu
ZyBuw61uIHp1w7J3w6lpIHNow7J1ecOsIHLDqW4gbMOhaSBxdcOoYseObyBqxKtqxKtuIGRlIMSB
bnF1w6FuLA0KecSrbnfDqGkgd8eSIGRlIGvDqGjDuSBxw7lzaMOsIHNow60gd8OoaSBsacO6IHhp
w6AgecOtemjHlCAodMSBIGRlIMOpcnppIGTDoCB3w6hpIHNow6wNCmrDrG5xxKtuKS4gV8eSIGpp
xIFuZyB3w6hpIG7DrW4gdMOtZ8WNbmcgc2jHkCBjx5AgamnEgW95w6wgaMOpZseOIGLDrG5nIHNo
xJNucceQbmcNCnrEq2rEq24gc2jDrGbDoG5nIHN1x5IgeMWrIGRlIHN1x5J5x5J1IHhpxIFuZ2d1
xIFuIHjDrG54xKsuDQoNCkbEgXPDsm5nIGfEm2kgd8eSIHhpw6BtacOgbiBkZSB4acOhbmd4w6wg
eMOsbnjEqywNCg0KbsOtbiBkZSBxdcOhbiBtw61uZzogLi4uLi4uLi4uLi4uLi4uLi4uLi4uDQpM
acOhbnjDrCBkw6x6aMeQOiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLg0KTmnDoW5sw61u
ZzogLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uDQpTaMeSdWrEqyBow6BvbceOOiAu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uDQpaaMOtecOoOiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4NCg0KR8eObnhpw6ggbsOtbiBodcSBIHNow61qacSBbiB5dcOoZMO6LCBy
w7pndceSIG7DrW4gbsOpbmcgY2jHlGzHkCBox45vLCB3x5IgamnEgW5nDQpkxJtuZ2TDoGkgbsOt
biBkZSBodcOtZsO5LiBaaMO5ecOsOiBRx5BuZyB0xY1uZ2d1w7Igd8eSIGRlIGRpw6BueseQIHnD
s3VqacOgbiBkw6x6aMeQDQooTWFya0Rvc3NvdUBjb25zdWx0YW50LkNvbSkgeGnDoG5nIHfHkiB0
w61nxY1uZyBzaMOgbmdzaMO5IHjDrG54xKssIHnHkCBodcOycceUDQpnw6huZyBkdcWNIHhpw6Fu
Z3jDrCB4w6xueMSrIGjDqSBsx5BqacSbLg0KDQpDx5B6aMOsLA0KbceOa8OowrdkdcWNIHN1x5Ig
eGnEgW5zaMSTbmcNCnDDrW5nZMSbbmcgeceUIGfFjW5ncMOtbmcgbMecc2jEqyBzaMOsd8O5IHN1
x5INCg==
