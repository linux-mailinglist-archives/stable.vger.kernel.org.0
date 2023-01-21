Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8E676891
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 20:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjAUTnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 14:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjAUTnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 14:43:40 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B4D1BADB
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 11:43:39 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z3so6264273pfb.2
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 11:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:content-language:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iwwJbLg03M2akhgrqq3yLCNb5yitksCqvarRvGc6KJ0=;
        b=2/plLEnqzK+rWZoJ1tK2/buuMqVLefVKO00vjVSd5uMvBAEXbpqNB0pmtoGL6Ig8i2
         Wq014fGGwkC8XOQGiNfNm7VX1Fl9J43m0uQJbaCjoSmztuIIYvhuZb7ygy/dh1/GBdpq
         rvcJaQPDR4DaFSh2Fo/OJxvOMay4DreuoAQhxgmcOF2YQExWSbAHNACTwQT94T1FoDM2
         ZUNF1g29kvPdW+IVvte78+bi9T2mGFNeCbrBFmeEdfF9vEQs7BAbB4V9lx2Y2En5Fc1G
         Z0zhFtuZUedUQclLKZIqr+0K2LUWK06ol6XPRX/kVPkNe/I/JRJS/aiLPS2uF0iYNbis
         awYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=subject:from:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwwJbLg03M2akhgrqq3yLCNb5yitksCqvarRvGc6KJ0=;
        b=c69L6GdmYEF2GuNmCfSbUVcTCo8HH76jcdMLQcx0ubn5vdCUDAkIULecK0omzMfV5C
         UaD//ByU1TYp6YegMezHm0yTnHFMkMqnn5nasznWwWeOTsjxO9w9Hktw3tPKC6L55Ztz
         pBf1GWZgDEmGiS7TlgZWhcVOVNIApQ0get9azGM+LTZPVKN1hYv6/MqBp4KetU2/oafN
         C+h4xWlzlkQJkoTSj/gD2PM19yVRxeNGnJPPBdv8XGHoTP0+vL9Pa6Vl32Ocdl6I0qDS
         w427QdokY/3uXRuyVMbJ+6SShW/7Vi/6rFwbO8G9jTszV/fF8JdgqbbWmB+xih5qVI4S
         WHfQ==
X-Gm-Message-State: AFqh2koRdpZd2C2wTT/51J5FOYC9FkcKcWEjJp+1vQUPpeqF/QTbjtmW
        RlwrWVgs+E2+ra3AxAgefGKtFxIEBiOq6y4v
X-Google-Smtp-Source: AMrXdXtg/LYGinCPb3jNiHIklEljkVMiQyyeL1/wgAn2WLmWBmSUQT8E8gacwnowPA9QfnG63OjY9A==
X-Received: by 2002:a62:f243:0:b0:583:3bb3:4392 with SMTP id y3-20020a62f243000000b005833bb34392mr4386258pfl.3.1674330218896;
        Sat, 21 Jan 2023 11:43:38 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p2-20020aa79e82000000b005825b8e0540sm12908119pfq.204.2023.01.21.11.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 11:43:38 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------bgb6pa72mSicp50BBE1r3Au4"
Message-ID: <318fe114-04d9-5de8-6670-74aa0d624f10@kernel.dk>
Date:   Sat, 21 Jan 2023 12:43:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: One more 5.10/5.15 stable backport
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------bgb6pa72mSicp50BBE1r3Au4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Noticed one more missing patch, here's a backport that applies to both
the 5.10 and 5.15 stable branches. Please apply to both of them, thanks!

-- 
Jens Axboe

--------------bgb6pa72mSicp50BBE1r3Au4
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-ensure-that-cached-task-references-are-alwa.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-ensure-that-cached-task-references-are-alwa.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBlOTJiNDA2MjBkMDliMDNlNjJjZDVjNTNkZjQ4MzU0Yzg5MzVmYWIzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFNhdCwgMjEgSmFuIDIwMjMgMTI6MzY6MDggLTA3MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZW5zdXJlIHRoYXQgY2FjaGVkIHRhc2sgcmVmZXJlbmNlcyBhcmUgYWx3YXlz
IHB1dAogb24gZXhpdAoKY29tbWl0IGU3NzVmOTNmMmFiOTc2YTJjZGI0YTdiNTMwNjNjYmU4
OTA5MDRmNzMgdXBzdHJlYW0uCgppb191cmluZyBjYWNoZXMgdGFzayByZWZlcmVuY2VzIHRv
IGF2b2lkIGRvaW5nIGF0b21pY3MgZm9yIGVhY2ggb2YgdGhlbQpwZXIgcmVxdWVzdC4gSWYg
YSByZXF1ZXN0IGlzIHB1dCBmcm9tIHRoZSBzYW1lIHRhc2sgdGhhdCBhbGxvY2F0ZWQgaXQs
CnRoZW4gd2UgY2FuIG1haW50YWluIGEgcGVyLWN0eCBjYWNoZSBvZiB0aGVtLiBUaGlzIG9i
dmlvdXNseSByZWxpZXMKb24gaW9fdXJpbmcgYWx3YXlzIHBydW5pbmcgY2FjaGVzIGluIGEg
cmVsaWFibGUgd2F5LCBhbmQgdGhlcmUncwpjdXJyZW50bHkgYSBjYXNlIG9mZiBpb191cmlu
ZyBmZCByZWxlYXNlIHdoZXJlIHdlIGNhbiBtaXNzIHRoYXQuCgpPbmUgZXhhbXBsZSBpcyBh
IHJpbmcgc2V0dXAgd2l0aCBJT1BPTEwsIHdoaWNoIHJlbGllcyBvbiB0aGUgdGFzawpwb2xs
aW5nIGZvciBjb21wbGV0aW9ucywgd2hpY2ggd2lsbCBmcmVlIHRoZW0uIEhvd2V2ZXIsIGlm
IHN1Y2ggYSB0YXNrCnN1Ym1pdHMgYSByZXF1ZXN0IGFuZCB0aGVuIGV4aXRzIG9yIGNsb3Nl
cyB0aGUgcmluZyB3aXRob3V0IHJlYXBpbmcKdGhlIGNvbXBsZXRpb24sIHRoZW4gcmluZyBy
ZWxlYXNlIHdpbGwgcmVhcCBhbmQgcHV0LiBJZiByZWxlYXNlIGhhcHBlbnMKZnJvbSB0aGF0
IHZlcnkgc2FtZSB0YXNrLCB0aGUgY29tcGxldGVkIHJlcXVlc3QgdGFzayByZWZzIHdpbGwg
Z2V0CnB1dCBiYWNrIGludG8gdGhlIGNhY2hlIHBvb2wuIFRoaXMgaXMgcHJvYmxlbWF0aWMs
IGFzIHdlJ3JlIG5vdyBiZXlvbmQKdGhlIHBvaW50IG9mIHBydW5pbmcgY2FjaGVzLgoKTWFu
dWFsbHkgZHJvcCB0aGVzZSBjYWNoZXMgYWZ0ZXIgZG9pbmcgYW4gSU9QT0xMIHJlYXAuIFRo
aXMgcmVsZWFzZXMKcmVmZXJlbmNlcyBmcm9tIHRoZSBjdXJyZW50IHRhc2ssIHdoaWNoIGlz
IGVub3VnaC4gSWYgYW5vdGhlciB0YXNrCmhhcHBlbnMgdG8gYmUgZG9pbmcgdGhlIHJlbGVh
c2UsIHRoZW4gdGhlIGNhY2hpbmcgd2lsbCBub3QgYmUKdHJpZ2dlcmVkIGFuZCB0aGVyZSdz
IG5vIGlzc3VlLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKRml4ZXM6IGU5OGU0OWIy
YmJmNyAoImlvX3VyaW5nOiBleHRlbmQgdGFzayBwdXQgb3B0aW1pc2F0aW9ucyIpClJlcG9y
dGVkLWJ5OiBIb21pbiBSaGVlIDxob21pbmxhYkBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6
IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpb191cmluZy9pb191cmluZy5j
IHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggZTg4
NTJkNTZiMWVjLi5mOGEwZDIyOGQ3OTkgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5n
LmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtOTUxMyw2ICs5NTEzLDEwIEBAIHN0
YXRpYyB2b2lkIGlvX3JpbmdfY3R4X3dhaXRfYW5kX2tpbGwoc3RydWN0IGlvX3JpbmdfY3R4
ICpjdHgpCiAJLyogaWYgd2UgZmFpbGVkIHNldHRpbmcgdXAgdGhlIGN0eCwgd2UgbWlnaHQg
bm90IGhhdmUgYW55IHJpbmdzICovCiAJaW9faW9wb2xsX3RyeV9yZWFwX2V2ZW50cyhjdHgp
OwogCisJLyogZHJvcCBjYWNoZWQgcHV0IHJlZnMgYWZ0ZXIgcG90ZW50aWFsbHkgZG9pbmcg
Y29tcGxldGlvbnMgKi8KKwlpZiAoY3VycmVudC0+aW9fdXJpbmcpCisJCWlvX3VyaW5nX2Ry
b3BfdGN0eF9yZWZzKGN1cnJlbnQpOworCiAJSU5JVF9XT1JLKCZjdHgtPmV4aXRfd29yaywg
aW9fcmluZ19leGl0X3dvcmspOwogCS8qCiAJICogVXNlIHN5c3RlbV91bmJvdW5kX3dxIHRv
IGF2b2lkIHNwYXduaW5nIHRvbnMgb2YgZXZlbnQga3dvcmtlcnMKLS0gCjIuMzkuMAoK

--------------bgb6pa72mSicp50BBE1r3Au4--
