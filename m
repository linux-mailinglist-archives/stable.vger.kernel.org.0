Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB1348056F
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 01:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhL1A7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 19:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhL1A7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 19:59:23 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A1C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 16:59:22 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id r15so29523659uao.3
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 16:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=/bFuADBwC4EPW7y3RrPU0rN87a72JnY9KmW5k5Yc2XY=;
        b=iRixyO4gLoSd1Pxr/PPmw/sEvf8snM3x8qhP2cAMIb/h0/FoKKsyK5+p6tHfRe7TnO
         PkWiZwaijlseZ9cnqmPqK15WsmQcxzuJ6v1rPV0yviTMIYsZGsWyMcfYCeh4XTvF7+S/
         ZqwBFuxmuPiWIo3MspiNPb9alo9dXWjvoWJNs8KP58sF6sroX+3YwRcdk23+WKL44tMW
         Xflz0EqKGC58JA4t56RYHMhZoPQ7lSNkDbCxFa53Qu4IhghucKjQRQjQLX3M0x+L0tjV
         fCVXmjhx5BLho6fgwg/0lyMaCYplvTR2OGL/VARzjItGQ4rizb0uEVrriPhFDi1k/Tz6
         qzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/bFuADBwC4EPW7y3RrPU0rN87a72JnY9KmW5k5Yc2XY=;
        b=OnME9Qjn1vu/4t5zkOrqbrlgZx1k0fIQdqm/tex5K+h7auQ3r7XyDVnYAywOZq7cGl
         BiZIouHFoEyrVu1fG5kvPcq456tXyEUKYjEXLEe73wLr0FEl0oR9H/r4iGSYDbn2COxk
         hSLNT1+ytIkKgng9t938E0nmZz0McTIpvGoGJTDJ8uWYCsp3QNOulAPDRLdyRasdaiu6
         bwrwcVyGoWhLHqX5dpkrWsd+wFweJiII7uuD6DvS8TKIExa1q5Kr3uGv4AQgln4disD8
         tfrQNCeWkaZE7rmrlGwIND/Dsn9I2CeoYCjzZ5C4e3vIsBIewREsrFDNa4j1QnadFHx3
         Mt+A==
X-Gm-Message-State: AOAM533yES8SX6gekCJvjiMqaHEQAh+BZfZ4Hnaz+ze4WtJLBbLJCttP
        cf6epxYYiW2VwanfEuotRAwnVW99yJTF7ZPchOU=
X-Google-Smtp-Source: ABdhPJwpVo/O6Wu3KoFmM+ZXkrYxHvGo/zbQNRHtqdmTLiyKT0jCiuNRvaV3iONTlUg6dvc0/UxpAtF4fT3svu+nVkI=
X-Received: by 2002:a05:6102:31ad:: with SMTP id d13mr5236347vsh.55.1640653160694;
 Mon, 27 Dec 2021 16:59:20 -0800 (PST)
MIME-Version: 1.0
From:   Kevin Anderson <andersonkw2@gmail.com>
Date:   Mon, 27 Dec 2021 19:59:09 -0500
Message-ID: <CAJsSGwWz3qncvb-XkpZefJsCJ1wfCPaiHVdJ-BTFSdiFWvhmRQ@mail.gmail.com>
Subject: iwlwifi Backport Request
To:     gregkh@linuxfoundation.org, luciano.coelho@intel.com,
        johannes@sipsolutions.net, stable@vger.kernel.org,
        ilan.peer@intel.com, johannes.berg@intel.com
Content-Type: multipart/mixed; boundary="000000000000d7f5d205d42a54f6"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000d7f5d205d42a54f6
Content-Type: text/plain; charset="UTF-8"

Hello,

I wanted to see if I could have two patches backported to 5.15 stable
that concern Intel iwlwifi AX2XX stability.

The patches are attached to the kernel bugzilla that can be found
here: https://bugzilla.kernel.org/show_bug.cgi?id=214549. I've also
attached them to this email.

The patches fix an issue with the Intel AX210 that I have where it can
cause a firmware reset when the device is under load causing
performance to drop to around ~500Kb/s till the interface is
restarted. This reset is easy to reproduce during normal use such as
streaming videos and is problematic for devices such as laptops that
primarily use wifi for connectivity.

The mac80211 change is currently in the 5.16 RC and the scan timeout
is in netdev-next and is supposed to be scheduled for 5.17 from what I
can tell.

I believe that the patches meet the requirements of the -stable tree
as it makes the adapter for many users including myself difficult to
use reliably.

If this is the incorrect venue for this please let me know.

Thanks,
Kevin Anderson

--000000000000d7f5d205d42a54f6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-mac80211-mark-TX-during-stop-for-TX-in-in_reconfig.patch"
Content-Disposition: attachment; 
	filename="0001-mac80211-mark-TX-during-stop-for-TX-in-in_reconfig.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kxpe9qqi1>
X-Attachment-Id: f_kxpe9qqi1

RnJvbSBlZWUwZDU5NjU0ZmM1YmIzNzI3YWM0MzY0MTAxYTYwNGUzMjJiMzEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNv
bT4KRGF0ZTogTW9uLCAxMiBKdWwgMjAyMSAxNzo1MzowMyArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IG1hYzgwMjExOiBtYXJrIFRYLWR1cmluZy1zdG9wIGZvciBUWCBpbiBpbl9yZWNvbmZpZwoKTWFy
ayBUWFFzIGFzIGhhdmluZyBzZWVuIHRyYW5zbWl0IHdoaWxlIHRoZXkgd2VyZSBzdG9wcGVkIGlm
CndlIGJhaWwgb3V0IG9mIGRydl93YWtlX3R4X3F1ZXVlKCkgZHVlIHRvIHJlY29uZmlnLCBzbyB0
aGF0CnRoZSBxdWV1ZSB3YWtlIGFmdGVyIHRoaXMgd2lsbCBtYWtlIHRoZW0gY2F0Y2ggdXAuIFRo
aXMgaXMKcGFydGljdWxhcmx5IG5lY2Vzc2FyeSBmb3Igd2hlbiBUWFFzIGFyZSB1c2VkIGZvciBt
YW5hZ2VtZW50CnBhY2tldHMgc2luY2UgdGhvc2UgVFhRcyB3b24ndCBzZWUgYSBsb3Qgb2YgdHJh
ZmZpYyB0aGF0J2QKbWFrZSB0aGVtIGNhdGNoIHVwIGxhdGVyLgoKQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcKRml4ZXM6IDQ4NTZiZmQyMzA5OCAoIm1hYzgwMjExOiBkbyBub3QgY2FsbCBkcml2
ZXIgd2FrZV90eF9xdWV1ZSBvcCBkdXJpbmcgcmVjb25maWciKQpTaWduZWQtb2ZmLWJ5OiBKb2hh
bm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNvbT4KLS0tCiBuZXQvbWFjODAyMTEvZHJp
dmVyLW9wcy5oIHwgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9kcml2ZXItb3BzLmggYi9uZXQv
bWFjODAyMTEvZHJpdmVyLW9wcy5oCmluZGV4IDYwNGNhNTk5MzdmMC4uZDk4YTA1MDYxOTg2IDEw
MDY0NAotLS0gYS9uZXQvbWFjODAyMTEvZHJpdmVyLW9wcy5oCisrKyBiL25ldC9tYWM4MDIxMS9k
cml2ZXItb3BzLmgKQEAgLTEyMDEsOCArMTIwMSwxMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZHJ2
X3dha2VfdHhfcXVldWUoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwsCiB7CiAJc3RydWN0
IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEgPSB2aWZfdG9fc2RhdGEodHhxLT50eHEudmlm
KTsKIAotCWlmIChsb2NhbC0+aW5fcmVjb25maWcpCisJLyogSW4gcmVjb25maWcgZG9uJ3QgdHJh
bnNtaXQgbm93LCBidXQgbWFyayBmb3Igd2FraW5nIGxhdGVyICovCisJaWYgKGxvY2FsLT5pbl9y
ZWNvbmZpZykgeworCQlzZXRfYml0KElFRUU4MDIxMV9UWFFfU1RPUF9ORVRJRl9UWCwgJnR4cS0+
ZmxhZ3MpOwogCQlyZXR1cm47CisJfQogCiAJaWYgKCFjaGVja19zZGF0YV9pbl9kcml2ZXIoc2Rh
dGEpKQogCQlyZXR1cm47Ci0tIAoyLjE3LjEKCg==
--000000000000d7f5d205d42a54f6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-iwlwifi-mvm-Increase-the-scan-timeout-guard-to-30-se.patch"
Content-Disposition: attachment; 
	filename="0001-iwlwifi-mvm-Increase-the-scan-timeout-guard-to-30-se.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kxpe9qqa0>
X-Attachment-Id: f_kxpe9qqa0

RnJvbSBmYTlmMDU3YjdiYTczZTlkYTBkYmQwYWJmMmIwMjY2NzQyNDcxZTljIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbGFuIFBlZXIgPGlsYW4ucGVlckBpbnRlbC5jb20+CkRhdGU6
IE1vbiwgMjkgTm92IDIwMjEgMTE6MTM6MzEgKzAyMDAKU3ViamVjdDogW1BBVENIXSBpd2x3aWZp
OiBtdm06IEluY3JlYXNlIHRoZSBzY2FuIHRpbWVvdXQgZ3VhcmQgdG8gMzAgc2Vjb25kcwoKV2l0
aCB0aGUgaW50cm9kdWN0aW9uIG9mIDZHSHogY2hhbm5lbHMgdGhlIHNjYW4gZ3VhcmQgdGltZW91
dCBzaG91bGQKYmUgYWRqdXN0ZWQgdG8gYWNjb3VudCBmb3IgdGhlIGZvbGxvd2luZyBleHRyZW1l
IGNhc2U6CgotIEFsbCA2R0h6IGNoYW5uZWxzIGFyZSBzY2FubmVkIHBhc3NpdmVseTogNTggY2hh
bm5lbHMuCi0gVGhlIHNjYW4gaXMgZnJhZ21lbnRlZCB3aXRoIHRoZSBmb2xsb3dpbmcgcGFyYW1l
dGVyczogMyBmcmFnbWVudHMsCiAgOTUgVFVzIHN1c3BlbmQgdGltZSwgNDQgVFVzIG1heGltYWwg
b3V0IG9mIGNoYW5uZWwgdGltZS4KClRoZSBhYm92ZSB3b3VsZCByZXN1bHQgd2l0aCBzY2FuIHRp
bWUgb2YgbW9yZSB0aGFuIDI0IHNlY29uZHMuIFRodXMsCnNldCB0aGUgdGltZW91dCB0byAzMCBz
ZWNvbmRzLgoKdHlwZT1idWdmaXgKdGlja2V0PWppcmE6V0lGSS0xNTcwNzUKZml4ZXM9dW5rbm93
bgoKQ2hhbmdlLUlkOiBJMzQ2ZmEyZTFkNzkyMjBhNjc3MDQ5NmU3NzNjNmY4N2EyYWQ5ZTZjNApT
aWduZWQtb2ZmLWJ5OiBJbGFuIFBlZXIgPGlsYW4ucGVlckBpbnRlbC5jb20+Ci0tLQogZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vc2Nhbi5jIHwgMiArLQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vc2Nhbi5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vc2Nhbi5jCmluZGV4IGVlM2FmZjhiZjdjMi4uMzg1MzIy
MjkxMWQ5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212
bS9zY2FuLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vc2Nh
bi5jCkBAIC0yNDc4LDcgKzI0NzgsNyBAQCBzdGF0aWMgaW50IGl3bF9tdm1fY2hlY2tfcnVubmlu
Z19zY2FucyhzdHJ1Y3QgaXdsX212bSAqbXZtLCBpbnQgdHlwZSkKIAlyZXR1cm4gLUVJTzsKIH0K
IAotI2RlZmluZSBTQ0FOX1RJTUVPVVQgMjAwMDAKKyNkZWZpbmUgU0NBTl9USU1FT1VUIDMwMDAw
CiAKIHZvaWQgaXdsX212bV9zY2FuX3RpbWVvdXRfd2soc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogewotLSAKMi4xNy4xCgo=
--000000000000d7f5d205d42a54f6--
