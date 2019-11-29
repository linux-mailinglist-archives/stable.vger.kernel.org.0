Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7410D036
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 01:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfK2Akm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 19:40:42 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41544 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfK2Akl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 19:40:41 -0500
Received: by mail-pj1-f41.google.com with SMTP id ca19so2928865pjb.8
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 16:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=+cVICArzI9EzJvxOUh3CD4i0GGO915bK/RHuLVfdAm4=;
        b=gZ91thYIhV1CEwf2tJ73T1Juuzq1ODyRbCrkNlTdv7lT4npAyPkdG1t9/WomoWjxFq
         XfPRnOjSukq8nlk/94mLi4+BZVHmQgQUWTgFTRxKrJXq2P2sozqHI+V6Xh3E2VYT2vWN
         jrxQIQF/GqabrfAohg+7wH8BufvS1dxViMJCMIAq6gZwzW3yTF+pplGP13YYRU/LQhR5
         /z8S2vZqq7LelFgdGopZPCK7sHEMy4WAWkEBiM2PtbcEkivpaxJOwmWz9KaYvD9/Xidn
         lFv+osj88O6k6YP9O31P52DO1wvDPdN/IEZRvsToannE3NrEvdbvQohizhQXFZjV14bh
         mzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=+cVICArzI9EzJvxOUh3CD4i0GGO915bK/RHuLVfdAm4=;
        b=V0/Y6HfeshTGvBX184skqXEwEDSvkuivzDzCvOnc/n5tup//jvZNlSTVZ488NAngAk
         /xAo1GjohCLx582lVEtao7BwaVBIzKBGn/JwecuHuBI6aPR87tg/vktwuCm4cj1e1fCw
         2Mggihy4aa2DbUH5WLPSHR56ldc0NF0eajqagVSuJvwp3iaV6RAlUdRBCfhyi0uxJ0vb
         4hrwsYlXR3hwMNP20YG1FtH9CXBfbpDJoa2a2qxdyDNDEsihDkKLpA+YaOscAZlWdMj/
         izoR+ufG1eE0MX38usREATdESpseesE7MexzIny8mTp4FIezp9w9OZs+WlLGlvqCA22p
         t8jQ==
X-Gm-Message-State: APjAAAVIDOYULEBxhaslAKTQ3AxLDFIdsHez4lT9KJDc96WoNA+cxAMW
        3ObHhA75Sxew33P0AGaWE+ZK5zltQMx3pg==
X-Google-Smtp-Source: APXvYqw8Ts9gjlSjAhiDwqyVrAe2oj4vQccjgP8s+LpG13L6z7muv7DKRgUqOMHJcupa7QEeLS6tAg==
X-Received: by 2002:a17:902:9046:: with SMTP id w6mr12526546plz.323.1574988040892;
        Thu, 28 Nov 2019 16:40:40 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:a906:8bbc:1653:4965? ([2605:e000:100e:8c61:a906:8bbc:1653:4965])
        by smtp.gmail.com with ESMTPSA id e27sm642740pfm.26.2019.11.28.16.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 16:40:39 -0800 (PST)
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: io_uring stable additions
Message-ID: <a552f6b6-bdb8-afb8-b178-1d30d4d9ece6@kernel.dk>
Date:   Thu, 28 Nov 2019 16:40:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------6B25B95A8C5F2AD044DC5D17"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------6B25B95A8C5F2AD044DC5D17
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have a few commits that went into 5.5-rc that should go into stable. The
first one is:

commit 181e448d8709e517c9c7b523fcd209f24eb38ca7
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Nov 25 08:52:30 2019 -0700

     io_uring: async workers should inherit the user creds

and I'm attaching a 5.4 port of this patch, since the one in 5.5 is built
on top of new code. The 5.4 port will apply all the way back to 5.1 when
io_uring was introduced.

Secondly, these two (in order):

commit 4257c8ca13b084550574b8c9a667d9c90ff746eb
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Nov 25 14:27:34 2019 -0700

     net: separate out the msghdr copy from ___sys_{send,recv}msg()

and

commit d69e07793f891524c6bbf1e75b9ae69db4450953
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Nov 25 17:04:13 2019 -0700

     net: disallow ancillary data for __sys_{send,recv}msg_file()

should be applied to 5.3/5.4 stable as well. They might look like pure
networking commits, but only io_uring uses the interface.

These three fix important issues, which is why we need them in stable.

-- 
Jens Axboe


--------------6B25B95A8C5F2AD044DC5D17
Content-Type: text/plain; charset=UTF-8;
 name="5.4-stable-creds"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="5.4-stable-creds"

Y29tbWl0IDNlZGM5MzYzNTRhNWEwYWQzOGE0YzI1OGU1ZGI4ZjdjMmUyZWI1MDUKQXV0aG9y
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6ICAgTW9uIE5vdiAyNSAwOTow
OTo0MyAyMDE5IC0wNzAwCgogICAgaW9fdXJpbmc6IGFzeW5jIHdvcmtlcnMgc2hvdWxkIGlu
aGVyaXQgdGhlIHVzZXIgY3JlZHMKICAgIAogICAgSWYgd2UgZG9uJ3QgaW5oZXJpdCB0aGUg
b3JpZ2luYWwgdGFzayBjcmVkcywgdGhlbiB3ZSBjYW4gY29uZnVzZSB1c2VycwogICAgbGlr
ZSBmdXNlIHRoYXQgcGFzcyBjcmVkcyBpbiB0aGUgcmVxdWVzdCBoZWFkZXIuIFNlZSBsaW5r
IGJlbG93IG9uCiAgICBpZGVudGljYWwgYWlvIGlzc3VlLgogICAgCiAgICBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9saW51eC1mc2RldmVsLzI2ZjBkNzhlLTk5Y2EtMmYxYi03
OGI5LTQzMzA4ODA1M2E2MUBzY3lsbGFkYi5jb20vVC8jdQogICAgU2lnbmVkLW9mZi1ieTog
SmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgoKZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5n
LmMgYi9mcy9pb191cmluZy5jCmluZGV4IDJjODE5YzNjODU1ZC4uY2JlOGRhYmI2NDc5IDEw
MDY0NAotLS0gYS9mcy9pb191cmluZy5jCisrKyBiL2ZzL2lvX3VyaW5nLmMKQEAgLTIzOCw2
ICsyMzgsOCBAQCBzdHJ1Y3QgaW9fcmluZ19jdHggewogCiAJc3RydWN0IHVzZXJfc3RydWN0
CSp1c2VyOwogCisJc3RydWN0IGNyZWQJCSpjcmVkczsKKwogCXN0cnVjdCBjb21wbGV0aW9u
CWN0eF9kb25lOwogCiAJc3RydWN0IHsKQEAgLTE3NTIsOCArMTc1NCwxMSBAQCBzdGF0aWMg
dm9pZCBpb19wb2xsX2NvbXBsZXRlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQog
CXN0cnVjdCBpb19wb2xsX2lvY2IgKnBvbGwgPSAmcmVxLT5wb2xsOwogCXN0cnVjdCBwb2xs
X3RhYmxlX3N0cnVjdCBwdCA9IHsgLl9rZXkgPSBwb2xsLT5ldmVudHMgfTsKIAlzdHJ1Y3Qg
aW9fcmluZ19jdHggKmN0eCA9IHJlcS0+Y3R4OworCWNvbnN0IHN0cnVjdCBjcmVkICpvbGRf
Y3JlZDsKIAlfX3BvbGxfdCBtYXNrID0gMDsKIAorCW9sZF9jcmVkID0gb3ZlcnJpZGVfY3Jl
ZHMoY3R4LT5jcmVkcyk7CisKIAlpZiAoIVJFQURfT05DRShwb2xsLT5jYW5jZWxlZCkpCiAJ
CW1hc2sgPSB2ZnNfcG9sbChwb2xsLT5maWxlLCAmcHQpICYgcG9sbC0+ZXZlbnRzOwogCkBA
IC0xNzY4LDcgKzE3NzMsNyBAQCBzdGF0aWMgdm9pZCBpb19wb2xsX2NvbXBsZXRlX3dvcmso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCWlmICghbWFzayAmJiAhUkVBRF9PTkNFKHBv
bGwtPmNhbmNlbGVkKSkgewogCQlhZGRfd2FpdF9xdWV1ZShwb2xsLT5oZWFkLCAmcG9sbC0+
d2FpdCk7CiAJCXNwaW5fdW5sb2NrX2lycSgmY3R4LT5jb21wbGV0aW9uX2xvY2spOwotCQly
ZXR1cm47CisJCWdvdG8gb3V0OwogCX0KIAlsaXN0X2RlbF9pbml0KCZyZXEtPmxpc3QpOwog
CWlvX3BvbGxfY29tcGxldGUoY3R4LCByZXEsIG1hc2spOwpAQCAtMTc3Niw2ICsxNzgxLDgg
QEAgc3RhdGljIHZvaWQgaW9fcG9sbF9jb21wbGV0ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKIAogCWlvX2NxcmluZ19ldl9wb3N0ZWQoY3R4KTsKIAlpb19wdXRfcmVxKHJl
cSk7CitvdXQ6CisJcmV2ZXJ0X2NyZWRzKG9sZF9jcmVkKTsKIH0KIAogc3RhdGljIGludCBp
b19wb2xsX3dha2Uoc3RydWN0IHdhaXRfcXVldWVfZW50cnkgKndhaXQsIHVuc2lnbmVkIG1v
ZGUsIGludCBzeW5jLApAQCAtMjE0NywxMCArMjE1NCwxMiBAQCBzdGF0aWMgdm9pZCBpb19z
cV93cV9zdWJtaXRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3RydWN0IGlv
X3JpbmdfY3R4ICpjdHggPSByZXEtPmN0eDsKIAlzdHJ1Y3QgbW1fc3RydWN0ICpjdXJfbW0g
PSBOVUxMOwogCXN0cnVjdCBhc3luY19saXN0ICphc3luY19saXN0OworCWNvbnN0IHN0cnVj
dCBjcmVkICpvbGRfY3JlZDsKIAlMSVNUX0hFQUQocmVxX2xpc3QpOwogCW1tX3NlZ21lbnRf
dCBvbGRfZnM7CiAJaW50IHJldDsKIAorCW9sZF9jcmVkID0gb3ZlcnJpZGVfY3JlZHMoY3R4
LT5jcmVkcyk7CiAJYXN5bmNfbGlzdCA9IGlvX2FzeW5jX2xpc3RfZnJvbV9zcWUoY3R4LCBy
ZXEtPnN1Ym1pdC5zcWUpOwogcmVzdGFydDoKIAlkbyB7CkBAIC0yMjU4LDYgKzIyNjcsNyBA
QCBzdGF0aWMgdm9pZCBpb19zcV93cV9zdWJtaXRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspCiAJCXVudXNlX21tKGN1cl9tbSk7CiAJCW1tcHV0KGN1cl9tbSk7CiAJfQorCXJl
dmVydF9jcmVkcyhvbGRfY3JlZCk7CiB9CiAKIC8qCkBAIC0yNjYzLDYgKzI2NzMsNyBAQCBz
dGF0aWMgaW50IGlvX3NxX3RocmVhZCh2b2lkICpkYXRhKQogewogCXN0cnVjdCBpb19yaW5n
X2N0eCAqY3R4ID0gZGF0YTsKIAlzdHJ1Y3QgbW1fc3RydWN0ICpjdXJfbW0gPSBOVUxMOwor
CWNvbnN0IHN0cnVjdCBjcmVkICpvbGRfY3JlZDsKIAltbV9zZWdtZW50X3Qgb2xkX2ZzOwog
CURFRklORV9XQUlUKHdhaXQpOwogCXVuc2lnbmVkIGluZmxpZ2h0OwpAQCAtMjY3Miw2ICsy
NjgzLDcgQEAgc3RhdGljIGludCBpb19zcV90aHJlYWQodm9pZCAqZGF0YSkKIAogCW9sZF9m
cyA9IGdldF9mcygpOwogCXNldF9mcyhVU0VSX0RTKTsKKwlvbGRfY3JlZCA9IG92ZXJyaWRl
X2NyZWRzKGN0eC0+Y3JlZHMpOwogCiAJdGltZW91dCA9IGluZmxpZ2h0ID0gMDsKIAl3aGls
ZSAoIWt0aHJlYWRfc2hvdWxkX3BhcmsoKSkgewpAQCAtMjc4Miw2ICsyNzk0LDcgQEAgc3Rh
dGljIGludCBpb19zcV90aHJlYWQodm9pZCAqZGF0YSkKIAkJdW51c2VfbW0oY3VyX21tKTsK
IAkJbW1wdXQoY3VyX21tKTsKIAl9CisJcmV2ZXJ0X2NyZWRzKG9sZF9jcmVkKTsKIAogCWt0
aHJlYWRfcGFya21lKCk7CiAKQEAgLTM1NjcsNiArMzU4MCw4IEBAIHN0YXRpYyB2b2lkIGlv
X3JpbmdfY3R4X2ZyZWUoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgpCiAJCWlvX3VuYWNjb3Vu
dF9tZW0oY3R4LT51c2VyLAogCQkJCXJpbmdfcGFnZXMoY3R4LT5zcV9lbnRyaWVzLCBjdHgt
PmNxX2VudHJpZXMpKTsKIAlmcmVlX3VpZChjdHgtPnVzZXIpOworCWlmIChjdHgtPmNyZWRz
KQorCQlwdXRfY3JlZChjdHgtPmNyZWRzKTsKIAlrZnJlZShjdHgpOwogfQogCkBAIC0zODM4
LDYgKzM4NTMsMTIgQEAgc3RhdGljIGludCBpb191cmluZ19jcmVhdGUodW5zaWduZWQgZW50
cmllcywgc3RydWN0IGlvX3VyaW5nX3BhcmFtcyAqcCkKIAljdHgtPmFjY291bnRfbWVtID0g
YWNjb3VudF9tZW07CiAJY3R4LT51c2VyID0gdXNlcjsKIAorCWN0eC0+Y3JlZHMgPSBwcmVw
YXJlX2NyZWRzKCk7CisJaWYgKCFjdHgtPmNyZWRzKSB7CisJCXJldCA9IC1FTk9NRU07CisJ
CWdvdG8gZXJyOworCX0KKwogCXJldCA9IGlvX2FsbG9jYXRlX3NjcV91cmluZ3MoY3R4LCBw
KTsKIAlpZiAocmV0KQogCQlnb3RvIGVycjsK
--------------6B25B95A8C5F2AD044DC5D17--
