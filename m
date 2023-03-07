Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD56AFAC3
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 00:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCGXvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 18:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGXvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 18:51:12 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B594A42FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 15:51:10 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x7so7216346pff.7
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 15:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678233070;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZ2bklo5JHj8bhxmn3bsIwDBdYGL4vgR8BcaTvr+GMM=;
        b=dtXgC3ZlQ6QRQkOqT7lh2llgefvppiqzxUKNFoK2VuTGlhJwNjxjhWm9rBO3/IjlcB
         fCC01buoBjKtvV497HzxbG5s8F2ft5zQHVizbdzthi6X5cBO7ympR6imzM9n6DPRBu9f
         797X8QyLYLyiWTq/x0I1scUAdcOwW61BkyTkb0snkdTLeJRBGi1Nb9/lgYGA+YwIIXnZ
         J7qHLO8c5LlqGmeAKKgh4T5YOfsSYtxvikfsIAhoBqWofT6v0JKwrN0MHS74MnJzxnf7
         a9dQ/Ul3Abn9XX01h+Z7qgIGrXeCdff4dOt1+CPRacG9HJ572pcxaQCgsAXmPKqce/Wy
         Kc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678233070;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KZ2bklo5JHj8bhxmn3bsIwDBdYGL4vgR8BcaTvr+GMM=;
        b=YQ+OWDIqxDo5eQ29eaFRyhQjPnvf0i/rze1AYZ6IrF7PFSItfOdHsca5L5ZA2ESXYf
         I60r99pXL/H0lpcMA9Bc5Fllo/+zgt1O+0zqwVwGraqBeic8bBdtphyTLKsFtlZcWE2W
         Z2bn6RdQLxsIxa2Mep1GnoejeiWPiZ0ez7nwewMQT7PaocTqWyFnqCKUdIYh0ShxBKht
         gjoBR24MO5OgvSeqXjfx1KGkwcm/1cuo7vP6vVuz+3tnQIktg0Lx6piYljVxvhe0vDOY
         1Y9Nm4v4CXWzvmPMD9OAJ+HaTVlLcmxBLaXr1Ob1fJnbrs/5Z0MGVtXmxoDvDjEUy8wE
         VKng==
X-Gm-Message-State: AO0yUKV5ZyNUohRNLUWNhEJJtbVYqSBw0fjXotNDYB0F1DUyqA8Q1o6/
        V4IL+6MmeJSFztBc1IC7YARlNx90hyLgzKwcmNU=
X-Google-Smtp-Source: AK7set/YA0kYrzhrxv+8g4d73RECcWlbQTo3ynEUqk9UkZS99+XT1qD505Cz2oIBfWQJjqxU2nsA4Q==
X-Received: by 2002:a05:6a00:1342:b0:61a:50f:cad1 with SMTP id k2-20020a056a00134200b0061a050fcad1mr715687pfu.3.1678233069705;
        Tue, 07 Mar 2023 15:51:09 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id m26-20020a056a00165a00b005a8aab9ae7esm8355848pfc.216.2023.03.07.15.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 15:51:09 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------uynS03mnQorDbaD5ggdMcXLK"
Message-ID: <5ec382c3-1de3-abf4-e6a4-b50c75a1eb28@kernel.dk>
Date:   Tue, 7 Mar 2023 16:51:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring/poll: allow some retries for poll
 triggering" failed to apply to 6.1-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <167809981810941@kroah.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <167809981810941@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------uynS03mnQorDbaD5ggdMcXLK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/6/23 3:50 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch just needs:

df730ec21f7b ("io_uring: fix two assignments in if conditions")

cherry picked first. I'm attaching that one, and the one from this email,
they will apply directly to 6.1-stable. Or you can just cherry-pick
them as that'll work too, as long as you do df730ec21f7b first. Thanks!

-- 
Jens Axboe


--------------uynS03mnQorDbaD5ggdMcXLK
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-poll-allow-some-retries-for-poll-triggering.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-poll-allow-some-retries-for-poll-triggering.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxMzM4NTE2ZTk2MjFjNDAwMjNkZTcyZTAyYTQxMzA5MTJjNzc3MWMzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFNhdCwgMjUgRmViIDIwMjMgMTI6NTM6NTMgLTA3MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gaW9fdXJpbmcvcG9sbDogYWxsb3cgc29tZSByZXRyaWVzIGZvciBwb2xsIHRyaWdnZXJp
bmcKIHNwdXJpb3VzbHkKCmNvbW1pdCBjMTZiZGEzNzU5NGY4MzE0N2IxNjdkMzgxZDU0YzAx
MDAyNGVmZWNmIHVwc3RyZWFtLgoKSWYgd2UgZ2V0IHdva2VuIHNwdXJpb3VzbHkgd2hlbiBw
b2xsaW5nIGFuZCBmYWlsIHRoZSBvcGVyYXRpb24gd2l0aAotRUFHQUlOIGFnYWluLCB0aGVu
IHdlIGdlbmVyYWxseSBvbmx5IGFsbG93IHBvbGxpbmcgYWdhaW4gaWYgZGF0YQpoYWQgYmVl
biB0cmFuc2ZlcnJlZCBhdCBzb21lIHBvaW50LiBUaGlzIGlzIGluZGljYXRlZCB3aXRoClJF
UV9GX1BBUlRJQUxfSU8uIEhvd2V2ZXIsIGlmIHRoZSBzcHVyaW91cyBwb2xsIHRyaWdnZXJz
IHdoZW4gdGhlIHNvY2tldAp3YXMgb3JpZ2luYWxseSBlbXB0eSwgdGhlbiB3ZSBoYXZlbid0
IHRyYW5zZmVycmVkIGRhdGEgeWV0IGFuZCB3ZSB3aWxsCmZhaWwgdGhlIHBvbGwgcmUtYXJt
LiBUaGlzIGVpdGhlciBwdW50cyB0aGUgc29ja2V0IHRvIGlvLXdxIGlmIGl0J3MKYmxvY2tp
bmcsIG9yIGl0IGZhaWxzIHRoZSByZXF1ZXN0IHdpdGggLUVBR0FJTiBpZiBub3QuIE5laXRo
ZXIgY29uZGl0aW9uCmlzIGRlc2lyYWJsZSwgYXMgdGhlIGZvcm1lciB3aWxsIHNsb3cgdGhp
bmdzIGRvd24sIHdoaWxlIHRoZSBsYXR0ZXIKd2lsbCBtYWtlIHRoZSBhcHBsaWNhdGlvbiBj
b25mdXNlZC4KCldlIHdhbnQgdG8gZW5zdXJlIHRoYXQgYSByZXBlYXRlZCBwb2xsIHRyaWdn
ZXIgZG9lc24ndCBsZWFkIHRvIGluZmluaXRlCndvcmsgbWFraW5nIG5vIHByb2dyZXNzLCB0
aGF0J3Mgd2hhdCB0aGUgUkVRX0ZfUEFSVElBTF9JTyBjaGVjayB3YXMKZm9yLiBCdXQgaXQg
ZG9lc24ndCBwcm90ZWN0IGFnYWluc3QgYSBsb29wIHBvc3QgdGhlIGZpcnN0IHJlY2VpdmUs
IGFuZAppdCdzIHVubmVjZXNzYXJpbHkgc3RyaWN0IGlmIHdlIHN0YXJ0ZWQgb3V0IHdpdGgg
YW4gZW1wdHkgc29ja2V0LgoKQWRkIGEgc29tZXdoYXQgcmFuZG9tIHJldHJ5IGNvdW50LCBq
dXN0IHRvIHB1dCBhbiB1cHBlciBsaW1pdCBvbiB0aGUKcG90ZW50aWFsIG51bWJlciBvZiBy
ZXRyaWVzIHRoYXQgd2lsbCBiZSBkb25lLiBUaGlzIHNob3VsZCBiZSBoaWdoIGVub3VnaAp0
aGF0IHdlIHdvbid0IHJlYWxseSBoaXQgaXQgaW4gcHJhY3RpY2UsIHVubGVzcyBzb21ldGhp
bmcgbmVlZHMgdG8gYmUKYWJvcnRlZCBhbnl3YXkuCgpDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZyAjIHY1LjEwKwpMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vYXhib2UvbGlidXJpbmcv
aXNzdWVzLzM2NApTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+
Ci0tLQogaW9fdXJpbmcvcG9sbC5jIHwgMTQgKysrKysrKysrKysrLS0KIGlvX3VyaW5nL3Bv
bGwuaCB8ICAxICsKIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9wb2xsLmMgYi9pb191cmluZy9wb2xs
LmMKaW5kZXggOGFhOWRkOWU1MDRhLi41NmRiZDE4NjNjNzggMTAwNjQ0Ci0tLSBhL2lvX3Vy
aW5nL3BvbGwuYworKysgYi9pb191cmluZy9wb2xsLmMKQEAgLTY2OCw2ICs2NjgsMTQgQEAg
c3RhdGljIHZvaWQgaW9fYXN5bmNfcXVldWVfcHJvYyhzdHJ1Y3QgZmlsZSAqZmlsZSwgc3Ry
dWN0IHdhaXRfcXVldWVfaGVhZCAqaGVhZCwKIAlfX2lvX3F1ZXVlX3Byb2MoJmFwb2xsLT5w
b2xsLCBwdCwgaGVhZCwgJmFwb2xsLT5kb3VibGVfcG9sbCk7CiB9CiAKKy8qCisgKiBXZSBj
YW4ndCByZWxpYWJseSBkZXRlY3QgbG9vcHMgaW4gcmVwZWF0ZWQgcG9sbCB0cmlnZ2VycyBh
bmQgaXNzdWUKKyAqIHN1YnNlcXVlbnRseSBmYWlsaW5nLiBCdXQgcmF0aGVyIHRoYW4gZmFp
bCB0aGVzZSBpbW1lZGlhdGVseSwgYWxsb3cgYQorICogY2VydGFpbiBhbW91bnQgb2YgcmV0
cmllcyBiZWZvcmUgd2UgZ2l2ZSB1cC4gR2l2ZW4gdGhhdCB0aGlzIGNvbmRpdGlvbgorICog
c2hvdWxkIF9yYXJlbHlfIHRyaWdnZXIgZXZlbiBvbmNlLCB3ZSBzaG91bGQgYmUgZmluZSB3
aXRoIGEgbGFyZ2VyIHZhbHVlLgorICovCisjZGVmaW5lIEFQT0xMX01BWF9SRVRSWQkJMTI4
CisKIHN0YXRpYyBzdHJ1Y3QgYXN5bmNfcG9sbCAqaW9fcmVxX2FsbG9jX2Fwb2xsKHN0cnVj
dCBpb19raW9jYiAqcmVxLAogCQkJCQkgICAgIHVuc2lnbmVkIGlzc3VlX2ZsYWdzKQogewpA
QCAtNjgzLDE0ICs2OTEsMTggQEAgc3RhdGljIHN0cnVjdCBhc3luY19wb2xsICppb19yZXFf
YWxsb2NfYXBvbGwoc3RydWN0IGlvX2tpb2NiICpyZXEsCiAJCWlmIChlbnRyeSA9PSBOVUxM
KQogCQkJZ290byBhbGxvY19hcG9sbDsKIAkJYXBvbGwgPSBjb250YWluZXJfb2YoZW50cnks
IHN0cnVjdCBhc3luY19wb2xsLCBjYWNoZSk7CisJCWFwb2xsLT5wb2xsLnJldHJpZXMgPSBB
UE9MTF9NQVhfUkVUUlk7CiAJfSBlbHNlIHsKIGFsbG9jX2Fwb2xsOgogCQlhcG9sbCA9IGtt
YWxsb2Moc2l6ZW9mKCphcG9sbCksIEdGUF9BVE9NSUMpOwogCQlpZiAodW5saWtlbHkoIWFw
b2xsKSkKIAkJCXJldHVybiBOVUxMOworCQlhcG9sbC0+cG9sbC5yZXRyaWVzID0gQVBPTExf
TUFYX1JFVFJZOwogCX0KIAlhcG9sbC0+ZG91YmxlX3BvbGwgPSBOVUxMOwogCXJlcS0+YXBv
bGwgPSBhcG9sbDsKKwlpZiAodW5saWtlbHkoIS0tYXBvbGwtPnBvbGwucmV0cmllcykpCisJ
CXJldHVybiBOVUxMOwogCXJldHVybiBhcG9sbDsKIH0KIApAQCAtNzEyLDggKzcyNCw2IEBA
IGludCBpb19hcm1fcG9sbF9oYW5kbGVyKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25l
ZCBpc3N1ZV9mbGFncykKIAkJcmV0dXJuIElPX0FQT0xMX0FCT1JURUQ7CiAJaWYgKCFmaWxl
X2Nhbl9wb2xsKHJlcS0+ZmlsZSkpCiAJCXJldHVybiBJT19BUE9MTF9BQk9SVEVEOwotCWlm
ICgocmVxLT5mbGFncyAmIChSRVFfRl9QT0xMRUR8UkVRX0ZfUEFSVElBTF9JTykpID09IFJF
UV9GX1BPTExFRCkKLQkJcmV0dXJuIElPX0FQT0xMX0FCT1JURUQ7CiAJaWYgKCEocmVxLT5m
bGFncyAmIFJFUV9GX0FQT0xMX01VTFRJU0hPVCkpCiAJCW1hc2sgfD0gRVBPTExPTkVTSE9U
OwogCmRpZmYgLS1naXQgYS9pb191cmluZy9wb2xsLmggYi9pb191cmluZy9wb2xsLmgKaW5k
ZXggNWYzYmFlNTBmYzgxLi5iMjM5M2I0MDNhMmMgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3Bv
bGwuaAorKysgYi9pb191cmluZy9wb2xsLmgKQEAgLTEyLDYgKzEyLDcgQEAgc3RydWN0IGlv
X3BvbGwgewogCXN0cnVjdCBmaWxlCQkJKmZpbGU7CiAJc3RydWN0IHdhaXRfcXVldWVfaGVh
ZAkJKmhlYWQ7CiAJX19wb2xsX3QJCQlldmVudHM7CisJaW50CQkJCXJldHJpZXM7CiAJc3Ry
dWN0IHdhaXRfcXVldWVfZW50cnkJCXdhaXQ7CiB9OwogCi0tIAoyLjM5LjIKCg==
--------------uynS03mnQorDbaD5ggdMcXLK
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-fix-two-assignments-in-if-conditions.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-fix-two-assignments-in-if-conditions.patch"
Content-Transfer-Encoding: base64

RnJvbSA1OWE1ZGYyMjc0ODA3Mjg4NTQ3YTc0MGZkMmJjMjU4YTU4OTQ0Mzk2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBYaW5naHVpIExpIDxrb3JhbnRsaUB0ZW5jZW50LmNv
bT4KRGF0ZTogV2VkLCAyIE5vdiAyMDIyIDE2OjI1OjAzICswODAwClN1YmplY3Q6IFtQQVRD
SCAxLzJdIGlvX3VyaW5nOiBmaXggdHdvIGFzc2lnbm1lbnRzIGluIGlmIGNvbmRpdGlvbnMK
CmNvbW1pdCBkZjczMGVjMjFmN2JhMzk1YjFiMjJlN2Y5M2EzYTg1YjFkMWI3ODgyIHVwc3Ry
ZWFtLgoKRml4ZXMgdHdvIGVycm9yczoKCiJFUlJPUjogZG8gbm90IHVzZSBhc3NpZ25tZW50
IGluIGlmIGNvbmRpdGlvbgoxMzA6IEZJTEU6IGlvX3VyaW5nL25ldC5jOjEzMDoKKyAgICAg
ICBpZiAoIShpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfVU5MT0NLRUQpICYmCgpFUlJPUjog
ZG8gbm90IHVzZSBhc3NpZ25tZW50IGluIGlmIGNvbmRpdGlvbgo1OTk6IEZJTEU6IGlvX3Vy
aW5nL3BvbGwuYzo1OTk6CisgICAgICAgfSBlbHNlIGlmICghKGlzc3VlX2ZsYWdzICYgSU9f
VVJJTkdfRl9VTkxPQ0tFRCkgJiYiCnJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2gucGwgaW4gbmV0
LmMgYW5kIHBvbGwuYyAuCgpTaWduZWQtb2ZmLWJ5OiBYaW5naHVpIExpIDxrb3JhbnRsaUB0
ZW5jZW50LmNvbT4KUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwu
Y29tPgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIxMTAyMDgyNTAzLjMy
MjM2LTEta29yYW50d29ya0BnbWFpbC5jb20KW2F4Ym9lOiBzdHlsZSB0d2Vha3NdClNpZ25l
ZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpb191cmluZy9u
ZXQuYyAgfCAxNiArKysrKysrKystLS0tLS0tCiBpb191cmluZy9wb2xsLmMgfCAgNyArKysr
Ky0tCiAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvbmV0LmMgYi9pb191cmluZy9uZXQuYwppbmRleCA1
MjBhNzNiNWE0NDguLmU3ZTRlYzE2MzM3ZCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvbmV0LmMK
KysrIGIvaW9fdXJpbmcvbmV0LmMKQEAgLTEyNiwxMyArMTI2LDE1IEBAIHN0YXRpYyBzdHJ1
Y3QgaW9fYXN5bmNfbXNnaGRyICppb19tc2dfYWxsb2NfYXN5bmMoc3RydWN0IGlvX2tpb2Ni
ICpyZXEsCiAJc3RydWN0IGlvX2NhY2hlX2VudHJ5ICplbnRyeTsKIAlzdHJ1Y3QgaW9fYXN5
bmNfbXNnaGRyICpoZHI7CiAKLQlpZiAoIShpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfVU5M
T0NLRUQpICYmCi0JICAgIChlbnRyeSA9IGlvX2FsbG9jX2NhY2hlX2dldCgmY3R4LT5uZXRt
c2dfY2FjaGUpKSAhPSBOVUxMKSB7Ci0JCWhkciA9IGNvbnRhaW5lcl9vZihlbnRyeSwgc3Ry
dWN0IGlvX2FzeW5jX21zZ2hkciwgY2FjaGUpOwotCQloZHItPmZyZWVfaW92ID0gTlVMTDsK
LQkJcmVxLT5mbGFncyB8PSBSRVFfRl9BU1lOQ19EQVRBOwotCQlyZXEtPmFzeW5jX2RhdGEg
PSBoZHI7Ci0JCXJldHVybiBoZHI7CisJaWYgKCEoaXNzdWVfZmxhZ3MgJiBJT19VUklOR19G
X1VOTE9DS0VEKSkgeworCQllbnRyeSA9IGlvX2FsbG9jX2NhY2hlX2dldCgmY3R4LT5uZXRt
c2dfY2FjaGUpOworCQlpZiAoZW50cnkpIHsKKwkJCWhkciA9IGNvbnRhaW5lcl9vZihlbnRy
eSwgc3RydWN0IGlvX2FzeW5jX21zZ2hkciwgY2FjaGUpOworCQkJaGRyLT5mcmVlX2lvdiA9
IE5VTEw7CisJCQlyZXEtPmZsYWdzIHw9IFJFUV9GX0FTWU5DX0RBVEE7CisJCQlyZXEtPmFz
eW5jX2RhdGEgPSBoZHI7CisJCQlyZXR1cm4gaGRyOworCQl9CiAJfQogCiAJaWYgKCFpb19h
bGxvY19hc3luY19kYXRhKHJlcSkpIHsKZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3BvbGwuYyBi
L2lvX3VyaW5nL3BvbGwuYwppbmRleCBhYjVhZTQ3NTg0MGYuLjhhYTlkZDllNTA0YSAxMDA2
NDQKLS0tIGEvaW9fdXJpbmcvcG9sbC5jCisrKyBiL2lvX3VyaW5nL3BvbGwuYwpAQCAtNjc4
LDEwICs2NzgsMTMgQEAgc3RhdGljIHN0cnVjdCBhc3luY19wb2xsICppb19yZXFfYWxsb2Nf
YXBvbGwoc3RydWN0IGlvX2tpb2NiICpyZXEsCiAJaWYgKHJlcS0+ZmxhZ3MgJiBSRVFfRl9Q
T0xMRUQpIHsKIAkJYXBvbGwgPSByZXEtPmFwb2xsOwogCQlrZnJlZShhcG9sbC0+ZG91Ymxl
X3BvbGwpOwotCX0gZWxzZSBpZiAoIShpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfVU5MT0NL
RUQpICYmCi0JCSAgIChlbnRyeSA9IGlvX2FsbG9jX2NhY2hlX2dldCgmY3R4LT5hcG9sbF9j
YWNoZSkpICE9IE5VTEwpIHsKKwl9IGVsc2UgaWYgKCEoaXNzdWVfZmxhZ3MgJiBJT19VUklO
R19GX1VOTE9DS0VEKSkgeworCQllbnRyeSA9IGlvX2FsbG9jX2NhY2hlX2dldCgmY3R4LT5h
cG9sbF9jYWNoZSk7CisJCWlmIChlbnRyeSA9PSBOVUxMKQorCQkJZ290byBhbGxvY19hcG9s
bDsKIAkJYXBvbGwgPSBjb250YWluZXJfb2YoZW50cnksIHN0cnVjdCBhc3luY19wb2xsLCBj
YWNoZSk7CiAJfSBlbHNlIHsKK2FsbG9jX2Fwb2xsOgogCQlhcG9sbCA9IGttYWxsb2Moc2l6
ZW9mKCphcG9sbCksIEdGUF9BVE9NSUMpOwogCQlpZiAodW5saWtlbHkoIWFwb2xsKSkKIAkJ
CXJldHVybiBOVUxMOwotLSAKMi4zOS4yCgo=

--------------uynS03mnQorDbaD5ggdMcXLK--
