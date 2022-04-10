Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DECF4FAF1B
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbiDJQ4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 12:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbiDJQz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 12:55:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5674B436
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 09:53:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so492081pjb.1
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 09:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to;
        bh=rMZpmr+m2JMHJjjS8npoHKx5Nqv63hbs26FU69O+Dg0=;
        b=5dxwLjBfSXjqozEz3z5jB2N6tKIu42D9Bh1kBZcQTwglD392r1pYWQHJEi+hPU0BVp
         1bRx/m9u4Au6YTw/O8iZj8f5+/77iDy9ghrHySqmQxSbA6d6iQlsSiOfPvPnyKoo8s8m
         ga60GWsn4FBD8OGyocTtxRcbGD9NvbkvMfHEnpodgYoIThfCkYGwfpB1kYpH2cPDviCD
         aF+SPOj7KPUXqhDb6MOcW3a4nMBbUZH+m8Xj7kohkdEGZNfdb+1Lkne7/K9b3cioBvO/
         X3bjizzrAjk9W8E1dKcpvV4XVGA6wiEtj7HCp9zvltOFKeymR2aKJfUYswYdUeB52Fob
         WIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to;
        bh=rMZpmr+m2JMHJjjS8npoHKx5Nqv63hbs26FU69O+Dg0=;
        b=R8Q+knophhQvoPbb5uT8ZMjMCyJ9J6n8XL1msrrjwdD9hc6sEM7EiMLbFfsfoNOnqh
         E3cGr/wm7C8O8cdHaPgNvqaQnO0DwFlDIXRf3kmvFPqhGdcvIJDP6DW5T5CpfDi8Vzti
         9KhOfyxvZRytX5igf/JHuQA4lWpu1MCmeqIwvNO3CRlzAmCbUqLnUWq0feiOUtHET56p
         gM9WQ63NXRK4pkEnbkImO3V7Z1XzNAOgEuCHu4Qgds3Rp+c34cN8mfVVMDSu/h0m5Wg5
         r/mbbOb0p87mFv6Hc5OeFhgnfe9KIUpE4xxTEXCwrRrk65NCL3Y0AJ3mX+ekesnuCBgm
         yGuQ==
X-Gm-Message-State: AOAM5313STgcYRabFTsfevs74AX7rcJM0UUXobsRk0jne8crmEFe82j9
        bt5giQOODLfIma/aYUjtWTDIQ1mAiqwFww==
X-Google-Smtp-Source: ABdhPJxqqtJb/BDOEH4j0EmoKTu6Dvk7zGgY8FkDGdeVEUXIyl9IalkxbZhmhFyrK+8kPbyxSadI/Q==
X-Received: by 2002:a17:90a:d3d1:b0:1bb:fdc5:182 with SMTP id d17-20020a17090ad3d100b001bbfdc50182mr32689217pjw.206.1649609628174;
        Sun, 10 Apr 2022 09:53:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020a17090a6d9000b001c9c3e2a177sm17590969pjk.27.2022.04.10.09.53.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 09:53:47 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------BQh0WMGv7GMr608DUzQSOj3s"
Message-ID: <22c864c3-d0c5-8081-f965-754db2e75069@kernel.dk>
Date:   Sun, 10 Apr 2022 10:53:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Queue up 5.10 io_uring backport
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     stable@vger.kernel.org
References: <5baa6fdd-4f5e-338b-7c38-28e5a88bfe65@kernel.dk>
In-Reply-To: <5baa6fdd-4f5e-338b-7c38-28e5a88bfe65@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------BQh0WMGv7GMr608DUzQSOj3s
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/22 10:46 AM, Jens Axboe wrote:
> Hi,
> 
> Can you queue up this one for 5.10 stable? It has an extra hunk
> that's needed for 5.10. 5.15/16/17 will be a direct port of
> the 5.18-rc patch.

Here's the 5.15-stable backport. For 5.16 and 5.17, the upstream commit
will apply directly with no fuzz.

-- 
Jens Axboe

--------------BQh0WMGv7GMr608DUzQSOj3s
Content-Type: text/x-patch; charset=UTF-8; name="5.15-port.patch"
Content-Disposition: attachment; filename="5.15-port.patch"
Content-Transfer-Encoding: base64

Y29tbWl0IGU2NzdlZGJjYWJlZTg0OWJmZGQ0M2YxNjAyYmNjYmVjZjczNmE2NDYKQXV0aG9y
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6ICAgRnJpIEFwciA4IDExOjA4
OjU4IDIwMjIgLTA2MDAKCiAgICBpb191cmluZzogZml4IHJhY2UgYmV0d2VlbiB0aW1lb3V0
IGZsdXNoIGFuZCByZW1vdmFsCiAgICAKICAgIGlvX2ZsdXNoX3RpbWVvdXRzKCkgYXNzdW1l
cyB0aGUgdGltZW91dCBpc24ndCBpbiBwcm9ncmVzcyBvZiB0cmlnZ2VyaW5nCiAgICBvciBi
ZWluZyByZW1vdmVkL2NhbmNlbGVkLCBzbyBpdCB1bmNvbmRpdGlvbmFsbHkgcmVtb3ZlcyBp
dCBmcm9tIHRoZQogICAgdGltZW91dCBsaXN0IGFuZCBhdHRlbXB0cyB0byBjYW5jZWwgaXQu
CiAgICAKICAgIExlYXZlIGl0IG9uIHRoZSBsaXN0IGFuZCBsZXQgdGhlIG5vcm1hbCB0aW1l
b3V0IGNhbmNlbGF0aW9uIHRha2UgY2FyZQogICAgb2YgaXQuCiAgICAKICAgIENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnICMgNS41KwogICAgU2lnbmVkLW9mZi1ieTogSmVucyBBeGJv
ZSA8YXhib2VAa2VybmVsLmRrPgoKZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9mcy9p
b191cmluZy5jCmluZGV4IDVmYzNhNjJlYWU3Mi4uMDIwMmE2YzQzMWRmIDEwMDY0NAotLS0g
YS9mcy9pb191cmluZy5jCisrKyBiL2ZzL2lvX3VyaW5nLmMKQEAgLTE1NDYsMTIgKzE1NDYs
MTEgQEAgc3RhdGljIHZvaWQgaW9fZmx1c2hfdGltZW91dHMoc3RydWN0IGlvX3JpbmdfY3R4
ICpjdHgpCiAJX19tdXN0X2hvbGQoJmN0eC0+Y29tcGxldGlvbl9sb2NrKQogewogCXUzMiBz
ZXEgPSBjdHgtPmNhY2hlZF9jcV90YWlsIC0gYXRvbWljX3JlYWQoJmN0eC0+Y3FfdGltZW91
dHMpOworCXN0cnVjdCBpb19raW9jYiAqcmVxLCAqdG1wOwogCiAJc3Bpbl9sb2NrX2lycSgm
Y3R4LT50aW1lb3V0X2xvY2spOwotCXdoaWxlICghbGlzdF9lbXB0eSgmY3R4LT50aW1lb3V0
X2xpc3QpKSB7CisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHJlcSwgdG1wLCAmY3R4LT50
aW1lb3V0X2xpc3QsIHRpbWVvdXQubGlzdCkgewogCQl1MzIgZXZlbnRzX25lZWRlZCwgZXZl
bnRzX2dvdDsKLQkJc3RydWN0IGlvX2tpb2NiICpyZXEgPSBsaXN0X2ZpcnN0X2VudHJ5KCZj
dHgtPnRpbWVvdXRfbGlzdCwKLQkJCQkJCXN0cnVjdCBpb19raW9jYiwgdGltZW91dC5saXN0
KTsKIAogCQlpZiAoaW9faXNfdGltZW91dF9ub3NlcShyZXEpKQogCQkJYnJlYWs7CkBAIC0x
NTY4LDcgKzE1NjcsNiBAQCBzdGF0aWMgdm9pZCBpb19mbHVzaF90aW1lb3V0cyhzdHJ1Y3Qg
aW9fcmluZ19jdHggKmN0eCkKIAkJaWYgKGV2ZW50c19nb3QgPCBldmVudHNfbmVlZGVkKQog
CQkJYnJlYWs7CiAKLQkJbGlzdF9kZWxfaW5pdCgmcmVxLT50aW1lb3V0Lmxpc3QpOwogCQlp
b19raWxsX3RpbWVvdXQocmVxLCAwKTsKIAl9CiAJY3R4LT5jcV9sYXN0X3RtX2ZsdXNoID0g
c2VxOwpAQCAtNjIxMCw2ICs2MjA4LDcgQEAgc3RhdGljIGludCBpb190aW1lb3V0X3ByZXAo
c3RydWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSwK
IAlpZiAoZ2V0X3RpbWVzcGVjNjQoJmRhdGEtPnRzLCB1NjRfdG9fdXNlcl9wdHIoc3FlLT5h
ZGRyKSkpCiAJCXJldHVybiAtRUZBVUxUOwogCisJSU5JVF9MSVNUX0hFQUQoJnJlcS0+dGlt
ZW91dC5saXN0KTsKIAlkYXRhLT5tb2RlID0gaW9fdHJhbnNsYXRlX3RpbWVvdXRfbW9kZShm
bGFncyk7CiAJaHJ0aW1lcl9pbml0KCZkYXRhLT50aW1lciwgaW9fdGltZW91dF9nZXRfY2xv
Y2soZGF0YSksIGRhdGEtPm1vZGUpOwogCg==

--------------BQh0WMGv7GMr608DUzQSOj3s--
