Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC453E263
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiFFIMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiFFIMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:12:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2644657F
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 01:12:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so11986755pjs.1
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 01:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CrA4YBm/C0o/d7+8DPi9KXWYpOuSBuqwF7Z6o0fXbnA=;
        b=gvremHlAPslmXudVGz4LjTSuC9ZMLa9iVUVIiYwwY4RQjPzhFMBrgkLB1zk7i2h0wj
         CIAId/DwvN7bsuRzcpGNEDD6OLtNiymSOo3zrNIgpTilud0CYP00fgPPm+pKIk+Oq6cN
         JpzKLgroUsDWQWWzUfgWRXss3Y31CqB1brIw6hcaLHJ3scO7Rt+EoUO0s0RcZifFGo9W
         qAH2DzTdbxO2mp1vGgUQHJbJLH25ygp5k8CLj7IAC0wr2TfgKMssKPGu1ipOnpqYmekK
         SFkaeiUhnZP/fJfDCZ0e4k8CzbRSmIagE56iPQPEiKDE08lI70miIMBNMzB1n2bGlezC
         RFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=CrA4YBm/C0o/d7+8DPi9KXWYpOuSBuqwF7Z6o0fXbnA=;
        b=HIztfmb+j95N5aHVOxGhcGrdm5hb1YLr631IjbmJtkft6JDPt0pkF5uL4c7fj6nzrK
         ZgzDE3N2bserWvDHXH5+DzLrFBjN0yZMUkNtLVX0h84Z8m8E5QhPtQ+51yEdENSMnk+f
         FhUiJc3T9UBX1gty4MIEc77kZcUCFCZrt2yuJ3nXS9uv6is6/Qw2b6aIv7GYjKPOE+CJ
         ivp/X4WkcJq8MMWl85iavLYQnrxTotlBLJGP2qfaxCcK9XzUby3ToENNPadjuJ9eoIN6
         Ia4b0bsgIGrHVdw2krJSx0AFGeAipz8aBWywaCy90qAC1SlTW6ov/572OQDWAr07ANuk
         iqXw==
X-Gm-Message-State: AOAM533dIwjRgyIF3YkmiHoXbZRCg9HthrWhj7zF7fsXfZGpB3K5TX4v
        GE6IzwZx5Ga6z+auHfUoX3h7lqu+UD8BHm/Yee8=
X-Google-Smtp-Source: ABdhPJxq3UNkhf3RuxbwrxcMd3J9XyQkX6r4Yy7SPKnJYxV0iJdyD/VKakiuFszqR3cbB4C0h4W/WM8IkGsk6tm+SsE=
X-Received: by 2002:a17:902:ecc1:b0:167:74c3:55b1 with SMTP id
 a1-20020a170902ecc100b0016774c355b1mr6545346plh.108.1654503152524; Mon, 06
 Jun 2022 01:12:32 -0700 (PDT)
MIME-Version: 1.0
Sender: dr.alitrouni@gmail.com
Received: by 2002:a17:902:f549:b0:167:6547:ff4d with HTTP; Mon, 6 Jun 2022
 01:12:31 -0700 (PDT)
From:   AISHA GADDAFI <madamisha00@gmail.com>
Date:   Mon, 6 Jun 2022 09:12:31 +0100
X-Google-Sender-Auth: tWZL7V8KnODIQVFiPXytdbICUOk
Message-ID: <CAE+xecBbP--8PZHm5HCVdEX5F+qrLYS0G4sRhso-OTnVCc6UEg@mail.gmail.com>
Subject: =?UTF-8?B?15HXkden16nXlCDXkNeg15kg16bXqNeZ15og15DXqiDXoteW16jXqtea?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_50,
        BODY_EMAIL_419_FRAUD_GM,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,
        MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

15HXkden16nXlCDXkNeg15kg16bXqNeZ15og15DXqiDXoteW16jXqteaDQrXkNeg15kg16nXldec
15cg15zXmiDXkNeqINeR16jXm9eq15kg157XodeV15zXmNeg15XXqiDXoteV157XkNefLCDXkdei
15nXqCDXlNeR15nXqNeUINee15XXoden15guDQrXlNeQ150g15DXldeb15wg15zXlNep16rXntep
INeR157Xk9eZ15XXnSDXlNeW15Qg15vXk9eZINec16TXqteV15cg15DXmdeq15og16rXp9ep15XX
qNeqINeU15PXk9eZ16osINeV15zXl9ek16kg15DXqiDXp9eR15zXqteaDQrXnNeU16nXp9ei15Qg
15HXnteT15nXoNeUINep15zXmiDXkdeg15nXlNeV15zXmiDXm9ep15XXqtek15Qg16nXnNeZLCDX
qdee15kg16LXmdeZ16nXlCDXp9eT15DXpNeZINeV157XqteS15XXqNeo16og15vXmdeV150NCteR
16LXldee15DXnywg15DXoNeZINeQ15zXnteg15Qg15XXkNedINeX15Mg15TXldeo15nXqiDXoted
INep15zXldep15Qg15nXnNeT15nXnSAsINeR16rXlSDXlNeR15nXldec15XXkteZ16og15TXmdeX
15nXk9eUDQrXqdecINeg16nXmdeQINec15XXkSDXlNee16DXldeXICjXp9eV15zXldeg15wg15TX
nteg15XXlyDXnteV16LXnteoINen15PXkNek15kpINeV15vXqNeS16Ig15DXoNeZINeg157XpteQ
16og16rXl9eqINeU15LXoNeqDQrXnten15zXmCDXnteT15nXoNeZINei15wg15nXk9eZINee157X
qdec16og16LXldee16DXmS4NCteZ16kg15zXmSDXm9eh16TXmdedINeR16nXldeV15kgItei16nX
qNeZ150g15XXqdeR16Ig157Xmdec15nXldefINeV15fXntepINee15DXldeqINeQ15zXoyDXk9eV
15zXqCDXkNee16jXmden15DXmSINCi0kMjcuNTAwLjAwMC4wMCDXk9eV15zXqCDXkNee16jXmden
15DXmSDXqdeQ16DXmSDXqNeV16bXlCDXnNeU16TXp9eZ15Mg15HXmdeT15og16LXkdeV16gg16TX
qNeV15nXp9eYINeU16nXp9ei15QNCteR15DXqNem15ouINeQ150g15DXqteUINee15XXm9efINec
15jXpNecINeR16TXqNeV15nXp9eYINeW15Qg15HXqdee15ksINeQ16DXkCDXlNep15Eg15PXl9eV
16Mg15vXk9eZINec15DXpNep16gg15zXmQ0K15zXodek16cg15zXmiDXpNeo15jXmdedINeg15XX
odek15nXnSDXm9eT15kg15zXlNeq15fXmdecINeR16rXlNec15nXmiDXlNeU16LXkdeo15QuDQrX
kNeV15PXlCDXnNeq15LXldeR16rXmiDXlNeT15fXldek15Qg15HXkNee16bXoteV16og15vXqteV
15HXqiDXlNeT15XXkCLXnCDXqdec15kg15zXnteY15Q6IG1hZGFtZ2FkYWZpYWlzaGFAZ21haWwu
Y29tDQrXqteV15PXlA0K16nXnNeaINeR15DXnteqINei15nXmdep15QNCiwsLCwsLCwsLCwsLCws
LCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCws
LCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCws
LA0KUGxlYXNlIGkgbmVlZCB5b3VyIGhlbHANCkkgYW0gc2VuZGluZyBteSBncmVldGluZ3MgdG8g
eW91IGZyb20gdGhlIFN1bHRhbmF0ZSBvZiBPbWFuLCBJbiB0aGUNCmNhcGl0YWwgY2l0eSBvZiBN
dXNjYXQuDQpNYXkgaSB1c2UgdGhpcyBtZWRpdW0gdG8gb3BlbiBhIG11dHVhbCBjb21tdW5pY2F0
aW9uIHdpdGggeW91LCBhbmQNCnNlZWtpbmcgeW91ciBhY2NlcHRhbmNlIHRvd2FyZHMgaW52ZXN0
aW5nIGluIHlvdXIgY291bnRyeSB1bmRlciB5b3VyDQptYW5hZ2VtZW50IGFzIG15IHBhcnRuZXIs
IE15IG5hbWUgaXMgQWlzaGEgR2FkZGFmaSBhbmQgcHJlc2VudGx5DQpsaXZpbmcgaW4gT21hbiwg
aSBhbSBhIFdpZG93IGFuZCBzaW5nbGUgTW90aGVyIHdpdGggdGhyZWUgQ2hpbGRyZW4sDQp0aGUg
b25seSBiaW9sb2dpY2FsIERhdWdodGVyIG9mIGxhdGUgTGlieWFuIFByZXNpZGVudCAoTGF0ZSBD
b2xvbmVsDQpNdWFtbWFyIEdhZGRhZmkpIGFuZCBwcmVzZW50bHkgaSBhbSB1bmRlciBwb2xpdGlj
YWwgYXN5bHVtIHByb3RlY3Rpb24NCmJ5IHRoZSBPbWFuaSBHb3Zlcm5tZW50Lg0KSSBoYXZlIGZ1
bmRzIHdvcnRoIOKAnFR3ZW50eSBTZXZlbiBNaWxsaW9uIEZpdmUgSHVuZHJlZCBUaG91c2FuZCBV
bml0ZWQNClN0YXRlIERvbGxhcnPigJ0gLSQyNy41MDAuMDAwLjAwIFVTIERvbGxhcnMgd2hpY2gg
aSB3YW50IHRvIGVudHJ1c3Qgb24NCnlvdSBmb3IgaW52ZXN0bWVudCBwcm9qZWN0IGluIHlvdXIg
Y291bnRyeS4gSWYgeW91IGFyZSB3aWxsaW5nIHRvDQpoYW5kbGUgdGhpcyBwcm9qZWN0IG9uIG15
IGJlaGFsZiwga2luZGx5IHJlcGx5IHVyZ2VudCB0byBlbmFibGUgbWUNCnByb3ZpZGUgeW91IG1v
cmUgZGV0YWlscyB0byBzdGFydCB0aGUgdHJhbnNmZXIgcHJvY2Vzcy4NCkkgc2hhbGwgYXBwcmVj
aWF0ZSB5b3VyIHVyZ2VudCByZXNwb25zZSB0aHJvdWdoIG15IGVtYWlsIGFkZHJlc3MNCmJlbG93
OiBtYWRhbWdhZGFmaWFpc2hhQGdtYWlsLmNvbQ0KVGhhbmtzDQpZb3VycyBUcnVseSBBaXNoYQ0K
