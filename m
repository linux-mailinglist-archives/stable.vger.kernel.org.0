Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C814A3EB56D
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhHMMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhHMMZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628857512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/B9ah+gGtpZZ3JqrPhJFE6K7VGnlrCxHbZMFyn3erGI=;
        b=jKtwryMFDnRByylI25UpURiXVNb8EYRffBPhuamkBrDbdzTzM/C9i/2DIDeSuoIayZHuA8
        9DI1UD2SX09Jt2icfs+n4BCHwnzD+k1v2zDZ7wJCt/78l+jarT/Rge2ZqifQpyaHiuW+O7
        V4WZMWuU1x4VcBZL2ROQWDpJYTslLP4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-bToQAhLhMT2EI9Cc-wfw0Q-1; Fri, 13 Aug 2021 08:25:10 -0400
X-MC-Unique: bToQAhLhMT2EI9Cc-wfw0Q-1
Received: by mail-qv1-f71.google.com with SMTP id z8-20020a0ce9880000b02903528f1b338aso6907997qvn.6
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 05:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/B9ah+gGtpZZ3JqrPhJFE6K7VGnlrCxHbZMFyn3erGI=;
        b=i4ip+VjmNPvT0UxZB1Aju7lFfUNWYIrh39VNMODRaEKuF7NMO9pPUUYi+X3tP2ddpN
         C1H5YIlEErbOBx8PmHWc9nm8ygoUACUa49tye2vMpVBbNE9bc6bhv4+7AcAcVSF4VKrF
         lCR2cLGE4WGEMTJOWK8JUfRwslaVpNnjsAJ+jjykJe8/DhO7CurI20+D0YFwUHL4NKmm
         kWEhCdS1CG+3UEu/KX3EqCJRQAi+BHgh71F06qJlloCi6u+ZtTVAOgOj02pTnIh4C/Ws
         bf1JHPA0EZz1C5s40UyBX5/LjIVi5lQ12ZXL6/q7+qSQ0en5K+BoM0ZwKb76pA0Vfkzl
         k2dw==
X-Gm-Message-State: AOAM530ABSAsHdnd1c2ExUJEudMgiUvHlFCeQHlJ5ayfQmwo38JS/K+F
        nNlaaJE8Z11YXMVAKc8w+qbA8/duPRyGufXnpcs48WyWnRziYlCKMzeHocABDeE+K/vJsq0CztK
        UnKkjWlqEsBIlN8ayoYJG6ma+f5t1gww/
X-Received: by 2002:ad4:522c:: with SMTP id r12mr2226139qvq.17.1628857510353;
        Fri, 13 Aug 2021 05:25:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFouZfgC4hBb8VlKlC6mWetyD10Rvf8Ix5mahAZPBkPxG426GvAiVAAQrg0z19EiH27QAbWiPBYyZDCHYI/5w=
X-Received: by 2002:ad4:522c:: with SMTP id r12mr2226116qvq.17.1628857510130;
 Fri, 13 Aug 2021 05:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <1628845325236177@kroah.com>
In-Reply-To: <1628845325236177@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Fri, 13 Aug 2021 14:24:59 +0200
Message-ID: <CAOssrKds1jpyoq296kfJocwbo8H+cbMRRDnAQeaxM3Fk4pHO-A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: prevent private clone if bind mount
 is not allowed" failed to apply to 4.9-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     alois1@gmx-topmail.de, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000483fc105c96ff12a"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000483fc105c96ff12a
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 13, 2021 at 11:02 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 427215d85e8d1476da1a86b8d67aceb485eb3631 Mon Sep 17 00:00:00 2001

Attaching backport.  Applies to 4.4 and 4.9.

Thanks,
Miklos

--000000000000483fc105c96ff12a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ovl-prevent-private-clone-if-bind-mount-is-not-allowed-4.4.patch"
Content-Disposition: attachment; 
	filename="ovl-prevent-private-clone-if-bind-mount-is-not-allowed-4.4.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksabmol40>
X-Attachment-Id: f_ksabmol40

RnJvbTogTWlrbG9zIFN6ZXJlZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+ClN1YmplY3Q6IG92bDog
cHJldmVudCBwcml2YXRlIGNsb25lIGlmIGJpbmQgbW91bnQgaXMgbm90IGFsbG93ZWQKCkFkZCB0
aGUgZm9sbG93aW5nIGNoZWNrcyBmcm9tIF9fZG9fbG9vcGJhY2soKSB0byBjbG9uZV9wcml2YXRl
X21vdW50KCkgYXMKd2VsbDoKCiAtIHZlcmlmeSB0aGF0IHRoZSBtb3VudCBpcyBpbiB0aGUgY3Vy
cmVudCBuYW1lc3BhY2UKCiAtIHZlcmlmeSB0aGF0IHRoZXJlIGFyZSBubyBsb2NrZWQgY2hpbGRy
ZW4KClJlcG9ydGVkLWJ5OiBBbG9pcyBXb2hsc2NobGFnZXIgPGFsb2lzMUBnbXgtdG9wbWFpbC5k
ZT4KRml4ZXM6IGM3NzFkNjgzYTYyZSAoInZmczogaW50cm9kdWNlIGNsb25lX3ByaXZhdGVfbW91
bnQoKSIpCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2My4xOApTaWduZWQtb2ZmLWJ5
OiBNaWtsb3MgU3plcmVkaSA8bXN6ZXJlZGlAcmVkaGF0LmNvbT4KLS0tCiBmcy9uYW1lc3BhY2Uu
YyB8ICAgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgotLS0gYS9mcy9u
YW1lc3BhY2UuYworKysgYi9mcy9uYW1lc3BhY2UuYwpAQCAtMTc4Miw2ICsxNzgyLDIwIEBAIHZv
aWQgZHJvcF9jb2xsZWN0ZWRfbW91bnRzKHN0cnVjdCB2ZnNtb3UKIAluYW1lc3BhY2VfdW5sb2Nr
KCk7CiB9CiAKK3N0YXRpYyBib29sIGhhc19sb2NrZWRfY2hpbGRyZW4oc3RydWN0IG1vdW50ICpt
bnQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKK3sKKwlzdHJ1Y3QgbW91bnQgKmNoaWxkOworCisJ
bGlzdF9mb3JfZWFjaF9lbnRyeShjaGlsZCwgJm1udC0+bW50X21vdW50cywgbW50X2NoaWxkKSB7
CisJCWlmICghaXNfc3ViZGlyKGNoaWxkLT5tbnRfbW91bnRwb2ludCwgZGVudHJ5KSkKKwkJCWNv
bnRpbnVlOworCisJCWlmIChjaGlsZC0+bW50Lm1udF9mbGFncyAmIE1OVF9MT0NLRUQpCisJCQly
ZXR1cm4gdHJ1ZTsKKwl9CisJcmV0dXJuIGZhbHNlOworfQorCiAvKioKICAqIGNsb25lX3ByaXZh
dGVfbW91bnQgLSBjcmVhdGUgYSBwcml2YXRlIGNsb25lIG9mIGEgcGF0aAogICoKQEAgLTE3OTYs
MTYgKzE4MTAsMjcgQEAgc3RydWN0IHZmc21vdW50ICpjbG9uZV9wcml2YXRlX21vdW50KHN0cgog
CXN0cnVjdCBtb3VudCAqb2xkX21udCA9IHJlYWxfbW91bnQocGF0aC0+bW50KTsKIAlzdHJ1Y3Qg
bW91bnQgKm5ld19tbnQ7CiAKKwlkb3duX3JlYWQoJm5hbWVzcGFjZV9zZW0pOwogCWlmIChJU19N
TlRfVU5CSU5EQUJMRShvbGRfbW50KSkKLQkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7CisJCWdv
dG8gaW52YWxpZDsKKworCWlmICghY2hlY2tfbW50KG9sZF9tbnQpKQorCQlnb3RvIGludmFsaWQ7
CisKKwlpZiAoaGFzX2xvY2tlZF9jaGlsZHJlbihvbGRfbW50LCBwYXRoLT5kZW50cnkpKQorCQln
b3RvIGludmFsaWQ7CiAKLQlkb3duX3JlYWQoJm5hbWVzcGFjZV9zZW0pOwogCW5ld19tbnQgPSBj
bG9uZV9tbnQob2xkX21udCwgcGF0aC0+ZGVudHJ5LCBDTF9QUklWQVRFKTsKIAl1cF9yZWFkKCZu
YW1lc3BhY2Vfc2VtKTsKKwogCWlmIChJU19FUlIobmV3X21udCkpCiAJCXJldHVybiBFUlJfQ0FT
VChuZXdfbW50KTsKIAogCXJldHVybiAmbmV3X21udC0+bW50OworCitpbnZhbGlkOgorCXVwX3Jl
YWQoJm5hbWVzcGFjZV9zZW0pOworCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOwogfQogRVhQT1JU
X1NZTUJPTF9HUEwoY2xvbmVfcHJpdmF0ZV9tb3VudCk7CiAKQEAgLTIxMDMsMTkgKzIxMjgsNiBA
QCBzdGF0aWMgaW50IGRvX2NoYW5nZV90eXBlKHN0cnVjdCBwYXRoICpwCiAJcmV0dXJuIGVycjsK
IH0KIAotc3RhdGljIGJvb2wgaGFzX2xvY2tlZF9jaGlsZHJlbihzdHJ1Y3QgbW91bnQgKm1udCwg
c3RydWN0IGRlbnRyeSAqZGVudHJ5KQotewotCXN0cnVjdCBtb3VudCAqY2hpbGQ7Ci0JbGlzdF9m
b3JfZWFjaF9lbnRyeShjaGlsZCwgJm1udC0+bW50X21vdW50cywgbW50X2NoaWxkKSB7Ci0JCWlm
ICghaXNfc3ViZGlyKGNoaWxkLT5tbnRfbW91bnRwb2ludCwgZGVudHJ5KSkKLQkJCWNvbnRpbnVl
OwotCi0JCWlmIChjaGlsZC0+bW50Lm1udF9mbGFncyAmIE1OVF9MT0NLRUQpCi0JCQlyZXR1cm4g
dHJ1ZTsKLQl9Ci0JcmV0dXJuIGZhbHNlOwotfQotCiAvKgogICogZG8gbG9vcGJhY2sgbW91bnQu
CiAgKi8K
--000000000000483fc105c96ff12a--

