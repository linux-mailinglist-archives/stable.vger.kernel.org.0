Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF16176D6
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 07:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiKCGpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 02:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCGpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 02:45:02 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C6618B0C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 23:45:01 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f8so586121qkg.3
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 23:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NMOvgkuB8lyX4Rwafin1j3iALf2ImbCXoMHWWARw3mA=;
        b=Q15Xi45csjZ6O+MVN2MVm8CRUJ/hZrklHbHw9um0Q2sZA8UJooWij0sXYCn26tjdq0
         5PAiCgBnPdgApMXNQ5Epl5CE+S4cdMSoC6KCCG6SOTqGtd0I4x+ZH4Q05yO2uGyX9KIr
         ZxEgRw9eD5Da33gpWfrX+wgQ1A8osGp5o+K/y+ITFuzR24LjPUio4AD4OWp9+pKQo9Qc
         sgMGmUa9sNwdrNEEQ+ZWP8GuT+6rXNJBT7aKlCq4l7zRfbdyQqrfH7a7QKnaNGTlpOiv
         b6bmg4zhKNY4va4orST6Hj4BCD7e8IjmrXiVVXbi8ES/97oVnk27oMdmSMi6s36hqMqQ
         gM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMOvgkuB8lyX4Rwafin1j3iALf2ImbCXoMHWWARw3mA=;
        b=HpYLwg0MEByOjB9GxoDZwe/d0gZ0iZLFPncMSn4ZYa+is3U88WI+AFte/UxIJYfcoL
         LY3DB2Car113bAqJqv/b2a/UxkU3xksdU/1L8x34n09Y/FRFcRCm4fZ6QJilW/0sIOKo
         ngPkQ3mJa+mGZBNIu8272Qu81v6kFuln0KGS2gAuUUQWfVaLJhkKuWScNWfpN7zFNwyz
         Qkc3A+pwyjNwxljQc1DyRsCBSUGna0wGKhFmCzC8QPdY8LZ8ZGAQiqn5zIrTc5NN46pB
         y0y5wYm2B7V8B8pmSCR+verg7+4H1Z7qJpSaakowC+p0t4uKQRCJtL44uyg40epT42W8
         WoPg==
X-Gm-Message-State: ACrzQf0vPjGcR1dgPiu3HO7TyyFC4CiBNu32NabwfzeWkK4fmst6rc0a
        wQkbmMRcq3mQa3hb/2xc+5dh/RRqACVgJkHowaeGMmP2FPf1gg==
X-Google-Smtp-Source: AMsMyM4Mcbfukva/wuD7n38ErlsCNtJ0tNqWtH7OzD8Ig8LkHOo9pM+3qPnxSm3ZVWlW0Eeds3qwU+BqkitGgeWEXjA=
X-Received: by 2002:a05:620a:2888:b0:6cf:5798:9a2d with SMTP id
 j8-20020a05620a288800b006cf57989a2dmr20842513qkp.508.1667457900563; Wed, 02
 Nov 2022 23:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
 <Y2F0s/+TDf7deuIg@kroah.com> <CACCxZWPVXAR2tdf7twp=OtOico=EhaXjVQY=yxdxhMgJutuEfw@mail.gmail.com>
 <Y2MxURlV6NRjSABO@kroah.com>
In-Reply-To: <Y2MxURlV6NRjSABO@kroah.com>
From:   Anil Altinay <aaltinay@google.com>
Date:   Wed, 2 Nov 2022 23:44:49 -0700
Message-ID: <CACCxZWM6kBhEeaMSBO05e2UzBWWVTU8Cd_-nw1w-pk=JSLzivQ@mail.gmail.com>
Subject: Re: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15 stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d7e23205ec8b4b43"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000d7e23205ec8b4b43
Content-Type: text/plain; charset="UTF-8"

Ops, I am sorry. It is my first time sending a patch to the stable
tree. I added "Signed-off-by: Anil Altinay <aaltinay@google.com>" at
the end of the Signed-off list. Hopefully, it is good to go this time
:) Thanks for your patience Greg!

On Wed, Nov 2, 2022 at 8:10 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 02, 2022 at 07:59:24PM -0700, Anil Altinay wrote:
> > Please see attached patch for backported version with the commit
> > message updated with the upstream commit SHA. I also applied this
> > patch to our kernel and it built fine. Hopefully, it is good to go
> > this time.
>
> You forgot to sign off on the patch :(
>

--000000000000d7e23205ec8b4b43
Content-Type: application/octet-stream; 
	name="0001-af_unix-Fix-memory-leaks-of-the-whole-sk-due-to-OOB- (3).patch"
Content-Disposition: attachment; 
	filename="0001-af_unix-Fix-memory-leaks-of-the-whole-sk-due-to-OOB- (3).patch"
Content-Transfer-Encoding: base64
Content-ID: <f_la0pa9lr0>
X-Attachment-Id: f_la0pa9lr0

RnJvbSAwYmUwZjQ3YmFkMGM3MzYyNTFkZTQxYjY0ZTQ4NzgyZjZiNmEwZjJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLdW5peXVraSBJd2FzaGltYSA8a3VuaXl1QGFtYXpvbi5jb20+
CkRhdGU6IFRodSwgMjkgU2VwIDIwMjIgMDg6NTI6MDQgLTA3MDAKU3ViamVjdDogW1BBVENIXSBh
Zl91bml4OiBGaXggbWVtb3J5IGxlYWtzIG9mIHRoZSB3aG9sZSBzayBkdWUgdG8gT09CIHNrYi4K
ClsgVXBzdHJlYW0gY29tbWl0IDdhNjJlZDYxMzY3YjhmZDAxYmFlMWUxOGUzMDYwMmMyNTA2MGQ4
MjQgXQoKc3l6Ym90IHJlcG9ydGVkIGEgc2VxdWVuY2Ugb2YgbWVtb3J5IGxlYWtzLCBhbmQgb25l
IG9mIHRoZW0gaW5kaWNhdGVkIHdlCmZhaWxlZCB0byBmcmVlIGEgd2hvbGUgc2s6CgogIHVucmVm
ZXJlbmNlZCBvYmplY3QgMHhmZmZmODg4MDEyNmUwMDAwIChzaXplIDEwODgpOgogICAgY29tbSAi
c3l6LWV4ZWN1dG9yNDE5IiwgcGlkIDMyNiwgamlmZmllcyA0Mjk0NzczNjA3IChhZ2UgMTIuNjA5
cykKICAgIGhleCBkdW1wIChmaXJzdCAzMiBieXRlcyk6CiAgICAgIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDdkIDAwIDAwIDAwIDAwIDAwIDAwIDAwICAuLi4uLi4uLn0uLi4uLi4uCiAgICAgIDAx
IDAwIDA3IDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwICAuLi5ALi4uLi4u
Li4uLi4uCiAgICBiYWNrdHJhY2U6CiAgICAgIFs8MDAwMDAwMDA2ZmVmZTc1MD5dIHNrX3Byb3Rf
YWxsb2MrMHg2NC8weDJhMCBuZXQvY29yZS9zb2NrLmM6MTk3MAogICAgICBbPDAwMDAwMDAwNzQw
MDZkYjU+XSBza19hbGxvYysweDNiLzB4ODAwIG5ldC9jb3JlL3NvY2suYzoyMDI5CiAgICAgIFs8
MDAwMDAwMDA3MjhjZDQzND5dIHVuaXhfY3JlYXRlMSsweGFmLzB4OTIwIG5ldC91bml4L2FmX3Vu
aXguYzo5MjgKICAgICAgWzwwMDAwMDAwMGEyNzlhMTM5Pl0gdW5peF9jcmVhdGUrMHgxMTMvMHgx
ZDAgbmV0L3VuaXgvYWZfdW5peC5jOjk5NwogICAgICBbPDAwMDAwMDAwNjgyNTk4MTI+XSBfX3Nv
Y2tfY3JlYXRlKzB4MmFiLzB4NTUwIG5ldC9zb2NrZXQuYzoxNTE2CiAgICAgIFs8MDAwMDAwMDBk
YTE1MjFlMT5dIHNvY2tfY3JlYXRlIG5ldC9zb2NrZXQuYzoxNTY2IFtpbmxpbmVdCiAgICAgIFs8
MDAwMDAwMDBkYTE1MjFlMT5dIF9fc3lzX3NvY2tldHBhaXIrMHgxYTgvMHg1NTAgbmV0L3NvY2tl
dC5jOjE2OTgKICAgICAgWzwwMDAwMDAwMDdhYjI1OWUxPl0gX19kb19zeXNfc29ja2V0cGFpciBu
ZXQvc29ja2V0LmM6MTc1MSBbaW5saW5lXQogICAgICBbPDAwMDAwMDAwN2FiMjU5ZTE+XSBfX3Nl
X3N5c19zb2NrZXRwYWlyIG5ldC9zb2NrZXQuYzoxNzQ4IFtpbmxpbmVdCiAgICAgIFs8MDAwMDAw
MDA3YWIyNTllMT5dIF9feDY0X3N5c19zb2NrZXRwYWlyKzB4OTcvMHgxMDAgbmV0L3NvY2tldC5j
OjE3NDgKICAgICAgWzwwMDAwMDAwMDdkZWRkZGMxPl0gZG9fc3lzY2FsbF94NjQgYXJjaC94ODYv
ZW50cnkvY29tbW9uLmM6NTAgW2lubGluZV0KICAgICAgWzwwMDAwMDAwMDdkZWRkZGMxPl0gZG9f
c3lzY2FsbF82NCsweDM4LzB4OTAgYXJjaC94ODYvZW50cnkvY29tbW9uLmM6ODAKICAgICAgWzww
MDAwMDAwMDk0NTY2NzlmPl0gZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NjMvMHhj
ZAoKV2UgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlIGJ5IGNyZWF0aW5nIHR3byBBRl9VTklYIFNP
Q0tfU1RSRUFNIHNvY2tldHMsCnNlbmQoKWluZyBhbiBPT0Igc2tiIHRvIGVhY2ggb3RoZXIsIGFu
ZCBjbG9zZSgpaW5nIHRoZW0gd2l0aG91dCBjb25zdW1pbmcKdGhlIE9PQiBza2JzLgoKICBpbnQg
c2twYWlyWzJdOwoKICBzb2NrZXRwYWlyKEFGX1VOSVgsIFNPQ0tfU1RSRUFNLCAwLCBza3BhaXIp
OwoKICBzZW5kKHNrcGFpclswXSwgIngiLCAxLCBNU0dfT09CKTsKICBzZW5kKHNrcGFpclsxXSwg
IngiLCAxLCBNU0dfT09CKTsKCiAgY2xvc2Uoc2twYWlyWzBdKTsKICBjbG9zZShza3BhaXJbMV0p
OwoKQ3VycmVudGx5LCB3ZSBmcmVlIGFuIE9PQiBza2IgaW4gdW5peF9zb2NrX2Rlc3RydWN0b3Io
KSB3aGljaCBpcyBjYWxsZWQgdmlhCl9fc2tfZnJlZSgpLCBidXQgaXQncyB0b28gbGF0ZSBiZWNh
dXNlIHRoZSByZWNlaXZlcidzIHVuaXhfc2soc2spLT5vb2Jfc2tiCmlzIGFjY291bnRlZCBhZ2Fp
bnN0IHRoZSBzZW5kZXIncyBzay0+c2tfd21lbV9hbGxvYyBhbmQgX19za19mcmVlKCkgaXMKY2Fs
bGVkIG9ubHkgd2hlbiBzay0+c2tfd21lbV9hbGxvYyBpcyAwLgoKSW4gdGhlIHJlcHJvIHNlcXVl
bmNlcywgd2UgZG8gbm90IGNvbnN1bWUgdGhlIE9PQiBza2IsIHNvIGJvdGggdHdvIHNrJ3MKc29j
a19wdXQoKSBuZXZlciByZWFjaCBfX3NrX2ZyZWUoKSBkdWUgdG8gdGhlIHBvc2l0aXZlIHNrLT5z
a193bWVtX2FsbG9jLgpUaGVuLCBubyBvbmUgY2FuIGNvbnN1bWUgdGhlIE9PQiBza2Igbm9yIGNh
bGwgX19za19mcmVlKCksIGFuZCB3ZSBmaW5hbGx5CmxlYWsgdGhlIHR3byB3aG9sZSBzay4KClRo
dXMsIHdlIG11c3QgZnJlZSB0aGUgdW5jb25zdW1lZCBPT0Igc2tiIGVhcmxpZXIgd2hlbiBjbG9z
ZSgpaW5nIHRoZQpzb2NrZXQuCgpGaXhlczogMzE0MDAxZjBiZjkyICgiYWZfdW5peDogQWRkIE9P
QiBzdXBwb3J0IikKUmVwb3J0ZWQtYnk6IHN5emJvdCA8c3l6a2FsbGVyQGdvb2dsZWdyb3Vwcy5j
b20+ClNpZ25lZC1vZmYtYnk6IEt1bml5dWtpIEl3YXNoaW1hIDxrdW5peXVAYW1hem9uLmNvbT4K
U2lnbmVkLW9mZi1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PgpTaWdu
ZWQtb2ZmLWJ5OiBBbmlsIEFsdGluYXkgPGFhbHRpbmF5QGdvb2dsZS5jb20+Ci0tLQogbmV0L3Vu
aXgvYWZfdW5peC5jIHwgMTMgKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvdW5peC9hZl91bml4LmMg
Yi9uZXQvdW5peC9hZl91bml4LmMKaW5kZXggNzhlMDhlODJjMDhjLi4zZDIwYTliOTIzYWIgMTAw
NjQ0Ci0tLSBhL25ldC91bml4L2FmX3VuaXguYworKysgYi9uZXQvdW5peC9hZl91bml4LmMKQEAg
LTUwNCwxMiArNTA0LDYgQEAgc3RhdGljIHZvaWQgdW5peF9zb2NrX2Rlc3RydWN0b3Ioc3RydWN0
IHNvY2sgKnNrKQogCiAJc2tiX3F1ZXVlX3B1cmdlKCZzay0+c2tfcmVjZWl2ZV9xdWV1ZSk7CiAK
LSNpZiBJU19FTkFCTEVEKENPTkZJR19BRl9VTklYX09PQikKLQlpZiAodS0+b29iX3NrYikgewot
CQlrZnJlZV9za2IodS0+b29iX3NrYik7Ci0JCXUtPm9vYl9za2IgPSBOVUxMOwotCX0KLSNlbmRp
ZgogCVdBUk5fT04ocmVmY291bnRfcmVhZCgmc2stPnNrX3dtZW1fYWxsb2MpKTsKIAlXQVJOX09O
KCFza191bmhhc2hlZChzaykpOwogCVdBUk5fT04oc2stPnNrX3NvY2tldCk7CkBAIC01NTYsNiAr
NTUwLDEzIEBAIHN0YXRpYyB2b2lkIHVuaXhfcmVsZWFzZV9zb2NrKHN0cnVjdCBzb2NrICpzaywg
aW50IGVtYnJpb24pCiAKIAl1bml4X3N0YXRlX3VubG9jayhzayk7CiAKKyNpZiBJU19FTkFCTEVE
KENPTkZJR19BRl9VTklYX09PQikKKwlpZiAodS0+b29iX3NrYikgeworCQlrZnJlZV9za2IodS0+
b29iX3NrYik7CisJCXUtPm9vYl9za2IgPSBOVUxMOworCX0KKyNlbmRpZgorCiAJd2FrZV91cF9p
bnRlcnJ1cHRpYmxlX2FsbCgmdS0+cGVlcl93YWl0KTsKIAogCWlmIChza3BhaXIgIT0gTlVMTCkg
ewotLSAKMi4zOC4xLjI3My5nNDNhMTdiZmVhYy1nb29nCgo=
--000000000000d7e23205ec8b4b43--
