Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63546174AF
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 03:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiKCC7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 22:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKCC7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 22:59:37 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E203813F96
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 19:59:36 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id k26so398291qkg.2
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 19:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uoVTnXGiQwG9fBZGRhOLt+p4dy1iNjh0PwRuTr2Hp7w=;
        b=tQ1p/DEvUS6D6vDaLsqZP4vzx947kVpitRVFD50IPDxBDekUzPTRjPYMTYr/TL05Gx
         iENvXyo7ofCVOCAiWZrzz5wcUfK8tT6tW3owXoYBHPTzJeNJDOnyAEkcfcVrc1yr7zD/
         EcgGJFIh3FGRA/5dCvsso+RevAQVYMh/e515GFoF/CG9DNOR04vgHfqqero/wPjXhM/J
         3VSfpbnXFAuIKCmXhQIvkwE002dRAuTrTJ0jRoJiVWII7/l4CwLCZAT0m/MreqTOOLoR
         mLkoWbTvd93q75sF+/oBbt6deUNauM8Jh+DRmSr4aZ41ina8k1WxGgYiMFIohg7V8Ykk
         aPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uoVTnXGiQwG9fBZGRhOLt+p4dy1iNjh0PwRuTr2Hp7w=;
        b=UFAB0px1Ov79KAwpzBdaeVTpvyQc9uS0pYadqFAllcYxb50tf7H2QyGWfsbwHjv2hR
         NMYYJrMxp6plMK7mXW8o7G9vhYBfyssTfXP+WN4T+x3x6C+m8bCcBVXVHF+7r6h5O6Uo
         7HPgjDecZ7uu0xbKdPuNvm6ZQ+t4ZG/0UoI3azo4zOqik3bXwIMyxw1Bzhrc5qPqGgFk
         hFTGq/DdPCG/6gnK7XGi94YgiGHzQIBnFfBLMbp7l0OWLvRf1LMJBDYHzjfZHin3TBvQ
         pyJVCmbO0OFlTP0SK4rEaI9MZzZJ63lPLXHoqgJwDfkYFuGC0bHBEg11g1/wq0Bn0Vlk
         exgw==
X-Gm-Message-State: ACrzQf19r3fKVPs9XTpzXTisKyL2uFJOa/0sxgwkYYAhJUc/6STZT8K8
        r+yozSNO1uWS4vUeZqocQsqMIXbTzLmFmhiXrzeTsILuAbE=
X-Google-Smtp-Source: AMsMyM5sAQ3YaUS0FoqWofNuCoUdQZ5BV4Dgh4nDvSc59905JRYpJ8ybbBh4zG5cCxhoro1mbXPbLVqPaPkdKPglfjM=
X-Received: by 2002:a05:620a:140d:b0:6f9:c38b:4d7 with SMTP id
 d13-20020a05620a140d00b006f9c38b04d7mr20956440qkj.140.1667444375956; Wed, 02
 Nov 2022 19:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
 <Y2F0s/+TDf7deuIg@kroah.com>
In-Reply-To: <Y2F0s/+TDf7deuIg@kroah.com>
From:   Anil Altinay <aaltinay@google.com>
Date:   Wed, 2 Nov 2022 19:59:24 -0700
Message-ID: <CACCxZWPVXAR2tdf7twp=OtOico=EhaXjVQY=yxdxhMgJutuEfw@mail.gmail.com>
Subject: Re: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15 stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b6a9ab05ec8825cb"
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

--000000000000b6a9ab05ec8825cb
Content-Type: text/plain; charset="UTF-8"

Please see attached patch for backported version with the commit
message updated with the upstream commit SHA. I also applied this
patch to our kernel and it built fine. Hopefully, it is good to go
this time.


On Tue, Nov 1, 2022 at 12:33 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Oct 31, 2022 at 11:25:32AM -0700, Anil Altinay wrote:
> > Hi,
> >
> > Can you please backport the following commit to 5.15 stable?
> > Title: "af_unix: Fix memory leaks of the whole sk due to OOB skb."
> > Commit SHA: 7a62ed61367b8fd01bae1e18e30602c25060d824
> >
> > This commit fixes "314001f0bf927015e459c9d387d62a231fe93af3" which
> > landed on "tags/v5.15-rc1~157^2~305".
>
> As this commit does not apply cleanly on the 5.15.y tree, how was it
> tested?
>
> Can you provide a working version of this change so that we can apply
> it?
>
> thanks,
>
> greg k-h

--000000000000b6a9ab05ec8825cb
Content-Type: application/x-patch; 
	name="0001-af_unix-Fix-memory-leaks-of-the-whole-sk-due-to-OOB-.patch"
Content-Disposition: attachment; 
	filename="0001-af_unix-Fix-memory-leaks-of-the-whole-sk-due-to-OOB-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_la05f0ki0>
X-Attachment-Id: f_la05f0ki0

RnJvbSA0MjllODAyYWM2OWE5Y2NiZDAzYjg3M2RiYTU5MTc0YjIzOGUzMTE5IE1vbiBTZXAgMTcg
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
U2lnbmVkLW9mZi1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PgotLS0K
IG5ldC91bml4L2FmX3VuaXguYyB8IDEzICsrKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L3VuaXgvYWZf
dW5peC5jIGIvbmV0L3VuaXgvYWZfdW5peC5jCmluZGV4IDc4ZTA4ZTgyYzA4Yy4uM2QyMGE5Yjky
M2FiIDEwMDY0NAotLS0gYS9uZXQvdW5peC9hZl91bml4LmMKKysrIGIvbmV0L3VuaXgvYWZfdW5p
eC5jCkBAIC01MDQsMTIgKzUwNCw2IEBAIHN0YXRpYyB2b2lkIHVuaXhfc29ja19kZXN0cnVjdG9y
KHN0cnVjdCBzb2NrICpzaykKIAogCXNrYl9xdWV1ZV9wdXJnZSgmc2stPnNrX3JlY2VpdmVfcXVl
dWUpOwogCi0jaWYgSVNfRU5BQkxFRChDT05GSUdfQUZfVU5JWF9PT0IpCi0JaWYgKHUtPm9vYl9z
a2IpIHsKLQkJa2ZyZWVfc2tiKHUtPm9vYl9za2IpOwotCQl1LT5vb2Jfc2tiID0gTlVMTDsKLQl9
Ci0jZW5kaWYKIAlXQVJOX09OKHJlZmNvdW50X3JlYWQoJnNrLT5za193bWVtX2FsbG9jKSk7CiAJ
V0FSTl9PTighc2tfdW5oYXNoZWQoc2spKTsKIAlXQVJOX09OKHNrLT5za19zb2NrZXQpOwpAQCAt
NTU2LDYgKzU1MCwxMyBAQCBzdGF0aWMgdm9pZCB1bml4X3JlbGVhc2Vfc29jayhzdHJ1Y3Qgc29j
ayAqc2ssIGludCBlbWJyaW9uKQogCiAJdW5peF9zdGF0ZV91bmxvY2soc2spOwogCisjaWYgSVNf
RU5BQkxFRChDT05GSUdfQUZfVU5JWF9PT0IpCisJaWYgKHUtPm9vYl9za2IpIHsKKwkJa2ZyZWVf
c2tiKHUtPm9vYl9za2IpOworCQl1LT5vb2Jfc2tiID0gTlVMTDsKKwl9CisjZW5kaWYKKwogCXdh
a2VfdXBfaW50ZXJydXB0aWJsZV9hbGwoJnUtPnBlZXJfd2FpdCk7CiAKIAlpZiAoc2twYWlyICE9
IE5VTEwpIHsKLS0gCjIuMzguMS4yNzMuZzQzYTE3YmZlYWMtZ29vZwoK
--000000000000b6a9ab05ec8825cb--
