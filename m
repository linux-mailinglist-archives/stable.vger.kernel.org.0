Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED32F638C5
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 17:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfGIPkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 11:40:07 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38760 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIPkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 11:40:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so20024194ljg.5
        for <stable@vger.kernel.org>; Tue, 09 Jul 2019 08:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hSjbRdGhXfPpbL9rEnRhqmDFMe264yMY7+x8SyYMkDk=;
        b=Py7UaoA+PQwuZHyVWC2opjer3XXQ/lVsfNPBD7dnNxN1EvBhtz6bUgRvMQAEWHa1Ft
         lWEdVPKoOXP3Im8OtFoI+nv6z8B6JBGBVNBSNlTOn5X42ZTEOfmCZ3+NfTEBetjAtDUy
         cRFvdUVoZ7acgcZXSXscZiGiihI9gInbcp4OsN8KEis/zP2CscFqJOSIZmxqUQ8DxiWY
         eoVU7nCD3A17LsKZPvvaSZuPzbj+sfLcbQErpb5Z5nPx7F7bHk/Epha6D90Mp7KnXnek
         D+xeNbFReneU4vR8U6RY0V9LC2Octecza136vCdIYPV4vwoRMInyyYzrGU3oy+y+/Bwy
         Sekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=hSjbRdGhXfPpbL9rEnRhqmDFMe264yMY7+x8SyYMkDk=;
        b=NyzMjwq//F7I/P+9iUQ54G45mZCsutf6e5ym8kgipCnJ25MI+lIunqm82W53E++gMY
         91LyQRlw1wleFkvnQtc/50F79tsBJzFMvV5IzbPj4/K4prXATlPa3jj7YqS6ngTCvy/M
         UIuhzcgrG5dgjY6aguwcDIwYPnosSGdxjXv74w1XCJhrHX5hZ0XIygTYs5uhp0jo+4KD
         MnklD+bX6YjY2ZYhkGEXXImaCeeG7qzZbiKNLmm0GgbX5o/9ERgCY9wzjn4kItGXMGnY
         Jyd8y4nZ5ZNsyj8ynDglnLsVAWoPm9LCQiSaJrecCgg8CvQGdlQ/4VAUXZFc2TGJ0TPu
         O7jw==
X-Gm-Message-State: APjAAAWT8dE+IhZq+gdljbtj5W8h0YIC7Mfvy4Pys/FO5bTuRTV8PzMZ
        dufGJ3bYZzBup2AcrzwdapZnrD+g1vG5qF8mXFg=
X-Google-Smtp-Source: APXvYqzVeGCPxUu/d9um7Y7J5GqMSpZlHjlmgYJvElKRckWd2GAt+r1V9x73Dxg9crnitZ+8zTNkHktsN59VmJN3oWU=
X-Received: by 2002:a2e:994:: with SMTP id 142mr13949569ljj.130.1562686805255;
 Tue, 09 Jul 2019 08:40:05 -0700 (PDT)
MIME-Version: 1.0
Reply-To: Mohaiyani@alumnidirector.com
Received: by 2002:a2e:874a:0:0:0:0:0 with HTTP; Tue, 9 Jul 2019 08:40:04 -0700 (PDT)
From:   Mohaiyani binti Shamsudin <sanaousmanedg@gmail.com>
Date:   Tue, 9 Jul 2019 17:40:04 +0200
X-Google-Sender-Auth: VjUsfB3Ug9aAWlG86xtIwob2Hls
Message-ID: <CABCFyk+AaeM8hW+tXZsjXOFYPCS+Wwi6u8DLhH7YuH6-NNnV=g@mail.gmail.com>
Subject: =?UTF-8?B?VsOhxb5lbsO9IHBhbmUgbmVibyBwYW7DrSwgcG90xZllYnVqaSB2YcWhaSBwb21vYw==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RHJhaMO9IHBhbmUgbmVibyBwYW7DrSwNCg0KSnNlbSBwYW7DrSBNb2hhaXlhbmkgYmludGkgU2hh
bXN1ZGluLCBwcmFjdWplIHYgTUFZQkFOSyAoTWFsYWpzaWUpIGpha28NCm5lesOhdmlzbMO9IG5l
dsO9a29ubsO9IMWZZWRpdGVsIGEgcMWZZWRzZWRhIE1heWJhbmsuIELEm2hlbSBuYcWhZWhvDQpw
b3NsZWRuw61obyBiYW5rb3Zuw61obyBhdWRpdHUganNtZSB6amlzdGlsaSwgxb5lIG9wdcWhdMSb
bsO9IMO6xI1ldCBwYXTFmcOtDQpqZWRub211IHogbmHFoWljaCBaYWhyYW5pxI1uw61obyBvZGNp
emVuw6lobyB6w6FrYXpuw61rYS4gcMWZaSBuZWhvZMSbIG5hDQpzbHXFvmVibsOtIGNlc3TEmyB2
ZSBGcmFuY2lpIHYgw7p0ZXLDvS4NCg0KUHJvamTEm3RlIHNpIHByb3PDrW0gdGVudG8gb2RrYXo6
DQpodHRwczovL29ic2VydmVyLmNvbS8yMDE4LzA3L3dhbmctamlhbi1obmEtZm91bmRlci1kaWVz
LXRyYWdpYy1mYWxsLw0KDQrCoENoY2kgcG/FvsOhZGF0IG8gdmHFoWkgcG9tb2MgcMWZaSBwxZll
dm9kdSDEjcOhc3RreSAxNSAwMDAgMDAwLDAwIFVTRCAoMTUNCm1pbGlvbsWvIGFtZXJpY2vDvWNo
IGRvbGFyxa8pIG5hIHbDocWhIMO6xI1ldCBqYWtvIHphaHJhbmnEjW7DrSBvYmNob2Ruw60NCnBh
cnRuZXIgV2FuZyBKaWFuLCBrdGVyw70gaG9kbMOhbSB0ZW50byBmb25kIHBvdcW+w610IGsgaW52
ZXN0b3bDoW7DrSB2ZQ0KcHJvc3DEm2NoIHZlxZllam5vc3RpLCBuw6FzbGVkdWplOw0KDQrCoMKg
wqDCoDEuIFrFmcOtZGl0IGRvbW92IHNpcm90xI1pbmNlLCBrdGVyw70gcG9txa/FvmUgc2lyb3TE
jcOtbSBkxJt0ZW0uDQrCoMKgwqDCoDIuIFBvc3RhdnRlIG5lbW9jbmljaSwga3RlcsOhIHBvbcWv
xb5lIGNodWTDvW0uDQrCoMKgwqDCoDMuIFBvc3Rhdml0IHBlxI1vdmF0ZWxza8O9IGTFr20gcHJv
IHN0YXLDqSBsaWRpIGEgYmV6ZG9tb3ZjZS4NCg0KwqDCoE1leml0w61tLCBuZcW+IGpzZW0gdsOh
cyBrb250YWt0b3ZhbCwganNlbSBwcm92ZWRsIG9zb2Juw60gdnnFoWV0xZlvdsOhbsOtLA0KYWJ5
Y2ggemppc3RpbCwgxb5lIHNlIGplZG7DoSBvIHDFmcOtYnV6bsOpIExhdGUgcGFuYSBXYW5nIEpp
YW5hLCBrdGXFmcOtIG8NCsO6xI10dSB2xJtkw60sIGFsZSBqw6EganNlbSBwxZlpxaFlbCBuZcO6
c3DEm8WhbsSbLiBTIHTDrW10byBmb25kZW0ganNlbSB2xaFhaw0KcMWZaWphbCB0b3RvIHJvemhv
ZG51dMOtIG5hIHBvZHBvcnUgc2lyb3Rrxa8gYSBtw6luxJsgcHJpdmlsZWdvdmFuw71jaCBkxJt0
w60sDQpwcm90b8W+ZSBuZWNoY2ksIGFieSBieWwgdGVudG8gZm9uZCBwxZlldmVkZW4gbmEgbsOh
xaEgdmzDoWRuw60gcG9rbGFkbsOtDQrDusSNZXQgamFrbyBuZXZ5xb7DoWRhbsO9IGZvbmQuIEpz
ZW0gb2Nob3RlbiBWw6FtIG5hYsOtZG5vdXQgMzAlIHogZm9uZHUgbmENCnBvZHBvcnUgYSBwb21v
YyBwxZlpIHDFmWV2b2R1IGZvbmR1IG5hIHbDocWhIMO6xI1ldC4NCg0KVsOtY2UgaW5mb3JtYWPD
rSB2w6FtIGJ1ZGUgemFzbMOhbm8sIGFieSB2w6FtIGJ5bG8gdnlzdsSbdGxlbm8sIGphayBidWRl
DQpmb25kIHDFmWV2ZWRlbiBuYSB2w6FzLiBQb2tyYcSNdWp0ZSBwcm9zw61tIHYgZG9zYcW+ZW7D
rSB0b2hvdG8gY8OtbGUuDQoNCsSMZWvDoW7DrSBuYSB2YcWhaSBuYWzDqWhhdm91IHJlYWtjaS4N
CnMgcG96ZHJhdmVtDQpQYW7DrSBNb2hhaXlhbmkgQmludGkgU2hhbXN1ZGluLg0K
