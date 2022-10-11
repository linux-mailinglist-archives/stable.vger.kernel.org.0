Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8B35FB898
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 18:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJKQwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 12:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJKQw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 12:52:29 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4378BA8CD0
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 09:52:21 -0700 (PDT)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 10C333F483
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1665507139;
        bh=G9FIrwOq5jqn12Do6LwEO9BHB3Wb2O5VwjjbsZsmfdg=;
        h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type;
        b=PMopUY0hy47tI64e4VB2l/NQSf9OiOcZmTuVZgSQFziCQRy6TfDNmdIndAIFrfki9
         LweUuJxZ2TdqiSYn8gtuYeGkcrA/WdnMJGtCDWJYnOe4BGpI/IHFV0N0kk8spaAEJM
         iYLBq2NDssP9m6SJAvZR2nSZgseojoY/qO43ywzR4KxG3Fxu6xMgcr2z6wojZx5ZFT
         HjOi2uCoFDOCaXXVO/tn4qQVY8/NHHJgildzBQaF1hPode8sy83qIccMBzj08Auyct
         i+dwvh64XKcGq3mouRHc892+0Wc/8WGNVUEhaiAF9/O0NkSmO7ClX+j5TPUP1upkdY
         9/N35a/gRokjw==
Received: by mail-wr1-f72.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so4106547wrg.21
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 09:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9FIrwOq5jqn12Do6LwEO9BHB3Wb2O5VwjjbsZsmfdg=;
        b=GJqNxlyq6kgDqDSmac52MtLaANrWLB36/LUVep2murM4AvglgVLgT8XgWfe+zgZV2z
         zo05RgXCw9qLKyTShB77gTlVh48Ym0bjwzC2WfsIqiPhmcBqd366NEPBd/XH05/+ayEe
         aQEy6RkTnm537GviCnn0Al3/OK80F3MCHFpRRB08y3A0J7Y6lGSG3EeVvKnBomI8LV1C
         qjx/cNtzuam+dwkt1YIE8OkhxL6MhXrBHY9PjcwP2/3/gIGCRYzVkBNBG2C5A17VMJxb
         HCC0IwJ3SHW1lk7z/w6y6yG9GCoIHJ3/rrdWfZHURXlmFGmhKmj/g7ge5meMGYSjRd8i
         WvrA==
X-Gm-Message-State: ACrzQf0r7vgR/MGnGeK2WlVC639ZNa0tMb+IxjT94aIyCO+vYqMWZNdH
        1NnQZc9sMgYgkxTTmkE3fJPnohlH3wKsHUmck6J8HiwPktew9T214xLmKTuobJMMTdt9HVSkawX
        eZchQYsanenWa20DxhCkWA5j/+0+uUgH4UQ==
X-Received: by 2002:adf:f710:0:b0:22c:d668:504e with SMTP id r16-20020adff710000000b0022cd668504emr15632058wrp.98.1665507136534;
        Tue, 11 Oct 2022 09:52:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM62BZlONGt70hun353coJB4OjIYnf5wi5JUwzBGEIq0Tg3ZGZyL9z1pYmkcN1Mo6Ul5wy7zDA==
X-Received: by 2002:adf:f710:0:b0:22c:d668:504e with SMTP id r16-20020adff710000000b0022cd668504emr15632042wrp.98.1665507136176;
        Tue, 11 Oct 2022 09:52:16 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:85fd:d700:2160:31b3:dfc8:afef? ([2a01:4b00:85fd:d700:2160:31b3:dfc8:afef])
        by smtp.gmail.com with ESMTPSA id az29-20020a05600c601d00b003c6b70a4d69sm5612846wmb.42.2022.10.11.09.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 09:52:15 -0700 (PDT)
Message-ID: <d6c9e249-08bd-4439-7dcc-371b32e7b851@canonical.com>
Date:   Tue, 11 Oct 2022 17:52:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     regressions@lists.linux.dev, stable@vger.kernel.org
Cc:     Eva Kotova <nyandarknessgirl@gmail.com>,
        linux-riscv@lists.infradead.org, coelacanthus@outlook.com,
        kernel-team@lists.ubuntu.com
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: Regression: Fwd: Re: [PATCH] riscv: mmap with PROT_WRITE but no
 PROT_READ is invalid
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0DLPZ0BJGbltvhaCkZlcupAH"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0DLPZ0BJGbltvhaCkZlcupAH
Content-Type: multipart/mixed; boundary="------------TRztwcVpFhYexT6hLjgcH9mA";
 protected-headers="v1"
From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To: regressions@lists.linux.dev, stable@vger.kernel.org
Cc: Eva Kotova <nyandarknessgirl@gmail.com>, linux-riscv@lists.infradead.org,
 coelacanthus@outlook.com, kernel-team@lists.ubuntu.com
Message-ID: <d6c9e249-08bd-4439-7dcc-371b32e7b851@canonical.com>
Subject: Regression: Fwd: Re: [PATCH] riscv: mmap with PROT_WRITE but no
 PROT_READ is invalid

--------------TRztwcVpFhYexT6hLjgcH9mA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

I3JlZ3pib3QgXmludHJvZHVjZWQgMjEzOTYxOWJjYWQ3YWM0NGNjOGY2Zjc0OTA4OTEyMDU5
NDA1NjYxMw0KDQpPdmVyIGF0IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJpc2N2
L1l6ODBld0hLVFBJNVJ2dXpAc3B1ZC9ULyNlYmRlNDcwNjQ0MzRkNGNhNDgwN2I0YWJiOGVi
Mzk4OThjNDhhOGRlMiBpdCBpcyByZXBvcnRlZCB0aGF0IDIxMzk2MTliY2FkN2FjNDRjYzhm
NmY3NDkwODkxMjA1OTQwNTY2MTMgcmVncmVzc2VzIHVzZXJzcGFjZSAob3Blbmpkaykgb24g
cmlzY3Y2NC4NCg0KVGhpcyBjb21taXQgaGFzIGFscmVhZHkgYmVlbiByZWxlYXNlZCBpbiB2
Ni4wIGtlcm5lbCB1cHN0cmVhbSwgYnV0IGhhcyBhbHNvIGJlZW4gaW5jbHVkZWQgaW4gdGhl
IHN0YWJsZSBwYXRjaCBzZXJpZXMgYWxsIHRoZSB3YXkgYmFjayB0byB2NC4xOS55DQoNClRo
ZXJlIGlzIGEgcHJvcG9zZWQgZml4IGZvciB0aGlzIGF0IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LXJpc2N2LzIwMjIwOTE1MTkzNzAyLjIyMDEwMTgtMS1hYnJlc3RpY0ByaXZv
c2luYy5jb20vIHdoaWNoIGhhcyBub3QgeWV0IGJlZW4gbWVyZ2VkIHVwc3RyZWFtIG9yIGlu
IHN0YWJsZSBzZXJpZXMuDQoNClBsZWFzZSByZXZpZXcgYW5kIG1lcmdlIGFib3ZlIHByb3Bv
c2VkIGZpeCwgb3IgcGxlYXNlIHJldmVydCAyMTM5NjE5YmNhZDdhYzQ0Y2M4ZjZmNzQ5MDg5
MTIwNTk0MDU2NjEzIHRvIHN0b3AgdGhlIHJlZ3Jlc3Npb24gc3ByZWFkaW5nIHRvIGFsbCB0
aGUgZGlzdHJpYnV0aW9ucy4NCg0KSW4gVWJ1bnR1IHRoaXMgcmVncmVzc2lvbiB3aWxsIGJl
IHRyYWNrZWQgYXMgaHR0cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQvYnVncy8rYnVnLzE5OTI0
ODQNCg0KLS0tLS0tLS0gRm9yd2FyZGVkIE1lc3NhZ2UgLS0tLS0tLS0NClN1YmplY3Q6IFJl
OiBbUEFUQ0hdIHJpc2N2OiBtbWFwIHdpdGggUFJPVF9XUklURSBidXQgbm8gUFJPVF9SRUFE
IGlzIGludmFsaWQNCkRhdGU6IFRodSwgNiBPY3QgMjAyMiAyMjoyMDowMiArMDMwMA0KRnJv
bTogRXZhIEtvdG92YSA8bnlhbmRhcmtuZXNzZ2lybEBnbWFpbC5jb20+DQpSZXBseS1Ubzog
UEg3UFIxNE1CNTU5NDY0REJERDMxMEU3NTVGNUIyMUU4Q0VEQzlAUEg3UFIxNE1CNTU5NC5u
YW1wcmQxNC5wcm9kLm91dGxvb2suY29tDQpUbzogY29lbGFjYW50aHVzQG91dGxvb2suY29t
DQpDQzogYzE0MTAyOEBnbWFpbC5jb20sIGRyYW1mb3JldmVyQGxpdmUuY29tLCBsaW51eC1y
aXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnLCBwYWxtZXJAZGFiYmVsdC5jb20sIHhjLXRhbkBv
dXRsb29rLmNvbQ0KDQpPbiBUdWUsIDMxIE1heSAyMDIyIDAwOjU2OjUyIFBEVCAoLTA3MDAp
LCBjb2VsYWNhbnRodXNAb3V0bG9vay5jb20gd3JvdGU6DQo+IEFzIG1lbnRpb25lZCBpbiBU
YWJsZSA0LjUgaW4gUklTQy1WIHNwZWMgVm9sdW1lIDIgU2VjdGlvbiA0LjMsIHdyaXRlDQo+
IGJ1dCBub3QgcmVhZCBpcyAiUmVzZXJ2ZWQgZm9yIGZ1dHVyZSB1c2UuIi4gRm9yIG5vdywg
dGhleSBhcmUgbm90IHZhbGlkLg0KPiBJbiB0aGUgY3VycmVudCBjb2RlLCAtd3ggaXMgbWFy
a2VkIGFzIGludmFsaWQsIGJ1dCAtdy0gaXMgbm90IG1hcmtlZA0KPiBhcyBpbnZhbGlkLg0K
DQpUaGlzIHBhdGNoIGJyZWFrcyBPcGVuSkRLL0phdmEgb24gUklTQy1WLCBhcyBpdCB0cmll
cyB0byBjcmVhdGUgYSB3LW9ubHkNCnByb3RlY3RpdmUgcGFnZToNCg0KIw0KIyBUaGVyZSBp
cyBpbnN1ZmZpY2llbnQgbWVtb3J5IGZvciB0aGUgSmF2YSBSdW50aW1lIEVudmlyb25tZW50
IHRvIGNvbnRpbnVlLg0KIyBOYXRpdmUgbWVtb3J5IGFsbG9jYXRpb24gKG1tYXApIGZhaWxl
ZCB0byBtYXAgNDA5NiBieXRlcyBmb3IgZmFpbGVkIHRvDQphbGxvY2F0ZSBtZW1vcnkgZm9y
IFBhWCBjaGVjay4NCiMgQW4gZXJyb3IgcmVwb3J0IGZpbGUgd2l0aCBtb3JlIGluZm9ybWF0
aW9uIGlzIHNhdmVkIGFzOg0KIyAvcm9vdC9oc19lcnJfcGlkMTA3LmxvZw0KDQpJIGJpc2Vj
dGVkIHRvIHRoaXMgY29tbWl0IHNpbmNlIG9uIExpbnV4IDUuMTkrIGphdmEgbm8gbG9uZ2Vy
IHdvcmtzLg0KUGVyaGFwcyBzb21lIGZhbGxiYWNrIHNob3VsZCBiZSBpbXBsZW1lbnRlZCwg
dG8gcHJldmVudCB1c2Vyc3BhY2UNCmJyZWFrYWdlLiBJdCBpcyBjdXJyZW50bHkgZG9jdW1l
bnRlZCwgdGhhdCBhdCBsZWFzdCBvbiBpMzg2IFBST1RfV1JJVEUNCm1hcHBpbmdzIGltcGx5
IFBST1RfUkVBRCAoU2VlIG1hbiBtbWFwKDIpIE5PVEVTKSwgdGhpcyB3b3VsZCBiZSBhIGdv
b2QNCnBsYWNlIHRvIHN0YXJ0Lg0KDQpCZXN0IHJlZ2FyZHMsDQpFdmENCg0KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCmxpbnV4LXJpc2N2IG1h
aWxpbmcgbGlzdA0KbGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZw0KaHR0cDovL2xp
c3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1yaXNjdg0KDQo=

--------------TRztwcVpFhYexT6hLjgcH9mA--

--------------0DLPZ0BJGbltvhaCkZlcupAH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE7iQKBSojGtiSWEHXm47ISdXvcO0FAmNFnz4ACgkQm47ISdXv
cO2QAg/9E5/mtzedG7WB1LjYn9B+0TCRo64FStswhZ7wA+vS5tVx05tGnMJ99UyQ
5rQnw7f09PHiDyPRap1pMlDYlZa/3m4quhxVhzhGGkcZFk0ItQcr+JFfmc9p2z22
WLa7rLgb63VTcStIlRTINSbTNSim7Tz4X6+8cVh+7pogd8chekMsI+/th/CjDPR/
ubl915JTTEpwu9QTkjMj9Cc946PquVD9sPquPydIbpm4msT5qe91KPJ8HmQ5AB8l
P1qR0MtRs3Uop1AFrOZ3orEgcmXvx61YN12TvhiJ01xnoTXkhjSAxoF/QUFP1wz2
7mnVGhnsUPUKBHb3t9hvlQbFx3GepXqU5Agi1vdKtg+GsO9qGJ8PD7faLmuzi/xD
rD7y32TTF+0tAAp/sfyeubjgYVV1WmqnnwARE1ebwsdKWN2aPwCRYk+e8D/Gv4xK
bNdCTnzZH/RGNek/NhkyCgH33fJCE4cdydAYZUotIl5URsAi4O8+4v+HcMgfMmkN
I3xEmnY9w6nh7Mf+51wNgrxBIS+BNuKBmn/uAk0Vdb5YorKfw3GHKOPsULKFGVjF
3PgmfqTPFQ1LVkPBix/BWcDMCCpbLR24TKF3SS3DC67wd7/QVDSpvMklxQfFDfi0
4TRFwP0pX/Nsy3KP/t0DaCcxyIYy1LqY4r0emeDIQ9YmxvD069c=
=hkso
-----END PGP SIGNATURE-----

--------------0DLPZ0BJGbltvhaCkZlcupAH--
