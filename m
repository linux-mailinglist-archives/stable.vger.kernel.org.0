Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812D9450755
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhKOOow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:44:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236379AbhKOOoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 09:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636987288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2eGYU7kRPDzaMQLWywXxjUNa1F3/wp4T3xsGl+O0s1E=;
        b=A08u2H49+Wwn4kl5D8+ivucOC2eYSxyOlIaHGpOS850wfswBA6U3+fy6xgj65//dmW8Txe
        Ouuhncvfak/5+jbivlPBvPZ1wKIx1h+wwszBTgFZ0mci+4+6KI8mIF8M14hTnbgvKbR0DG
        u8UIHt2FXPqpAQO37rtSTHqRa9K3ddw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-RcYyIvZXNtq4V5WYK8sXrA-1; Mon, 15 Nov 2021 09:41:26 -0500
X-MC-Unique: RcYyIvZXNtq4V5WYK8sXrA-1
Received: by mail-qk1-f199.google.com with SMTP id m9-20020a05620a24c900b00467f2fdd657so9549122qkn.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 06:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2eGYU7kRPDzaMQLWywXxjUNa1F3/wp4T3xsGl+O0s1E=;
        b=gt6x6MrJkIDgg7T6e2mwWJ/PkisvHhTrxAif+unj3AGp/1SNXR9j/nbz8jrzpT7sKV
         zrEA7mMWlRF9mcXHrgCK4j2sCZ+SmGriRseg9srKuCa0KnHCSpDpS8A00Uw3rwzg+h9t
         2DJnoeghpDYGAnShmh3YBNfnen4bY7iX91P1G8YoS16Ek+XDG+BFoO95XpIMxy2tZBGc
         tYR83BZjnTn6W85HfUM7egmUhEbN/bB1BTKyMqR7sJaV0xBPPblpSnRpLspLRuH5wBP3
         qX62Lpqx4v4FaGuijBYVf/yaNl8raBQ9+MpevUHQj9BvnPHE1nWoujVtOIpUom49ZKMr
         SL5Q==
X-Gm-Message-State: AOAM532dSNkeGsG3d/9/w/nxas42nslykHGdc94zQn8K2+6TQlsD8SmF
        W1bjPpGdCIKVsH0HUMhuU5wjHAw32ggJOdU9LNPCa97OytzaR06rW6AmxD4CYeaxGEXccJPK6qh
        RUWN9eRYaWHpgY89b+BFIhpFLV9nPsTZY
X-Received: by 2002:a05:620a:20d6:: with SMTP id f22mr19954225qka.342.1636987286237;
        Mon, 15 Nov 2021 06:41:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZLOEFQhepWOw6JOzO4SCklliK49uXxlxX3b+9Zbdpx1EdICt5Nx3/qlzUBwLZHoL9MNdHDrmxWpdxBZUCz3g=
X-Received: by 2002:a05:620a:20d6:: with SMTP id f22mr19954211qka.342.1636987286055;
 Mon, 15 Nov 2021 06:41:26 -0800 (PST)
MIME-Version: 1.0
References: <1631532743204250@kroah.com>
In-Reply-To: <1631532743204250@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 15 Nov 2021 15:41:15 +0100
Message-ID: <CAOssrKd1=0vow0PBHf+d_5cLmiNUufM_LAmzJstErbP3HTHviw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fuse: truncate pagecache on
 atomic_o_trunc" failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, xieyongji@bytedance.com
Content-Type: multipart/mixed; boundary="000000000000b02b9d05d0d4cdbe"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000b02b9d05d0d4cdbe
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 13, 2021 at 1:32 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hi Greg,

Attaching the backport of commit 76224355db75 ("fuse: truncate
pagecache on atomic_o_trunc") to v4.19.217.

Thanks,
Miklos

--000000000000b02b9d05d0d4cdbe
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="fuse-truncate-pagecache-on-atomic_o_trunc-4.19.patch"
Content-Disposition: attachment; 
	filename="fuse-truncate-pagecache-on-atomic_o_trunc-4.19.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kw0rxze30>
X-Attachment-Id: f_kw0rxze30

RnJvbSA1NmQwODIwNGY3ZGE2NDJjM2M5MTRmYjViNTIwOGJmZmU5ZGViZTNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtsb3MgU3plcmVkaSA8bXN6ZXJlZGlAcmVkaGF0LmNvbT4K
RGF0ZTogVHVlLCAxNyBBdWcgMjAyMSAyMTowNToxNiArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGZ1
c2U6IHRydW5jYXRlIHBhZ2VjYWNoZSBvbiBhdG9taWNfb190cnVuYwoKZnVzZV9maW5pc2hfb3Bl
bigpIHdpbGwgYmUgY2FsbGVkIHdpdGggRlVTRV9OT1dSSVRFIGluIGNhc2Ugb2YgYXRvbWljCk9f
VFJVTkMuICBUaGlzIGNhbiBkZWFkbG9jayB3aXRoIGZ1c2Vfd2FpdF9vbl9wYWdlX3dyaXRlYmFj
aygpIGluCmZ1c2VfbGF1bmRlcl9wYWdlKCkgdHJpZ2dlcmVkIGJ5IGludmFsaWRhdGVfaW5vZGVf
cGFnZXMyKCkuCgpGaXggYnkgcmVwbGFjaW5nIGludmFsaWRhdGVfaW5vZGVfcGFnZXMyKCkgaW4g
ZnVzZV9maW5pc2hfb3BlbigpIHdpdGggYQp0cnVuY2F0ZV9wYWdlY2FjaGUoKSBjYWxsLiAgVGhp
cyBtYWtlcyBzZW5zZSByZWdhcmRsZXNzIG9mIEZPUEVOX0tFRVBfQ0FDSEUKb3IgZmMtPndyaXRl
YmFjayBjYWNoZSwgc28gZG8gaXQgdW5jb25kaXRpb25hbGx5LgoKUmVwb3J0ZWQtYnk6IFhpZSBZ
b25namkgPHhpZXlvbmdqaUBieXRlZGFuY2UuY29tPgpSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBz
eXpib3QrYmVhNDRhNTE4OTgzNmQ5NTY4OTRAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQpGaXhl
czogZTQ2NDgzMDliODVhICgiZnVzZTogdHJ1bmNhdGUgcGVuZGluZyB3cml0ZXMgb24gT19UUlVO
QyIpCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogTWlrbG9zIFN6
ZXJlZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+CihjaGVycnkgcGlja2VkIGZyb20gY29tbWl0IDc2
MjI0MzU1ZGI3NTcwY2JlNmI2Zjc1Yzg5MjlhMTU1ODgyOGRkNTUpCi0tLQogZnMvZnVzZS9maWxl
LmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZnVzZS9maWxlLmMgYi9mcy9mdXNlL2ZpbGUuYwppbmRl
eCA2YTNkODk2NzJmZjcuLjEzMzcxYTQwZjdhMSAxMDA2NDQKLS0tIGEvZnMvZnVzZS9maWxlLmMK
KysrIGIvZnMvZnVzZS9maWxlLmMKQEAgLTE3OCwxMiArMTc4LDExIEBAIHZvaWQgZnVzZV9maW5p
c2hfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAogCWlmIChm
Zi0+b3Blbl9mbGFncyAmIEZPUEVOX0RJUkVDVF9JTykKIAkJZmlsZS0+Zl9vcCA9ICZmdXNlX2Rp
cmVjdF9pb19maWxlX29wZXJhdGlvbnM7Ci0JaWYgKCEoZmYtPm9wZW5fZmxhZ3MgJiBGT1BFTl9L
RUVQX0NBQ0hFKSkKLQkJaW52YWxpZGF0ZV9pbm9kZV9wYWdlczIoaW5vZGUtPmlfbWFwcGluZyk7
CiAJaWYgKGZmLT5vcGVuX2ZsYWdzICYgRk9QRU5fU1RSRUFNKQogCQlzdHJlYW1fb3Blbihpbm9k
ZSwgZmlsZSk7CiAJZWxzZSBpZiAoZmYtPm9wZW5fZmxhZ3MgJiBGT1BFTl9OT05TRUVLQUJMRSkK
IAkJbm9uc2Vla2FibGVfb3Blbihpbm9kZSwgZmlsZSk7CisKIAlpZiAoZmMtPmF0b21pY19vX3Ry
dW5jICYmIChmaWxlLT5mX2ZsYWdzICYgT19UUlVOQykpIHsKIAkJc3RydWN0IGZ1c2VfaW5vZGUg
KmZpID0gZ2V0X2Z1c2VfaW5vZGUoaW5vZGUpOwogCkBAIC0xOTEsMTAgKzE5MCwxNCBAQCB2b2lk
IGZ1c2VfZmluaXNoX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUp
CiAJCWZpLT5hdHRyX3ZlcnNpb24gPSArK2ZjLT5hdHRyX3ZlcnNpb247CiAJCWlfc2l6ZV93cml0
ZShpbm9kZSwgMCk7CiAJCXNwaW5fdW5sb2NrKCZmYy0+bG9jayk7CisJCXRydW5jYXRlX3BhZ2Vj
YWNoZShpbm9kZSwgMCk7CiAJCWZ1c2VfaW52YWxpZGF0ZV9hdHRyKGlub2RlKTsKIAkJaWYgKGZj
LT53cml0ZWJhY2tfY2FjaGUpCiAJCQlmaWxlX3VwZGF0ZV90aW1lKGZpbGUpOworCX0gZWxzZSBp
ZiAoIShmZi0+b3Blbl9mbGFncyAmIEZPUEVOX0tFRVBfQ0FDSEUpKSB7CisJCWludmFsaWRhdGVf
aW5vZGVfcGFnZXMyKGlub2RlLT5pX21hcHBpbmcpOwogCX0KKwogCWlmICgoZmlsZS0+Zl9tb2Rl
ICYgRk1PREVfV1JJVEUpICYmIGZjLT53cml0ZWJhY2tfY2FjaGUpCiAJCWZ1c2VfbGlua193cml0
ZV9maWxlKGZpbGUpOwogfQotLSAKMi4zMS4xCgo=
--000000000000b02b9d05d0d4cdbe--

