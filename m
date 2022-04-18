Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B371505433
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiDRNEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241361AbiDRNDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB3027146
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:43:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id md4so12902369pjb.4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=p341SqsdOUJwO1s6piaVzdmySVuxDEiMM8H40BX3VS8=;
        b=Onl/ND0T5yYd35MMoyA0yqfDcGJYBDfb6pv8ohx5z2m04A35XenAi/i+hq+tXf+3sU
         wy4ETWVFAW/VjDpSex+t9TBeegmKPyiEFAUM1gahDKl6EvgBP3s/EjLmC9mR/Zn1MHfw
         85PRQcVR1uuulBRQMSkLm6sktXC56CqCk8MS0aV/QrfW5Vm72gYJbixxw2OdZ3X/BFOG
         bohc6wmZwQ081jpui0l9G4EaJTnb/5yw8HfZo5V/MXJUZtGelwrhTkHPPBILOFA25bJK
         vNSh5V6bA2s+cZUHLuMPPvQrK5Re5GgZZuYm4eQC1JOPnVD6O+s9z2w9zQnCz+BTlKaB
         71Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=p341SqsdOUJwO1s6piaVzdmySVuxDEiMM8H40BX3VS8=;
        b=sYLNfTjvywnVOEATCdC5WY8WYYcWrGziXfpIQOFKfLrs0fLGfRuDnNfHFdlGa4Lihu
         i3EvZVVoMVGLJfak8dl3JohMYa0WfyFSVPxi/XLxafhuJBHJixSDZZOQ5x8phUmA5I6h
         q9iiSPXsShmar6lyDFIAwUbQ7lqtlkbidn0P6e+Kir6f+0JScyJ/WX13DAZmAkD7nbcG
         UP0SaeGpM8B/6OET+ipkRy32qePdEYWuCcbb19QBHC/OuiuY2IuZCcT6erJFUK3XWtwE
         VdRrUx30udeKzGsNBYB6VfUAYEp6wbo1d0nirgSBG6FoUrIcjpYryNsf/+fzIv3/046c
         6aqw==
X-Gm-Message-State: AOAM5301zzzow+Pv7Wl2PT+R8kauW4TBzaHifBDh5yV5PjYZUlr6XDvl
        rqtxjsEYkTAv3JL6YoplwDT+1sOmU1veWUH/
X-Google-Smtp-Source: ABdhPJyFrbuz3gwdqJS41ok/S5rkkl1AIkkrzYrfDxWIGPHKCMCMZt/FwqedPYMl31dJkwZQqvwx5g==
X-Received: by 2002:a17:902:e98b:b0:158:bc16:d5d2 with SMTP id f11-20020a170902e98b00b00158bc16d5d2mr10563482plb.103.1650285795530;
        Mon, 18 Apr 2022 05:43:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bc11-20020a656d8b000000b0039cc4dbb295sm12353112pgb.60.2022.04.18.05.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 05:43:14 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------djYQcI0jbhrXNzJc8ETMqKrE"
Message-ID: <6bb25dbf-a25b-b35a-d6dd-bb5845084649@kernel.dk>
Date:   Mon, 18 Apr 2022 06:43:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring: use right issue_flags for
 splice/tee" failed to apply to 5.17-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <1650275686134226@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1650275686134226@kroah.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------djYQcI0jbhrXNzJc8ETMqKrE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/22 3:54 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.17-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's this one, and the two others that failed to apply for
5.17-stable.

-- 
Jens Axboe

--------------djYQcI0jbhrXNzJc8ETMqKrE
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-fix-poll-error-reporting.patch"
Content-Disposition: attachment;
 filename="0003-io_uring-fix-poll-error-reporting.patch"
Content-Transfer-Encoding: base64

RnJvbSA4ZjhjYWJiNzc4MjZiNzg2YzJmNWExODU0YWJhZDQ2NWY5ZmJmZWYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogTW9uLCAxOCBBcHIgMjAyMiAwNjo0MToyMCAtMDYwMApTdWJqZWN0
OiBbUEFUQ0ggMy8zXSBpb191cmluZzogZml4IHBvbGwgZXJyb3IgcmVwb3J0aW5nCgpjb21t
aXQgNzE3OWMzY2UzZGJmZjY0NmM1NWY3Y2Q2NjRhODk1ZjQ2MmYwNDllNSB1cHN0cmVhbS4K
CldlIHNob3VsZCBub3QgcmV0dXJuIGFuIGVycm9yIGNvZGUgaW4gcmVxLT5yZXN1bHQgaW4K
aW9fcG9sbF9jaGVja19ldmVudHMoKSwgYmVjYXVzZSBpdCBtYXkgZ2V0IG1hbmdsZWQgYW5k
IHJldHVybmVkIGFzCnN1Y2Nlc3MuIEp1c3QgcmV0dXJuIHRoZSBlcnJvciBjb2RlIGRpcmVj
dGx5LCB0aGUgY2FsbGVycyB3aWxsIGZhaWwgdGhlCnJlcXVlc3Qgb3IgcHJvY2VlZCBhY2Nv
cmRpbmdseS4KCkZpeGVzOiA2YmY5YzQ3YTM5ODkgKCJpb191cmluZzogZGVmZXIgZmlsZSBh
c3NpZ25tZW50IikKU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5j
ZUBnbWFpbC5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvNWYwMzUxNGVl
MzMzMjRkYzgxMWZiOTNkZjg0YWVlMGY2OTVmYjA0NC4xNjQ5ODYyNTE2LmdpdC5hc21sLnNp
bGVuY2VAZ21haWwuY29tClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5l
bC5kaz4KLS0tCiBmcy9pb191cmluZy5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9pb191cmlu
Zy5jIGIvZnMvaW9fdXJpbmcuYwppbmRleCAyOTNiMDRjN2VkZGEuLjdiNGQ0OGNmZTQ0YyAx
MDA2NDQKLS0tIGEvZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC01NTA5
LDkgKzU1MDksOCBAQCBzdGF0aWMgaW50IGlvX3BvbGxfY2hlY2tfZXZlbnRzKHN0cnVjdCBp
b19raW9jYiAqcmVxLCBib29sIGxvY2tlZCkKIAkJCXVuc2lnbmVkIGZsYWdzID0gbG9ja2Vk
ID8gMCA6IElPX1VSSU5HX0ZfVU5MT0NLRUQ7CiAKIAkJCWlmICh1bmxpa2VseSghaW9fYXNz
aWduX2ZpbGUocmVxLCBmbGFncykpKQotCQkJCXJlcS0+cmVzdWx0ID0gLUVCQURGOwotCQkJ
ZWxzZQotCQkJCXJlcS0+cmVzdWx0ID0gdmZzX3BvbGwocmVxLT5maWxlLCAmcHQpICYgcG9s
bC0+ZXZlbnRzOworCQkJCXJldHVybiAtRUJBREY7CisJCQlyZXEtPnJlc3VsdCA9IHZmc19w
b2xsKHJlcS0+ZmlsZSwgJnB0KSAmIHBvbGwtPmV2ZW50czsKIAkJfQogCiAJCS8qIG11bHRp
c2hvdCwganVzdCBmaWxsIGFuIENRRSBhbmQgcHJvY2VlZCAqLwotLSAKMi4zNS4xCgo=
--------------djYQcI0jbhrXNzJc8ETMqKrE
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-fix-poll-file-assign-deadlock.patch"
Content-Disposition: attachment;
 filename="0002-io_uring-fix-poll-file-assign-deadlock.patch"
Content-Transfer-Encoding: base64

RnJvbSBjYmIzZjU5MzhjZGY5NzVmMjk3MGY5YjU2NzRhNTZlNmZhMWE1OWZmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogTW9uLCAxOCBBcHIgMjAyMiAwNjo0MDozMCAtMDYwMApTdWJqZWN0
OiBbUEFUQ0ggMi8zXSBpb191cmluZzogZml4IHBvbGwgZmlsZSBhc3NpZ24gZGVhZGxvY2sK
CmNvbW1pdCBjY2U2NGVmMDEzMDhiNjc3YTY4N2Q5MDkyN2ZjMmIyZTBlMWNiYTY3IHVwc3Ry
ZWFtLgoKV2UgcGFzcyAidW5sb2NrZWQiIGludG8gaW9fYXNzaWduX2ZpbGUoKSBpbiBpb19w
b2xsX2NoZWNrX2V2ZW50cygpLAp3aGljaCBjYW4gbGVhZCB0byBkb3VibGUgbG9ja2luZy4K
CkZpeGVzOiA2YmY5YzQ3YTM5ODkgKCJpb191cmluZzogZGVmZXIgZmlsZSBhc3NpZ25tZW50
IikKU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5j
b20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjQ3NmQ0YWU0NjU1NDMyNGI1
OTllZTQwNTU0NDdiMTA1ZjIwYTc1YS4xNjQ5ODYyNTE2LmdpdC5hc21sLnNpbGVuY2VAZ21h
aWwuY29tClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBmcy9pb191cmluZy5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMvaW9f
dXJpbmcuYwppbmRleCAyNjgzMmQxNjZjYTIuLjI5M2IwNGM3ZWRkYSAxMDA2NDQKLS0tIGEv
ZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC01NTA2LDggKzU1MDYsOSBA
QCBzdGF0aWMgaW50IGlvX3BvbGxfY2hlY2tfZXZlbnRzKHN0cnVjdCBpb19raW9jYiAqcmVx
LCBib29sIGxvY2tlZCkKIAogCQlpZiAoIXJlcS0+cmVzdWx0KSB7CiAJCQlzdHJ1Y3QgcG9s
bF90YWJsZV9zdHJ1Y3QgcHQgPSB7IC5fa2V5ID0gcG9sbC0+ZXZlbnRzIH07CisJCQl1bnNp
Z25lZCBmbGFncyA9IGxvY2tlZCA/IDAgOiBJT19VUklOR19GX1VOTE9DS0VEOwogCi0JCQlp
ZiAodW5saWtlbHkoIWlvX2Fzc2lnbl9maWxlKHJlcSwgSU9fVVJJTkdfRl9VTkxPQ0tFRCkp
KQorCQkJaWYgKHVubGlrZWx5KCFpb19hc3NpZ25fZmlsZShyZXEsIGZsYWdzKSkpCiAJCQkJ
cmVxLT5yZXN1bHQgPSAtRUJBREY7CiAJCQllbHNlCiAJCQkJcmVxLT5yZXN1bHQgPSB2ZnNf
cG9sbChyZXEtPmZpbGUsICZwdCkgJiBwb2xsLT5ldmVudHM7Ci0tIAoyLjM1LjEKCg==
--------------djYQcI0jbhrXNzJc8ETMqKrE
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-use-right-issue_flags-for-splice-tee.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-use-right-issue_flags-for-splice-tee.patch"
Content-Transfer-Encoding: base64

RnJvbSBkNWY2MmQ4MTk5ZTAwZDVhZjFhNTdmODNjYTFmY2Q0OWZlY2QzYTM2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogV2VkLCAxMyBBcHIgMjAyMiAxNjoxMDozMyArMDEwMApTdWJqZWN0
OiBbUEFUQ0ggMS8zXSBpb191cmluZzogdXNlIHJpZ2h0IGlzc3VlX2ZsYWdzIGZvciBzcGxp
Y2UvdGVlCgpjb21taXQgZTk0MTk3NjY1OWYxZjY4MzQwNzdhMTU5NmJmNTNlNmJkYjEwZTkw
YiB1cHN0cmVhbS4KClBhc3MgcmlnaHQgaXNzdWVfZmxhZ3MgaW50byBpbnRvIGlvX2ZpbGVf
Z2V0X2ZpeGVkKCkgaW5zdGVhZCBvZgpJT19VUklOR19GX1VOTE9DS0VELiBJdCdzIHByb2Jh
Ymx5IG5vdCBhIHByb2JsZW0gYXQgdGhlIG1vbWVudCBidXQgbGV0J3MKZG8gaXQgc2FmZXIu
CgpGaXhlczogNmJmOWM0N2EzOTg5ICgiaW9fdXJpbmc6IGRlZmVyIGZpbGUgYXNzaWdubWVu
dCIpClNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwu
Y29tPgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzdkMjQyZGFhOWRmNWQ3NzY5
MDc2ODY5NzdjZDI5ZmJjZWI0YTJkOGQuMTY0OTg2MjUxNi5naXQuYXNtbC5zaWxlbmNlQGdt
YWlsLmNvbQpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0t
LQogZnMvaW9fdXJpbmcuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMv
aW9fdXJpbmcuYwppbmRleCAxYTk2MzBkYzUzNjEuLjI2ODMyZDE2NmNhMiAxMDA2NDQKLS0t
IGEvZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC00MTM2LDcgKzQxMzYs
NyBAQCBzdGF0aWMgaW50IGlvX3RlZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQg
aW50IGlzc3VlX2ZsYWdzKQogCQlyZXR1cm4gLUVBR0FJTjsKIAogCWlmIChzcC0+ZmxhZ3Mg
JiBTUExJQ0VfRl9GRF9JTl9GSVhFRCkKLQkJaW4gPSBpb19maWxlX2dldF9maXhlZChyZXEs
IHNwLT5zcGxpY2VfZmRfaW4sIElPX1VSSU5HX0ZfVU5MT0NLRUQpOworCQlpbiA9IGlvX2Zp
bGVfZ2V0X2ZpeGVkKHJlcSwgc3AtPnNwbGljZV9mZF9pbiwgaXNzdWVfZmxhZ3MpOwogCWVs
c2UKIAkJaW4gPSBpb19maWxlX2dldF9ub3JtYWwocmVxLCBzcC0+c3BsaWNlX2ZkX2luKTsK
IAlpZiAoIWluKSB7CkBAIC00MTc4LDcgKzQxNzgsNyBAQCBzdGF0aWMgaW50IGlvX3NwbGlj
ZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQogCQly
ZXR1cm4gLUVBR0FJTjsKIAogCWlmIChzcC0+ZmxhZ3MgJiBTUExJQ0VfRl9GRF9JTl9GSVhF
RCkKLQkJaW4gPSBpb19maWxlX2dldF9maXhlZChyZXEsIHNwLT5zcGxpY2VfZmRfaW4sIElP
X1VSSU5HX0ZfVU5MT0NLRUQpOworCQlpbiA9IGlvX2ZpbGVfZ2V0X2ZpeGVkKHJlcSwgc3At
PnNwbGljZV9mZF9pbiwgaXNzdWVfZmxhZ3MpOwogCWVsc2UKIAkJaW4gPSBpb19maWxlX2dl
dF9ub3JtYWwocmVxLCBzcC0+c3BsaWNlX2ZkX2luKTsKIAlpZiAoIWluKSB7Ci0tIAoyLjM1
LjEKCg==

--------------djYQcI0jbhrXNzJc8ETMqKrE--
