Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A43E4A31
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhHIQrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhHIQrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 12:47:22 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893BFC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 09:47:01 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a7so24493506ljq.11
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udKIodiSA3KxW+d6YqCOvFGACcreV1bn2G0GyLYDXdE=;
        b=hwRSkRNfEJcgXIaIO9CGTqqfP4caT8Ck2BVhoP/7yGzG+JZ5i1Xnj40Q1GeXjIEKm6
         KC7YMfFRK3VM6cG1IH2+1nNSFru2K8o+rZ+EF+u6j4huWqmlNHsKbrvYRU5Owk8WkAt3
         Mw0qxlHTXDtBAk/j4vYx0q4ExlIQoup4zGCBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udKIodiSA3KxW+d6YqCOvFGACcreV1bn2G0GyLYDXdE=;
        b=MVKo5LNvEzAWd+aE96mcJNR5CYxxU5wqZvvkE+mHXKI2tmQu1bwLlyyWDP7eFvvbnm
         AwkciNRlKxZn9GdkL/5s5G1L1RIYMCZ1SbJFAO8D/Vk6XslluBEUyRbNjqranlj5HX3C
         jSOx3ouug93d8ASe85T/Z31FKyxl8+v6ddhIN8daScC7PuDr2mhGlh0O4v5LDNBAyUMv
         dz//4nsbBjToJi+a53UK9aBUqNwJvcDpriQclPg9RodE2fKdTW2SDBdu98pj1lRGqbJi
         AwDqCftOFEOj1d+8nVvywYLfGbDZz0CriRHftmD4CH3z19ATd5oRZNvk+hfsAEBVuOP6
         gjqg==
X-Gm-Message-State: AOAM532CjOYVDAyPdATv7kgGHIxPpENHd+YsOgvpSmnuahwqTDX5kDJ9
        KPLp4XNvJV7ss6PnbG2Gx70r9oB8noyHQ2Ec
X-Google-Smtp-Source: ABdhPJzognvfAQN7jTabYjtEjzzkewypimsVpI+gOLwoHNMH4uzM7/VtTzx3EIlMZ5Ijol59tG1WuQ==
X-Received: by 2002:a2e:995a:: with SMTP id r26mr6559978ljj.297.1628527619730;
        Mon, 09 Aug 2021 09:46:59 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id z8sm1942967lfb.30.2021.08.09.09.46.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 09:46:59 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id h11so9496042ljo.12
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:46:58 -0700 (PDT)
X-Received: by 2002:a2e:84c7:: with SMTP id q7mr16042961ljh.61.1628527618423;
 Mon, 09 Aug 2021 09:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <162850274511123@kroah.com> <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com> <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
In-Reply-To: <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 9 Aug 2021 09:46:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
Message-ID: <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000342fbb05c92322e9"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000342fbb05c92322e9
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 9, 2021 at 9:36 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh, I guess I have to actually download the stable tree. Normally I
> only keep the main tree git around..

Ok, so it does the accounting a bit differently - after allocating
them rather than before - but it actually ends up being a simpler
patch because of that.

I think it ends up like the attached.

UNTESTED.

I'm not 100% convinced we need to backport this that far anyway, but
whatever. Nobody sane runs something like a build server on 4.4.

Nobody sane should run 4.4 at all, of course.

              Linus

--000000000000342fbb05c92322e9
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_ks4v99060>
X-Attachment-Id: f_ks4v99060

IGZzL3BpcGUuYyB8IDE3ICsrKysrKysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3Bp
cGUuYwppbmRleCA2NTM0NDcwYTZjMTkuLjM3YTAwM2I2NDVlZiAxMDA2NDQKLS0tIGEvZnMvcGlw
ZS5jCisrKyBiL2ZzL3BpcGUuYwpAQCAtMjcsNiArMjcsMjEgQEAKIAogI2luY2x1ZGUgImludGVy
bmFsLmgiCiAKKy8qCisgKiBOZXcgcGlwZSBidWZmZXJzIHdpbGwgYmUgcmVzdHJpY3RlZCB0byB0
aGlzIHNpemUgd2hpbGUgdGhlIHVzZXIgaXMgZXhjZWVkaW5nCisgKiB0aGVpciBwaXBlIGJ1ZmZl
ciBxdW90YS4gVGhlIGdlbmVyYWwgcGlwZSB1c2UgY2FzZSBuZWVkcyBhdCBsZWFzdCB0d28KKyAq
IGJ1ZmZlcnM6IG9uZSBmb3IgZGF0YSB5ZXQgdG8gYmUgcmVhZCwgYW5kIG9uZSBmb3IgbmV3IGRh
dGEuIElmIHRoaXMgaXMgbGVzcworICogdGhhbiB0d28sIHRoZW4gYSB3cml0ZSB0byBhIG5vbi1l
bXB0eSBwaXBlIG1heSBibG9jayBldmVuIGlmIHRoZSBwaXBlIGlzIG5vdAorICogZnVsbC4gVGhp
cyBjYW4gb2NjdXIgd2l0aCBHTlUgbWFrZSBqb2JzZXJ2ZXIgb3Igc2ltaWxhciB1c2VzIG9mIHBp
cGVzIGFzCisgKiBzZW1hcGhvcmVzOiBtdWx0aXBsZSBwcm9jZXNzZXMgbWF5IGJlIHdhaXRpbmcg
dG8gd3JpdGUgdG9rZW5zIGJhY2sgdG8gdGhlCisgKiBwaXBlIGJlZm9yZSByZWFkaW5nIHRva2Vu
czogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8xNjI4MDg2NzcwLjVybjhwMDRuNmoubm9u
ZUBsb2NhbGhvc3QvLgorICoKKyAqIFVzZXJzIGNhbiByZWR1Y2UgdGhlaXIgcGlwZSBidWZmZXJz
IHdpdGggRl9TRVRQSVBFX1NaIGJlbG93IHRoaXMgYXQgdGhlaXIKKyAqIG93biByaXNrLCBuYW1l
bHk6IHBpcGUgd3JpdGVzIHRvIG5vbi1mdWxsIHBpcGVzIG1heSBibG9jayB1bnRpbCB0aGUgcGlw
ZSBpcworICogZW1wdGllZC4KKyAqLworI2RlZmluZSBQSVBFX01JTl9ERUZfQlVGRkVSUyAyCisK
IC8qCiAgKiBUaGUgbWF4IHNpemUgdGhhdCBhIG5vbi1yb290IHVzZXIgaXMgYWxsb3dlZCB0byBn
cm93IHRoZSBwaXBlLiBDYW4KICAqIGJlIHNldCBieSByb290IGluIC9wcm9jL3N5cy9mcy9waXBl
LW1heC1zaXplCkBAIC02MjEsNyArNjM2LDcgQEAgc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqYWxs
b2NfcGlwZV9pbmZvKHZvaWQpCiAKIAkJaWYgKCF0b29fbWFueV9waXBlX2J1ZmZlcnNfaGFyZCh1
c2VyKSkgewogCQkJaWYgKHRvb19tYW55X3BpcGVfYnVmZmVyc19zb2Z0KHVzZXIpKQotCQkJCXBp
cGVfYnVmcyA9IDE7CisJCQkJcGlwZV9idWZzID0gUElQRV9NSU5fREVGX0JVRkZFUlM7CiAJCQlw
aXBlLT5idWZzID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHBpcGVfYnVmZmVyKSAqIHBpcGVfYnVm
cywgR0ZQX0tFUk5FTCk7CiAJCX0KIAo=
--000000000000342fbb05c92322e9--
